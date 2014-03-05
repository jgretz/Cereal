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



#import "PascalCaseMatch.h"


@implementation PascalCaseMatch

-(id) valueForKey: (NSString*) key inDictionary: (NSDictionary*) dictionary {
    return dictionary[[self pascalString: key]];
}

-(NSString*) keyForPropertyNamed: (NSString*) propertyName {
    return [self pascalString: propertyName];
}

-(NSString*) pascalString: (NSString*) string {
    NSString* first = [string substringToIndex: 1];
    return [first.uppercaseString stringByAppendingString: [string substringFromIndex: 1]];
}

@end