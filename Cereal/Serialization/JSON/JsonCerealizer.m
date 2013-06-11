//
//  JsonCerealizer.h
//  Cereal
//
//  Created by Joshua Gretz on 6/27/11.
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

#import "JsonCerealizer.h"
#import "Cerealizable.h"

@implementation JsonCerealizer

#pragma mark Serialize
-(NSString*) toString: (id) object {    
    if (object == nil)
        return nil;
    
    id jsonObject = [self toObject: object];
    if (![NSJSONSerialization isValidJSONObject: jsonObject]) {
        NSLog(@"!!! Error Writing JSON: Object unable to be serialized to JSON");
        return nil;
    }
    
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject: jsonObject options: NSJSONWritingPrettyPrinted error: &error];
    if (error) {
        NSLog(@"!!! Error Writing JSON: %@", error);
        return nil;
    }
    
    return [[NSString alloc] initWithData: jsonData encoding: NSUTF8StringEncoding];
}

#pragma mark Deserialize
-(id) createArrayOfType: (Class) classType fromString: (NSString*) json {
    if (!json || json.length == 0)
        return nil;
    
    id jsonObj = [self JSONValue: json];
    if ([jsonObj isKindOfClass: [NSDictionary class]])
        jsonObj = [NSArray arrayWithObject: jsonObj];
    
    if (![jsonObj isKindOfClass: [NSArray class]])
        return nil;
    
    return [self createArrayOfType: classType fromArray: jsonObj];    
}

-(void) fillObject: (id) object fromString: (NSString*) json {
    id jsonObj = [self JSONValue: json];
    if (![jsonObj isKindOfClass: [NSDictionary class]])
        return;
    
    [self fillObject: object fromDictionary: jsonObj];
}

-(id) JSONValue: (NSString*) json {
    NSData* jsonData = [json dataUsingEncoding: NSUTF8StringEncoding];
    NSError* error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData: jsonData options: NSJSONReadingAllowFragments error: &error];
    if (error) {
        NSLog(@"!!! Error Reading JSON: %@", error);
        return nil;
    }
    
    return jsonObj;
}

@end
