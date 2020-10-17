//
//  NSDate+GOLFExtensions.h
//  GOLFKit
//
//  Created by John Bishop on 1/9/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

#import <GOLFKit/GOLFKit.h>

@interface NSDate (GOLFExtensions)

//	Exactly one day forward
- (NSDate *)tomorrowDate;

//	Exactly one day backward
- (NSDate *)yesterdayDate;

//	Date normalized to midnight (no minutes or seconds)
- (NSDate *)midnightDate;

//	Date normalized to noon (12:00:00)
- (NSDate *)noonDate;

//	Exactly one year forward
- (NSDate *)nextYearDate;

//	Exactly one year backward
- (NSDate *)yearAgoDate;

//	Same time on first day of the year
- (NSDate *)firstDayOfYearDate;

//	Same time on last day of the year
- (NSDate *)lastDayOfYearDate;

//	Day comparison, ignoring time
- (BOOL)isSameDayAsDate:(NSDate *)otherDate;

@end
