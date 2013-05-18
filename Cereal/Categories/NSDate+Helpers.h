//
//  NSDate+Helpers.h
//  Cereal
//
//  Created by Joshua Gretz on 10/7/11.
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

#import <Foundation/Foundation.h>

@interface NSDate(Helpers)

// Create methods
+(NSDate*) dateWithMonth: (int) month day: (int) day year: (int) year;
+(NSDate*) dateWithMonth: (int) month day: (int) day year: (int) year hour: (int) hour minutes: (int) minutes seconds: (int) seconds;
+(NSDate*) now;
+(NSDate*) dateFrom: (NSString*) string withFormat: (NSString*) format;

// Info methods
-(int) day;
-(int) month;
-(int) year;

-(int) dayOfWeek;
-(int) dayOfYear;

-(int) daysInMonth;
+(int) daysInMonth: (int) month inYear: (int) year;

-(NSDate*) firstDayInMonth;
-(NSDate*) lastDayInMonth;

-(BOOL) sameDayAs: (NSDate*) comp;
-(BOOL) sameWeekAs: (NSDate*) comp;
-(BOOL) sameMonthAs: (NSDate*) comp;
-(BOOL) sameYearAs: (NSDate*) comp;

-(BOOL) isBetween: (NSDate*) date1 and: (NSDate*) date2;
-(BOOL) isDateBetween: (NSDate*) date1 and: (NSDate*) date2;

-(NSString*) dateStringWithStyle: (NSDateFormatterStyle) style;
-(NSString*) timeStringWithStyle: (NSDateFormatterStyle) style;
-(NSString*) stringWithFormat: (NSString*)format;
-(NSString*) shortDayName;
-(NSString*) dayName;
-(NSString*) shortMonthName;
-(NSString*) monthName;
-(NSString*) shortYearName;
-(NSString*) yearName;

-(int) daysSince1970;
-(int) weeksSince1970;
-(int) monthsSince1970;

// Set methods
-(NSDate*) setDay: (int) day;
-(NSDate*) setMonth: (int) month;
-(NSDate*) setYear: (int) year;

-(NSDate*) setHour: (int) hour;
-(NSDate*) setMinutes: (int) minute;
-(NSDate*) setSeconds: (int) second;

// Math methods
-(NSDate*) nextDay;
-(NSDate*) previousDay;

-(NSDate*) nextWeek;
-(NSDate*) previousWeek;

-(NSDate*) nextMonth;
-(NSDate*) previousMonth;

-(NSDate*) nextQuarter;
-(NSDate*) previousQuarter;

-(NSDate*) nextYear;
-(NSDate*) previousYear;

-(NSDate*) firstDayOfNextMonth;
-(NSDate*) firstDayOfPreviousMonth;

-(NSDate*) firstDayOfWeek;
-(NSDate*) firstDayOfNextWeek;
-(NSDate*) firstDayOfPreviousWeek;

-(NSDate*) nextOccurenceOfWeekday: (int) weekday;

-(NSDate*) addDays: (int) days;

-(NSDate*) addSeconds: (int) seconds;
-(NSDate*) addMinutes: (int) minutes;
-(NSDate*) addHours: (int) hours;

// Time Methods
-(int) hour;
-(int) minute;
-(int) seconds;
-(int) compareTimeTo: (NSDate*) date;

-(NSDate*) midnight;
-(NSDate*) noon;

@end
