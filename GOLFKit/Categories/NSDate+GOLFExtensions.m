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
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:1];	//	Forward exactly 1 day
	return [calendar dateByAddingComponents:comps toDate:self options:0];	// Same time tomorrow
}

- (NSDate *)yesterdayDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:-1];	//	Backward exactly 1 day
	return [calendar dateByAddingComponents:comps toDate:self options:0];	// Same time yesterday
}

- (NSDate *)midnightDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
	return [calendar dateFromComponents:ourComponents];	//	Normalized to midnight
}

- (NSDate *)noonDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
	[ourComponents setHour:12];
	[ourComponents setMinute:0];
	[ourComponents setSecond:0];
	return [calendar dateFromComponents:ourComponents];	//	Noon
}

- (NSDate *)nextYearDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *yearComps = [[NSDateComponents alloc] init];
	[yearComps setYear:1];	//	Forward exactly 1 year
	return [calendar dateByAddingComponents:yearComps toDate:self options:0];
}

- (NSDate *)yearAgoDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *yearComps = [[NSDateComponents alloc] init];
	[yearComps setYear:-1];	//	Backward exactly 1 year
	return [calendar dateByAddingComponents:yearComps toDate:self options:0];
}

- (NSDate *)firstDayOfYearDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
	[ourComponents setMonth:1];
	[ourComponents setDay:1];
	return [calendar dateFromComponents:ourComponents];	// Same time on first day of the year
}

- (NSDate *)lastDayOfYearDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
	[ourComponents setYear:([ourComponents year] + 1)];
	[ourComponents setMonth:1];
	[ourComponents setDay:1];
	return [[calendar dateFromComponents:ourComponents] dateByAddingTimeInterval:(-60.0 * 60.0 * 24.0)];	// Same time on last day of the year
}

- (BOOL)isSameDayAsDate:(NSDate *)otherDate {
	if (otherDate) {
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *ourComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
		NSDateComponents *otherComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:otherDate];
		return (([ourComponents year] == [otherComponents year]) && ([ourComponents month] == [otherComponents month]) && ([ourComponents day] == [otherComponents day]));
	}
	return NO;
}

@end
