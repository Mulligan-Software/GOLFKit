//
//  NSDate+GOLFExtensions.m
//  GOLFKit
//
//  Created by John Bishop on 1/9/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

#import "NSDate+GOLFExtensions.h"
#import "GOLFKitTypes.h"

@implementation NSDate (GOLFExtensions)

- (NSDate *)tomorrowDate {
	//	Returns a local NSDate, at the same time, for the next day (tomorrow))
	//	Exactly one day forward
	NSCalendar *calendar = [NSCalendar currentCalendar];
//	NSDateComponents *comps = [[NSDateComponents alloc] init];
//	[comps setDay:1];	//	Forward exactly 1 day
//	return [calendar dateByAddingComponents:comps toDate:self options:0];	// Same time tomorrow
	return [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:self options:0];	//	Same time tomorrow
}

- (NSDate *)yesterdayDate {
	//	Returns a local NSDate, at the same time, for the previous day (yesterday)
	NSCalendar *calendar = [NSCalendar currentCalendar];
//	NSDateComponents *comps = [[NSDateComponents alloc] init];
//	[comps setDay:-1];	//	Backward exactly 1 day
//	return [calendar dateByAddingComponents:comps toDate:self options:0];	// Same time yesterday
	return [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:self options:0];	//	Same time yesterday
}

- (NSDate *)midnightDate {
	//	Returns a calendar-determinent start of day (local midnight)
	//	Thus, the NSDate (with its UTC offset) that defines 12:00AM o'clock locally
	//	The return NSDate is the first instant of the day represented by self and usually
	//	requires an NSDateFormatter to display in local time formats
	NSCalendar *calendar = [NSCalendar currentCalendar];
	return [calendar startOfDayForDate:self];
}

- (NSDate *)noonDate {
	//	Returns a calendar-determinent middle of day (local noon)
	NSCalendar *calendar = [NSCalendar currentCalendar];
	return [calendar dateByAddingUnit:NSCalendarUnitHour value:12 toDate:[self midnightDate] options:0];	//	12 hours after midnight
}

- (NSDate *)nextYearDate {
	//	Returns a local NSDate, at the same time and day, in the next year
	NSCalendar *calendar = [NSCalendar currentCalendar];
	return [calendar dateByAddingUnit:NSCalendarUnitYear value:1 toDate:self options:0];
}

- (NSDate *)yearAgoDate {
	//	Returns a local NSDate, at the same time and day, in the previous year
	NSCalendar *calendar = [NSCalendar currentCalendar];
	return [calendar dateByAddingUnit:NSCalendarUnitYear value:-1 toDate:self options:0];
}

- (NSDate *)firstDayOfYearDate {
	//	Returns a local NSDate, at the same time, of the first day of the year (like: Jan 1st)
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond) fromDate:self];
	[ourComponents setMonth:1];
	[ourComponents setDay:1];
	return [calendar dateFromComponents:ourComponents];	// Same time on first day of the year
}

- (NSDate *)lastDayOfYearDate {
	//	Returns a local NSDate, at the same time, of the last day of the year (like: Dec 31st)
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond) fromDate:self];
	[ourComponents setYear:([ourComponents year] + 1)];
	[ourComponents setMonth:1];
	[ourComponents setDay:1];
	NSDate *first = [calendar dateFromComponents:ourComponents];	// Same time on first day of next year
	return [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:first options:0];	//	Same time on last day of the year
}

- (BOOL)isSameDayAsDate:(NSDate *)otherDate {
	//	Compares our (year, month, day) to otherDate, without comparing era or time
	if (otherDate) {
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
		NSDateComponents *otherComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:otherDate];
		return (([ourComponents year] == [otherComponents year]) && ([ourComponents month] == [otherComponents month]) && ([ourComponents day] == [otherComponents day]));
	}
	return NO;
}

@end
