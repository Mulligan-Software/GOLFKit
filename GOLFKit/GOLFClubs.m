//
//  GOLFClubs.m
//  GOLFKit
//
//  Created by John Bishop on 4/2/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <GOLFKit/GOLFKit.h>
#import <GOLFKit/GOLFUtilities.h>
#import <GOLFKit/GOLFClubs.h>

//	Private Prototypes
//NSInteger EGACategoryFromEGAHandicap(float EGAHandicap, BOOL playerIsFemale);

//	Globals
//GOLFHandicapAuthority * const GOLFHandicapAuthorityWHS			= @"WHS";


//=================================================================
//	NSStringFromCourseMeasurementType(type, abbreviated, descriptiveText)
//=================================================================
NSString * NSStringFromCourseMeasurementType(GOLFCourseMeasurementType type, BOOL abbreviated, NSString **descriptiveText) {

//		Course Measurement Type
//
//		Type								  Value		Description
//		---------------------------------	---------	---------------------------------------
//		GOLFCourseMeasurementTypeUnknown		0
//		GOLFCourseMeasurementTypeImperial		1		Course length in imperial units (yards)
//		GOLFCourseMeasurementTypeMetric			2		Course length in metric units (meters)
	
	switch(type) {
		case GOLFCourseMeasurementTypeImperial:
			if (descriptiveText != nil) {
				*descriptiveText = [GOLFLocalizedString(@"TERM_IMPERIAL") capitalizedString];
			}
			return (abbreviated ? GOLFLocalizedString(@"TERM_YARD_PLURAL_ABBR") : GOLFLocalizedString(@"TERM_YARD_PLURAL"));
			
		case GOLFCourseMeasurementTypeMetric:
			if (descriptiveText != nil) {
				*descriptiveText = [GOLFLocalizedString(@"TERM_METRIC") capitalizedString];
			}
			return (abbreviated ? GOLFLocalizedString(@"TERM_METER_PLURAL_ABBR") : GOLFLocalizedString(@"TERM_METER_PLURAL"));
			
		case GOLFCourseMeasurementTypeUnknown:
		default:
			if (descriptiveText) {
				*descriptiveText = @"";
			}
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

