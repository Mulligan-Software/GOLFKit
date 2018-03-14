//
//  GOLFHandicapping.m
//  GOLFKit
//
//  Created by John Bishop on 3/6/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "GOLFUtilities.h"
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
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
GOLFHandicapAuthority * const GOLFHandicapAuthorityMulligan		= @"MULLIGAN";
GOLFHandicapAuthority * const GOLFHandicapAuthorityPersonal		= @"PERSONAL";
GOLFHandicapAuthority * const GOLFHandicapAuthoritySecondBest	= @"SECONDBEST";
#endif

static NSArray *cachedGOLFHandicapAuthorities = nil;
static NSDictionary *cachedGOLFHomeCountryInfo = nil;

//=================================================================
//	GOLFDefaultHandicapAuthority()
//=================================================================
GOLFHandicapAuthority * GOLFDefaultHandicapAuthority() {
	if (cachedGOLFHomeCountryInfo == nil) {
		cachedGOLFHomeCountryInfo = GOLFHomeCountryInfo();	//	This might take a bit, so we just get it once
	}
	return [cachedGOLFHomeCountryInfo objectForKey:@"authoritys"];
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

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
  		case GOLFHandicapMethodMulligan:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityMulligan;

  		case GOLFHandicapMethodPersonal:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthorityPersonal;

  		case GOLFHandicapMethodSecondBest:
    		return (GOLFHandicapAuthority *)GOLFHandicapAuthoritySecondBest;
#endif

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
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return GOLFHandicapMethodMulligan;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return GOLFHandicapMethodPersonal;
		} else if ([authority isEqualToString:GOLFHandicapSecondBest]) {
			return GOLFHandicapMethodSecondBest;
#endif
		}
	}
	return GOLFHandicapMethodUSGA;
}

//=================================================================
//	GOLFHandicapCertifiableAuthority(authority)
//=================================================================
BOOL GOLFHandicapCertifiableAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]
				|| [authority isEqualToString:GOLFHandicapAuthorityAGU] || [authority isEqualToString:GOLFHandicapAuthorityCONGU]
				|| [authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			return YES;
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapAuthorities()
//=================================================================
NSArray * GOLFHandicapAuthorities(void) {
	if (cachedGOLFHandicapAuthorities == nil) {
		NSBundle *ourBundle = GOLFKitBundle();
		NSMutableArray *workingArray = [NSMutableArray arrayWithObjects:
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodUSGA], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodUSGA), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodUSGA), @"authorityDisplay",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_ASSOCIATION_USGA", @"GOLFKit", ourBundle, @""), @"association",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_USGA", @"GOLFKit", ourBundle, @""), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodRCGA], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodRCGA), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodRCGA), @"authorityDisplay",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_ASSOCIATION_RCGA", @"GOLFKit", ourBundle, @""), @"association",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_RCGA", @"GOLFKit", ourBundle, @""), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodAGU], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodAGU), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodAGU), @"authorityDisplay",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_ASSOCIATION_AGU", @"GOLFKit", ourBundle, @""), @"association",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_AGU", @"GOLFKit", ourBundle, @""), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodEGA], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodEGA), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodEGA), @"authorityDisplay",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_ASSOCIATION_EGA", @"GOLFKit", ourBundle, @""), @"association",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_EGA", @"GOLFKit", ourBundle, @""), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodCONGU], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodCONGU), @"handicapAuthority",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodCONGU), @"authorityDisplay",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_ASSOCIATION_CONGU", @"GOLFKit", ourBundle, @""), @"association",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_CONGU", @"GOLFKit", ourBundle, @""), @"methodName",
						[NSNumber numberWithBool:YES], @"certifiable",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodWHS], @"methodIndex",
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodWHS), @"handicapAuthority",
						[NSString string], @"authorityDisplay",		//	Temporary?
						NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_WHS", @"GOLFKit", ourBundle, @""), @"association",	//	Temporary?
						NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_WHS", @"GOLFKit", ourBundle, @""), @"methodName",
						nil],
				nil];
		
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodMulligan], @"methodIndex",
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodMulligan), @"handicapAuthority",
					NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_MULLIGAN", @"GOLFKit", ourBundle, @""), @"methodName",
					nil]];
		
		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodPersonal], @"methodIndex",
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodPersonal), @"handicapAuthority",
					NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_PERSONAL", @"GOLFKit", ourBundle, @""), @"methodName",
					nil]];

		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:GOLFHandicapMethodSecondBest], @"methodIndex",
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodSecondBest), @"handicapAuthority",
					NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_2ND_BEST", @"GOLFKit", ourBundle, @""), @"methodName",
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
	return NSLocalizedStringFromTableInBundle(@"HANDICAP_METHOD_UNKNOWN", @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapIndexTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFHandicapIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	switch (handicapMethod) {
  		case GOLFHandicapMethodUSGA:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_INDEX_RTM_PLURAL" : @"TITLE_HANDICAP_INDEX_RTM"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodRCGA:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_FACTOR_PLURAL" : @"TITLE_HANDICAP_FACTOR"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodAGU:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_GA_PLURAL" : @"TITLE_HANDICAP_GA"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodEGA:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_EGA_PLURAL" : @"TITLE_HANDICAP_EGA"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodCONGU:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_EXACT_PLURAL" : @"TITLE_HANDICAP_EXACT"), @"GOLFKit", GOLFKitBundle(), @"");

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
  		case GOLFHandicapMethodMulligan:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_ESTIMATED_PLURAL" : @"TITLE_HANDICAP_ESTIMATED"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodPersonal:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_PERSONAL_PLURAL" : @"TITLE_HANDICAP_PERSONAL"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodSecondBest:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_INDEX_PLURAL" : @"TITLE_HANDICAP_INDEX"), @"GOLFKit", GOLFKitBundle(), @"");
#endif

  		case GOLFHandicapMethodWHS:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_INDEX_PLURAL" : @"TITLE_HANDICAP_INDEX"), @"GOLFKit", GOLFKitBundle(), @"");

  		default:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_PLURAL" : @"TITLE_HANDICAP"), @"GOLFKit", GOLFKitBundle(), @"");
	}
}

//=================================================================
//	GOLFHandicapCurrentIndexTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFHandicapCurrentIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	NSString *titleString = GOLFHandicapIndexTitle(handicapMethod, plural);	//	This and the format string must handle capitalization
	NSString *currentFormat = NSLocalizedStringFromTableInBundle((plural ? @"CURRENT_%@_TITLE_PLURAL" : @"CURRENT_%@_TITLE"), @"GOLFKit", GOLFKitBundle(), @"");
	return [NSString stringWithFormat:currentFormat, titleString];
}

//=================================================================
//	GOLFPlayingHandicapTitle(handicapMethod, plural)
//=================================================================
NSString * GOLFPlayingHandicapTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural) {
	switch (handicapMethod) {
  		case GOLFHandicapMethodUSGA:
     		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_COURSE_TM_PLURAL" : @"TITLE_HANDICAP_COURSE_TM"), @"GOLFKit", GOLFKitBundle(), @"");

 		case GOLFHandicapMethodRCGA:
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
  		case GOLFHandicapMethodSecondBest:
#endif
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_COURSE_PLURAL" : @"TITLE_HANDICAP_COURSE"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodAGU:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_DAILY_PLURAL" : @"TITLE_HANDICAP_DAILY"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodEGA:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_EGA_PLAYING_PLURAL" : @"TITLE_HANDICAP_EGA_PLAYING"), @"GOLFKit", GOLFKitBundle(), @"");

  		case GOLFHandicapMethodCONGU:
  		case GOLFHandicapMethodWHS:
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
  		case GOLFHandicapMethodMulligan:
  		case GOLFHandicapMethodPersonal:
#endif
  		default:
    		return NSLocalizedStringFromTableInBundle((plural ? @"TITLE_HANDICAP_PLAYING_PLURAL" : @"TITLE_HANDICAP_PLAYING"), @"GOLFKit", GOLFKitBundle(), @"");
	}
}

//=================================================================
//	GOLFHandicapAllowanceTitle(handicapMethod)
//=================================================================
NSString * GOLFHandicapAllowanceTitle(GOLFHandicapMethodIndex handicapMethod) {
	return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_ALLOWANCE", @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapAdjustedGrossTitle(handicapMethod)
//=================================================================
NSString * GOLFHandicapAdjustedGrossTitle(GOLFHandicapMethodIndex handicapMethod) {
	return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_ADJUSTED_GROSS", @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapDifferentialTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapDifferentialTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_HANDICAP_DIFFERENTIAL_ABBR" : @"TITLE_HANDICAP_DIFFERENTIAL"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapGradeTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapGradeTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_HANDICAP_GRADE_ABBR" : @"TITLE_HANDICAP_GRADE"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapCCRTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapCCRTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_CCR_ABBR" : @"TITLE_CCR"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapCSSTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapCSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_CSS_ABBR" : @"TITLE_CSS"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapSSSTitle(handicapMethod, abbreviated)
//=================================================================
NSString * GOLFHandicapSSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_SSS_ABBR" : @"TITLE_SSS"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapMaximumNonLocalIndexForAuthority(authority, playerIsFemale, for9Holes)
//=================================================================
GOLFHandicapIndex GOLFHandicapMaximumNonLocalIndexForAuthority(GOLFHandicapAuthority *authority, BOOL playerIsFemale, BOOL for9Holes) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			//	Gender-independent
			return (for9Holes ? 27.0 : 54.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			if (playerIsFemale)
				return (for9Holes ? 20.2 : 40.4);
			else
				return (for9Holes ? 18.2 : 36.4);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			if (playerIsFemale)
				return (for9Holes ? 22.7 : 45.4);
			else
				return (for9Holes ? 18.2 : 36.4);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			if (playerIsFemale)
				return (for9Holes ? 18.0 : 36.0);
			else
				return (for9Holes ? 14.0 : 28.0);
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			//	Gender-independent
			return (for9Holes ? 20.0 : 40.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthoritySecondBest]) {
			if (playerIsFemale)
				return (for9Holes ? 20.0 : 40.0);
			else
				return (for9Holes ? 18.0 : 36.0);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			float max = (playerIsFemale
					? [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHMaximumWomensStandard"] floatValue]
					: [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHMaximumMensStandard"] floatValue]);
			return (for9Holes ? floorf((max * 5.0) + 0.5) / 10.0 : max);
#endif
		}
	}
	return 72.0;
}

//=================================================================
//	GOLFHandicapLocalIndexModifierForAuthority(authority)
//=================================================================
NSString * GOLFHandicapLocalIndexModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			return @"C";	//	"Club"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return @"C";	//	"Club"
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return @"L";	//	"Local"
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
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return @"N";
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
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
	return @"N";
}

//=================================================================
//	GOLFHandicapGradeTitleForAuthority(authority)
//=================================================================
NSString * GOLFHandicapGradeTitleForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_GRADE_ABBR", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA] || [authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_CATEGORY_ABBR", @"GOLFKit", GOLFKitBundle(), @"");
		}
	}
	return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_GRADE_ABBR", @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapExceptionalScoringModifierForAuthority(authority)
//=================================================================
NSString * GOLFHandicapExceptionalScoringModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if (([authority isEqualToString:GOLFHandicapAuthorityUSGA]) || ([authority isEqualToString:GOLFHandicapAuthorityRCGA])) {
			return @"R";	//	"Restricted"
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return @"E";	//	"Exceptional Scoring Reduction"
		}
	}
	return @"R";
}

//=================================================================
//	GOLFRoundModifierTooltip(authority)
//=================================================================
NSString * GOLFRoundModifierTooltip(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_WHS", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_USGA", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_RCGA", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_AGU", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityCONGU]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_CONGU", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_EGA", @"GOLFKit", GOLFKitBundle(), @"");
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_USGA", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_MULLIGAN", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:GOLFHandicapAuthoritySecondBest]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_EGA", @"GOLFKit", GOLFKitBundle(), @"");
#endif
		}
	}
	return @"";
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
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityPersonal]) {
			return NO;
#endif
		}
	}
	return NO;
}

//=================================================================
//	GOLFDoesTournamentAdjustmentForAuthority(authority)
//=================================================================
BOOL GOLFDoesTournamentAdjustmentForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			return YES;
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
			//	CSS-based differential calculation (CSS = Competition Scratch Score) since 2016
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
//	GOLFHandicapDefaultLimitsDifferenceForAuthority(authority)
//=================================================================
GOLFHandicapStrokes GOLFHandicapDefaultLimitsDifferenceForAuthority(GOLFHandicapAuthority *authority) {
	GOLFHandicapStrokes difference = 8;
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
			difference = (NSInteger)8;
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			difference = (NSInteger)8;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			difference = (NSInteger)10;
#endif
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
		} else if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			adjustment = (float)10.0;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:GOLFHandicapAuthorityMulligan]) {
			adjustment = (float)12.0;
#endif
		}
	}
	return adjustment;
}

//=================================================================
//	GOLFHandicapDifferentialsToUseForAuthority(authority, numberOfScores
//=================================================================
NSInteger GOLFHandicapDifferentialsToUseForAuthority(GOLFHandicapAuthority *authority, NSInteger numberOfScores) {
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
		} else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
		
			//	Scores				Differentials
			//	----------------------------------
			//	less than 3			None
			//	3 to 6				Lowest 1
			//	7 or 8				Lowest 2
			//	9 or 10				Lowest 3
			//	11 or 12			Lowest 4
			//	13 or 14			Lowest 5
			//	15 or 16			Lowest 6
			//	17 or 18			Lowest 7
			//	19 or 20			Lowest 8
			
			if (numberOfScores < 3)
				return 0;
			else if (numberOfScores < 7)
				return 1;
			else
				return ((NSInteger)((numberOfScores + 1) / 2) - 2);
		} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
		
			//	Scores				Differentials
			//	----------------------------------
			//	less than 3			None
			//	3 to 6				Lowest 1
			//	7 or 8				Lowest 2
			//	9 or 10				Lowest 3
			//	11 or 12			Lowest 4
			//	13 or 14			Lowest 5
			//	15 or 16			Lowest 6
			//	17 or 18			Lowest 7
			//	19 or 20			Lowest 8
			
			if (numberOfScores < 3)
				return 0;
			else if (numberOfScores < 7)
				return 1;
			else
				return ((NSInteger)((numberOfScores + 1) / 2) - 2);
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
	return numberOfScores;
}

//=================================================================
//	GOLFHandicapExceptionalScoringReductionForAuthority(authority, excessIndex, eligibleScores)
//=================================================================
GOLFHandicapDifferential GOLFHandicapExceptionalScoringReductionForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex excessIndex, NSInteger eligibleScores) {
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityUSGA] || [authority isEqualToString:GOLFHandicapAuthorityRCGA] || [authority isEqualToString:GOLFHandicapAuthorityWHS]) {
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
		}
	}
	return 0.0;
}

//=================================================================
//	GOLFHandicapUnratedSLOPERatingForAuthority(authority)
//=================================================================
GOLFTeeSLOPERating GOLFHandicapUnratedSLOPERatingForAuthority(GOLFHandicapAuthority *authority) {
	return (GOLFTeeSLOPERating)113;
}

//=================================================================
//	GOLFPlayingHandicapFor(authority, handicapIndex, courseRating, slopeRating, par, options, info)
//=================================================================
GOLFPlayingHandicap GOLFPlayingHandicapFor(GOLFHandicapAuthority *authority, GOLFHandicapIndex handicapIndex, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, NSDictionary *info) {

	//	Parameters:
	//	GOLFHandicapAuthority *			authority		required		Handicap authority
	//	GOLFHandicapIndex				handicapIndex	required		18 holes unless GOLFHandicapCalculationOption9HoleIndex (kNotAHandicapIndex is valid)
	//	GOLFTeeCourseRating				courseRating	required		18 holes unless GOLFHandicapCalculationOption9HoleRating (kNotACourseRating is valid)
	//	GOLFTeeSLOPERating				slopeRating		required		18 holes unless GOLFHandicapCalculationOption9HoleSLOPE (kNotASLOPERating is valid)
	//	GOLFPar							par				required		18 holes unless GOLFHandicapCalculationOption9HolePar (kNotAPar is valid)
	//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
	//	NSDictionary *					info			optional		optional NSDictionary
	//
	//	options:
	//	GOLFHandicapCalculationOptionNeed9HoleResult	(1)		Need return of a 9-hole handicap
	//	GOLFHandicapCalculationOptionNeedWomensResult	(2)		Need return of a woman's handicap
	//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFHandicapIndex is for 9 holes
	//	GOLFHandicapCalculationOption9HoleRating		(8)		Provided GOLFTeeCourseRating is for 9 holes
	//	GOLFHandicapCalculationOption9HoleSLOPE			(16)	Provided GOLFTeeSLOPERating is for 9 holes
	//	GOLFHandicapCalculationOption9HolePar			(32)	Provided GOLFPar is for 9 holes
	//
	//	info:
	//	key					type			description
	//	------------------	--------------	-------------------------------------------------------
	//	is9HoleResult		NSNumber *		BOOL indicating result is for 9-hole play
	//	isWomensResult		NSNumber *		BOOL indicating result is for women
	//	referenceObject		id				a <GOLFHandicapDataSource> with data of interest
	//	need9HoleHandicap	NSNumber *		(legacy) BOOL (TRUE --> courseRating and/or par are 9-hole values)
	//	needWomensHandicap	NSNumber *		(legacy) BOOL (TRUE --> courseRating and/or par are women's values)
	//	event				id				(legacy) an event <GOLFHandicapDataSource> with handicap data
	//	roundSide			id				(legacy) a side <GOLFHandicapDataSource> with handicap data
	//	round				id				(legacy) a round <GOLFHandicapDataSource> with handicap data
	//	courseRating		NSNumber *		(legacy) 9 or 18-hole course rating value
	//	par					NSNumber *		(legacy) 9 or 18-hole par

	GOLFPlayingHandicap playingHandicap = kNotAPlayingHandicap;	//	Start with a default return response
	id referenceSource = nil;	//	Assume we don't have a reference source (round, event, competitor, scorecard, etc.)
	BOOL is9HoleResult = NO;
	BOOL isWomensResult = NO;
	
	//	Decide specifically what is needed…
	BOOL need9HoleResult = ((options & GOLFHandicapCalculationOptionNeed9HoleResult) != 0);
	BOOL needWomensResult = ((options & GOLFHandicapCalculationOptionNeedWomensResult) != 0);
	if (info) {
		//	A possible dataSource…
		referenceSource = [info objectForKey:@"referenceObject"];
		
		//	Override of a couple parameter options
		NSNumber *needSomething = [info objectForKey:@"need9HoleHandicap"];
		if (needSomething && [needSomething boolValue]) {
			need9HoleResult = YES;
		}
		needSomething = [info objectForKey:@"needWomensHandicap"];
		if (needSomething && [needSomething boolValue]) {
			needWomensResult = YES;
		}
	}
	
	GOLFHandicapAuthority *localAuthority = (authority ?: [[NSUserDefaults standardUserDefaults] objectForKey:@"LastSelectedHandicapAuthority"]);
	localAuthority = (localAuthority ?: GOLFDefaultHandicapAuthority());
	GOLFHandicapIndex localIndex = handicapIndex;
	BOOL have9HoleIndex = ((options & GOLFHandicapCalculationOption9HoleHandicap) != 0);
	if (referenceSource && [referenceSource respondsToSelector:@selector(handicapIndexForWomen:for9Holes:)]) {
		BOOL for9Holes = need9HoleResult;
		BOOL forWomen = needWomensResult;
		NSNumber *indexValue = [referenceSource handicapIndexForWomen:&forWomen for9Holes:&for9Holes];
		if (indexValue) {
			localIndex = [indexValue floatValue];
			have9HoleIndex = for9Holes;
			isWomensResult = forWomen;
		}
	}
	if (localIndex != kNotAHandicapIndex) {
		//	We've got a handicapIndex, and we'll usually need a SLOPE rating
		GOLFTeeSLOPERating localSlope = slopeRating;
		BOOL have9HoleSlope = ((options & GOLFHandicapCalculationOption9HoleSLOPE) != 0);
		BOOL haveWomensSlope = needWomensResult;
		if (localSlope == kNotASLOPERating) {
			//	The passed-in parameters didn't provide a SLOPE rating - we'll try some dataSources…
			if (referenceSource && [referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
				BOOL for9Holes = need9HoleResult;
				BOOL forWomen = needWomensResult;
				NSNumber *slopeValue = [referenceSource teeSLOPERatingForWomen:&forWomen for9Holes:&for9Holes];
				if (slopeValue) {
					localSlope = [slopeValue integerValue];
					have9HoleSlope = for9Holes;
					haveWomensSlope = forWomen;
				}
				if (localSlope == kNotASLOPERating) {
					id extraSource = [info objectForKey:@"round"];
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"roundSide"];
					}
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"event"];
					}
					if (extraSource && [extraSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
						for9Holes = need9HoleResult;
						forWomen = needWomensResult;
						slopeValue = [extraSource teeSLOPERatingForWomen:&forWomen for9Holes:&for9Holes];
						if (slopeValue) {
							localSlope = [slopeValue integerValue];
							have9HoleSlope = for9Holes;
							haveWomensSlope = forWomen;
						}
					}
				}	//	if (localSlope == kNotASLOPERating)
			}	//	if (referenceSource && [referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)])
			if (localSlope == kNotASLOPERating) {
				localSlope = GOLFHandicapUnratedSLOPERatingForAuthority(authority);	//	Use the unrated tee SLOPE value
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
				NSNumber *ratingValue = [referenceSource teeCourseRatingForWomen:&forWomen for9Holes:&for9Holes];
				if (ratingValue) {
					localRating = [ratingValue floatValue];
					have9HoleRating = for9Holes;
					haveWomensRating = forWomen;
				}
				if (localRating == kNotACourseRating) {
					id extraSource = [info objectForKey:@"round"];
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"roundSide"];
					}
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"event"];
					}
					if (extraSource && [extraSource respondsToSelector:@selector(teeCourseRatingForWomen:for9Holes:)]) {
						for9Holes = need9HoleResult;
						forWomen = needWomensResult;
						ratingValue = [extraSource teeCourseRatingForWomen:&forWomen for9Holes:&for9Holes];
						if (ratingValue) {
							localRating = [ratingValue floatValue];
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
				NSNumber *parValue = [referenceSource teeParForWomen:&forWomen for9Holes:&for9Holes];
				if (parValue) {
					localPar = [parValue integerValue];
					have9HolePar = for9Holes;
					haveWomensPar = forWomen;
				}
				if (localPar == kNotAPar) {
					id extraSource = [info objectForKey:@"round"];
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"roundSide"];
					}
					if (extraSource == nil) {
						extraSource = [info objectForKey:@"event"];
					}
					if (extraSource && [extraSource respondsToSelector:@selector(teeParForWomen:for9Holes:)]) {
						for9Holes = need9HoleResult;
						forWomen = needWomensResult;
						parValue = [extraSource teeParForWomen:&forWomen for9Holes:&for9Holes];
						if (parValue) {
							localPar = [parValue integerValue];
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
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope) / 113.0) + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	9-hole index… need 18-hole courseHandicap…
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope * 2.0) / 113.0) + 0.5);
				is9HoleResult = NO;
			} else {
				//	18-hole index…, need 9-hole courseHandicap…
				float halfIndex = (floorf(((negative ? -localIndex : localIndex) * 5.0) + 0.5) / 10.0);	//	rounded to a tenth
				playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope) / 113.0) + 0.5);
				is9HoleResult = YES;
			}
			
			if (negative || (playingHandicap < 0)) {
				playingHandicap = -playingHandicap;
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			//	RCGA Course Handicap calculation
			BOOL negative = (localIndex < 0.0);	//	Plus handicaps - rounded away from zero (calculate as positive, then re-sign)
			
			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope) / 113.0) + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	9-hole index… need 18-hole courseHandicap…
				playingHandicap = (GOLFPlayingHandicap)floorf((((negative ? -localIndex : localIndex) * localSlope * 2.0) / 113.0) + 0.5);
				is9HoleResult = NO;
			} else {
				//	18-hole index…, need 9-hole courseHandicap…
				float halfIndex = (floorf(((negative ? -localIndex : localIndex) * 5.0) + 0.5) / 10.0);	//	rounded to a tenth
				playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope) / 113.0) + 0.5);
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
				GOLFPlayingHandicap playingHandicapDifferential = GOLFPlayingHandicapFor(localAuthority, 36.0, localRating, localSlope, localPar, localOptions, localInfo) - (need9HoleResult ? 18 : 36);
				playingHandicap = (GOLFPlayingHandicap)floorf(localIndex + playingHandicapDifferential + 0.5);
				is9HoleResult = need9HoleResult;
			} else {
				//	Plus handicaps - rounded toward zero
				float adjust = 0.0;
				if ((localRating != kNotACourseRating) && (localPar != kNotAPar)) {
					//	adjustment is based on rating and par pre-set for proper number of holes
					adjust += localRating - localPar;
				}
				if (have9HoleIndex == need9HoleResult) {
					playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / 113.0) + adjust) + 0.5);
					is9HoleResult = have9HoleIndex;
				} else if (have9HoleIndex) {
					//	requirement is for 18 holes, so we don't double adjustment
					playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / 113.0) * 2.0) + adjust + 0.5);
					is9HoleResult = NO;
				} else {
					//	requirement is for 9 holes, so we don't halve adjustment
					float halfIndex = (floorf((localIndex * 5.0) + 0.5) / 10.0);	//	rounded to a tenth
					playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope / 113.0) + adjust) + 0.5);
					is9HoleResult = YES;
				}
			}
		} else if ([localAuthority isEqualToString:GOLFHandicapAuthorityAGU]) {
			//	Daily handicap is GA handicap * slope / 113
			//	Plus handicaps - rounded toward zero

			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope) / 113.0) + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	9-hole index… need 18-hole courseHandicap…
				playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope * 2.0) / 113.0) + 0.5);
				is9HoleResult = NO;
			} else {
				//	18-hole index…, need 9-hole courseHandicap…
				float halfIndex = (floorf((localIndex * 5.0) + 0.5) / 10.0);	//	rounded to a tenth
				playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope) / 113.0) + 0.5);
				is9HoleResult = YES;
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

			//	Plus handicaps - rounded toward zero
			float adjust = 0.0;
			if ((localRating != kNotACourseRating) && (localPar != kNotAPar)) {
				//	adjustment is based on rating and par pre-set for proper number of holes
				adjust += localRating - localPar;
			}
			if (have9HoleIndex == need9HoleResult) {
				playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / 113.0) + adjust) + 0.5);
				is9HoleResult = have9HoleIndex;
			} else if (have9HoleIndex) {
				//	requirement is for 18 holes, so we don't double adjustment
				playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / 113.0) * 2.0) + adjust + 0.5);
				is9HoleResult = NO;
			} else {
				//	requirement is for 9 holes, so we don't halve adjustment
				float halfIndex = (floorf((localIndex * 5.0) + 0.5) / 10.0);	//	rounded to a tenth
				playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope / 113.0) + adjust) + 0.5);
				is9HoleResult = YES;
			}
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
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
						if ((localRating != kNotACourseRating) && (localPar != kNotAPar)) {
							adjust = localRating - localPar;
						}
						if (have9HoleIndex == need9HoleResult) {
							playingHandicap = (GOLFPlayingHandicap)floorf(localIndex + adjust + 0.5);
							is9HoleResult = have9HoleIndex;
						} else if (have9HoleIndex) {
							playingHandicap = (GOLFPlayingHandicap)floorf((localIndex  * 2.0) + adjust + 0.5);
							is9HoleResult = NO;
						} else {
							float halfIndex = (floorf((localIndex * 5.0) + 0.5) / 10.0);	//	rounded to a tenth
							playingHandicap = (GOLFPlayingHandicap)floorf(halfIndex + adjust + 0.5);
							is9HoleResult = YES;
						}
					}
					break;

				case GOLFPlayingHandicapTypeFullyAdjusted:
					{
						//	Use both slope and rating to adjust the exact handicap…
						float adjust = 0.0;
						if ((localRating != kNotACourseRating) && (localPar != kNotAPar)) {
							adjust = localRating - localPar;
						}
						if (have9HoleIndex == need9HoleResult) {
							playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope) / 113.0) + adjust + 0.5);
							is9HoleResult = have9HoleIndex;
						} else if (have9HoleIndex) {
							playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope * 2.0) / 113.0) + adjust + 0.5);
							is9HoleResult = NO;
						} else {
							float halfIndex = (floorf((localIndex * 5.0) + 0.5) / 10.0);	//	rounded to a tenth
							playingHandicap = (GOLFPlayingHandicap)floorf(((halfIndex * localSlope) / 113.0) + adjust + 0.5);
							is9HoleResult = YES;
						}
					}
					break;

				case GOLFPlayingHandicapTypeSlopeAdjusted:
					//	Playing handicap is exact handicap adjusted from neutral slope…
					if (have9HoleIndex == need9HoleResult) {
						playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope) / 113.0) + 0.5);
						is9HoleResult = have9HoleIndex;
					} else if (have9HoleIndex) {
						playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope * 2.0) / 113.0) + 0.5);
						is9HoleResult = NO;
					} else {
						playingHandicap = (GOLFPlayingHandicap)floorf(((localIndex * localSlope / 2.0) / 113.0) + 0.5);
						is9HoleResult = YES;
					}
					break;

				default:
					break;
			}	//	switch (playingHandicapType)
#endif
		}	//	else if ([localAuthority isEqualToString:GOLFHandicapAuthorityPersonal])
	}	//	if (localIndex != kNotAHandicapIndex)

	//	Update the info dictionary (when we've computed a handicap) with changes or additions…
	if (info && (playingHandicap != kNotAPlayingHandicap) && [info isKindOfClass:[NSMutableDictionary class]]) {
		[(NSMutableDictionary *)info setObject:[NSNumber numberWithBool:is9HoleResult] forKey:@"is9HoleResult"];
		[(NSMutableDictionary *)info setObject:[NSNumber numberWithBool:isWomensResult] forKey:@"isWomensResult"];
	}
	return playingHandicap;
}

//=================================================================
//	GOLFLowHighIndexesAsPointFor(authority, playingHandicap, courseRating, slopeRating, par, options, referenceSource)
//=================================================================
CGPoint GOLFLowHighIndexesAsPointFor(GOLFHandicapAuthority *authority, GOLFPlayingHandicap playingHandicap, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, id <GOLFHandicapDataSource>referenceSource) {

	//	Parameters:
	//	GOLFHandicapAuthority *			authority		required		Handicap authority
	//	GOLFPlayingHandicap				playingHandicap	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAPlayingHandicap is valid)
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

	GOLFHandicapAuthority *localAuthority = authority;
	localAuthority = (localAuthority ?: [[NSUserDefaults standardUserDefaults] objectForKey:@"HandicapAuthority"]);
	BOOL have9HoleHandicap = ((options & GOLFHandicapCalculationOption9HoleHandicap) != 0);
	BOOL need9HoleResult = ((options & GOLFHandicapCalculationOptionNeed9HoleResult) != 0);
	GOLFPlayingHandicap localHandicap = ((have9HoleHandicap == need9HoleResult)
			? playingHandicap
			: (need9HoleResult
					? (GOLFPlayingHandicap)floorf((playingHandicap / 2.0) + 0.5)
					: (playingHandicap * 2)));
	GOLFTeeSLOPERating localSlope = slopeRating;
	BOOL have9HoleSlope = ((options & GOLFHandicapCalculationOption9HoleSLOPE) != 0);
	GOLFTeeCourseRating localRating = courseRating;
	BOOL have9HoleRating = ((options & GOLFHandicapCalculationOption9HoleRating) != 0);
	GOLFPar localPar = par;
	BOOL have9HolePar = ((options & GOLFHandicapCalculationOption9HolePar) != 0);

	//	Even if we've been provided a SLOPE rating - we'll try the dataSource…
	if (referenceSource) {
		BOOL for9Holes = need9HoleResult;
		if ([referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
			NSNumber *slopeValue = [referenceSource teeSLOPERatingForWomen:nil for9Holes:&for9Holes];
			if (slopeValue) {
				localSlope = [slopeValue integerValue];
				have9HoleSlope = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeCourseRatingForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *ratingValue = [referenceSource teeCourseRatingForWomen:nil for9Holes:&for9Holes];
			if (ratingValue) {
				localRating = [ratingValue floatValue];
				have9HoleRating = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeParForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *parValue = [referenceSource teeParForWomen:nil for9Holes:&for9Holes];
			if (parValue) {
				localPar = [parValue integerValue];
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
	
	float minVal;
	float maxVal;
	if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating)) ? 0.0 : (localRating - (GOLFTeeCourseRating)localPar));
		minVal = floor((((float)localHandicap - ratingAdj - 0.5) * 1130.0 / localSlope) + 0.999) / 10.0;
		maxVal = floor((((float)localHandicap - ratingAdj + 0.5) * 1130.0 / localSlope) - 0.001) / 10.0;
	} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating)) ? 0.0 : (localRating - (GOLFTeeCourseRating)localPar));
		minVal = floor((((float)localHandicap - ratingAdj - 0.5) * 1130.0 / localSlope) + 0.999) / 10.0;
		maxVal = floor((((float)localHandicap - ratingAdj + 0.5) * 1130.0 / localSlope) - 0.001) / 10.0;
	} else {
		GOLFPlayingHandicap positiveHdcp = (localHandicap < 0 ? -localHandicap : localHandicap);
		minVal = floor((((float)positiveHdcp - 0.5) * 1130.0 / localSlope) + 0.999) / 10.0;
		maxVal = floor((((float)positiveHdcp + 0.5) * 1130.0 / localSlope) - 0.001) / 10.0;
		if (localHandicap < 0) {
			float tmp = minVal;
			minVal = -maxVal;
			maxVal = -tmp;
		} else if (localHandicap == 0) {
			minVal = -maxVal;
		}
	}
	return CGPointMake(minVal, maxVal);
}

//=================================================================
//	GOLFFirstLocalHandicapForAuthority(authority, limitingIndex, courseRating, slopeRating, par, options, referenceSource)
//=================================================================
GOLFPlayingHandicap GOLFFirstLocalHandicapForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex limitingIndex, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, id <GOLFHandicapDataSource>referenceSource) {

	//	Parameters:
	//	GOLFHandicapAuthority *			authority		required		Handicap authority
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

	GOLFHandicapAuthority *localAuthority = authority;
	localAuthority = (localAuthority ?: [[NSUserDefaults standardUserDefaults] objectForKey:@"HandicapAuthority"]);
	BOOL have9HoleHandicap = ((options & GOLFHandicapCalculationOption9HoleHandicap) != 0);
	BOOL need9HoleResult = ((options & GOLFHandicapCalculationOptionNeed9HoleResult) != 0);
	GOLFHandicapIndex localLimit = ((have9HoleHandicap == need9HoleResult)
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

	//	Even if we've been provided a SLOPE rating - we'll try the dataSource…
	if (referenceSource) {
		BOOL for9Holes = need9HoleResult;
		if ([referenceSource respondsToSelector:@selector(teeSLOPERatingForWomen:for9Holes:)]) {
			NSNumber *slopeValue = [referenceSource teeSLOPERatingForWomen:nil for9Holes:&for9Holes];
			if (slopeValue) {
				localSlope = [slopeValue integerValue];
				have9HoleSlope = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeCourseRatingForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *ratingValue = [referenceSource teeCourseRatingForWomen:nil for9Holes:&for9Holes];
			if (ratingValue) {
				localRating = [ratingValue floatValue];
				have9HoleRating = for9Holes;
			}
		}
		if ([referenceSource respondsToSelector:@selector(teeParForWomen:for9Holes:)]) {
			for9Holes = need9HoleResult;
			NSNumber *parValue = [referenceSource teeParForWomen:nil for9Holes:&for9Holes];
			if (parValue) {
				localPar = [parValue integerValue];
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

	if ([authority isEqualToString:GOLFHandicapAuthorityEGA]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating)) ? 0.0 : (localRating - (GOLFTeeCourseRating)localPar));
		return (GOLFPlayingHandicap)floor((((localLimit + 0.1) * localSlope) / 113.0) + ratingAdj + 0.5);
	} else if ([authority isEqualToString:GOLFHandicapAuthorityWHS]) {
		GOLFTeeCourseRating ratingAdj = (((localPar == kNotAPar) || (localRating == kNotACourseRating)) ? 0.0 : (localRating - (GOLFTeeCourseRating)localPar));
		return (GOLFPlayingHandicap)floor((((localLimit + 0.1) * localSlope) / 113.0) + ratingAdj + 0.5);
	} else {
		return (GOLFPlayingHandicap)floor((((localLimit + 0.1) * localSlope) / 113.0) + 0.5);
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
			return (GOLFHandicapGrade)kNotAGrade;
	}
	return (GOLFHandicapGrade)kNotAGrade;
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

