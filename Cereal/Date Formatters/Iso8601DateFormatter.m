//
//  Iso8601DateFormatter.m
//  Cereal
//
//  Created by Scott Ferguson on 12/30/13.
//  Copyright (c) 2013 TrueFit Solutions
/*
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


#import "Iso8601DateFormatter.h"

@implementation Iso8601UtcDateFormatter

- (id)init {
    self = [super init];
    if (self) {
        [self setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [self setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [self setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    }
    
    return self;
}

@end
