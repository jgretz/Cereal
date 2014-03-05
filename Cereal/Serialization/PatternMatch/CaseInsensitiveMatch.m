//
// Created by Joshua Gretz on 3/5/14.
/* Copyright 2014 TrueFit Solutions
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


#import "CaseInsensitiveMatch.h"


@implementation CaseInsensitiveMatch

-(id) valueForKey: (NSString*) key inDictionary: (NSDictionary*) dictionary {
    NSString* searchKey = [self findKey: key inDictionary: dictionary];
    if (!searchKey) {
        return nil;
    }

    return dictionary[searchKey];
}

-(NSString*) keyForPropertyNamed: (NSString*) propertyName {
    return propertyName;
}

-(NSString*) findKey: (NSString*) key inDictionary: (NSDictionary*) dictionary {
    for (NSString* string in dictionary.allKeys) {
        if ([string compare: key options: NSCaseInsensitiveSearch] == NSOrderedSame) {
            return string;
        }
    }

    return nil;
}

@end