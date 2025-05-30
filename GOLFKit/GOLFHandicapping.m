//
//  GOLFHandicapping.m
//  GOLFKit
//
//  Created by John Bishop on 3/6/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFUtilities.h"
#import "GOLFExtensions.h"
#import "GOLFHandicapping.h"

//	Private Prototypes
NSInteger EGACategoryFromEGAHandicap(float EGAHandicap, BOOL playerIsFemale);
float EGABufferLimitFromCategory(NSInteger category, BOOL is9HoleRound);
float EGAPerStrokeHandicapReductionFromCategory(NSInteger category);
float EGAHandicapAdditionFromCategory(NSInteger category);

//	Globals
GOLFHandicapAuthority * const GOLFHandicapAuthorityUSGA			= @"USGA";
GOLFHandicapAuthority * const GOLFHandicapAuthorityRCGA			= @"RCGA";
GOLFHandicapAuthority * const GOLFHandicapAuthorityAGU			= @"AGU";
GOLFHandicapAuthority * const GOLFHandicapAuthorityEGA			= @"EGA";
GOLFHandicapAuthority * const GOLFHandicapAuthorityCONGU		= @"CONGU";
GOLFHandicapAuthority * const GOLFHandicapAuthorityWHS			= @"WHS";
GOLFHandicapAuthority * const GOLFHandicapAuthorityWHS2020		= @"WHS2020";
GOLFHandicapAuthority * const GOLFHandicapAuthorityMulligan		= @"MULLIGAN";
GOLFHandicapAuthority * const GOLFHandicapAuthoritySecondBest	= @"SECONDBEST";
GOLFHandicapAuthority * const GOLFHandicapAuthorityPersonal		= @"PERSONAL";

static NSArray *cachedGOLFHandicapAuthorities = nil;
static NSDictionary *cachedGOLFHomeCountryInfo = nil;

#pragma mark Localization & non-authority utilities

//=================================================================
//	NSStringFromGOLFHandicapExpectedScoreMethod(method, &descriptiveText)
//=================================================================
NSString * NSStringFromGOLFHandicapExpectedScoreMethod(GOLFHandicapExpectedScoreMethod method, NSString **descriptiveText) {
	//	Returns a localized title/name of an Expected Score calculation technique ("Net Par", "Scoring Record", "USGA Table", etc.) and
	//	optionally (when the address of descriptiveText is provided), a localized description of the
	//	method ("An expected score for holes if played at net par - par plus handicap stroke(s)", etc.)

	//	GOLFHandicapExpectedScoreMethodNone = 0,			//	Don't calculate Expected Scores						(0)
	//	GOLFHandicapExpectedScoreMethodNetPar,				//	Calculate net par (nines or unplayed holes)			(1)
	//	GOLFHandicapExpectedScoreMethodNetParPlus1,			//	Calculate net par (nines or unplayed holes)			(2)
	//	GOLFHandicapExpectedScoreMethodUsingRecord,			//	Calculate from active scores record (last 20?)		(3) *
	//	GOLFHandicapExpectedScoreMethodUsingHistory,		//	Calculate from scoring history (last 365 days?)		(4)	*
	//	GOLFHandicapExpectedScoreMethodUSGATable = 10,		//	Calculate with USGA expected score table			(10)
	//	GOLFHandicapExpectedScoreMethodUnknown = 99			//	Unknown method for Expected Score calculations

	if (method == GOLFHandicapExpectedScoreMethodNetPar) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_NET_PAR");	//	Calculate net par (par + strokes) for nines or unplayed holes
		}
		return GOLFLocalizedString(@"TITLE_NET_PAR");
	} else if (method == GOLFHandicapExpectedScoreMethodNetParPlus1) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_NET_PAR_PLUS_1");	//	Calculate net par (par + strokes) for nines or unplayed holes
		}
		return GOLFLocalizedString(@"TITLE_NET_PAR_PLUS_1");
	} else if (method == GOLFHandicapExpectedScoreMethodUsingRecord) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SCORING_RECORD");	//	Determine, typical score or differential from player's scoring record - last 20 rounds
		}
		return GOLFLocalizedString(@"TITLE_SCORING_RECORD");
	} else if (method == GOLFHandicapExpectedScoreMethodUsingHistory) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SCORING_HISTORY");	//	Determine, typical score or differential from historical scoring - 365 days
		}
		return GOLFLocalizedString(@"TITLE_SCORING_HISTORY");
	} else if (method == GOLFHandicapExpectedScoreMethodUSGATable) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_USGA_TABLE");	//	Retrieve score or differential from proprietary USGA statistical tables
		}
		return GOLFLocalizedString(@"TITLE_USGA_TABLE");
	} else if (method == GOLFHandicapExpectedScoreMethodNone) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_NO_METHOD");	//	Do not use expected scores for handicapping
		}
		return [GOLFLocalizedString(@"TERM_NONE") capitalizedString];
	} else {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"");
		}
		return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

//=================================================================
//	NSStringFromGOLFHandicapCalculationScheduleType(type, &descriptiveText, &day)
//=================================================================
NSString * NSStringFromGOLFHandicapCalculationScheduleType(GOLFHandicapCalculationScheduleType type, NSString **descriptiveText, NSInteger *specifiedDay) {
	//	Returns a localized title/name of a handicap calculation schedule type ("None", "Daily", "Weekly", etc.) and
	//	optionally (when the address of descriptiveText is provided), a localized description of the
	//	type ("No schedule", "Calculation of new handicap records for play through every day",
	//	"Calculation of new handicap records for play through the last day of the month", etc.)

	//	GOLFHandicapCalculationScheduleType			value	description
	//	-----------------------------------------	-----	--------------------------------------------------
	//	GOLFHandicapCalculationScheduleTypeNone		  0		No handicap calculation schedule set (None)
	//	GOLFHandicapCalculationScheduleTypeDaily	  1		Handicap calculation daily
	//	GOLFHandicapCalculationScheduleTypeWeekly	 10		Handicap calculation weekly on a specified weekday
	//	GOLFHandicapCalculationScheduleTypeMonthly	 20		Handicap calculation monthly on a specified day
	//	GOLFHandicapCalculationScheduleTypeMonthEnd	 21		Handicap calculation on the last day of the month
	
	NSInteger dayOrWeekday = 0;	//	Unknown date
	NSDateFormatter *dateFormatter;
	if (specifiedDay) {
		dayOrWeekday = *specifiedDay;
	}

	if (type == GOLFHandicapCalculationScheduleTypeNone) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_HANDICAP_CALCULATION_TYPE_NONE");	//	No handicap calculation scheduled
		}
		return [GOLFLocalizedString(@"TERM_NONE") capitalizedString];
	} else if (type == GOLFHandicapCalculationScheduleTypeDaily) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_HANDICAP_CALCULATION_TYPE_DAILY");	//	Daily handicap calculations through each day end
		}
		return [GOLFLocalizedString(@"TERM_DAILY") capitalizedString];
	} else if (type == GOLFHandicapCalculationScheduleTypeWeekly) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_HANDICAP_CALCULATION_TYPE_WEEKLY");	//	Weekly handicap calculations through the end of a specified weekday of each week
		}
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.calendar = [NSCalendar currentCalendar];
		dateFormatter.locale = [NSLocale currentLocale];
		NSString *weekdayName;

		if (dayOrWeekday > 0) {
			weekdayName = [[dateFormatter weekdaySymbols] objectAtIndex:(dayOrWeekday - 1)];
		} else {
			weekdayName = GOLFLocalizedString(@"DESCRIPTION_HANDICAP_CALCULATION_THE_WEEKDAY");
		}
		return [NSString localizedStringWithFormat:GOLFLocalizedString(@"FORMAT_WEEKLY_THROUGH_%@"), weekdayName];
	} else if (type == GOLFHandicapCalculationScheduleTypeMonthly) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_HANDICAP_CALCULATION_TYPE_MONTHLY");	//	Monthly handicap calculations through the end of a specified day of each month 
		}
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.calendar = [NSCalendar currentCalendar];
		dateFormatter.locale = [NSLocale currentLocale];
		NSString *dayName;
		if (dayOrWeekday > 0) {
			dayName = [NSString localizedStringWithFormat:@"%ld%@", (long)dayOrWeekday, NSStringOrdinalSuffixFromRank(dayOrWeekday)];
		} else {
			dayName = GOLFLocalizedString(@"DESCRIPTION_HANDICAP_CALCULATION_NTH_DAY");
		}
		return [NSString localizedStringWithFormat:GOLFLocalizedString(@"FORMAT_MONTHLY_THROUGH_%@"), dayName];
	} else if (type == GOLFHandicapCalculationScheduleTypeMonthEnd) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_HANDICAP_CALCULATION_TYPE_MONTHEND");	//	Monthly handicap calculations through the last day of each month
		}
		return GOLFLocalizedString(@"TITLE_MONTHLY_LAST_DAY");
	} else {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"");
		}
		return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

#pragma mark Handicap authority-specific functions and utilities

//=================================================================
//	GOLFDefaultHandicapAuthority()
//=================================================================
GOLFHandicapAuthority * GOLFDefaultHandicapAuthority(void) {
	if (cachedGOLFHomeCountryInfo == nil) {
		cachedGOLFHomeCountryInfo = GOLFHomeCountryInfo();	//	This might take a bit, so we just get it once
	}
	
	GOLFHandicapAuthority *prospectiveAuthority = [cachedGOLFHomeCountryInfo objectForKey:@"authority"];
	if (!GOLFHandicapValidAuthority(prospectiveAuthority)
			|| [[GOLFHandicapInfoForAuthority(prospectiveAuthority) objectForKey:@"obsolete"] boolValue]) {
		prospectiveAuthority = [[NSUserDefaults standardUserDefaults] objectForKey:@"HandicapAuthority"];
		if (!GOLFHandicapValidAuthority(prospectiveAuthority)
				|| [[GOLFHandicapInfoForAuthority(prospectiveAuthority) objectForKey:@"obsolete"] boolValue]) {
			prospectiveAuthority = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSelectedHandicapAuthority"];
			if (!GOLFHandicapValidAuthority(prospectiveAuthority)
					|| [[GOLFHandicapInfoForAuthority(prospectiveAuthority) objectForKey:@"obsolete"] boolValue]) {
				prospectiveAuthority = GOLFHandicapAuthorityWHS;
			}
		}
	}

	return prospectiveAuthority;
}

//=================================================================
//	GOLFHandicapAuthorityFromMethodIndex(methodIndex)
//=================================================================
GOLFHandicapAuthority * GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodIndex methodIndex) {
	switch (methodIndex) {
  		case GOLFHandicapMethodUSGA:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityUSGA;

  		case GOLFHandicapMethodRCGA:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityRCGA;

  		case GOLFHandicapMethodAGU:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityAGU;

  		case GOLFHandicapMethodEGA:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityEGA;

  		case GOLFHandicapMethodCONGU:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityCONGU;

  		case GOLFHandicapMethodWHS:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityWHS;

  		case GOLFHandicapMethodWHS2020:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityWHS2020;

  		case GOLFHandicapMethodMulligan:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityMulligan;

  		case GOLFHandicapMethodPersonal:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityPersonal;

  		case GOLFHandicapMethodSecondBest:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthoritySecondBest;

  		case GOLFHandicapMethodNone:
  		case GOLFHandicapMethodUnknown:
  		default:
    		return nil;
	}	//	switch (methodIndex)
}

//=================================================================
//	GOLFHandicapBestMethodIndexFromAuthority(authority)
//=================================================================
GOLFHandicapMethodIndex GOLFHandicapBestMethodIndexFromAuthority(GOLFHandicapAuthority *authority) {
	if (authority && [authority isKindOfClass:[GOLFHandicapAuthority class]]) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			return GOLFHandicapMethodUSGA;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return GOLFHandicapMethodRCGA;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return GOLFHandicapMethodAGU;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			return GOLFHandicapMethodEGA;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return GOLFHandicapMethodCONGU;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return GOLFHandicapMethodWHS;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return GOLFHandicapMethodWHS2020;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return GOLFHandicapMethodMulligan;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return GOLFHandicapMethodPersonal;
		} else if ([authority isEqualToString:GOLFHandicapAuthoritySecondBest]) {
			return GOLFHandicapMethodSecondBest;
		}
	}
	return GOLFHandicapMethodWHS;
}

//=================================================================
//	GOLFHandicapCertifiableAuthority(authority)
//=================================================================
BOOL GOLFHandicapCertifiableAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]
				|| [authority isEqualToString:GOLFHandicapAuthorityRCGA]
				|| [authority isEqualToString:GOLFHandicapAuthorityAGU]
				|| [authority isEqualToString:GOLFHandicapAuthorityCONGU]
				|| [authority isEqualToString:GOLFHandicapAuthorityEGA]
				|| [authority isEqualToString:GOLFHandicapAuthorityWHS]
				|| [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return YES;
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapValidAuthority(authority)
//=================================================================
BOOL GOLFHandicapValidAuthority(GOLFHandicapAuthority *authority) {
	if (authority && ([authority length] > 0)) {
		for (NSDictionary *authDict in GOLFHandicapAuthorities()) {
			NSString *candidate = [authDict objectForKey:@"handicapAuthority"];
			if (candidate && [candidate isEqualToString:authority]) {
				return YES;
			}
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapInfoForAuthority(authority)
//=================================================================
NSDictionary * GOLFHandicapInfoForAuthority(GOLFHandicapAuthority *authority) {
	//	Returns an NSDictionary, with information about a handicapping authority and the
	//	handicapping system used by its golfers:
	//
	//	Key						Type			Description
	//	----------------------	--------------	---------------------------------
	//	methodIndex				NSNumber *		GOLFHandicapMethodIndex identifying the handicapping authority
	//	handicapAuthority		NSString *		A mnemonic identifying the handicapping authority - used in most handicapping function calls
	//	authorityDisplay		NSString *		A mnemonic for display identifying the handicapping authority
	//	association				NSString *		The localized name of the handicapping association (authority)
	//	URL						NSString *		The URL of the handicapping association (authority) web site
	//	methodName				NSString *		The localized name of the handicap SYSTEM supported by the authority
	//	certifiable				NSNumber *		A BOOL indicating whether the handicap method requires certification for use
	//	obsolete				NSNumber *		A BOOL indicating the handicap method is not available as a default
	
	if (authority && ([authority length] > 0)) {
		for (NSDictionary *authDict in GOLFHandicapAuthorities()) {
			NSString *candidate = [authDict objectForKey:@"handicapAuthority"];
			if (candidate && [candidate isEqualToString:authority]) {
				return authDict;
			}
		}
	}
	return nil;
}

//=================================================================
//	GOLFHandicapAuthorities()
//=================================================================
NSArray * GOLFHandicapAuthorities(void) {
	if (cachedGOLFHandicapAuthorities == nil) {
		BOOL enforceExtinctHandicaps = [[[NSUserDefaults standardUserDefaults] objectForKey:@"EnforceExtinctHandicaps"] boolValue];
		NSMutableArray *workingArray = [NSMutableArray arrayWithObjects:
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodWHS], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodWHS), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodWHS), @"authorityDisplay",
						GOLFLocalizedString(@"HANDICAP_ASSOCIATION_WHS"), @"association",
						@"https://www.usga.org/content/dam/usga/pdf/Handicap/Rules-of-Handicapping_USGA_Final.pdf", @"URL",
						GOLFLocalizedString(@"HANDICAP_METHOD_WHS"), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodRCGA], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodRCGA), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodRCGA), @"authorityDisplay",
						GOLFLocalizedString(@"HANDICAP_ASSOCIATION_RCGA"), @"association",
						@"http://www.golfcanada.ca", @"URL",
						GOLFLocalizedString(@"HANDICAP_METHOD_RCGA"), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodAGU], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodAGU), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodAGU), @"authorityDisplay",
						GOLFLocalizedString(@"HANDICAP_ASSOCIATION_AGU"), @"association",
						@"http://www.golf.org.au", @"URL",
						GOLFLocalizedString(@"HANDICAP_METHOD_AGU"), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodEGA], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodEGA), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodEGA), @"authorityDisplay",
						GOLFLocalizedString(@"HANDICAP_ASSOCIATION_EGA"), @"association",
						@"http://www.ega-golf.ch", @"URL",
						GOLFLocalizedString(@"HANDICAP_METHOD_EGA"), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodCONGU], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodCONGU), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodCONGU), @"authorityDisplay",
						GOLFLocalizedString(@"HANDICAP_ASSOCIATION_CONGU"), @"association",
						@"http://www.congu.com", @"URL",
						GOLFLocalizedString(@"HANDICAP_METHOD_CONGU"), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodWHS2020], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodWHS2020), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodWHS2020), @"authorityDisplay",
						GOLFLocalizedString(@"HANDICAP_ASSOCIATION_WHS"), @"association",
						@"https://www.usga.org/content/dam/usga/pdf/Handicap/Rules-of-Handicapping_USGA_Final.pdf", @"URL",
						GOLFLocalizedString(@"HANDICAP_METHOD_WHS2020"), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodUSGA], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodUSGA), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodUSGA), @"authorityDisplay",
						GOLFLocalizedString(@"HANDICAP_ASSOCIATION_USGA"), @"association",
						@"https://www.usga.org", @"URL",
						(enforceExtinctHandicaps
								? [NSString stringWithFormat:@"%@ (%@)", GOLFLocalizedString(@"HANDICAP_METHOD_USGA"), GOLFLocalizedString(@"TERM_SUPERSEDED")]
								: GOLFLocalizedString(@"HANDICAP_METHOD_USGA")), @"methodName",
						[NSNumber numberWithBool:(enforceExtinctHandicaps ? NO : YES)], @"certifiable",
						[NSNumber numberWithBool:YES], @"obsolete",
						nil],
				nil];
		
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		//	In iOS, we allow use of incoming GOLFHandicapMethodMulligan and GOLFHandicapMethodSecondBest, but
		//	we don't include them in this list as selectable types of handicapping
		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodMulligan], @"methodIndex",
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodMulligan), @"handicapAuthority",
					GOLFLocalizedString(@"HANDICAP_METHOD_MULLIGAN"), @"methodName",
					nil]];
		
		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodPersonal], @"methodIndex",
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodPersonal), @"handicapAuthority",
					GOLFLocalizedString(@"HANDICAP_METHOD_PERSONAL"), @"methodName",
					nil]];

		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodSecondBest], @"methodIndex",
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodSecondBest), @"handicapAuthority",
					GOLFLocalizedString(@"HANDICAP_METHOD_2ND_BEST"), @"methodName",
					nil]];
#endif
		cachedGOLFHandicapAuthorities = [NSArray arrayWithArray:workingArray];
	}	//	if (cachedGOLFHandicapAuthorities == nil)
	return [cachedGOLFHandicapAuthorities copy];
}

//=================================================================
//	GOLFHandicapMethodNameForAuthority(authority)
//=================================================================
NSString * GOLFHandicapMethodNameForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		for (NSDictionary *authorityDict in GOLFHandicapAuthorities()) {
			if ([authority isEqualToString:[authorityDict objectForKey:@"handicapAuthority"]])
				return [authorityDict objectForKey:@"methodName"];
		}
	}
	return GOLFLocalizedString(@"HANDICAP_METHOD_UNKNOWN");
}

//=================================================================
//	GOLFHandicapIndexTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFHandicapIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	return GOLFOfficialHandicapTitle(handicapMethod, plural);
}

//=================================================================
//	GOLFHandicapIndexCasualTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFHandicapIndexCasualTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	switch (handicapMethod) {
  		case GOLFHandicapMethodWHS:
  		case GOLFHandicapMethodWHS2020:
  		case GOLFHandicapMethodUSGA:
  		case GOLFHandicapMethodSecondBest:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_INDEX_PLURAL" : @"TITLE_HANDICAP_INDEX");

  		case GOLFHandicapMethodRCGA:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_FACTOR_PLURAL" : @"TITLE_HANDICAP_FACTOR");

  		case GOLFHandicapMethodAGU:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_GA_PLURAL" : @"TITLE_HANDICAP_GA");

  		case GOLFHandicapMethodEGA:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_EGA_PLURAL" : @"TITLE_HANDICAP_EGA");

  		case GOLFHandicapMethodCONGU:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_EXACT_PLURAL" : @"TITLE_HANDICAP_EXACT");

  		case GOLFHandicapMethodMulligan:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_EXPECTED_PLURAL" : @"TITLE_HANDICAP_EXPECTED");

  		case GOLFHandicapMethodPersonal:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_PERSONAL_PLURAL" : @"TITLE_HANDICAP_PERSONAL");

  		default:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_PLURAL" : @"TITLE_HANDICAP");
	}
}

//=================================================================
//	GOLFHandicapCurrentIndexTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFHandicapCurrentIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	NSString *titleString = GOLFOfficialHandicapTitle(handicapMethod, plural);	//	This and the format string must handle capitalization
	NSString *currentFormat = GOLFLocalizedString(plural ? @"FORMAT_CURRENT_%@_TITLE_PLURAL" : @"FORMAT_CURRENT_%@_TITLE");
	return [NSString stringWithFormat:currentFormat, titleString];
}

//=================================================================
//	GOLFOfficialHandicapTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFOfficialHandicapTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	switch (handicapMethod) {
  		case GOLFHandicapMethodUSGA:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_INDEX_RTM_PLURAL" : @"TITLE_HANDICAP_INDEX_RTM");

  		case GOLFHandicapMethodRCGA:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_FACTOR_PLURAL" : @"TITLE_HANDICAP_FACTOR");

  		case GOLFHandicapMethodAGU:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_GA_PLURAL" : @"TITLE_HANDICAP_GA");

  		case GOLFHandicapMethodEGA:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_EGA_PLURAL" : @"TITLE_HANDICAP_EGA");

  		case GOLFHandicapMethodCONGU:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_EXACT_PLURAL" : @"TITLE_HANDICAP_EXACT");

  		case GOLFHandicapMethodMulligan:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_EXPECTED_PLURAL" : @"TITLE_HANDICAP_EXPECTED");

  		case GOLFHandicapMethodPersonal:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_PERSONAL_PLURAL" : @"TITLE_HANDICAP_PERSONAL");

  		case GOLFHandicapMethodSecondBest:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_INDEX_PLURAL" : @"TITLE_HANDICAP_INDEX");

  		case GOLFHandicapMethodWHS:
  		case GOLFHandicapMethodWHS2020:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_INDEX_RTM_PLURAL" : @"TITLE_HANDICAP_INDEX_RTM");	//	"World Handicap Index(es)"

  		default:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_PLURAL" : @"TITLE_HANDICAP");
	}
}

//=================================================================
//	GOLFPlayingHandicapTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFPlayingHandicapTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	switch (handicapMethod) {
  		case GOLFHandicapMethodUSGA:
     		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_COURSE_TM_PLURAL" : @"TITLE_HANDICAP_COURSE_TM");

 		case GOLFHandicapMethodRCGA:
  		case GOLFHandicapMethodSecondBest:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_COURSE_PLURAL" : @"TITLE_HANDICAP_COURSE");

  		case GOLFHandicapMethodAGU:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_DAILY_PLURAL" : @"TITLE_HANDICAP_DAILY");

  		case GOLFHandicapMethodEGA:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_EGA_PLAYING_PLURAL" : @"TITLE_HANDICAP_EGA_PLAYING");

		case GOLFHandicapMethodWHS:
		case GOLFHandicapMethodWHS2020:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_COURSE_TM_PLURAL" : @"TITLE_HANDICAP_COURSE_TM");

  		case GOLFHandicapMethodCONGU:
  		case GOLFHandicapMethodMulligan:
  		case GOLFHandicapMethodPersonal:
  		default:
    		return GOLFLocalizedString(plural ? @"TITLE_HANDICAP_PLAYING_PLURAL" : @"TITLE_HANDICAP_PLAYING");
	}
}

//=================================================================
//	GOLFHandicapAllowanceTitle(handicapMethod)
//=================================================================
NSString * GOLFHandicapAllowanceTitle(GOLFHandicapMethodIndex handicapMethod) {
	switch (handicapMethod) {
		case GOLFHandicapMethodWHS:
		case GOLFHandicapMethodWHS2020:
    		return GOLFLocalizedString(@"TITLE_HANDICAP_PLAYING");

		case GOLFHandicapMethodAGU:
			return GOLFLocalizedString(@"TITLE_HANDICAP_ALLOWANCE");

		case GOLFHandicapMethodUSGA:
		case GOLFHandicapMethodRCGA:
		case GOLFHandicapMethodSecondBest:
		case GOLFHandicapMethodEGA:
		case GOLFHandicapMethodCONGU:
		case GOLFHandicapMethodMulligan:
		case GOLFHandicapMethodPersonal:
		default:
			return GOLFLocalizedString(@"TITLE_HANDICAP_ALLOWANCE");
	}
}

//=================================================================
//	GOLFHandicapAccountNumberTitle(handicapMethod)
//=================================================================
NSString * GOLFHandicapAccountNumberTitle(GOLFHandicapMethodIndex handicapMethod) {
	switch (handicapMethod) {
		case GOLFHandicapMethodWHS:
		case GOLFHandicapMethodWHS2020:
			return GOLFLocalizedString(@"TITLE_HANDICAP_ID");

		case GOLFHandicapMethodUSGA:
			return GOLFLocalizedString(@"TITLE_GHIN_NUMBER");
			
		case GOLFHandicapMethodAGU:
			return GOLFLocalizedString(@"TITLE_GOLFLINK_NUMBER");

		case GOLFHandicapMethodRCGA:
		case GOLFHandicapMethodSecondBest:
		case GOLFHandicapMethodEGA:
		case GOLFHandicapMethodCONGU:
		case GOLFHandicapMethodMulligan:
		case GOLFHandicapMethodPersonal:
		default:
			return GOLFLocalizedString(@"TITLE_HANDICAPPING_NUMBER");
	}
}

//=================================================================
//	GOLFHandicapAdjustedGrossTitle(handicapMethod)
//=================================================================
NSString * GOLFHandicapAdjustedGrossTitle(GOLFHandicapMethodIndex handicapMethod) {
	if (handicapMethod == GOLFHandicapMethodAGU) {
		return GOLFLocalizedString(@"TITLE_HANDICAP_ELIGIBLE_SCORE");
	} else if ((handicapMethod == GOLFHandicapMethodEGA) || (handicapMethod == GOLFHandicapMethodCONGU)) {
		return GOLFLocalizedString(@"TITLE_HANDICAP_STABLEFORD_SCORE");
	}
	//	Everybody else
	return GOLFLocalizedString(@"TITLE_HANDICAP_ADJUSTED_GROSS");
}

//=================================================================
//	GOLFHandicapDifferentialTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapDifferentialTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return GOLFLocalizedString(abbreviated ? @"TITLE_HANDICAP_DIFFERENTIAL_ABBR" : @"TITLE_HANDICAP_DIFFERENTIAL");
}

//=================================================================
//	GOLFHandicapGradeTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapGradeTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return GOLFLocalizedString(abbreviated ? @"TITLE_HANDICAP_GRADE_ABBR" : @"TITLE_HANDICAP_GRADE");
}

//=================================================================
//	GOLFHandicapCCRTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapCCRTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	if (handicapMethod == GOLFHandicapMethodAGU) {
		return GOLFLocalizedString(abbreviated ? @"TITLE_PCC_ABBR" : @"TITLE_PCC");	//	Playing Conditions Calculation
	} else if (handicapMethod == GOLFHandicapMethodCONGU) {
		return GOLFLocalizedString(abbreviated ? @"TITLE_CSS_ABBR" : @"TITLE_CSS");	//	Competition Scratch Score
	} else if (handicapMethod == GOLFHandicapMethodEGA) {
		return GOLFLocalizedString(abbreviated ? @"TITLE_CBA_ABBR" : @"TITLE_CBA");	//	Computed Buffer Adjustment
	} else if ((handicapMethod == GOLFHandicapMethodWHS) || (handicapMethod == GOLFHandicapMethodWHS2020)) {
		return GOLFLocalizedString(abbreviated ? @"TITLE_PCC_ABBR" : @"TITLE_PCC");	//	Playing Conditions Calculation
	}
	return GOLFLocalizedString(abbreviated ? @"TITLE_CCR_ABBR" : @"TITLE_CCR");	//	Calculated Course Rating
}

//=================================================================
//	GOLFHandicapCSSTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapCSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	if ((handicapMethod == GOLFHandicapMethodWHS) || (handicapMethod == GOLFHandicapMethodWHS2020)) {
		return GOLFLocalizedString(abbreviated ? @"TITLE_PCC_ABBR" : @"TITLE_PCC");	//	Playing Conditions Calculation
	} else if (handicapMethod == GOLFHandicapMethodAGU) {
		return GOLFLocalizedString(abbreviated ? @"TITLE_PCC_ABBR" : @"TITLE_PCC");	//	Playing Conditions Calculation
	}
	return GOLFLocalizedString(abbreviated ? @"TITLE_CSS_ABBR" : @"TITLE_CSS");	//	Competition Scratch Score
}

//=================================================================
//	GOLFHandicapSSSTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapSSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return GOLFLocalizedString(abbreviated ? @"TITLE_SSS_ABBR" : @"TITLE_SSS");
}

//=================================================================
//	GOLFHandicapTableBlurb(handicapMethod)
//=================================================================
NSString * GOLFHandicapTableBlurb(GOLFHandicapMethodIndex handicapMethod) {
	NSString *slopeChartTitle = GOLFLocalizedString(@"TITLE_HANDICAP_SLOPE_CHART");	//	"Slope Chart"
//	NSString *handicapTableTitle = GOLFLocalizedString(@"TITLE_HANDICAP_TABLE");	//	"Handicap Table"
	NSString *playingHandicapTitle = GOLFPlayingHandicapTitle(handicapMethod, NO);	//	Localized
	NSString *officialHandicapTitle = GOLFOfficialHandicapTitle(handicapMethod, NO);	//	Localized

	switch (handicapMethod) {
  		case GOLFHandicapMethodPersonal:
  			{
				GOLFPlayingHandicapType playingHandicapType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHPlayingHandicapType"] integerValue];
				switch (playingHandicapType) {
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
					case GOLFPlayingHandicapTypeRatingAdjusted:
						//	Use just the rating to adjust the handicap…
						return [NSString stringWithFormat:GOLFLocalizedString(@"HANDICAP_BLURB_PLAY_%@_CHART_%@_INDEX_%@_PLAY_%@_BASED_%@"),
								playingHandicapTitle,
								slopeChartTitle,
								officialHandicapTitle,
								playingHandicapTitle,
								GOLFLocalizedString(@"TITLE_HANDICAP_COURSE_RATING")];

					case GOLFPlayingHandicapTypeSlopeAdjusted:
						//	Playing handicap is handicap adjusted from neutral slope…
						return [NSString stringWithFormat:GOLFLocalizedString(@"HANDICAP_BLURB_PLAY_%@_CHART_%@_INDEX_%@_PLAY_%@_BASED_%@"),
								playingHandicapTitle,
								slopeChartTitle,
								officialHandicapTitle,
								playingHandicapTitle,
								GOLFLocalizedString(@"TITLE_HANDICAP_SLOPE_RATING")];

					case GOLFPlayingHandicapTypeFullyAdjusted:
						{
							//	Use both slope, rating and par to adjust the handicap…
							NSString *usingPhrase = GOLFLocalizedString(@"TITLE_HANDICAP_SLOPE_RATING");
							if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SuppressVsParHandicapAdjustments"]) {
								usingPhrase = [usingPhrase stringByAppendingFormat:@", %@", GOLFLocalizedString(@"TITLE_HANDICAP_COURSE_RATING")];
								usingPhrase = [usingPhrase stringByAppendingFormat:GOLFLocalizedString(@"FORMAT_AND_%@"), GOLFLocalizedString(@"TERM_PAR")];
							}

							return [NSString stringWithFormat:GOLFLocalizedString(@"HANDICAP_BLURB_PLAY_%@_CHART_%@_INDEX_%@_PLAY_%@_BASED_%@"),
									playingHandicapTitle,
									slopeChartTitle,
									officialHandicapTitle,
									playingHandicapTitle,
									usingPhrase];
						}

					case GOLFPlayingHandicapTypeUnadjusted:
#endif
					default:
						//	The playing handicap is the rounded handicap
						return [NSString stringWithFormat:GOLFLocalizedString(@"HANDICAP_BLURB_PLAY_%@_CHART_%@_INDEX_%@_PLAY_%@"),
								playingHandicapTitle,
								slopeChartTitle,
								officialHandicapTitle,
								playingHandicapTitle];
				}	//	switch (playingHandicapType)
			}

  		case GOLFHandicapMethodEGA:
  		case GOLFHandicapMethodWHS:
  		case GOLFHandicapMethodWHS2020:
  		case GOLFHandicapMethodAGU:
  			{
				NSString *usingPhrase = GOLFLocalizedString(@"TITLE_HANDICAP_SLOPE_RATING");
				if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SuppressVsParHandicapAdjustments"]) {
					usingPhrase = [usingPhrase stringByAppendingFormat:@", %@", GOLFLocalizedString(@"TITLE_HANDICAP_COURSE_RATING")];
					usingPhrase = [usingPhrase stringByAppendingFormat:GOLFLocalizedString(@"FORMAT_AND_%@"), GOLFLocalizedString(@"TERM_PAR")];
				}

				return [NSString stringWithFormat:GOLFLocalizedString(@"HANDICAP_BLURB_PLAY_%@_CHART_%@_INDEX_%@_PLAY_%@_BASED_%@"),
						playingHandicapTitle,
						slopeChartTitle,
						officialHandicapTitle,
						playingHandicapTitle,
						usingPhrase];
			}

  		case GOLFHandicapMethodUSGA:
  		case GOLFHandicapMethodRCGA:
    		return [NSString stringWithFormat:GOLFLocalizedString(@"HANDICAP_BLURB_PLAY_%@_CHART_%@_INDEX_%@_PLAY_%@_BASED_%@"),
    				playingHandicapTitle,
    				slopeChartTitle,
    				officialHandicapTitle,
    				playingHandicapTitle,
    				GOLFLocalizedString(@"TITLE_HANDICAP_SLOPE_RATING")];

  		case GOLFHandicapMethodCONGU:
  		case GOLFHandicapMethodMulligan:
		case GOLFHandicapMethodSecondBest:
  		default:
    		return [NSString stringWithFormat:GOLFLocalizedString(@"HANDICAP_BLURB_PLAY_%@_CHART_%@_INDEX_%@_PLAY_%@"),
    				playingHandicapTitle,
    				slopeChartTitle,
    				officialHandicapTitle,
    				playingHandicapTitle];
	}
}

//=================================================================
//	GOLFHandicapTableInstruction(handicapMethod)
//=================================================================
NSString * GOLFHandicapTableInstruction(GOLFHandicapMethodIndex handicapMethod) {
	NSString *playingHandicapTitle = GOLFPlayingHandicapTitle(handicapMethod, NO);	//	Localized
	NSString *officialHandicapTitle = GOLFOfficialHandicapTitle(handicapMethod, NO);	//	Localized

	return [NSString stringWithFormat:GOLFLocalizedString(@"FORMAT_DETERMINE_YOUR_%@_WITH_YOUR_%@"), playingHandicapTitle, officialHandicapTitle];
}

//=================================================================
//	GOLFHandicapCalculationFormula(handicapMethod, usingSSS)
//=================================================================
NSString * GOLFHandicapCalculationFormula(GOLFHandicapMethodIndex handicapMethod, BOOL usingSSS) {
	NSString *indexText = GOLFHandicapIndexTitle(handicapMethod, NO /* plural */);
	NSString *courseHdcpText = GOLFPlayingHandicapTitle(handicapMethod, NO /* plural */);
	NSString *slopeText = GOLFLocalizedString(@"TITLE_HANDICAP_SLOPE_RATING");

	switch (handicapMethod) {
  		case GOLFHandicapMethodEGA:
  		case GOLFHandicapMethodWHS:
  		case GOLFHandicapMethodWHS2020:
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SuppressVsParHandicapAdjustments"]) {
				return [NSString stringWithFormat:@"%@ = %@ x %@ / %ld %@", courseHdcpText, indexText, slopeText, (GOLFTeeSLOPERating)GOLFDefaultUnratedTeeSLOPERating, GOLFLocalizedString(@"TERM_ROUNDED")];
  			} else {
				NSString *courseRatingText = (usingSSS ? GOLFLocalizedString(@"TITLE_SCRATCH_SCORE") : GOLFLocalizedString(@"TITLE_HANDICAP_COURSE_RATING"));
				NSString *parText = [GOLFLocalizedString(@"TERM_PAR") capitalizedString];
				return [NSString stringWithFormat:@"%@ = %@ x %@ / %ld + (%@ - %@) %@", courseHdcpText, indexText, slopeText, (GOLFTeeSLOPERating)GOLFDefaultUnratedTeeSLOPERating, courseRatingText, parText, GOLFLocalizedString(@"TERM_ROUNDED")];
  			}
  		
  		case GOLFHandicapMethodAGU:
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SuppressVsParHandicapAdjustments"]) {
				return [NSString stringWithFormat:@"%@ = %@ x %@ / %ld x 0.93 %@", courseHdcpText, indexText, slopeText, (GOLFTeeSLOPERating)GOLFDefaultUnratedTeeSLOPERating, GOLFLocalizedString(@"TERM_ROUNDED")];
  			} else {
				NSString *courseRatingText = (usingSSS ? GOLFLocalizedString(@"TITLE_SCRATCH_SCORE") : GOLFLocalizedString(@"TITLE_HANDICAP_COURSE_RATING"));
				NSString *parText = [GOLFLocalizedString(@"TERM_PAR") capitalizedString];
				return [NSString stringWithFormat:@"%@ = (%@ x %@ / %ld + (%@ - %@)) x 0.93 %@", courseHdcpText, indexText, slopeText, (GOLFTeeSLOPERating)GOLFDefaultUnratedTeeSLOPERating, courseRatingText, parText, GOLFLocalizedString(@"TERM_ROUNDED")];
  			}

   		case GOLFHandicapMethodUSGA:
  		case GOLFHandicapMethodRCGA:
			return [NSString stringWithFormat:@"%@ = %@ x %@ / %ld %@", courseHdcpText, indexText, slopeText, (GOLFTeeSLOPERating)GOLFDefaultUnratedTeeSLOPERating, GOLFLocalizedString(@"TERM_ROUNDED")];


 		case GOLFHandicapMethodPersonal:
  		case GOLFHandicapMethodCONGU:
  		case GOLFHandicapMethodMulligan:
		case GOLFHandicapMethodSecondBest:
  		default:
			return [NSString stringWithFormat:@"%@ = %@ %@", courseHdcpText, indexText, GOLFLocalizedString(@"TERM_ROUNDED")];
	}
}

//=================================================================
//	GOLFHandicapMaximumNonLocalIndexForAuthority(authority, playerIsFemale, for9Holes)
//=================================================================
GOLFHandicapIndex GOLFHandicapMaximumNonLocalIndexForAuthority(GOLFHandicapAuthority *authority, BOOL playerIsFemale, BOOL for9Holes) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			//	Gender-independent
			return (for9Holes ? 27.0 : 54.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			if (playerIsFemale)
				return (for9Holes ? 20.2 : 40.4);
			else
				return (for9Holes ? 18.2 : 36.4);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	Gender-independent - (WHS doesn't support 9-hole indexes)
			return (for9Holes ? 27.0 : 54.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			if (playerIsFemale)
				return (for9Holes ? 18.0 : 36.0);
			else
				return (for9Holes ? 14.0 : 28.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	Gender-independent - (WHS doesn't support 9-hole indexes)
			return (for9Holes ? 27.0 : 54.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			//	Gender-independent
			return (for9Holes ? 20.0 : 40.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthoritySecondBest]) {
			if (playerIsFemale)
				return (for9Holes ? 20.0 : 40.0);
			else
				return (for9Holes ? 18.0 : 36.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
			float max = (playerIsFemale
					? [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHMaximumWomensStandard"] floatValue]
					: [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHMaximumMensStandard"] floatValue]);
			return (for9Holes ? floorf((max * 5.0) + 0.5) / 10.0 : max);
#else
			return (for9Holes ? 27.0 : 54.0);	//	Return WHS limit in iOS
#endif
		}
	}
	return 72.0;
}

//=================================================================
//	GOLFHandicapStrokeControlLimitForAuthority(authority, playingHandicap, options, info)
//=================================================================
GOLFScore GOLFHandicapStrokeControlLimitForAuthority(GOLFHandicapAuthority *authority, GOLFPlayingHandicap playingHandicap, GOLFHandicapCalculationOption options, NSDictionary *info) {

	//	GOLFHandicapAuthority *			authority		required		Handicap authority
	//	GOLFPlayingHandicap *			playingHandicap	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAPlayingHandicap is valid)
	//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
	//	NSDictionary *					info			optional		optional parameters (described below)
	//
	//	options:
	//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFPlayingHandicap is for 9 holes
	//
	//	info:
	//	key					type						description
	//	------------------	--------------------------	-------------------------------------------------------
	//	referenceObject		id							a <GOLFHandicapDataSource> that responds to strokeControlInfo:
	//	strokeControlType	GOLFHandicapStrokeControl	Personal Handicapping stroke control style ????

	GOLFScore limit = kMaximumStrokeControlLimit;	//	The default is no stroke limitations
	BOOL playingHandicapIs9Holes = ((options & GOLFHandicapCalculationOption9HoleHandicap) != 0);
	NSInteger numberOfHoles = (playingHandicapIs9Holes ? 9 : 18);
	GOLFPar par = (GOLFPar)(numberOfHoles * 4);
	GOLFHandicapStrokes strokes = 0;
	id competitor = nil;
	BOOL competitorIsFemale = NO;
	id <GOLFHandicapDataSource> referenceObject = (info != nil) ? [info objectForKey:@"referenceObject"] : nil;
	
	if ((referenceObject != nil) && [referenceObject respondsToSelector:@selector(strokeControlInfo)]) {
		NSDictionary *scInfo = [referenceObject strokeControlInfo];
		//	Key						Type			Description
		//	----------------------	--------------	---------------------------------
		//	numberOfHoles			NSNumber *		The number of holes against which stroke control should be applied (1 for a hole, 9 for a side, etc.)
		//	par						NSNumber *		GOLFPar for this entity (may be estimated)
		//	strokes					NSNumber *		GOLFHandicapStrokes for this entity (may be estimated)
		//	competitor				id				Any associated competitor with this entity
		//	competitorIsFemale		NSNumber *		A BOOL indicating whether competitor is female
		
		competitor = [scInfo objectForKey:@"competitor"];
		NSNumber *workingNumber = [scInfo objectForKey:@"competitorIsFemale"];
		if (workingNumber) {
			competitorIsFemale = [workingNumber boolValue];
		}
		workingNumber = [scInfo objectForKey:@"numberOfHoles"];
		if (workingNumber) {
			numberOfHoles = [workingNumber integerValue];
		}
		workingNumber = [scInfo objectForKey:@"par"];
		if (workingNumber) {
			par = [workingNumber parValue];
		}
		workingNumber = [scInfo objectForKey:@"strokes"];
		if (workingNumber) {
			strokes = [workingNumber handicapStrokesValue];
		}
		
		if (([authority isEqualToString:GOLFHandicapAuthorityUSGA]) || ([authority isEqualToString:GOLFHandicapAuthoritySecondBest])) {

			//	USGA Equitable Stroke Control
			//	Course Handicap			Maximum Number on Any Hole
			//	-----------------      ----------------------------
			//		9 or less					2 over par
			//		10 - 19							7
			//		20 - 29							8
			//		30 - 39							9
			//		40 or more						10

			//	USGA Equitable Stroke Control - 9 holes
			//	Course Handicap			Maximum Number on Any Hole
			//	-----------------      ----------------------------
			//		4 or less					2 over par
			//		5 - 9							7
			//		10 - 14							8
			//		15 - 19							9
			//		20 or more						10
			
			limit = 10 * numberOfHoles;
			
			if (playingHandicap != kNotAPlayingHandicap) {
				if (playingHandicapIs9Holes) {
					if (playingHandicap > 4)
						limit = ((GOLFScore)MIN(MAX(0, (GOLFPlayingHandicap)(playingHandicap / 5)), 4) + 6) * numberOfHoles;
					else
						limit = (2 * numberOfHoles) + par;
				}
				else if (playingHandicap > 9)
					limit = ((GOLFScore)MIN(MAX((NSInteger)0, (GOLFPlayingHandicap)(playingHandicap / 10)), 4) + 6) * numberOfHoles;
				else
					limit = (2 * numberOfHoles) + par;
			}
		}

		else if ([authority isEqualToString:GOLFHandicapAuthorityRCGA]) {

			//	Golf Canada Equitable Stroke Control (effective March 1, 2012)
			//	Course Handicap			Maximum Number on Any Hole
			//	-----------------      ----------------------------
			//		9 or less					2 over par
			//		10 - 19							7
			//		20 - 29							8
			//		30 - 39							9
			//		40 or more						10

			//	Golf Canada Equitable Stroke Control - 9 holes
			//	Course Handicap			Maximum Number on Any Hole
			//	-----------------      ----------------------------
			//		4 or less					2 over par
			//		5 - 9							7
			//		10 - 14							8
			//		15 - 19							9
			//		20 or more						10
			
			limit = 10 * numberOfHoles;
			
			if (playingHandicap != kNotAPlayingHandicap) {
				if (playingHandicapIs9Holes) {
					if (playingHandicap > 4)
						limit = ((NSInteger)MIN(MAX(0, (GOLFPlayingHandicap)(playingHandicap / 5)), 4) + 6) * numberOfHoles;
					else
						limit = (2 * numberOfHoles) + par;
				} else if (playingHandicap > 9) {
					limit = ((NSInteger)MIN(MAX((NSInteger)0, (GOLFPlayingHandicap)(playingHandicap / 10)), 4) + 6) * numberOfHoles;
				} else {
					limit = (2 * numberOfHoles) + par;
				}
			}
		}
		else if ([authority isEqualToString:@"OLDAGU"]) {
			//	Golf Australia only limits hole scores for first 3 rounds!
			//	Since Sep 2011
			
			//	Men - 3 over par
			//	Women - 4 over par

			limit = (((((competitor == nil) || competitorIsFemale) ? 4 : 3) * numberOfHoles) + par);
			
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	Net double-bogey (Stableford limit)

			limit = ((2 * numberOfHoles) + par + (playingHandicap == kNotAPlayingHandicap ? (4 * numberOfHoles) : strokes));
			
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			//	CONGU limits scores for handicapping to "Nett Double Bogey"
			
			limit = ((2 * numberOfHoles) + par + (playingHandicap == kNotAPlayingHandicap ? (4 * numberOfHoles) : strokes));
			
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			//	World Handicap System limits scores for handicapping to net double-bogey
			
			limit = ((2 * numberOfHoles) + par + (playingHandicap == kNotAPlayingHandicap ? (4 * numberOfHoles) : strokes));
			
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	World Handicap System limits scores for handicapping to net double-bogey
			
			limit = ((2 * numberOfHoles) + par + (playingHandicap == kNotAPlayingHandicap ? (4 * numberOfHoles) : strokes));
			
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			//	Mulligan Stroke Control
			//	Limit is net double-bogey (two over par + strokes)
			
			limit = ((2 * numberOfHoles) + par + (playingHandicap == kNotAPlayingHandicap ? (4 * numberOfHoles) : strokes));
			
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {

			//	GOLFHandicapStrokeControlNone = 0,			//	Don't adjust strokes for handicapping				(0)
			//	GOLFHandicapStrokeControlDoubleBogey,		//	Limit to gross double-bogey							(1)
			//	GOLFHandicapStrokeControlNetDoubleBogey,	//	Limit to net double-bogey							(2)
			//	GOLFHandicapStrokeControlDoubleBogeyPlus10,	//	Limit to double-bogey plus 10% of playing handicap	(3)
			//	GOLFHandicapStrokeControlTripleBogey,		//	Limit to gross triple-bogey							(4)
			//	GOLFHandicapStrokeControlNetTripleBogey,	//	Limit to net triple-bogey							(5)
			//	GOLFHandicapStrokeControlESC = 10,			//	Equitable Stroke Control (ESC) limit				(10)

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
			GOLFHandicapStrokeControl adjustmentType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHStrokeAdjustmentType"] integerValue];

			switch (adjustmentType) {
				case GOLFHandicapStrokeControlDoubleBogey:
					limit = ((2 * numberOfHoles) + par);
					break;
					
				case GOLFHandicapStrokeControlNetDoubleBogey:
					limit = ((2 * numberOfHoles) + par + (playingHandicap == kNotAPlayingHandicap ? (4 * numberOfHoles) : strokes));
					break;
					
				case GOLFHandicapStrokeControlDoubleBogeyPlus10:
					limit = ((2 * numberOfHoles) + par);
					if ((playingHandicap != kNotAPlayingHandicap) && (playingHandicap > 0)) {
						limit += (((NSInteger)floorf((playingHandicap / 10.0) + 0.5)) * numberOfHoles);
					}
					break;
					
				case GOLFHandicapStrokeControlTripleBogey:
					limit = ((3 * numberOfHoles) + par);
					break;
					
				case GOLFHandicapStrokeControlNetTripleBogey:
					limit = ((3 * numberOfHoles) + par + (playingHandicap == kNotAPlayingHandicap ? (4 * numberOfHoles) : strokes));
					break;
					
				case GOLFHandicapStrokeControlESC:
					limit = 10 * numberOfHoles;
					if (playingHandicap != kNotAPlayingHandicap) {
						if (playingHandicapIs9Holes) {
							if (playingHandicap > 4)
								limit = ((NSInteger)MIN(MAX(0, (GOLFPlayingHandicap)(playingHandicap / 5)), 4) + 6) * numberOfHoles;
							else
								limit = (2 * numberOfHoles) + par;
						}
						else if (playingHandicap > 9)
							limit = ((NSInteger)MIN(MAX((NSInteger)0, (GOLFPlayingHandicap)(playingHandicap / 10)), 4) + 6) * numberOfHoles;
						else
							limit = (2 * numberOfHoles) + par;
					}
					break;
					
				case GOLFHandicapStrokeControlNone:
				default:
					break;
			}	//	switch (adjustmentType)
#endif
		}
	}
	return limit;
}

//=================================================================
//	GOLFHandicapLocalIndexModifierForAuthority(authority)
//=================================================================
NSString * GOLFHandicapLocalIndexModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return @"L";	//	"Local" (current WHS specs don't identify "local" indexes)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			return @"C";	//	"Club"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return @"C";	//	"Club"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return @"L";	//	"Local"
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return [[NSUserDefaults standardUserDefaults] objectForKey:@"PHNonStandardModifier"];
#endif
		}
	}
	return @"C";
}

//=================================================================
//	GOLFHandicapNineHoleModifierForAuthority(authority)
//=================================================================
NSString * GOLFHandicapNineHoleModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return @"N";
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			return @"N";
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return @"N";
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return @"N";
#endif
		}
	}
	//	AGU (Golf Australia) and WHS (World Handicap System) don't produce 9-hole handicap indexes
	
	return @"N";
}

//=================================================================
//	GOLFHandicapGradeTitleForAuthority(authority)
//=================================================================
NSString * GOLFHandicapGradeTitleForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]
				|| [authority isEqualToString:GOLFHandicapAuthorityWHS2020]
				|| [authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return GOLFLocalizedString(@"TITLE_HANDICAP_ADJUSTED_ABBR");	//	Grade is used to report integral adjustments
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA] || [authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return GOLFLocalizedString(@"TITLE_HANDICAP_CATEGORY_ABBR");
		}
	}
	return GOLFLocalizedString(@"TITLE_HANDICAP_GRADE_ABBR");
}

//=================================================================
//	GOLFHandicapExceptionalScoringModifierForAuthority(authority)
//=================================================================
NSString * GOLFHandicapExceptionalScoringModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if (([authority isEqualToString:GOLFHandicapAuthorityUSGA]) || ([authority isEqualToString:GOLFHandicapAuthorityRCGA])) {
			return @"R";	//	"Restricted"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return @"E";	//	Exceptional scores scores are tagged in WHS - an exceptional score adjusts the most recent differentials
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return @"E";	//	Exceptional scores scores are tagged in WHS - an exceptional score adjusts the most recent differentials
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return @"E";	//	"Exceptional Scoring Reduction"
		}
	}
	return @"R";
}

//=================================================================
//	GOLFHandicapCombinedScoresModifierForAuthority(authority)
//=================================================================
NSString * GOLFHandicapCombinedScoresModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return @"N";	//	In 2024, nine hole scores aren't combined.  They used an Expected Score to creat a differential.
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return @"N";	//	In 2020 nine hole scores were combined, and examples display an "N"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return @"N";	//	Not clear, but AGU examples show combined scores with an "N"
		}
	}
	return @"C";	//	"Combined"
}

//=================================================================
//	GOLFHandicapTournamentScoreModifierForAuthority(authority)
//=================================================================
NSString * GOLFHandicapTournamentScoreModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return @"C";	// "Competition"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return @"C";	// "Competition"
		}
	}
	return @"T";	//	"Tournament"
}

//=================================================================
//	GOLFHandicapTournamentTitleForAuthority(authority)
//=================================================================
NSString * GOLFHandicapTournamentTitleForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return GOLFLocalizedString(@"TITLE_ORGANIZED_COMPETITION");	// "Organized Competition"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return GOLFLocalizedString(@"TITLE_ORGANIZED_COMPETITION");	// "Organized Competition"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			return [GOLFLocalizedString(@"TERM_TOURNAMENT") capitalizedString];	// "Tournament"
		}
	}
	return [GOLFLocalizedString(@"TERM_COMPETITION") capitalizedString];	//	"Competition"
}

//=================================================================
//	GOLFHandicapServiceAccountIDForAuthority(authority)
//=================================================================
NSString * GOLFHandicapServiceAccountIDForAuthority(GOLFHandicapAuthority *authority) {
//	Returns a localized name of the handicapping service identifier ("GHIN number", "GOLFLink account", etc.)
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]
				|| [authority isEqualToString:GOLFHandicapAuthorityWHS2020]
				|| [authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			return GOLFLocalizedString(@"TITLE_GHIN_NUMBER");	// "GHIN number"
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return GOLFLocalizedString(@"TITLE_HDCP_NETWORK_NUMBER");	// "Handicap Network Account"
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return GOLFLocalizedString(@"TITLE_GOLFLINK_NUMBER");	// "GOLFLink Number"
		}
	}
	return GOLFLocalizedString(@"TITLE_ACCOUNT_NUMBER");	//	"Account Number"
}

//=================================================================
//	GOLFRoundModifierTooltip(authority)
//=================================================================
NSString * GOLFRoundModifierTooltip(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_WHS");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_WHS2020");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_USGA");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_RCGA");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_AGU");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_CONGU");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_EGA");
//#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_USGA");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_MULLIGAN");
		} else if ([authority isEqualToString:GOLFHandicapAuthoritySecondBest]) {
			return GOLFLocalizedString(@"TOOLTIP_ROUNDS_MODIFIER_USGA");
//#endif
		}
	}
	return @"";
}

//=================================================================
//	GOLFHandicap9HoleHandicapsSupported(authority)
//=================================================================
BOOL GOLFHandicap9HoleHandicapsSupported(GOLFHandicapAuthority *authority) {
	//	Indicates whether the handicapping method of this authority supports 9-hole handicap indexes
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	Golf Australia doesn't calculate 9-hole indexes
			return NO;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	World Handicap System doesn't calculate 9-hole indexes
			return NO;
//#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return NO;
//#endif
		}
	}
	return YES;	//	default
}

//=================================================================
//	GOLFHandicapStablefordRequiredForAuthority(authority)
//=================================================================
BOOL GOLFHandicapStablefordRequiredForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			//	Stableford-based handicap computations
			return YES;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return NO;	//	Since Sep 2011
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return YES;	//	Since 2016
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapIncludesRatingsAdjustmentForAuthority(authority)
//=================================================================
BOOL GOLFHandicapIncludesRatingsAdjustmentForAuthority(GOLFHandicapAuthority *authority) {
	GOLFHandicapMethodIndex methodIndex = GOLFHandicapBestMethodIndexFromAuthority(authority);

	switch (methodIndex) {
  		case GOLFHandicapMethodEGA:
  		case GOLFHandicapMethodWHS:
  		case GOLFHandicapMethodWHS2020:
  			return ([[NSUserDefaults standardUserDefaults] boolForKey:@"SuppressVsParHandicapAdjustments"] ? NO : YES);
  		
  		case GOLFHandicapMethodAGU:
  			return ([[NSUserDefaults standardUserDefaults] boolForKey:@"SuppressVsParHandicapAdjustments"] ? NO : YES);

   		case GOLFHandicapMethodUSGA:
  		case GOLFHandicapMethodRCGA:
			return NO;


 		case GOLFHandicapMethodPersonal:
  		case GOLFHandicapMethodCONGU:
  		case GOLFHandicapMethodMulligan:
		case GOLFHandicapMethodSecondBest:
  		default:
			return NO;
	}
}

//=================================================================
//	GOLFDoesTournamentAdjustmentForAuthority(authority)
//=================================================================
BOOL GOLFDoesTournamentAdjustmentForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			return YES;	//	Exceptional Score Reduction (ESR - all rounds)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return YES;	//	Exceptional Score Reduction (ESR - all rounds)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			return YES;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return YES;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHFlagTournamentScores"] boolValue];
#endif
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapCCRUsedForAuthority(authority, required)
//=================================================================
BOOL GOLFHandicapCCRUsedForAuthority(GOLFHandicapAuthority *authority, BOOL *required) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	Weather-based differential adjustment (PCC - Playing Conditions Calculation)
			if (required) {
				*required = NO;
			}
			return YES;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			//	Weather-based differential adjustment (PCC - Playing Conditions Calculation)
			if (required) {
				*required = NO;
			}
			return YES;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	Weather-based differential adjustment (PCC - Playing Conditions Calculation)
			if (required) {
				*required = NO;
			}
			return YES;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			//	CSS-based differential calculation (CSS = Competition Scratch Score)
			if (required) {
				*required = YES;	//	Calculation must return CSS, SSS or par
			}
			return YES;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			//	Buffer (threshold) adjustment (CBA = Computed Buffer Adjustment)
			if (required) {
				*required = NO;	//	Although default value is zero
			}
			return YES;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			if (required) {
				*required = NO;
			}
			return ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PHDifferentialType"] integerValue] == GOLFHandicapDifferentialTypeOverCCR);
#endif
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapPreciseAllowancesForAuthority(authority)
//=================================================================
BOOL GOLFHandicapPreciseAllowancesForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			//	World Handicap System (post 1/1/2024)
			return YES;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	World Handicap System (pre 1/1/2024)
			return NO;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHPreciseAllowances"] booleanValue];
#endif
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapExpectedScoreMethodForAuthority(authority)
//=================================================================
GOLFHandicapExpectedScoreMethod GOLFHandicapExpectedScoreMethodForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			//	WHS (2024) - default setting is GOLFHandicapExpectedScoreMethodNetPar
			return [[[NSUserDefaults standardUserDefaults] objectForKey:@"WHSExpectedScoreMethod"] unsignedIntegerValue];
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	WHS (pre-2024) None
			return GOLFHandicapExpectedScoreMethodNone;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			//	return ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PHExpectedScoreMethod"] expectedScoreMethod]);
			return GOLFHandicapExpectedScoreMethodNone;
#endif
		}
	}
	return GOLFHandicapExpectedScoreMethodNone;
}

//=================================================================
//	GOLFHandicapPCCMinimumAdjustmentForAuthority(authority)
//=================================================================
GOLFPlayingConditionAdjustment GOLFHandicapPCCMinimumAdjustmentForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			//	WHS minimum of -1.0 to +3.0  (optional)
			return -1.0;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	WHS minimum of -1.0 to +3.0  (optional)
			return -1.0;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	AGU minimum of -1.0 to +3.0  (optional)	-1 -> Perfect, +3 -> Horrible
			return -1.0;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			//	return ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PHMinimumPCC"] roundCCRValue]);
			return kNotAPlayingConditionAdjustment;
#endif
		}
	}
	return kNotARoundCCR;
}

//=================================================================
//	GOLFHandicapPCCMaximumAdjustmentForAuthority(authority)
//=================================================================
GOLFPlayingConditionAdjustment GOLFHandicapPCCMaximumAdjustmentForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			//	WHS minimum of -1.0 to +3.0  (optional)
			return 3.0;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	AGU minimum of -1.0 to +3.0  (optional)
			return 3.0;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	AGU minimum of -1.0 to +3.0  (optional)
			return 3.0;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			//	return ([[[NSUserDefaults standardUserDefaults] objectForKey:@"PHMaximumPCC"] roundCCRValue]);
			return kNotAPlayingConditionAdjustment;
#endif
		}
	}
	return kNotAPlayingConditionAdjustment;
}

//=================================================================
//	GOLFHandicapDefaultLimitsDifferenceForAuthority(authority)
//=================================================================
GOLFHandicapStrokes GOLFHandicapDefaultLimitsDifferenceForAuthority(GOLFHandicapAuthority *authority) {
	GOLFHandicapStrokes difference = 8;
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			difference = (NSInteger)8;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			difference = (NSInteger)8;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			difference = (NSInteger)8;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			difference = (NSInteger)8;
//#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			difference = (NSInteger)10;
//#endif
		}
	}
	return difference;
}

//=================================================================
//	GOLFHandicapDefaultLimitsPctAdjForAuthority(authority)
//=================================================================
float GOLFHandicapDefaultLimitsPctAdjForAuthority(GOLFHandicapAuthority *authority) {
	float adjustment = 10.0;
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			adjustment = (float)10.0;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			adjustment = (float)10.0;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			adjustment = (float)10.0;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			adjustment = (float)10.0;
//#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			adjustment = (float)12.0;
//#endif
		}
	}
	return adjustment;
}

//=================================================================
//	GOLFHandicapScoringRecordSizeForAuthority(authority)
//=================================================================
NSUInteger GOLFHandicapScoringRecordSizeForAuthority(GOLFHandicapAuthority *authority) {
	NSUInteger size = 20;	//	The default
	//	The maximum number of valid rounds (9 or 18-hole) that constitute a full scoring record from which a current official
	//	handicap can be derived - excluding earlier (historical) rounds that might be examined to establish handicapping limits.

	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
		
			//	Scores				Differentials
			//	----------------------------------
			//	less than 5			None
			//	5 or 6				Lowest 1
			//	7 or 8				Lowest 2
			//	9 or 10				Lowest 3
			//	11 or 12			Lowest 4
			//	13 or 14			Lowest 5
			//	15 or 16			Lowest 6
			//	17					Lowest 7
			//	18					Lowest 8
			//	19					Lowest 9
			//	20					Lowest 10
			
			size = 20;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {

			//	Scores			Differentials
			//	------------------------------
			//	less than 3		None					
			//	3				Lowest 1
			//	4				Lowest 1
			//	5				Lowest 1
			//	6				Lowest 2
			//	7 or 8			Lowest 2
			//	9 to 11			Lowest 3
			//	12 to 14		Lowest 4
			//	15 or 16		Lowest 5
			//	17 or 18		Lowest 6
			//	19				Lowest 7
			//	20				Lowest 8
			
			size = 20;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {

			//	Scores			Differentials		Adjustment
			//	-----------------------------------------------
			//	less than 3		None					
			//	3				Lowest 1				-2.0
			//	4				Lowest 1				-1.0
			//	5				Lowest 1				0.0
			//	6				Lowest 2				-1.0
			//	7 or 8			Lowest 2				0.0
			//	9 to 11			Lowest 3				0.0
			//	12 to 14		Lowest 4				0.0
			//	15 or 16		Lowest 5				0.0
			//	17 or 18		Lowest 6				0.0
			//	19				Lowest 7				0.0
			//	20				Lowest 8				0.0
			
			size = 20;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
		
			//	Scores			Differentials		Adjustment
			//	-----------------------------------------------
			//	less than 3		None					
			//	3				Lowest 1				-2.0
			//	4				Lowest 1				-1.0
			//	5				Lowest 1				0.0
			//	6				Lowest 2				-1.0
			//	7 or 8			Lowest 2				0.0
			//	9 to 11			Lowest 3				0.0
			//	12 to 14		Lowest 4				0.0
			//	15 or 16		Lowest 5				0.0
			//	17 or 18		Lowest 6				0.0
			//	19				Lowest 7				0.0
			//	20				Lowest 8				0.0
			
			size = 20;
			
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			size = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHUseLastNScores"] integerValue];
#endif
		}
	}
	
	return size;
}

//=================================================================
//	GOLFHandicapDifferentialsToUseForAuthority(authority, numberOfScores)
//=================================================================
NSInteger GOLFHandicapDifferentialsToUseForAuthority(GOLFHandicapAuthority *authority, NSInteger numberOfScores, float *newHandicapAdj) {
	float adjustment = 0.0;
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
		
			//	Scores				Differentials
			//	----------------------------------
			//	less than 5			None
			//	5 or 6				Lowest 1
			//	7 or 8				Lowest 2
			//	9 or 10				Lowest 3
			//	11 or 12			Lowest 4
			//	13 or 14			Lowest 5
			//	15 or 16			Lowest 6
			//	17					Lowest 7
			//	18					Lowest 8
			//	19					Lowest 9
			//	20					Lowest 10
			
			if (numberOfScores < 5)
				return 0;
			else if (numberOfScores < 17)
				return ((NSInteger)((numberOfScores + 1) / 2) - 2);
			else
				return numberOfScores - 10;
//		} else if ([authority isEqualToString:GOLFHandicapAuthorityOLDAGU]) {
//		
//			//	Scores				Differentials
//			//	----------------------------------
//			//	less than 3			None
//			//	3 to 6				Lowest 1
//			//	7 or 8				Lowest 2
//			//	9 or 10				Lowest 3
//			//	11 or 12			Lowest 4
//			//	13 or 14			Lowest 5
//			//	15 or 16			Lowest 6
//			//	17 or 18			Lowest 7
//			//	19 or 20			Lowest 8
//			
//			if (numberOfScores < 3)
//				return 0;
//			else if (numberOfScores < 7)
//				return 1;
//			else
//				return ((NSInteger)((numberOfScores + 1) / 2) - 2);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			NSInteger diffs = 0;
			//	Scores			Differentials
			//	------------------------------
			//	less than 3		None					
			//	3				Lowest 1
			//	4				Lowest 1
			//	5				Lowest 1
			//	6				Lowest 2
			//	7 or 8			Lowest 2
			//	9 to 11			Lowest 3
			//	12 to 14		Lowest 4
			//	15 or 16		Lowest 5
			//	17 or 18		Lowest 6
			//	19				Lowest 7
			//	20				Lowest 8
			
			if (numberOfScores < 3) {
				//	0, 1, 2
				diffs = 0;
			} else if (numberOfScores < 6) {
				//	3, 4, 5
				diffs = 1;
			} else if (numberOfScores < 9) {
				//	6, 7, 8
				diffs = 2;
			} else if (numberOfScores < 12) {
				//	9, 10, 11
				diffs = 3;
			} else if (numberOfScores < 15) {
				//	12, 13, 14
				diffs = 4;
			} else if (numberOfScores < 17) {
				//	15, 16
				diffs = 5;
			} else if (numberOfScores < 19) {
				//	17, 18
				diffs = 6;
			} else if (numberOfScores < 20) {
				//	19
				diffs = 7;
			} else {
				//	20
				diffs = 8;
			}
			
			return diffs;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			NSInteger diffs = 0;
			//	Scores			Differentials		Adjustment
			//	-----------------------------------------------
			//	less than 3		None					
			//	3				Lowest 1				-2.0
			//	4				Lowest 1				-1.0
			//	5				Lowest 1				0.0
			//	6				Lowest 2				-1.0
			//	7 or 8			Lowest 2				0.0
			//	9 to 11			Lowest 3				0.0
			//	12 to 14		Lowest 4				0.0
			//	15 or 16		Lowest 5				0.0
			//	17 or 18		Lowest 6				0.0
			//	19				Lowest 7				0.0
			//	20				Lowest 8				0.0
			
			if (numberOfScores < 3) {
				//	0, 1, 2
				diffs = 0;
			} else if (numberOfScores < 6) {
				//	3, 4, 5
				diffs = 1;
				adjustment = ((numberOfScores < 4)
						? -2.0
						: ((numberOfScores < 5) ? -1.0 : 0.0));
			} else if (numberOfScores < 9) {
				//	6, 7, 8
				diffs = 2;
				adjustment = ((numberOfScores < 7)
						? -1.0
						: 0.0);
			} else if (numberOfScores < 12) {
				//	9, 10, 11
				diffs = 3;
			} else if (numberOfScores < 15) {
				//	12, 13, 14
				diffs = 4;
			} else if (numberOfScores < 17) {
				//	15, 16
				diffs = 5;
			} else if (numberOfScores < 19) {
				//	17, 18
				diffs = 6;
			} else if (numberOfScores < 20) {
				//	19
				diffs = 7;
			} else {
				//	20
				diffs = 8;
			}
			
			if (newHandicapAdj) {
				*newHandicapAdj = adjustment;
			}
			
			return diffs;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			NSInteger diffs = 0;
			//	Scores			Differentials		Adjustment
			//	-----------------------------------------------
			//	less than 3		None					
			//	3				Lowest 1				-2.0
			//	4				Lowest 1				-1.0
			//	5				Lowest 1				0.0
			//	6				Lowest 2				-1.0
			//	7 or 8			Lowest 2				0.0
			//	9 to 11			Lowest 3				0.0
			//	12 to 14		Lowest 4				0.0
			//	15 or 16		Lowest 5				0.0
			//	17 or 18		Lowest 6				0.0
			//	19				Lowest 7				0.0
			//	20				Lowest 8				0.0
			
			if (numberOfScores < 3) {
				//	0, 1, 2
				diffs = 0;
			} else if (numberOfScores < 6) {
				//	3, 4, 5
				diffs = 1;
				adjustment = ((numberOfScores < 4)
						? -2.0
						: ((numberOfScores < 5) ? -1.0 : 0.0));
			} else if (numberOfScores < 9) {
				//	6, 7, 8
				diffs = 2;
				adjustment = ((numberOfScores < 7)
						? -1.0
						: 0.0);
			} else if (numberOfScores < 12) {
				//	9, 10, 11
				diffs = 3;
			} else if (numberOfScores < 15) {
				//	12, 13, 14
				diffs = 4;
			} else if (numberOfScores < 17) {
				//	15, 16
				diffs = 5;
			} else if (numberOfScores < 19) {
				//	17, 18
				diffs = 6;
			} else if (numberOfScores < 20) {
				//	19
				diffs = 7;
			} else {
				//	20
				diffs = 8;
			}
			
			if (newHandicapAdj) {
				*newHandicapAdj = adjustment;
			}
			
			return diffs;
			
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			NSInteger useLastNScores = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHUseLastNScores"] integerValue];
			NSInteger discardBestNScores = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHDiscardNBestScores"] integerValue];
			NSInteger discardWorstNScores = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHDiscardNWorstScores"] integerValue];
			NSInteger bestToRemove = MAX(0, (NSInteger)floorf(((float)discardBestNScores * (float)numberOfScores / (float)useLastNScores) + 0.5));
			NSInteger worstToRemove = MAX(0, (NSInteger)floorf(((float)discardWorstNScores * (float)numberOfScores / (float)useLastNScores) + 0.5));

			return (MIN(numberOfScores, useLastNScores) - bestToRemove - worstToRemove);
#endif
		}
	}
	
	if (newHandicapAdj) {
		*newHandicapAdj = adjustment;
	}
	
	return numberOfScores;
}

//=================================================================
//	GOLFHandicapExceptionalScoringReductionForAuthority(authority, excessIndex, eligibleScores)
//=================================================================
GOLFHandicapDifferential GOLFHandicapExceptionalScoringReductionForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex excessIndex, NSInteger eligibleScores) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			//
			//                     USGA Handicap Reduction Table
			//
			//                          Number of Eligible Tournament Scores
			//  Excess Index      2      3      4     5-9   10-19  20-29  30-39   >40
			//  ------------    -----  -----  -----  -----  -----  -----  -----  -----
			//    3.0 - 3.4       *      *      *      *      *      *      *      *
			//    3.5 - 3.9       *      *      *      *      *      *      *      *
			//    4.0 - 4.4      1.0     *      *      *      *      *      *      *
			//    4.5 - 4.9      1.8    1.0     *      *      *      *      *      *
			//    5.0 - 5.4      2.6    1.9    1.0     *      *      *      *      *
			//    5.5 - 5.9      3.4    2.7    1.9    1.0     *      *      *      *
			//    6.0 - 6.4      4.1    3.5    2.8    1.9    1.0     *      *      *
			//    6.5 - 6.9      4.8    4.3    3.7    2.9    2.0    1.0     *      *
			//    7.0 - 7.4      5.5    5.0    4.5    3.8    3.0    2.1    1.0     *
			//    7.5 - 7.9      6.2    5.7    5.3    4.7    3.9    3.1    2.2    1.0
			//    8.0 - 8.4      6.8    6.4    6.0    5.5    4.8    4.1    3.2    2.2
			//    8.5 - 8.9      7.4    7.1    6.7    6.2    5.7    5.0    4.2    3.3
			//    9.0 - 9.4      8.1    7.8    7.4    7.0    6.5    5.9    5.2    4.4
			//    9.5 - 9.9      8.7    8.4    8.1    7.7    7.3    6.7    6.1    5.4
			//  10.0 - 10.4      9.2    9.0    8.8    8.4    8.0    7.6    7.0    6.4
			//  10.5 - 10.9      9.8    9.5    9.4    9.1    8.7    8.3    7.8    7.2
			//  11.0 - 11.4     10.4   10.2   10.0    9.7    9.4    9.1    8.6    8.1
			//  11.5 - 11.9     11.0   10.8   10.6   10.4   10.1    9.8    9.4    8.9
			//  12.0 - 12.4     11.5   11.4   11.2   11.0   10.7   10.5   10.1    9.7
			//  12.5 - 12.9     12.1   11.9   11.8   11.6   11.4   11.1   10.8   10.5
			//  13.0 - 13.4     12.6   12.5   12.4   12.2   12.0   11.8   11.5   11.2
			//  13.5 - 13.9     13.2   13.1   12.9   12.8   12.6   12.4   12.2   11.9
			//  14.0 & more     13.7   13.6   13.5   13.4   13.2   13.0   12.8   12.6
			//
			if ((excessIndex < 4.0) || (eligibleScores < 2)) {
				return 0.0;
			} else if (excessIndex < 4.5) {
				if (eligibleScores > 2) return 0.0;
				else return 1.0;
			} else if (excessIndex < 5.0) {
				if (eligibleScores > 3) return 0.0;
				else if (eligibleScores > 2) return 1.0;
				else return 1.8;
			} else if (excessIndex < 5.5) {
				if (eligibleScores > 4) return 0.0;
				else if (eligibleScores > 3) return 1.0;
				else if (eligibleScores > 2) return 1.9;
				else return 2.6;
			} else if (excessIndex < 6.0) {
				if (eligibleScores > 9) return 0.0;
				else if (eligibleScores > 4) return 1.0;
				else if (eligibleScores > 3) return 1.9;
				else if (eligibleScores > 2) return 2.7;
				else return 3.4;
			} else if (excessIndex < 6.5) {
				if (eligibleScores > 19) return 0.0;
				else if (eligibleScores > 9) return 1.0;
				else if (eligibleScores > 4) return 1.9;
				else if (eligibleScores > 3) return 2.8;
				else if (eligibleScores > 2) return 3.5;
				else return 4.1;
			} else if (excessIndex < 7.0) {
				if (eligibleScores > 29) return 0.0;
				else if (eligibleScores > 19) return 1.0;
				else if (eligibleScores > 9) return 2.0;
				else if (eligibleScores > 4) return 2.9;
				else if (eligibleScores > 3) return 3.7;
				else if (eligibleScores > 2) return 4.3;
				else return 4.8;
			} else if (excessIndex < 7.5) {
				if (eligibleScores > 39) return 0.0;
				else if (eligibleScores > 29) return 1.0;
				else if (eligibleScores > 19) return 2.1;
				else if (eligibleScores > 9) return 3.0;
				else if (eligibleScores > 4) return 3.8;
				else if (eligibleScores > 3) return 4.5;
				else if (eligibleScores > 2) return 5.0;
				else return 5.5;
			} else if (excessIndex < 8.0) {
				if (eligibleScores > 39) return 1.0;
				else if (eligibleScores > 29) return 2.2;
				else if (eligibleScores > 19) return 3.1;
				else if (eligibleScores > 9) return 3.9;
				else if (eligibleScores > 4) return 4.7;
				else if (eligibleScores > 3) return 5.3;
				else if (eligibleScores > 2) return 5.7;
				else return 6.2;
			} else if (excessIndex < 8.5) {
				if (eligibleScores > 39) return 2.2;
				else if (eligibleScores > 29) return 3.2;
				else if (eligibleScores > 19) return 4.1;
				else if (eligibleScores > 9) return 4.8;
				else if (eligibleScores > 4) return 5.5;
				else if (eligibleScores > 3) return 6.0;
				else if (eligibleScores > 2) return 6.4;
				else return 6.8;
			} else if (excessIndex < 9.0) {
				if (eligibleScores > 39) return 3.3;
				else if (eligibleScores > 29) return 4.2;
				else if (eligibleScores > 19) return 5.0;
				else if (eligibleScores > 9) return 5.7;
				else if (eligibleScores > 4) return 6.2;
				else if (eligibleScores > 3) return 6.7;
				else if (eligibleScores > 2) return 7.1;
				else return 7.4;
			} else if (excessIndex < 9.5) {
				if (eligibleScores > 39) return 4.4;
				else if (eligibleScores > 29) return 5.2;
				else if (eligibleScores > 19) return 5.9;
				else if (eligibleScores > 9) return 6.5;
				else if (eligibleScores > 4) return 7.0;
				else if (eligibleScores > 3) return 7.4;
				else if (eligibleScores > 2) return 7.8;
				else return 8.1;
			} else if (excessIndex < 10.0) {
				if (eligibleScores > 39) return 5.4;
				else if (eligibleScores > 29) return 6.1;
				else if (eligibleScores > 19) return 6.7;
				else if (eligibleScores > 9) return 7.3;
				else if (eligibleScores > 4) return 7.7;
				else if (eligibleScores > 3) return 8.1;
				else if (eligibleScores > 2) return 8.4;
				else return 8.7;
			} else if (excessIndex < 10.5) {
				if (eligibleScores > 39) return 6.4;
				else if (eligibleScores > 29) return 7.0;
				else if (eligibleScores > 19) return 7.6;
				else if (eligibleScores > 9) return 8.0;
				else if (eligibleScores > 4) return 8.4;
				else if (eligibleScores > 3) return 8.8;
				else if (eligibleScores > 2) return 9.0;
				else return 9.2;
			} else if (excessIndex < 11.0) {
				if (eligibleScores > 39) return 7.2;
				else if (eligibleScores > 29) return 7.8;
				else if (eligibleScores > 19) return 8.3;
				else if (eligibleScores > 9) return 8.7;
				else if (eligibleScores > 4) return 9.1;
				else if (eligibleScores > 3) return 9.4;
				else if (eligibleScores > 2) return 9.5;
				else return 9.8;
			} else if (excessIndex < 11.5) {
				if (eligibleScores > 39) return 8.1;
				else if (eligibleScores > 29) return 8.6;
				else if (eligibleScores > 19) return 9.1;
				else if (eligibleScores > 9) return 9.4;
				else if (eligibleScores > 4) return 9.7;
				else if (eligibleScores > 3) return 10.0;
				else if (eligibleScores > 2) return 10.2;
				else return 10.4;
			} else if (excessIndex < 12.0) {
				if (eligibleScores > 39) return 8.9;
				else if (eligibleScores > 29) return 9.4;
				else if (eligibleScores > 19) return 9.8;
				else if (eligibleScores > 9) return 10.1;
				else if (eligibleScores > 4) return 10.4;
				else if (eligibleScores > 3) return 10.6;
				else if (eligibleScores > 2) return 10.8;
				else return 11.0;
			} else if (excessIndex < 12.5) {
				if (eligibleScores > 39) return 9.7;
				else if (eligibleScores > 29) return 10.1;
				else if (eligibleScores > 19) return 10.5;
				else if (eligibleScores > 9) return 10.7;
				else if (eligibleScores > 4) return 11.0;
				else if (eligibleScores > 3) return 11.2;
				else if (eligibleScores > 2) return 11.4;
				else return 11.5;
			} else if (excessIndex < 13.0) {
				if (eligibleScores > 39) return 10.5;
				else if (eligibleScores > 29) return 10.8;
				else if (eligibleScores > 19) return 11.1;
				else if (eligibleScores > 9) return 11.4;
				else if (eligibleScores > 4) return 11.6;
				else if (eligibleScores > 3) return 11.8;
				else if (eligibleScores > 2) return 11.9;
				else return 12.1;
			} else if (excessIndex < 13.5) {
				if (eligibleScores > 39) return 11.2;
				else if (eligibleScores > 29) return 11.5;
				else if (eligibleScores > 19) return 11.8;
				else if (eligibleScores > 9) return 12.0;
				else if (eligibleScores > 4) return 12.2;
				else if (eligibleScores > 3) return 12.4;
				else if (eligibleScores > 2) return 12.5;
				else return 12.6;
			} else if (excessIndex < 14.0) {
				if (eligibleScores > 39) return 11.9;
				else if (eligibleScores > 29) return 12.2;
				else if (eligibleScores > 19) return 12.4;
				else if (eligibleScores > 9) return 12.6;
				else if (eligibleScores > 4) return 12.8;
				else if (eligibleScores > 3) return 12.9;
				else if (eligibleScores > 2) return 13.1;
				else return 13.2;
			} else {
				if (eligibleScores > 39) return 12.6;
				else if (eligibleScores > 29) return 12.8;
				else if (eligibleScores > 19) return 13.0;
				else if (eligibleScores > 9) return 13.2;
				else if (eligibleScores > 4) return 13.4;
				else if (eligibleScores > 3) return 13.5;
				else if (eligibleScores > 2) return 13.6;
				else return 13.7;
			}
		}	//	if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] ...
	}	//	if (authority)
	return 0.0;
}

//=================================================================
//	GOLFHandicapUnratedSLOPERatingForAuthority(authority)
//=================================================================
GOLFTeeSLOPERating GOLFHandicapUnratedSLOPERatingForAuthority(GOLFHandicapAuthority *authority) {
	return GOLFDefaultUnratedTeeSLOPERating;	//	Unless specified otherwise, the default
}

//=================================================================
//	GOLFPlayingHandicapFor(authority, handicapIndex, courseRating, slopeRating, par, options, info, unrounded)
//=================================================================
GOLFPlayingHandicap GOLFPlayingHandicapFor(GOLFHandicapAuthority *authority, GOLFHandicapIndex handicapIndex, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, NSDictionary *info, GOLFUnroundedPlayingHandicap *unrounded) {

	//	Parameters:
	//	GOLFHandicapAuthority *			authority		optional		Handicap authority
	//	GOLFHandicapIndex				handicapIndex	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAHandicapIndex is valid)
	//	GOLFTeeCourseRating				courseRating	required		18 holes unless GOLFHandicapCalculationOption9HoleRating (kNotACourseRating is valid)
	//	GOLFTeeSLOPERating				slopeRating		required		18 holes unless GOLFHandicapCalculationOption9HoleSLOPE (kNotASLOPERating is valid)
	//	GOLFPar							par				required		18 holes unless GOLFHandicapCalculationOption9HolePar (kNotAPar is valid)
	//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
	//	NS(Mutable)Dictionary *			info			optional		optional parameters (described below)
	//	GOLFUnroundedPlayingHandicap *	unrounded		optional		optional unrounded result destination
	//
	//	options:
	//	GOLFHandicapCalculationOptionNeed9HoleResult	(1)		Need return of a 9-hole handicap
	//	GOLFHandicapCalculationOptionNeedWomensResult	(2)		Need return of a woman's handicap
	//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFHandicapIndex is for 9 holes
	//	GOLFHandicapCalculationOption9HoleRating		(8)		Provided GOLFTeeCourseRating is for 9 holes
	//	GOLFHandicapCalculationOption9HoleSLOPE			(16)	Provided GOLFTeeSLOPERating is for 9 holes
	//	GOLFHandicapCalculationOption9HolePar			(32)	Provided GOLFPar is for 9 holes
	//	GOLFHandicapCalculationOptionSuppressVsParAdj	(256)	If authority includes it, suppress (Course Rating - Par) adjustment
	//	GOLFHandicapCalculationOptionEnforceVsParAdj	(512)	Do (Course Rating - Par) adjustment if Authority doesn't include it
	//
	//	info:
	//	key					type			description
	//	------------------	--------------	-------------------------------------------------------
	//	is9HoleResult		NSNumber *		BOOL indicating result is for 9-hole play
	//	isWomensResult		NSNumber *		BOOL indicating result is for women
	//	unroundedResult		NSNumber *		GOLFUnroundedPlayingHandicap of the returned GOLFPlayingHandicap
	//	referenceObject		id				a <GOLFHandicapDataSource> with data of interest
	//	need9HoleHandicap	NSNumber *		(legacy) BOOL (TRUE --> courseRating and/or par are 9-hole values)
	//	needWomensHandicap	NSNumber *		(legacy) BOOL (TRUE --> courseRating and/or par are women's values)
	//	event				id				(legacy) an event <GOLFHandicapDataSource> with handicap data
	//	roundSide			id				(legacy) a side <GOLFHandicapDataSource> with handicap data
	//	round				id				(legacy) a round <GOLFHandicapDataSource> with handicap data
	//	courseRating		NSNumber *		(legacy) 9 or 18-hole course rating value
	//	par					NSNumber *		(legacy) 9 or 18-hole par

	GOLFPlayingHandicap playingHandicap = kNotAPlayingHandicap;	//	Start with a default return response
	GOLFUnroundedPlayingHandicap unroundedPlayingHandicap = kNotAnUnroundedPlayingHandicap;	//	Special WHS calculation value
	id <GOLFHandicapDataSource> referenceSource = nil;	//	Assume we don't have a reference source (round, event, competitor, scorecard, etc.)
	BOOL is9HoleResult = NO;
	BOOL isWomensResult = NO;
	
	//	Rating vs. Par adjustment…
	BOOL forceVsParAdj = ((options & GOLFHandicapCalculationOptionEnforceVsParAdj) != 0);	//	Priority
	BOOL suppressVsParAdj = !forceVsParAdj
			&& ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SuppressVsParHandicapAdjustments"] boolValue]
					|| ((options & GOLFHandicapCalculationOptionSuppressVsParAdj) != 0));
	
	//	Decide specifically what is needed…
	BOOL need9HoleResult = ((options & GOLFHandicapCalculationOptionNeed9HoleResult) != 0);
	BOOL needWomensResult = ((options & GOLFHandicapCalculationOptionNeedWomensResult) != 0);
	BOOL needUnroundedResult = NO;
	if (info) {
		//	A possible dataSource…
		referenceSource = (id <GOLFHandicapDataSource>)[info objectForKey:@"referenceObject"];
		
		//	Override of a couple parameter options
		NSNumber *needSomething = [info objectForKey:@"need9HoleHandicap"];
		if ((needSomething != nil) && [needSomething boolValue]) {
			need9HoleResult = YES;
		}
		needSomething = [info objectForKey:@"needWomensHandicap"];
		if ((needSomething != nil) && [needSomething boolValue]) {
			needWomensResult = YES;
		}
	}
	
	//	Determine the correct handicapping authority for calculation…
	GOLFHandicapAuthority *localAuthority = nil;
	if (referenceSource && [referenceSource respondsToSelector:@selector(handicapAuthority)]) {
		localAuthority = [(id <GOLFHandicapDataSource>)referenceSource handicapAuthority];	//	First choice - our referenceSource knows the handicapping authority
	}
	if (!GOLFHandicapValidAuthority(localAuthority)) {
		localAuthority = authority;	//	Second choice - it's been provided as a parameter
		
		if (!GOLFHandicapValidAuthority(localAuthority)) {
			localAuthority = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSelectedHandicapAuthority"];	//	Third choice - last authority selected

			if (!GOLFHandicapValidAuthority(localAuthority)) {
				localAuthority = GOLFDefaultHandicapAuthority();	//	Fourth choice - a default authority setting

				if (!GOLFHandicapValidAuthority(localAuthority)) {
					localAuthority = GOLFHandicapAuthorityWHS;	//	Last choice - WHS
				}
			}
		}
	}
	
	if (localAuthority == GOLFHandicapAuthorityWHS) {
		//	We'll try to always determine an unrounded playing handicap for subsequent stroke calculations
		needUnroundedResult = YES;
	}
	
	GOLFHandicapIndex localIndex = handicapIndex;
	BOOL have9HoleIndex = ((options & GOLFHandicapCalculationOption9HoleHandicap) != 0);
	if (referenceSource && [referenceSource respondsToSelector:@selector(handicapIndexForWomen:for9Holes:)]) {
		BOOL for9Holes = need9HoleResult;
		BOOL forWomen = needWomensResult;
		NSNumber *indexValue = [(id <GOLFHandicapDataSource>)referenceSource handicapIndexForWomen:&forWomen for9Holes:&for9Holes];
		if (indexValue != nil) {
			localIndex = [indexValue floatValue];
			have9HoleIndex = for9Holes;
			isWomensResult = forWomen;
		}
	}
	if (localIndex != kNotAHandicapIndex) {
		//	We've got a handicapIndex, and we'll usually need a SLOPE rating
		GOLFTeeSLOPERating unratedSLOPERating = GOLFHandicapUnratedSLOPERatingForAuthority(localAuthority);	//	Usually, 113.
		GOLFTeeSLOPERating localSlope = slopeRating;
		BOOL have9HoleSlope = ((options & GOLFHandicapCalculationOption9HoleSLOPE) != 0);
		BOOL haveWomensSlope = needWomensResult;
		if (localSlope == kNotASLOPERating) {
			//	The passed-in parameters didn't provide a SLOPE rating - we'll try some dataSources…
			if (referenceSource && [referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
				BOOL for9Holes = need9HoleResult;
				BOOL forWomen = needWomensResult;
				NSNumber *slopeValue = [(id <GOLFHandicapDataSource>)referenceSource teeSLOPERatingForWomen:&forWomen for9Holes:&for9Holes];
				if (slopeValue != nil) {
					localSlope = [slopeValue teeSLOPERatingValue];
					have9HoleSlope = for9Holes;
					haveWomensSlope = forWomen;
				}
				if (localSlope == kNotASLOPERating) {
					id <GOLFHandicapDataSource> extraSource = [info objectForKey:@"round"];
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"roundSide"];
					}
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"event"];
					}
					if (extraSource && [extraSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
						for9Holes = need9HoleResult;
						forWomen = needWomensResult;
						slopeValue = [(id <GOLFHandicapDataSource>)extraSource teeSLOPERatingForWomen:&forWomen for9Holes:&for9Holes];
						if (slopeValue) {
							localSlope = [slopeValue teeSLOPERatingValue];
							have9HoleSlope = for9Holes;
							haveWomensSlope = forWomen;
						}
					}
				}	//	if (localSlope == kNotASLOPERating)
			}	//	if (referenceSource && [referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)])
			if (localSlope == kNotASLOPERating) {
				localSlope = unratedSLOPERating;	//	Use the unrated tee SLOPE value
			}
		}	//	if (localSlope == kNotASLOPERating) - the parameters didn't provide a SLOPE rating

		//	Establish a course rating, if provided or otherwise available…
		GOLFTeeCourseRating localRating = courseRating;
		BOOL have9HoleRating = ((options & GOLFHandicapCalculationOption9HoleRating) != 0);
		BOOL haveWomensRating = needWomensResult;
		if (localRating == kNotACourseRating) {
			//	The passed-in parameters didn't provide a Course Rating - we'll try some dataSources…
			if (referenceSource && [referenceSource respondsToSelector:@selector(teeCourseRatingForWomen:for9Holes:)]) {
				BOOL for9Holes = need9HoleResult;
				BOOL forWomen = needWomensResult;
				NSNumber *ratingNumber = [(id <GOLFHandicapDataSource>)referenceSource teeCourseRatingForWomen:&forWomen for9Holes:&for9Holes];
				if (ratingNumber) {
					localRating = [ratingNumber teeCourseRatingValue];
					have9HoleRating = for9Holes;
					haveWomensRating = forWomen;
				}
				if (localRating == kNotACourseRating) {
					id <GOLFHandicapDataSource> extraSource = [info objectForKey:@"round"];
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"roundSide"];
					}
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"event"];
					}
					if (extraSource && [extraSource respondsToSelector:@selector(teeCourseRatingForWomen:for9Holes:)]) {
						for9Holes = need9HoleResult;
						forWomen = needWomensResult;
						ratingNumber = [(id <GOLFHandicapDataSource>)extraSource teeCourseRatingForWomen:&forWomen for9Holes:&for9Holes];
						if (ratingNumber) {
							localRating = [ratingNumber teeCourseRatingValue];
							have9HoleRating = for9Holes;
							haveWomensRating = forWomen;
						}
					}
				}
			}
			//	The bail-out for a missing Course Rating is related to par or comparative yardages of existing rated tees - later
		}	//	if (localRating == kNotACourseRating)

		//	Establish par, if provided or otherwise available…
		GOLFPar localPar = par;
		BOOL have9HolePar = ((options & GOLFHandicapCalculationOption9HolePar) != 0);
		BOOL haveWomensPar = needWomensResult;
		if (localPar == kNotAPar) {
			//	The passed-in parameters didn't provide par - we'll try some dataSources…
			if (referenceSource && [referenceSource respondsToSelector:@selector(teeParForWomen:for9Holes:)]) {
				BOOL for9Holes = need9HoleResult;
				BOOL forWomen = needWomensResult;
				NSNumber *parValue = [(id <GOLFHandicapDataSource>)referenceSource teeParForWomen:&forWomen for9Holes:&for9Holes];
				if (parValue) {
					localPar = [parValue parValue];
					have9HolePar = for9Holes;
					haveWomensPar = forWomen;
				}
				if (localPar == kNotAPar) {
					id <GOLFHandicapDataSource> extraSource = [info objectForKey:@"round"];
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"roundSide"];
					}
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"event"];
					}
					if (extraSource && [extraSource respondsToSelector:@selector(teeParForWomen:for9Holes:)]) {
						for9Holes = need9HoleResult;
						forWomen = needWomensResult;
						parValue = [(id <GOLFHandicapDataSource>)extraSource teeParForWomen:&forWomen for9Holes:&for9Holes];
						if (parValue) {
							localPar = [parValue parValue];
							have9HolePar = for9Holes;
							haveWomensPar = forWomen;
						}
					}
				}	//	if (localPar == kNotAPar) -- referenceSource didn't provide a value for par
			}	//	if (referenceSource && [referenceSource respondsToSelector:@selector(teeParForWomen:for9Holes:)])
		}	//	if (localPar == kNotAPar) -- parameters didn't provide a value for par
		
		if ([localAuthority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			//	USGA Course Handicap calculation
			BOOL negative = (localIndex < 0.0);	//	Plus handicaps - rounded toward zero
			
			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope) / unratedSLOPERating) + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	9-hole index… need 18-hole playingHandicap…
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope * 2.0) / unratedSLOPERating) + 0.5);
				is9HoleResult = NO;
			} else {
				//	18-hole index…, need 9-hole playingHandicap…
				GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)floorf(((negative ? -localIndex : localIndex) * 5.0) + 0.5) / 10.0;	//	rounded to a tenth
				playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope) / unratedSLOPERating) + 0.5);
				is9HoleResult = YES;
			}
			
			if (negative || (playingHandicap < 0)) {
				playingHandicap = -playingHandicap;
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			//	RCGA Course Handicap calculation
			BOOL negative = (localIndex < 0.0);	//	Plus handicaps - rounded away from zero (calculate as positive, then re-sign)
			
			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope) / unratedSLOPERating) + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	9-hole index… need 18-hole playingHandicap…
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope * 2.0) / unratedSLOPERating) + 0.5);
				is9HoleResult = NO;
			} else {
				//	18-hole index…, need 9-hole playingHandicap…
				GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)floorf(((negative ? -localIndex : localIndex) * 5.0) + 0.5) / 10.0;	//	rounded to a tenth
				playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope) / unratedSLOPERating) + 0.5);
				is9HoleResult = YES;
			}
			
			if (negative || (playingHandicap < 0)) {
				playingHandicap = -playingHandicap;
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityEGA]) {
			//	Playing handicap is index * slope / 113 + (rating - par)
			//	Except in Category 6, playing handicap is index + playingHandicapDifferential

			GOLFHandicapGrade category = EGACategoryFromEGAHandicap(localIndex, isWomensResult);
			if (category > 5) {
				NSMutableDictionary *localInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:need9HoleResult], @"need9HoleHandicap", nil];
				if (localRating != kNotACourseRating) {
					[localInfo setObject:[NSNumber numberWithFloat:localRating] forKey:@"courseRating"];	//	Legacy form in info
				}
				if (localPar != kNotAPar) {
					[localInfo setObject:[NSNumber numberWithInteger:localPar] forKey:@"par"];
				}
				GOLFHandicapCalculationOption localOptions = (options & ~GOLFHandicapCalculationOption9HoleHandicap);	//	NOT a 9-hole index, still contains 9-hole and women's options
				GOLFPlayingHandicap playingHandicapDifferential = GOLFPlayingHandicapFor(localAuthority, 36.0, localRating, localSlope, localPar, localOptions, localInfo, nil) - (need9HoleResult ? 18 : 36);
				playingHandicap = (GOLFPlayingHandicap)floorf(localIndex + playingHandicapDifferential + 0.5);
				is9HoleResult = need9HoleResult;
			} else {
				//	Plus handicaps - rounded toward zero
				float adjust = 0.0;
				if ((localRating != kNotACourseRating) && (localPar != kNotAPar) && !suppressVsParAdj) {
					//	adjustment is based on rating and par pre-set for proper number of holes
					adjust += localRating - localPar;
				}
				if (have9HoleIndex == need9HoleResult) {
					playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / unratedSLOPERating) + adjust) + 0.5);
					is9HoleResult = have9HoleIndex;
				} else if (have9HoleIndex) {
					//	requirement is for 18 holes, so we don't double adjustment
					playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / unratedSLOPERating) * 2.0) + adjust + 0.5);
					is9HoleResult = NO;
				} else {
					//	requirement is for 9 holes, so we don't halve adjustment
					GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)floorf((localIndex * 5.0) + 0.5) / 10.0;	//	rounded to a tenth
					playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope / unratedSLOPERating) + adjust) + 0.5);
					is9HoleResult = YES;
				}
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	Playing handicap is (index * slope / 113 + (rating - par)) * 0.93

			//	Plus handicaps - rounding is to nearest whole number - as from GOLF Australia docs:
			//	"The result of the calculation is rounded to the nearest whole number.
			//	0.5 rounds to 1, 0.501 rounds to 1, 10.5 rounds to 11, 10.501 rounds to 11, 20.5 rounds to 21, 20.501 rounds to 21, etc.
			//	+0.5 rounds to Scratch, +0.501 rounds to +1, +1.5 rounds to +1, +1.501 rounds to +2, +2.5 rounds to +2, +2.501 rounds to +3, etc."

			float adjust = 0.0;
			if ((localRating != kNotACourseRating) && (localPar != kNotAPar) && !suppressVsParAdj) {
				//	adjustment is based on rating and par pre-set for proper number of holes
				adjust += localRating - localPar;
			}
			
			float workingHandicap = kNotAFloatValue;
			if (have9HoleIndex == need9HoleResult) {
				workingHandicap = (localIndex * localSlope / unratedSLOPERating) + adjust;	//	Either 9 holes or 18 holes, unmultipled, unrounded
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	requirement is for 18 holes, so we don't double adjustment
				workingHandicap = ((localIndex * localSlope / unratedSLOPERating) * 2.0) + adjust;	//	18 holes, unmultipled, unrounded
				is9HoleResult = NO;
			} else {
				//	requirement is for 9 holes, so we don't halve adjustment
				GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)floorf((localIndex * 5.0) + 0.5) / 10.0;	//	rounded to a tenth
				workingHandicap = (halfIndex * localSlope / unratedSLOPERating) + adjust;	//	9 holes, unmultipled, unrounded
				is9HoleResult = YES;
			}
			workingHandicap = workingHandicap * 0.93;	//	93% multiplier
			if (workingHandicap < 0) {
				playingHandicap = (GOLFPlayingHandicap)nearbyintf(workingHandicap);	//	Rounded to the nearest integer equivalent (-0.5 rounds to 0, 1.5 rounds to -1)
			} else {
				playingHandicap = (GOLFPlayingHandicap)floorf(fabs(workingHandicap) + 0.5);	//	Rounded positive whole number
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			//	Course handicap is the player's Exact Handicap, rounded to the nearest integer
			//	To be scratch (0 handicap) or less, the index must be 0.0 or lower

			if (localIndex > 0.0) {
				if (have9HoleIndex == need9HoleResult) {
					playingHandicap = (GOLFPlayingHandicap)MAX(floorf(localIndex + 0.5), 1);
					is9HoleResult = have9HoleIndex;
				} else if (have9HoleIndex) {
					playingHandicap = (GOLFPlayingHandicap)MAX(floorf((localIndex * 2.0) + 0.5), 1);
					is9HoleResult = NO;
				} else {
					playingHandicap = (GOLFPlayingHandicap)MAX(floorf((localIndex / 2.0) + 0.5), 1);
					is9HoleResult = YES;
				}
			} else {
				 //	Scratch and lower are unrounded
				if (have9HoleIndex == need9HoleResult) {
					playingHandicap = (GOLFPlayingHandicap)(localIndex);
					is9HoleResult = have9HoleIndex;
				} else if (have9HoleIndex) {
					playingHandicap = (GOLFPlayingHandicap)(localIndex * 2.0);
					is9HoleResult = NO;
				} else {
					playingHandicap = (GOLFPlayingHandicap)(localIndex / 2.0);
					is9HoleResult = YES;
				}
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityWHS]) {
			//	Playing handicap is index * slope / 113 + (rating - par)
			//	Just like EGA, no "category" special handling

			//	Plus handicaps - documentatation says handicaps are rounded "up"
			float adjust = 0.0;
			if ((localRating != kNotACourseRating) && (localPar != kNotAPar) && !suppressVsParAdj) {
				//	adjustment is based on rating and par pre-set for proper number of holes
				adjust += localRating - localPar;
			}
			if (have9HoleIndex == need9HoleResult) {
				// requirement is 9-hole handicap from 9-hole Index or 18-hole handicap from 18-hole Index
				unroundedPlayingHandicap = (GOLFUnroundedPlayingHandicap)((localIndex * localSlope / unratedSLOPERating) + adjust);
				playingHandicap = (GOLFPlayingHandicap)floorf(unroundedPlayingHandicap + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	requirement is for 18 holes, so we don't double adjustment
				unroundedPlayingHandicap = (GOLFUnroundedPlayingHandicap)(((localIndex * localSlope / unratedSLOPERating) * 2.0) + adjust);
				playingHandicap = (GOLFPlayingHandicap)floorf(unroundedPlayingHandicap + 0.5);
				is9HoleResult = NO;
			} else {
				//	requirement is for 9 holes from 18-hole Index, so we don't halve adjustment
				GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)(localIndex / 2.0);	//	unrounded
				unroundedPlayingHandicap = (GOLFUnroundedPlayingHandicap)((halfIndex * localSlope / unratedSLOPERating) + adjust);
				playingHandicap = (GOLFPlayingHandicap)floorf(unroundedPlayingHandicap + 0.5);
				is9HoleResult = YES;
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
			//	Playing handicap is index * slope / 113 + (rating - par)
			//	Just like EGA, no "category" special handling

			//	Plus handicaps - documentatation says handicaps are rounded "up"
			float adjust = 0.0;
			if ((localRating != kNotACourseRating) && (localPar != kNotAPar) && !suppressVsParAdj) {
				//	adjustment is based on rating and par pre-set for proper number of holes
				adjust += localRating - localPar;
			}
			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / unratedSLOPERating) + adjust) + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	requirement is for 18 holes, so we don't double adjustment
				playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / unratedSLOPERating) * 2.0) + adjust + 0.5);
				is9HoleResult = NO;
			} else {
				//	requirement is for 9 holes, so we don't halve adjustment
				GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)floorf((localIndex * 5.0) + 0.5) / 10.0;	//	rounded to a tenth
				playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope / unratedSLOPERating) + adjust) + 0.5);
				is9HoleResult = YES;
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			//	Method 3 Course Handicap calculation

			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf(handicapIndex + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				playingHandicap = (GOLFPlayingHandicap)floorf((handicapIndex * 2.0) + 0.5);
				is9HoleResult = NO;
			} else {
				playingHandicap = (GOLFPlayingHandicap)floorf((handicapIndex / 2) + 0.5);
				is9HoleResult = YES;
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthoritySecondBest]) {
			//	Method 3 Course Handicap calculation

			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf(handicapIndex + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				playingHandicap = (GOLFPlayingHandicap)floorf((handicapIndex * 2.0) + 0.5);
				is9HoleResult = NO;
			} else {
				playingHandicap = (GOLFPlayingHandicap)floorf((handicapIndex / 2) + 0.5);
				is9HoleResult = YES;
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityPersonal]) {
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
			GOLFPlayingHandicapType playingHandicapType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHPlayingHandicapType"] integerValue];
			switch (playingHandicapType) {
				case GOLFPlayingHandicapTypeUnadjusted:
					//	The playing handicap is the rounded exact handicap
					if (have9HoleIndex == need9HoleResult) {
						playingHandicap = (GOLFPlayingHandicap)floorf(localIndex + 0.5);
						is9HoleResult = have9HoleIndex;
					} else if (have9HoleIndex) {
						playingHandicap = (GOLFPlayingHandicap)floorf((localIndex * 2.0) + 0.5);
						is9HoleResult = NO;
					} else {
						playingHandicap = (GOLFPlayingHandicap)floorf((localIndex / 2) + 0.5);
						is9HoleResult = YES;
					}
					break;

				case GOLFPlayingHandicapTypeRatingAdjusted:
					{
						//	Use just the rating to adjust the exact handicap…
						float adjust = 0.0;
						if ((localRating != kNotACourseRating) && (localPar != kNotAPar) && !suppressVsParAdj) {
							adjust = localRating - localPar;
						}
						if (have9HoleIndex == need9HoleResult) {
							playingHandicap = (GOLFPlayingHandicap)floorf(localIndex + adjust + 0.5);
							is9HoleResult = have9HoleIndex;
						} else if (have9HoleIndex) {
							playingHandicap = (GOLFPlayingHandicap)floorf((localIndex  * 2.0) + adjust + 0.5);
							is9HoleResult = NO;
						} else {
							GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)floorf((localIndex * 5.0) + 0.5) / 10.0;	//	rounded to a tenth
							playingHandicap = (GOLFPlayingHandicap)floorf(halfIndex + adjust + 0.5);
							is9HoleResult = YES;
						}
					}
					break;

				case GOLFPlayingHandicapTypeFullyAdjusted:
					{
						//	Use both slope and rating to adjust the exact handicap…
						float adjust = 0.0;
						if ((localRating != kNotACourseRating) && (localPar != kNotAPar) && !suppressVsParAdj) {
							adjust = localRating - localPar;
						}
						if (have9HoleIndex == need9HoleResult) {
							playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope) / unratedSLOPERating) + adjust + 0.5);
							is9HoleResult = have9HoleIndex;
						} else if (have9HoleIndex) {
							playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope * 2.0) / unratedSLOPERating) + adjust + 0.5);
							is9HoleResult = NO;
						} else {
							GOLFHandicapIndex halfIndex = (GOLFHandicapIndex)floorf((localIndex * 5.0) + 0.5) / 10.0;	//	rounded to a tenth
							playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope) / unratedSLOPERating) + adjust + 0.5);
							is9HoleResult = YES;
						}
					}
					break;

				case GOLFPlayingHandicapTypeSlopeAdjusted:
					//	Playing handicap is exact handicap adjusted from neutral slope…
					if (have9HoleIndex == need9HoleResult) {
						playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope) / unratedSLOPERating) + 0.5);
						is9HoleResult = have9HoleIndex;
					} else if (have9HoleIndex) {
						playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope * 2.0) / unratedSLOPERating) + 0.5);
						is9HoleResult = NO;
					} else {
						playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / 2.0) / unratedSLOPERating) + 0.5);
						is9HoleResult = YES;
					}
					break;

				default:
					break;
			}	//	switch (playingHandicapType)
#else
			//	The playing handicap is the rounded exact handicap
			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf(localIndex + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				playingHandicap = (GOLFPlayingHandicap)floorf((localIndex * 2.0) + 0.5);
				is9HoleResult = NO;
			} else {
				playingHandicap = (GOLFPlayingHandicap)floorf((localIndex / 2) + 0.5);
				is9HoleResult = YES;
			}
#endif
		}	//	else if ([localAuthority isEqualToString:GOLFHandicapAuthorityPersonal])
	}	//	if (localIndex != kNotAHandicapIndex)

	//	Update the info dictionary (when we've computed a handicap) with changes or additions…
	if (info && (playingHandicap != kNotAPlayingHandicap) && [info isKindOfClass:[NSMutableDictionary class]]) {
		[(NSMutableDictionary *)info setObject:[NSNumber numberWithBool:is9HoleResult] forKey:@"is9HoleResult"];
		[(NSMutableDictionary *)info setObject:[NSNumber numberWithBool:isWomensResult] forKey:@"isWomensResult"];
		if (needUnroundedResult && (playingHandicap != kNotAPlayingHandicap)) {
			unroundedPlayingHandicap = ((unroundedPlayingHandicap == kNotAnUnroundedPlayingHandicap) ? (float)playingHandicap : unroundedPlayingHandicap);
			[(NSMutableDictionary *)info setObject:[NSNumber numberWithUnroundedPlayingHandicap:unroundedPlayingHandicap] forKey:@"unroundedResult"];
			
			if (unrounded) {
				//	We'll return unrounded as parameter requests, AND we'll also have the unrounded result in info
				*unrounded = unroundedPlayingHandicap;
			}
		}
	}
	return playingHandicap;
}

//=================================================================
//	GOLFLowHighIndexesAsPointFor(authority, playingHandicap, courseRating, slopeRating, par, options, referenceSource)
//=================================================================
CGPoint GOLFLowHighIndexesAsPointFor(GOLFHandicapAuthority *authority, GOLFPlayingHandicap playingHandicap, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, id <GOLFHandicapDataSource>referenceSource) {

	//	Parameters:
	//	GOLFHandicapAuthority *			authority		optional		Handicap authority
	//	GOLFPlayingHandicap				playingHandicap	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAPlayingHandicap is valid)
	//	GOLFTeeCourseRating				courseRating	required		18 holes unless GOLFHandicapCalculationOption9HoleRating (kNotACourseRating is valid)
	//	GOLFTeeSLOPERating				slopeRating		required		18 holes unless GOLFHandicapCalculationOption9HoleSLOPE (kNotASLOPERating is valid)
	//	GOLFPar							par				required		18 holes unless GOLFHandicapCalculationOption9HolePar (kNotAPar is valid)
	//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
	//	GOLFHandicapDataSource			referenceSource	optional		optional <GOLFHandicapDataSource> - most likely a tee
	//
	//	options:
	//	GOLFHandicapCalculationOptionNeed9HoleResult	(1)		Need return of 9-hole indexes *
	//	GOLFHandicapCalculationOptionNeedWomensResult	(2)		Need return of a woman's handicap
	//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFPlayingHandicap is for 9 holes
	//	GOLFHandicapCalculationOption9HoleRating		(8)		Provided GOLFTeeCourseRating is for 9 holes
	//	GOLFHandicapCalculationOption9HoleSLOPE			(16)	Provided GOLFTeeSLOPERating is for 9 holes
	//	GOLFHandicapCalculationOption9HolePar			(32)	Provided GOLFPar is for 9 holes
	//	GOLFHandicapCalculationOptionSuppressVsParAdj	(256)	If authority includes it, suppress (Course Rating - Par) adjustment
	//	GOLFHandicapCalculationOptionEnforceVsParAdj	(512)	Do (Course Rating - Par) adjustment if Authority doesn't include it

	//	* - NOTE:  Return indexes might be 18-hole, for example, EVEN IF the provided playingHandicap, courseRating, slopeRating and/or par are for 9 holes!
	
	GOLFHandicapAuthority *localAuthority = nil;
	if (referenceSource && [referenceSource respondsToSelector:@selector(handicapAuthority)]) {
		localAuthority = [referenceSource handicapAuthority];
	}
	if (!GOLFHandicapValidAuthority(localAuthority)) {
		localAuthority = authority;
		
		if (!GOLFHandicapValidAuthority(localAuthority)) {
			localAuthority = [[NSUserDefaults standardUserDefaults] objectForKey:@"HandicapAuthority"];
			
			if (!GOLFHandicapValidAuthority(localAuthority)) {
				localAuthority = GOLFDefaultHandicapAuthority();
			}
		}
	}

	BOOL have9HolePlayingHandicap = ((options & GOLFHandicapCalculationOption9HoleHandicap) != 0);
	BOOL need9HoleResult = ((options & GOLFHandicapCalculationOptionNeed9HoleResult) != 0);
	GOLFPlayingHandicap localHandicap = playingHandicap;
	GOLFTeeSLOPERating localSlope = slopeRating;
	BOOL have9HoleSlope = ((options & GOLFHandicapCalculationOption9HoleSLOPE) != 0);
	GOLFTeeCourseRating localRating = courseRating;
	BOOL have9HoleRating = ((options & GOLFHandicapCalculationOption9HoleRating) != 0);
	GOLFPar localPar = par;
	BOOL have9HolePar = ((options & GOLFHandicapCalculationOption9HolePar) != 0);

	//	Rating vs. Par adjustment…
	BOOL forceVsParAdj = ((options & GOLFHandicapCalculationOptionEnforceVsParAdj) != 0);	//	Priority
	BOOL suppressVsParAdj = !forceVsParAdj
			&& ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SuppressVsParHandicapAdjustments"] boolValue]
					|| ((options & GOLFHandicapCalculationOptionSuppressVsParAdj) != 0));
	
	//	Even if we've been provided a SLOPE rating - we'll try the dataSource…
	if (referenceSource) {
		BOOL for9Holes = need9HoleResult;
		if ([referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
			NSNumber *slopeNumber = [referenceSource teeSLOPERatingForWomen:nil for9Holes:&for9Holes];
			if (slopeNumber) {
				localSlope = [slopeNumber teeSLOPERatingValue];
				have9HoleSlope = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeCourseRatingForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *ratingNumber = [referenceSource teeCourseRatingForWomen:nil for9Holes:&for9Holes];
			if (ratingNumber) {
				localRating = [ratingNumber teeCourseRatingValue];
				have9HoleRating = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeParForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *parNumber = [referenceSource teeParForWomen:nil for9Holes:&for9Holes];
			if (parNumber) {
				localPar = [parNumber parValue];
				have9HolePar = for9Holes;
			}
		}
	}
	//	Make the Course Rating, SLOPE Rating and par conform to the supplied playingHandicap…
	if ((localSlope != kNotASLOPERating) && (have9HoleSlope != have9HolePlayingHandicap)) {
		have9HoleSlope = have9HolePlayingHandicap;	//	SLOPE Ratings are same size on 9 or 18 hole courses
	}
	if ((localRating != kNotACourseRating) && (have9HoleRating != have9HolePlayingHandicap)) {
		localRating = (have9HolePlayingHandicap ? (GOLFTeeCourseRating)(floorf((localRating * 5.0) + 0.5) / 10.0) : (localRating * 2.0));
		have9HoleRating = have9HolePlayingHandicap;
	}
	if ((localPar != kNotAPar) && (have9HolePar != have9HolePlayingHandicap)) {
		localPar = (have9HolePlayingHandicap ? (GOLFPar)floorf((localPar / 2.0) + 0.5) : (GOLFPar)(localPar * 2));
		have9HolePar = have9HolePlayingHandicap;
	}

	NSInteger unratedSLOPERating = GOLFHandicapUnratedSLOPERatingForAuthority(localAuthority);	//	Usually, 113.
	
	float minVal;
	float maxVal;
	float multiplier = ((!need9HoleResult && have9HolePlayingHandicap) ? 2.0 : 1.0);
	if ([localAuthority isEqualToString:GOLFHandicapAuthorityEGA]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		minVal = floor(((((float)localHandicap - ratingAdj - 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) + 0.999) / 10.0;
		maxVal = floor(((((float)localHandicap - ratingAdj + 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) - 0.001) / 10.0;
	} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityWHS]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		minVal = floor(((((float)localHandicap - ratingAdj - 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) + 0.999) / 10.0;
		maxVal = floor(((((float)localHandicap - ratingAdj + 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) - 0.001) / 10.0;
	} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		minVal = floor(((((float)localHandicap - ratingAdj - 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) + 0.999) / 10.0;
		maxVal = floor(((((float)localHandicap - ratingAdj + 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) - 0.001) / 10.0;
	} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityAGU]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		
//		if (workingHandicap < 0) {
//			playingHandicap = (GOLFPlayingHandicap)nearbyintf(workingHandicap);	//	Rounded to the nearest integer equivalent (-0.5 rounds to 0, 1.5 rounds to -1)
//		} else {
//			playingHandicap = (GOLFPlayingHandicap)floorf(fabs(workingHandicap) + 0.5);	//	Rounded positive whole number
//		}
		
		minVal = floor(((((float)(localHandicap - 0.4) / 0.93) - ratingAdj) * unratedSLOPERating * 10.0) * multiplier / localSlope) / 10.0;
		maxVal = floor(((((float)(localHandicap + 0.5) / 0.93) - ratingAdj) * unratedSLOPERating * 10.0) * multiplier / localSlope) / 10.0;
		
		float minReal = minVal;
		float maxReal = maxVal;
		GOLFPlayingHandicap minLocal = localHandicap;
		float testVal = minVal;
		while (minLocal == localHandicap) {
			minLocal = GOLFPlayingHandicapFor(authority, testVal, localRating, localSlope, localPar, options, nil, nil);
			if (minLocal != localHandicap) {
				break;
			}
			minReal = testVal;
			testVal = testVal - 0.1;
		}

		GOLFPlayingHandicap maxLocal = localHandicap;
		testVal = maxVal;
		while (maxLocal == localHandicap) {
			maxLocal = GOLFPlayingHandicapFor(authority, testVal, localRating, localSlope, localPar, options, nil, nil);
			if (maxLocal != localHandicap) {
				break;
			}
			maxReal = testVal;
			testVal = testVal + 0.1;
		}
//#ifdef DEBUG
//		NSLog(@"GOLFLowHighIndexesAsPointFor(%@, %d, %1.1f, %d, %d, %d, %@) returns %1.1f, %1.1f  (real: %1.1f, %1.1f)", authority, playingHandicap, courseRating, slopeRating, par, options, NSStringFromClass([referenceSource class]), minVal, maxVal, minReal, maxReal);
//#endif
	} else {
		GOLFPlayingHandicap positiveHdcp = (localHandicap < 0 ? -localHandicap : localHandicap);
		minVal = floor(((((float)positiveHdcp - 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) + 0.999) / 10.0;
		maxVal = floor(((((float)positiveHdcp + 0.5) * unratedSLOPERating * 10.0) * multiplier / localSlope) - 0.001) / 10.0;
		if (localHandicap < 0) {
			float tmp = minVal;
			minVal = -maxVal;
			maxVal = -tmp;
		} else if (localHandicap == 0) {
			minVal = -maxVal;
		}
	}
	
	if (!need9HoleResult && have9HolePlayingHandicap) {
		//	We're returning 18-hole index range computed from 9-hole playing handicap…
		GOLFPlayingHandicap targetHandicap = kNotAPlayingHandicap;
		GOLFHandicapCalculationOption options = GOLFHandicapCalculationOptionNeed9HoleResult;	//	An 18-hole index for a 9-hole handicap
		if (have9HoleRating) {
			options |= GOLFHandicapCalculationOption9HoleRating;
		}
		if (have9HoleSlope) {
			options |= GOLFHandicapCalculationOption9HoleSLOPE;
		}
		if (have9HolePar) {
			options |= GOLFHandicapCalculationOption9HolePar;
		}
		minVal = floorf((minVal * 10.0) - 0.5) / 10.0;	//	Reduce the minimum by a tenth to start
//		maxVal = floorf((maxVal * 10.0) + 1.5) / 10.0;	//	Increase the maximum by a tenth to start
//		NSUInteger loops = 0;
		while (targetHandicap != localHandicap) {
//			loops++;
			targetHandicap = GOLFPlayingHandicapFor(authority, minVal, localRating, localSlope, localPar, options, nil, nil);
			if (targetHandicap < localHandicap) {
				minVal = floorf((minVal * 10.0) + 1.5) / 10.0;	//	Bump min limit 0.1
			} else if (targetHandicap > localHandicap) {
				minVal = floorf((minVal * 10.0) - 0.5) / 10.0;	//	Reduce max limit 0.1
			}
		}
//#ifdef DEBUG
//	GOLFPlayingHandicap test = GOLFPlayingHandicapFor(authority, minVal, localRating, localSlope, localPar, options, nil);
//		NSLog(@"GOLFLowHighIndexesAsPointFor() target: %ld, local: %ld, minVal: %1.1f --> %ld (%lu)", (long)targetHandicap, (long)localHandicap, minVal, (long)test, loops);
//#endif
		targetHandicap = kNotAPlayingHandicap;
//		loops = 0;
		while (targetHandicap != localHandicap) {
//			loops++;
			targetHandicap = GOLFPlayingHandicapFor(authority, maxVal, localRating, localSlope, localPar, options, nil, nil);
			if (targetHandicap > localHandicap) {
				maxVal = floorf((maxVal * 10.0) - 0.5) / 10.0;	//	Reduce max limit 0.1
			} else if (targetHandicap < localHandicap) {
				maxVal = floorf((maxVal * 10.0) + 1.5) / 10.0;	//	Bump max limit 0.1
			}
		}
//#ifdef DEBUG
//	test = GOLFPlayingHandicapFor(authority, maxVal, localRating, localSlope, localPar, options, nil);
//		NSLog(@"GOLFLowHighIndexesAsPointFor() target: %ld, local: %ld, maxVal: %1.1f --> %ld (%lu)", (long)targetHandicap, (long)localHandicap, maxVal, (long)test, loops);
//#endif
	}

	return CGPointMake(minVal, maxVal);
}

//=================================================================
//	GOLFFirstLocalHandicapForAuthority(authority, limitingIndex, courseRating, slopeRating, par, options, referenceSource)
//=================================================================
GOLFPlayingHandicap GOLFFirstLocalHandicapForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex limitingIndex, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, id <GOLFHandicapDataSource>referenceSource) {

	//	Parameters:
	//	GOLFHandicapAuthority *			authority		optional		Handicap authority
	//	GOLFHandicapIndex				limitingIndex	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAHandicapIndex is valid)
	//	GOLFTeeCourseRating				courseRating	required		18 holes unless GOLFHandicapCalculationOption9HoleRating (kNotACourseRating is valid)
	//	GOLFTeeSLOPERating				slopeRating		required		18 holes unless GOLFHandicapCalculationOption9HoleSLOPE (kNotASLOPERating is valid)
	//	GOLFPar							par				required		18 holes unless GOLFHandicapCalculationOption9HolePar (kNotAPar is valid)
	//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
	//	GOLFHandicapDataSource			referenceSource	optional		optional <GOLFHandicapDataSource> - most likely a tee
	//
	//	options:
	//	GOLFHandicapCalculationOptionNeed9HoleResult	(1)		Need return of a 9-hole handicap
	//	GOLFHandicapCalculationOptionNeedWomensResult	(2)		Need return of a woman's handicap
	//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFPlayingHandicap is for 9 holes
	//	GOLFHandicapCalculationOption9HoleRating		(8)		Provided GOLFTeeCourseRating is for 9 holes
	//	GOLFHandicapCalculationOption9HoleSLOPE			(16)	Provided GOLFTeeSLOPERating is for 9 holes
	//	GOLFHandicapCalculationOption9HolePar			(32)	Provided GOLFPar is for 9 holes
	//	GOLFHandicapCalculationOptionSuppressVsParAdj	(256)	If authority includes it, suppress (Course Rating - Par) adjustment
	//	GOLFHandicapCalculationOptionEnforceVsParAdj	(512)	Do (Course Rating - Par) adjustment if Authority doesn't include it

	GOLFHandicapAuthority *localAuthority = nil;
	if (referenceSource && [referenceSource respondsToSelector:@selector(handicapAuthority)]) {
		localAuthority = [referenceSource handicapAuthority];
	}
	if (!GOLFHandicapValidAuthority(localAuthority)) {
		localAuthority = authority;
		
		if (!GOLFHandicapValidAuthority(localAuthority)) {
			localAuthority = [[NSUserDefaults standardUserDefaults] objectForKey:@"HandicapAuthority"];
			
			if (!GOLFHandicapValidAuthority(localAuthority)) {
				localAuthority = GOLFDefaultHandicapAuthority();
			}
		}
	}

	BOOL have9HoleIndex = ((options & GOLFHandicapCalculationOption9HoleHandicap) != 0);
	BOOL need9HoleResult = ((options & GOLFHandicapCalculationOptionNeed9HoleResult) != 0);
	GOLFHandicapIndex localLimit = ((have9HoleIndex == need9HoleResult)
			? limitingIndex
			: (need9HoleResult
					? (GOLFHandicapIndex)(floorf((limitingIndex * 5.0) + 0.5) / 10.0)
					: (limitingIndex * 2.0)));
	GOLFTeeSLOPERating localSlope = slopeRating;
	BOOL have9HoleSlope = ((options & GOLFHandicapCalculationOption9HoleSLOPE) != 0);
	GOLFTeeCourseRating localRating = courseRating;
	BOOL have9HoleRating = ((options & GOLFHandicapCalculationOption9HoleRating) != 0);
	GOLFPar localPar = par;
	BOOL have9HolePar = ((options & GOLFHandicapCalculationOption9HolePar) != 0);

	//	Rating vs. Par adjustment…
	BOOL forceVsParAdj = ((options & GOLFHandicapCalculationOptionEnforceVsParAdj) != 0);	//	Priority
	BOOL suppressVsParAdj = !forceVsParAdj
			&& ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SuppressVsParHandicapAdjustments"] boolValue]
					|| ((options & GOLFHandicapCalculationOptionSuppressVsParAdj) != 0));
	
	//	Even if we've been provided a SLOPE rating - we'll try the dataSource…
	if (referenceSource) {
		BOOL for9Holes = need9HoleResult;
		if ([referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
			NSNumber *slopeNumber = [referenceSource teeSLOPERatingForWomen:nil for9Holes:&for9Holes];
			if (slopeNumber) {
				localSlope = [slopeNumber teeSLOPERatingValue];
				have9HoleSlope = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeCourseRatingForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *ratingNumber = [referenceSource teeCourseRatingForWomen:nil for9Holes:&for9Holes];
			if (ratingNumber) {
				localRating = [ratingNumber teeCourseRatingValue];
				have9HoleRating = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeParForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *parNumber = [referenceSource teeParForWomen:nil for9Holes:&for9Holes];
			if (parNumber) {
				localPar = [parNumber parValue];
				have9HolePar = for9Holes;
			}
		}
	}
	//	Make the Course Rating, SLOPE Rating and par conform to the 9-hole requirements…
	if ((localSlope != kNotASLOPERating) && (have9HoleSlope != need9HoleResult)) {
		have9HoleSlope = NO;	//	SLOPE Ratings are same size on 9 or 18 hole courses
	}
	if ((localRating != kNotACourseRating) && (have9HoleRating != need9HoleResult)) {
		localRating = (need9HoleResult ? (GOLFTeeCourseRating)(floorf((localRating * 5.0) + 0.5) / 10.0) : (localRating * 2.0));
		have9HoleRating = need9HoleResult;
	}
	if ((localPar != kNotAPar) && (have9HolePar != need9HoleResult)) {
		localPar = (need9HoleResult ? (GOLFPar)floorf((localPar / 2.0) + 0.5) : (GOLFPar)(localPar * 2));
		have9HolePar = need9HoleResult;
	}

	NSInteger unratedSLOPERating = GOLFHandicapUnratedSLOPERatingForAuthority(localAuthority);	//	Usually, 113.

	if ([localAuthority isEqualToString:GOLFHandicapAuthorityEGA]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		return (GOLFPlayingHandicap)floor((((localLimit + 0.1) * localSlope) / unratedSLOPERating) + ratingAdj + 0.5);
	} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityWHS]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		return (GOLFPlayingHandicap)floor((((localLimit + 0.1) * localSlope) / unratedSLOPERating) + ratingAdj + 0.5);
	} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		return (GOLFPlayingHandicap)floor((((localLimit + 0.1) * localSlope) / unratedSLOPERating) + ratingAdj + 0.5);
	} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityAGU]) {
		//	Golf Australia applies a 0.93 multiplier to Daily Handicaps
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating) || suppressVsParAdj)
				? 0.0
				: (localRating - (GOLFTeeCourseRating)localPar));
		return (GOLFPlayingHandicap)floor((((((localLimit + 0.1) * localSlope) / unratedSLOPERating) + ratingAdj) * 0.93) + 0.5);
	} else {
		return (GOLFPlayingHandicap)floor((((localLimit + 0.1) * localSlope) / unratedSLOPERating) + 0.5);
	}
}

#pragma mark European Golf Association (EGA)

//=================================================================
//	EGACategoryFromExactHandicap
//=================================================================
GOLFHandicapGrade EGACategoryFromEGAHandicap(GOLFHandicapIndex EGAHandicap, BOOL playerIsFemale) {
	if (EGAHandicap != kNotAHandicapIndex) {
		if (EGAHandicap < 4.5)		//	Category 1
			return 1;
		else if (EGAHandicap < 11.5)	//	Category 2
			return 2;
		else if (EGAHandicap < 18.5)	//	Category 3
			return 3;
		else if (EGAHandicap < 26.5)	//	Category 4
			return 4;
		else if (EGAHandicap < 36.1)	//	Category 5
			return 5;
		else if (EGAHandicap < 54.1)	//	Category 6
			return 6;
		else							//	Beyond category
			return (GOLFHandicapGrade)kNotAHandicapGrade;
	}
	return (GOLFHandicapGrade)kNotAHandicapGrade;
}

//=================================================================
//	EGABufferLimitFromCategory(category, is9HoleRound)
//=================================================================
float EGABufferLimitFromCategory(GOLFHandicapGrade category, BOOL is9HoleRound) {
	if (category < 2)		//	Category 1
		return (is9HoleRound ? 36.0 : 35.0);
	if (category < 3)		//	Category 2
		return (is9HoleRound ? 35.0 : 34.0);
	if (category < 4)		//	Category 3
		return (is9HoleRound ? 35.0 : 33.0);
	if (category < 5)		//	Category 4
		return (is9HoleRound ? 34.0 : 32.0);
	if (category < 6)		//	Category 5
		return (is9HoleRound ? 33.0 : 31.0);

	return (is9HoleRound ? 33.0 : 31.0);		//	Category 6 and beyond
}

//=================================================================
//	EGAPerStrokeHandicapReductionFromCategory(category)
//=================================================================
float EGAPerStrokeHandicapReductionFromCategory(GOLFHandicapGrade category) {
	if (category < 2)		//	Category 1
		 return 0.1;
	if (category < 3)		//	Category 2
		return 0.2;
	if (category < 4)		//	Category 3
		return 0.3;
	if (category < 5)		//	Category 4
		return 0.4;
	if (category < 6)		//	Category 5
		return 0.5;
	if (category < 7)		//	Category 6
		return 1.0;

	return 1.0;			//	Beyond category ("Club" handicaps)
}

//=================================================================
//	EGAHandicapAdditionFromCategory(category)
//=================================================================
float EGAHandicapAdditionFromCategory(GOLFHandicapGrade category) {
	if (category < 6)		//	Categories 1, 2, 3, 4, 5
		 return 0.1;

	return 0.0;				//	Category 6 and "Beyond category" ("Club" handicaps) - never increased
}

