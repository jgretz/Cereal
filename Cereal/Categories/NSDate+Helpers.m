//
//  NSDate+Helpers.m
//
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

#import "NSDate+Helpers.h"
#import <objc/runtime.h>

enum {
	AdjustTypeDay = 0,
	AdjustTypeMonth = 1,
	AdjustTypeYear = 2
};
typedef NSUInteger AdjustType;

@interface NSDate(ExtensionsInternal)

+(NSCalendar*) calendar;

-(NSDateComponents*) components;
-(NSDate*) adjustDateByType: (AdjustType) type offset: (int) offset;

@end

@implementation NSDate(ExtensionsInternal)

+(NSCalendar*) calendar {
    static NSCalendar* calendarInstance;
    
    @synchronized(self) {
        if (!calendarInstance)
            calendarInstance = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];        
        return calendarInstance;
    }
}

-(NSDateComponents*) components {
	return [[NSDate calendar] components: NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate: self];
}

-(NSDate*) adjustDateByType: (AdjustType) type offset: (int) offset {
	NSDateComponents* c = [self components];
	
	// get parts
	int day = [c day];
	int month = [c month];
	int year = [c year];
	
	// apply offset
	switch (type) {
		case AdjustTypeDay:
			day += offset;
			break;
			
		case AdjustTypeMonth:
			month += offset;
			break;
			
		case AdjustTypeYear:
			year += offset;
			break;
	}
	
	// adjust
	while (day <= 0) {
		month--;
		
		day	= [NSDate daysInMonth: month inYear: year] + day;
	}
	
	while (day > [NSDate daysInMonth: month inYear: year]) {
		int dom = [NSDate daysInMonth: month inYear: year];
		
		month++;
		
		day = 1 + (day - (dom + 1));
	}
	
	while (month <= 0) {
		month = 12 + month;
		year--;
	}
	
	while (month > 12) {
		month = 1 + (month - 13);
		year++;
	}
	
	// return new date
	c.day = day;
	c.month = month;
	c.year = year;
	
	return [[NSDate calendar] dateFromComponents: c];
}

@end

@implementation NSDate(Extensions)

-(NSString*) dateStringWithStyle:(NSDateFormatterStyle)style {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateStyle:style];
    return [df stringFromDate:self];
}

-(NSString*) timeStringWithStyle:(NSDateFormatterStyle)style {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:style];
    return [df stringFromDate:self];
}

-(NSString*) stringWithFormat:(NSString*)format {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}

// create methods
+(NSDate*) dateWithMonth: (int) month day: (int) day year: (int) year {
	return [self dateWithMonth: month day: day year: year hour: 0 minutes:0 seconds:0];
}

+(NSDate*) dateWithMonth: (int) month day: (int) day year: (int) year hour: (int) hour minutes: (int) minutes seconds: (int) seconds {
    NSDateComponents* c = [[NSDateComponents alloc] init];
	c.day = day;
	c.month = month;
	c.year = year;
    c.hour = hour;
    c.minute = minutes;
    c.second = seconds;
	
	return [[NSDate calendar] dateFromComponents: c];
}

+(NSDate*) now {
    return [NSDate date]; // this is totally for my own OCD and readability - Josh
}

+(NSDate*) dateFrom: (NSString*) string withFormat: (NSString*) format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    
    return [dateFormatter dateFromString: string];
}

// info methods
-(int) day {
	return [self components].day;
}

-(int) month {
	return [self components].month;
}

-(int) year {
	return [self components].year;
}

-(int) dayOfWeek {
	return [self components].weekday;
}

-(int) dayOfYear {
    int day = 0;
    NSDate* date = [NSDate dateWithMonth: 1 day: 1 year: [self year]];    
    while (![date sameMonthAs: self]) {
        day += [date daysInMonth];
        date = [date nextMonth];
    }
    day += [self day];
    
    return day;
}

-(int) daysInMonth {
	return [[NSDate calendar] rangeOfUnit: NSDayCalendarUnit inUnit: NSMonthCalendarUnit forDate: self].length;
}

+(int) daysInMonth: (int) month inYear: (int) year {	
	return [[NSDate dateWithMonth: month day: 1 year: year] daysInMonth];
}

-(NSDate*) firstDayInMonth {
	NSDateComponents* c = [self components];	
	c.day = 1;
	
	return [[NSDate calendar] dateFromComponents: c];
}

-(NSDate*) lastDayInMonth {
	NSDateComponents* c = [self components];	
	c.day = [self daysInMonth];
	
	return [[NSDate calendar] dateFromComponents: c];
}

-(NSDate*) firstDayOfWeek {
    NSDate* date = self;
    while ([date dayOfWeek] != 1)
        date = [date addDays: -1];
    return date;
}

-(NSDate*) firstDayOfNextWeek {
    return [[self firstDayOfWeek] addDays: 7];
}

-(NSDate*) firstDayOfPreviousWeek {
    return [[self firstDayOfWeek] addDays: -7];
}

-(NSString*) shortDayName {
	return [self stringWithFormat: @"EEE"];
}

-(NSString*) dayName {
	return [self stringWithFormat: @"EEEE"];
}

-(NSString*) shortMonthName {
	return [self stringWithFormat: @"MMM"];
}

-(NSString*) monthName {
	return [self stringWithFormat: @"MMMM"];
}

-(NSString*) shortYearName {
	return [self stringWithFormat: @"yy"];
}

-(NSString*) yearName {
	return [self stringWithFormat: @"yyyy"];
}

-(BOOL) sameDayAs: (NSDate*) comp {
	if ([self day] != [comp day])
		return NO;
	
	if ([self month] != [comp month])
		return NO;
	
	if ([self year] != [comp year])
		return NO;
	
	return YES;
}

-(BOOL) sameWeekAs:(NSDate *)comp {    
    NSDate* first = [comp firstDayOfWeek];
    NSDate* nextWeek = [comp firstDayOfNextWeek];
    
    return [self isBetween: first and: [nextWeek previousDay]];
}

-(BOOL) sameMonthAs: (NSDate*) comp {
	if ([self month] != [comp month])
		return NO;
	
	if ([self year] != [comp year])
		return NO;
    
    return YES;
}

-(BOOL) sameYearAs: (NSDate*) comp {
	if ([self year] != [comp year])
		return NO;
    
    return YES;
}


-(BOOL) isBetween: (NSDate*) date1 and: (NSDate*) date2 {
    if ([self compare: date1] < 0)
        return NO;
    
    if ([self compare: date2] > 0)
        return NO;
    
    return YES;
}

-(BOOL) isDateBetween: (NSDate*) date1 and: (NSDate*) date2 {
    int days = self.daysSince1970;
    
    return days >= date1.daysSince1970 && days <= date2.daysSince1970;
}

-(int) daysSince1970 {
    return [self timeIntervalSince1970] / (60 * 60 * 24);
}

-(int) weeksSince1970 {
    return (self.daysSince1970 / 7) + 1;
}

-(int) monthsSince1970 {
    return ((self.year - 1970) * 12) + self.month;
}

// Set methods
-(NSDate*) setDay: (int) day {
	return [NSDate dateWithMonth: [self month] day: day year: [self year]];
}

-(NSDate*) setMonth: (int) month {
	return [NSDate dateWithMonth: month day: [self day] year: [self year]];
}

-(NSDate*) setYear: (int) year {
	return [NSDate dateWithMonth: [self month] day: [self day] year: year];
}

-(NSDate*) setHour: (int) hour {
	return [NSDate dateWithMonth: [self month] day: [self day] year: [self year] hour: hour minutes: [self minute] seconds: [self seconds]];
    
}
-(NSDate*) setMinutes: (int) minute {
	return [NSDate dateWithMonth: [self month] day: [self day] year: [self year] hour: [self hour] minutes: minute seconds: [self seconds]];
}

-(NSDate*) setSeconds: (int) second {
	return [NSDate dateWithMonth: [self month] day: [self day] year: [self year] hour: [self hour] minutes: [self minute] seconds: second];
}

// Math methods
-(NSDate*) nextDay {	
	return [self adjustDateByType: AdjustTypeDay offset: 1];
}

-(NSDate*) previousDay {
	return [self adjustDateByType: AdjustTypeDay offset: -1];
}

-(NSDate*) nextWeek {
	return [self adjustDateByType: AdjustTypeDay offset: 7];
}

-(NSDate*) previousWeek {
	return [self adjustDateByType: AdjustTypeDay offset: -7];
}

-(NSDate*) nextMonth {
	return [self adjustDateByType: AdjustTypeMonth offset: 1];
}

-(NSDate*) previousMonth {
	return [self adjustDateByType: AdjustTypeMonth offset: -1];
}

-(NSDate*) nextQuarter {
    return [self adjustDateByType: AdjustTypeMonth offset: 3];
}

-(NSDate*) previousQuarter {
    return [self adjustDateByType: AdjustTypeMonth offset: -3];
}

-(NSDate*) nextYear {
	return [self adjustDateByType: AdjustTypeYear offset: 1];
}

-(NSDate*) previousYear {
	return [self adjustDateByType: AdjustTypeYear offset: -1];
}

-(NSDate*) firstDayOfNextMonth {
    return [[self nextMonth] firstDayInMonth];
}

-(NSDate*) firstDayOfPreviousMonth {
    return [[self previousMonth] firstDayInMonth];
}

-(NSDate*) addDays: (int) days {
    if (days == 0)
        return self;
	return [self adjustDateByType: AdjustTypeDay offset: days];
}

-(NSDate*) nextOccurenceOfWeekday: (int) weekday {
    if (weekday < 1 || weekday > 7)
        return nil;
    
    NSDate* test = self;
    while (YES) {
        if (test.dayOfWeek == weekday)
            return test;
        test = [test nextDay];
    }
}

// time methods
-(int) hour {
	return [self components].hour;
}

-(int) minute {
	return [self components].minute;
}

-(int) seconds {
    return [self components].second;                
}

-(NSDate*) addSeconds: (int) secondsToAdd {    
    int seconds = self.seconds + secondsToAdd;
    int minutesToAdd = seconds / 60;
    seconds = seconds % 60;
    
    int minutes = self.minute + minutesToAdd;
    int hoursToAdd = minutes / 60;
    minutes = minutes % 60;
    
    int hours = self.hour + hoursToAdd;
    int daysToAdd = hours / 24;
    hours = hours % 24;
    
    return [[[[self addDays: daysToAdd] setHour: hours] setMinutes: minutes] setSeconds: seconds];
}

-(NSDate*) addMinutes: (int) minutes {
    return [self addSeconds: minutes * 60];
}

-(NSDate*) addHours: (int) hours {
    return [self addMinutes: hours * 60];
}

-(int) compareTimeTo: (NSDate*) date {    
    int hour1 = [self hour];
    int hour2 = [date hour];
    
    if (hour1 < hour2)
        return -1;
    if (hour1 > hour2)
        return 1;
    
    int minute1 = [self minute];
    int minute2 = [date minute];
    
    if (minute1 < minute2)
        return  -1;
    if (minute1 > minute2)
        return  1;
    
    return 0;
}

-(NSDate*) midnight {
    return [[[self setHour: 0] setMinutes: 0] setSeconds: 0];
}

-(NSDate*) noon {
    return [[[self setHour: 12] setMinutes: 0] setSeconds: 0];
}

@end
