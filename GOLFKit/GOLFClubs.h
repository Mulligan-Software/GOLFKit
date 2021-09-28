//
//  GOLFClubs.h
//  GOLFKit
//
//  Created by John Bishop on 4/2/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GOLFKit/GOLFKitTypes.h>

//	Club/course related constants

//	No-value constants
#define kNotAPar					-999		//	No-value for par - GOLFPar
#define kNotAYardage				-999		//	No-value for yardage (imperial or metric) - GOLFYardage
#define kNotAHoleNumber				-999		//	No-value for a hole number - GOLFHoleNumber
#define kNotAHoleHandicap			-999		//	No-value for hole handicap (stroke allocation) - GOLFHoleHandicap
#define kNotACourseRating			-999.0		//	No-value for tee course rating (round or side) - GOLFTeeCourseRating
#define kNotASLOPERating			-999		//	No-value for tee SLOPE rating (round or side) - GOLFTeeSLOPERating

//	Status bits

typedef NS_OPTIONS(NSUInteger, GOLFClubStatus) {
	GOLFClubStatusNone						= 0,			//	(0)
	GOLFClubStatusSettingJuniorPar			= 1 << 0,		//	(1)			Setting USGA Junior Par
	GOLFClubStatusOption1					= 1 << 1,		//	(2)
	GOLFClubStatusOption2					= 1 << 2,		//	(4)
	GOLFClubStatusOption3					= 1 << 3,		//	(8)
	GOLFClubStatusSyncedToiCloud			= 1 << 4,		//	(16)		Club configuration is synced to user's iCloud account
	GOLFClubStatusSyncedFromMulligan		= 1 << 5,		//	(32)		Club configuration is synced from Mulligan Software archives
	GOLFClubStatusOption6					= 1 << 6,		//	(64)
	GOLFClubStatusOption7					= 1 << 7,		//	(128)
	GOLFClubStatusOption8					= 1 << 8,		//	(256)
	GOLFClubStatusIsSpecial					= 1 << 9,		//	(512)		Club gets "special" handling
};

typedef NS_OPTIONS(NSUInteger, GOLFCourseStatus) {
	GOLFCourseStatusNone					= 0,			//	(0)
	GOLFCourseStatusOption1					= 1 << 0,		//	(1)
	GOLFCourseStatusAllowsWalking			= 1 << 1,		//	(2)			Course allows walking
	GOLFCourseStatusOption2					= 1 << 2,		//	(4)
	GOLFCourseStatusOption3					= 1 << 3,		//	(8)
	GOLFCourseStatusOption4					= 1 << 4,		//	(16)
	GOLFCourseStatusOption5					= 1 << 5,		//	(32)
	GOLFCourseStatusOption6					= 1 << 6,		//	(64)
};

typedef NS_ENUM(NSUInteger, GOLFCourseMeasurementType) {
	GOLFCourseMeasurementTypeUnknown = 0,
	GOLFCourseMeasurementTypeImperial,		//	Course length in imperial units (yards)		(1)
	GOLFCourseMeasurementTypeYards = GOLFCourseMeasurementTypeImperial,
	GOLFCourseMeasurementTypeMetric,		//	Course length in metric units (meters)		(2)
	GOLFCourseMeasurementTypeMeters = GOLFCourseMeasurementTypeMetric
};


//=================================================================
//	NSStringFromCourseMeasurementType(type, abbreviated, descriptiveText)
//=================================================================
NSString * NSStringFromCourseMeasurementType(GOLFCourseMeasurementType type, BOOL abbreviated, NSString **descriptiveText);
//	Returns a localized description or abbreviation of the units of the specified GOLFCourseMeasurementType ("yards", "meters") and
//	optionally, the localized description of the measurement system ("imperial", "metric")


