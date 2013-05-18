//
//  Cerealizer.m
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

#import <UIKit/UIKit.h>
#import "Cerealizer.h"
#import "Reflection.h"
#import "NSData+Base64.h"
#import "UIColor+Cereal.h"
#import "Container.h"

@implementation Cerealizer {
    NSDateFormatter* dateFormatter;
}

-(id) init {
    if ((self = [super init])) {
        // the serializers have issues with dates - we are going to go to string and back as standard
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    }

    return self;
}

#pragma mark Serialization
-(NSString*) toString: (id) object {
    return [object description];
}

-(id) toObject: (id) object {
    // special "value" reference types
    if ([object isKindOfClass: [NSString class]] || [object isKindOfClass: [NSNumber class]])
        return object;

    if ([object isKindOfClass: [NSValue class]])
        return [[NSKeyedArchiver archivedDataWithRootObject: object] base64EncodedString];

    // array
    if ([object isKindOfClass: [NSArray class]]) {
        NSMutableArray* array = [NSMutableArray array];
        if ([object count] > 0) {
            for (id obj in [NSArray arrayWithArray: object])
                [array addObject: [self toObject: obj]];
        }

        return array;
    }

    // dictionary
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    if ([object isKindOfClass: [NSDictionary class]]) {
        for (id key in  [object keyEnumerator])
            [dictionary setObject: [self toObject: [object objectForKey: key]] forKey: key];
        return dictionary;
    }

    // object
    for (PropertyInfo* propertyInfo in [Reflection propertiesForClass: [object class] includeInheritance: YES]) {
        if ([object conformsToProtocol: @protocol(Cerealizable)] && [object respondsToSelector: @selector(serializePropertyWithName:)]) {
            if (![object serializePropertyWithName: propertyInfo.name])
                continue;
        }

        id value = [object valueForKey: propertyInfo.name];
        if (!value)
            continue;

        // check nscoding
        if ([value isKindOfClass: [NSArray class]])
            value = [self toObject: value];
        else if ([value isKindOfClass: [NSDate class]])
            value = [dateFormatter stringFromDate: value];
        else if ([value isKindOfClass: [NSData class]])
            value = [value base64EncodedString];
        else if ([value isKindOfClass: [UIColor class]])
            value = [value toString];
        else if ([value conformsToProtocol: @protocol(NSObject)])
            value = [self toObject: value];

        [dictionary setValue: value forKey: propertyInfo.name];
    }
    return dictionary;
}

#pragma mark Deserialization
// cant do here
-(id) createArrayOfType: (Class) classType fromString: (NSString*) string {
    return nil;
}

-(void) fillObject: (id) object fromString: (NSString*) string {
}

// can
-(id) create: (Class) classType fromString: (NSString*) string {
    NSArray* array = [self createArrayOfType: classType fromString: string];
    return array.count == 0 ? nil : [array objectAtIndex: 0];
}

-(id) createArrayOfType: (Class) classType fromArray: (NSArray*) rawArray {
    NSMutableArray* array = [NSMutableArray array];

    // quick exit
    if (rawArray.count == 0)
        return array;

    // sample the object type    
    Class objectType = [[rawArray objectAtIndex: 0] class];
    if (objectType != [NSDictionary class] && ![objectType isSubclassOfClass: [NSDictionary class]]) {
        for (id obj in rawArray)
            [array addObject: obj];
        return array;
    }

    // override so we can actually do it
    if (classType == [NSDictionary class])
        classType = [NSMutableDictionary class];

    // deserialize
    for (NSDictionary* dictionary in rawArray) {
        id object = [[Container sharedContainer] objectForClass: classType];
        [self fillObject: object fromDictionary: dictionary];

        [array addObject: object];
    }

    return array;
}

-(id) create: (Class) classType fromDictionary: (NSDictionary*) dictionary {
    return [[self createArrayOfType: classType fromArray: [NSArray arrayWithObject: dictionary]] objectAtIndex: 0];
}

-(void) fillObject: (id) object fromDictionary: (NSDictionary*) dictionary {
    // fill dictionary
    if ([object isKindOfClass: [NSMutableDictionary class]]) {
        for (id key in dictionary.keyEnumerator)
            [(NSMutableDictionary*) object setObject: [dictionary objectForKey: key] forKey: key];
        return;
    }

    // fill object
    for (PropertyInfo* propertyInfo in [Reflection propertiesForClass: [object class] includeInheritance: YES]) {
        if (propertyInfo.readonly)
            continue;

        NSString* valueKey = propertyInfo.name;
        if ([object conformsToProtocol: @protocol(Cerealizable)] && [object respondsToSelector: @selector(valueKeyForPropertyName:)])
            valueKey = [object valueKeyForPropertyName: propertyInfo.name];

        id value = [dictionary objectForKey: valueKey];
        if (!value || [value isKindOfClass: [NSNull class]])
            continue;

        Class propertyClassType = propertyInfo.type;
        if (propertyInfo.valueType)
            continue;

        if (!propertyInfo.valueType) {
            if (propertyClassType == [NSArray class] || [propertyClassType isSubclassOfClass: [NSArray class]]) {
                // this allows for multiple subtypes in a single array
                NSArray* objects = value;

                value = [NSMutableArray array];
                for (id obj in objects) {
                    Class subClassType = [self overrideForProperty: propertyInfo withValue: obj forObject: object];
                    if (!subClassType)
                        continue;

                    if ([obj isKindOfClass: [NSDictionary class]])
                        [value addObject: [self create: subClassType fromDictionary: obj]];
                    else if ([obj isKindOfClass: [NSString class]] && ((NSString*) obj).length > 0)
                        [value addObject: [self parseValue: obj forPropertyType: subClassType]];
                }
            }
            else if (propertyClassType == [NSDictionary class] || [propertyClassType isSubclassOfClass: [NSDictionary class]]) {
                Class override = [self overrideForProperty: propertyInfo withValue: value forObject: object];
                if (override) {
                    propertyClassType = override;

                    value = [self create: propertyClassType fromDictionary: value];
                }
            }
            else if ([value isKindOfClass: [NSDictionary class]]) {
                NSDictionary* dict = value;
                Class override = [self overrideForProperty: propertyInfo withValue: value forObject: object];
                if (override)
                    propertyClassType = override;

                value = [[Container sharedContainer] objectForClass: [self class]];
                [self fillObject: value fromDictionary: dict];
            }

            if ([value isKindOfClass: [NSString class]] && ((NSString*) value).length > 0)
                value = [self parseValue: value forPropertyType: propertyClassType];

            [object setValue: value forKey: propertyInfo.name];
        }
    }
}

-(id) parseValue: (NSString*) value forPropertyType: (Class) propertyClassType {
    if (propertyClassType == [NSData class])
        return [NSData dataFromBase64String: value];

    if (propertyClassType == [NSDate class])
        return [dateFormatter dateFromString: value];

    if (propertyClassType == [UIColor class])
        return [UIColor fromString: value];

    if (propertyClassType == [NSValue class] || [propertyClassType isSubclassOfClass: [NSValue class]])
        return [NSKeyedUnarchiver unarchiveObjectWithData: [NSData dataFromBase64String: value]];

    return value;
}

-(Class) overrideForProperty: (PropertyInfo*) propertyInfo withValue: (id) targetValue forObject: (id) object {
    Class classType = nil;
    if ([object conformsToProtocol: @protocol(Cerealizable)]) {
        if ([object respondsToSelector: @selector(classTypeForKey:withValue:)])
            classType = [object classTypeForKey: propertyInfo.name withValue: targetValue];

        if (!classType && [object respondsToSelector: @selector(classTypeForKey:)])
            classType = [object classTypeForKey: propertyInfo.name];
    }

    return classType;
}

@end
