//
//  MicrosoftJsonDateFormatter.m
//  Cereal
//
/// Handles formatting and parsing a json date using the Microsoft format of "“/Date(<ticks>["+" | "-" <offset>)/" where <ticks> = number of milliseconds since midnight Jan 1, 1970
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

#import "MicrosoftJsonDateFormatter.h"

@implementation MicrosoftJsonDateFormatter

- (NSDate*)dateFromString:(NSString *)string {
    
    if (string.length <= 0)
        return nil;

	// Remove escape characters and the Date() text from the raw JSON date string.
	NSUInteger startIndex = [string rangeOfString:@"("].location;
    NSUInteger length = [string rangeOfString:@")"].location - startIndex;
    NSString* datePart = [string substringWithRange:NSMakeRange(startIndex+1, length)];

	// Determine if the UTC portion is present and extract it and the direction.
	NSRange plusRange = [datePart rangeOfString:@"+"];
	NSRange minusRange = [datePart rangeOfString:@"-"];
	
	// Default the values as if the UTC portion does not exist.
	NSString* timeZoneHoursPart = @"00";
	NSString* timeZoneMinutesPart = @"00";
	int timeZoneMultiplier = 0;
	
	if (plusRange.location != NSNotFound || minusRange.location != NSNotFound) {
		// The UTC portion exists and should be added.
		timeZoneMultiplier = plusRange.location != NSNotFound ? 1: -1;
        NSRange range = plusRange.location != NSNotFound ? plusRange : minusRange;
		timeZoneHoursPart = [datePart substringWithRange:NSMakeRange(range.location + 1, 2)];
		timeZoneMinutesPart = [datePart substringWithRange:NSMakeRange(range.location + 3, 2)];
        datePart = [datePart substringWithRange:NSMakeRange(0, range.location)];
	}
	
	// Convert the parts.
	NSTimeInterval time = [datePart doubleValue] / 1000.0;
	NSTimeInterval offsetHours = [timeZoneHoursPart doubleValue] * 3600 * timeZoneMultiplier;
	NSTimeInterval offsetMinutes = [timeZoneMinutesPart doubleValue] * 60 * timeZoneMultiplier;
	
	// Create the date
	return [NSDate dateWithTimeIntervalSince1970:(time + offsetHours + offsetMinutes)];
}

- (NSString*)stringFromDate:(NSDate *)date {
    return [NSString stringWithFormat:@"/Date(%llu)/", (unsigned long long)[date timeIntervalSince1970] * 1000];
}

@end
