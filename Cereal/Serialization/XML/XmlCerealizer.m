//
//  XmlCereallizer.m
//  Cereal
//
//  Created by Joshua Gretz on 12/12/11.
//
/* Copyright 2011 TrueFit Solutions
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "XmlCerealizer.h"
#import "Cerealizable.h"
#import "XmlSerializable.h"
#import "GDataXMLNode.h"
#import "NSObject+Properties.h"

@interface XmlCerealizer()
-(NSDictionary*) fromXml: (NSString*) xml;
-(NSDictionary*) fromXmlNode: (GDataXMLNode*) node;

-(NSString*) objectToXml: (id) object;
-(GDataXMLElement*) objectToNode: (id) object withName: (NSString*) name;
@end

@implementation XmlCerealizer

#pragma mark Serialize
-(NSString*) toString: (id) object {    
    return [self objectToXml: object];
}

#pragma mark Deserialize
-(id) createArrayOfType: (Class) classType fromString: (NSString*) xml {
    NSDictionary* dictionary = [self fromXml: xml];
    NSArray* array = [NSArray arrayWithObject: dictionary];
    
    return [self createArrayOfType: classType fromArray: array];    
}

-(void) fillObject: (id) object fromString: (NSString*) xml {
    NSDictionary* dictionary = [self fromXml: xml];
    
    [self fillObject: object fromDictionary: dictionary];
}

#pragma mark dictionary methods

-(NSDictionary*) fromXml: (NSString*) xml {
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithXMLString: xml options: 0 error: nil];
    
    return [self fromXmlNode: doc.rootElement];
}

-(NSDictionary*) fromXmlNode: (GDataXMLNode*) node {
    // node = dictionary
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (GDataXMLNode* child in node.children) {
        if (child.children.count == 0) {
            [dictionary setValue: child.stringValue forKey: child.name];
            continue;
        }
        
        if (child.children.count == 1) {
            GDataXMLNode* grandchild = [child.children objectAtIndex: 0];
            if (grandchild.kind == GDataXMLTextKind) {
                [dictionary setValue: grandchild.stringValue forKey: child.name];
                continue;
            }
        }
        
        [dictionary setValue: [self fromXmlNode: child] forKey: child.name];
    }
    
    return dictionary;
}                        

-(NSString*) objectToXml: (id) object {
    NSString* name = NSStringFromClass([object class]);
    if ([object conformsToProtocol: @protocol(XmlCerealizable)] && [object respondsToSelector: @selector(nodeNameForObject)])
        name = [object nodeNameForObject];
    
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithRootElement: [self objectToNode: object withName: name]];
    return [NSString stringWithUTF8String: [doc.XMLData bytes]];
}

-(GDataXMLElement*) objectToNode: (id) object withName: (NSString*) name {
    GDataXMLElement* root = [GDataXMLNode elementWithName: name];    
    if ([object conformsToProtocol: @protocol(Cerealizable)] && [object respondsToSelector: @selector(valueForNode)])
        root.stringValue = [object valueForNode];
    
    for (NSString* propertyName in [[object class] propertyNames]) {
        if ([object conformsToProtocol: @protocol(Cerealizable)] && [object respondsToSelector: @selector(serializePropertyWithName:)]) {
            if (![object serializePropertyWithName: propertyName])
                continue;
        }
        
        NSString* nodeName = propertyName;
        if ([object conformsToProtocol: @protocol(XmlCerealizable)] && [object respondsToSelector: @selector(nodeNameForPropertyNamed:)]) {
            NSString* override = [object nodeNameForPropertyNamed: propertyName];
            if (override)
                nodeName = override;
        }
        
        // form value
        id value = [object valueForKey: propertyName];
        
        if (![value conformsToProtocol: @protocol(NSCoding)]) {
            if ([value conformsToProtocol: @protocol(NSObject)])
                [root addChild: [self objectToNode: value withName: nodeName]];
            else
                continue;
        }
        else if ([value isKindOfClass: [NSArray class]]) {
            GDataXMLElement* subNode = [GDataXMLElement elementWithName: nodeName];
            
            for (id subObj in value) {
                NSString* subNodeName = NSStringFromClass([subObj class]);
                if ([subObj conformsToProtocol: @protocol(XmlCerealizable)] && [object respondsToSelector: @selector(nodeNameForObject)])
                    subNodeName = [subObj nodeNameForObject];
                
                [subNode addChild: [self objectToNode: subObj withName: subNodeName]];
            }
            
            [root addChild: subNode];
        }
		else {
            NSString* stringValue = nil;
            if ([value isKindOfClass: [NSString class]]) {
                stringValue = value;
            }
            else if ([value isKindOfClass: [NSNumber class]]) {
                if ('c' == *[value objCType])
                    stringValue = [value boolValue] ? @"true" : @"false";
                else
                    stringValue = [value stringValue];
            }
            else if ([value isKindOfClass: [NSNull class]]) {
                stringValue = @"";
            }
            
            if (value) {
                XmlNodeType nodeType = XmlNodeTypeNode;
                if ([object conformsToProtocol: @protocol(XmlCerealizable)] && [object respondsToSelector: @selector(nodeTypeForPropertyNamed:)])
                    nodeType = [object nodeTypeForPropertyNamed: propertyName];
                
                switch (nodeType) {
                    case XmlNodeTypeNode:
                        [root addChild: [GDataXMLNode elementWithName: nodeName stringValue: stringValue]];
                        break;
                        
                    case XmlNodeTypeAttribute:
                        [root addChild: [GDataXMLNode attributeWithName: nodeName stringValue: stringValue]];
                        break;
                }
            }
        }
	}
    
    return root;
}

@end
