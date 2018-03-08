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

//=================================================================
//	GOLFHandicapAuthorityFromMethodIndex
//=================================================================
GOLFHandicapAuthority * GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodIndex methodIndex) {
	switch (methodIndex) {
  		case GOLFHandicapMethodUSGA:
    		return (GOLFHandicapAuthority *)@"USGA";

  		case GOLFHandicapMethodRCGA:
    		return (GOLFHandicapAuthority *)@"RCGA";

  		case GOLFHandicapMethodAGU:
    		return (GOLFHandicapAuthority *)@"AGU";

  		case GOLFHandicapMethodEGA:
    		return (GOLFHandicapAuthority *)@"EGA";

  		case GOLFHandicapMethodCONGU:
    		return (GOLFHandicapAuthority *)@"CONGU";

  		case GOLFHandicapMethodWHS:
    		return (GOLFHandicapAuthority *)@"WHS";

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
  		case GOLFHandicapMethodMulligan:
    		return (GOLFHandicapAuthority *)@"MULLIGAN";

  		case GOLFHandicapMethodPersonal:
    		return (GOLFHandicapAuthority *)@"PERSONAL";

  		case GOLFHandicapMethodSecondBest:
    		return (GOLFHandicapAuthority *)@"SECONDBEST";
#endif

  		case GOLFHandicapMethodNone:
  		case GOLFHandicapMethodUnknown:
  		default:
    		return nil;
	}	//	switch (methodIndex)
}

//=================================================================
//	GOLFHandicapBestMethodIndexFromAuthority
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
//	GOLFHandicapCertifiableAuthority
//=================================================================
BOOL GOLFHandicapCertifiableAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:@"USGA"] || [authority isEqualToString:@"RCGA"]
				|| [authority isEqualToString:@"AGU"] || [authority isEqualToString:@"CONGU"]
				|| [authority isEqualToString:@"EGA"]) {
			return YES;
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapAuthorities
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
//	GOLFHandicapMethodNameForAuthority
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
//	GOLFHandicapIndexTitle
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
//	GOLFPlayingHandicapTitle
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
    		return NSLocalizedStringFromTableInBundle((plural ? @"PLAYING_HANDICAPS_TITLE" : @"PLAYING_HANDICAP_TITLE"), @"GOLFKit", GOLFKitBundle(), @"");
	}
}

//=================================================================
//	GOLFHandicapAllowanceTitle
//=================================================================
NSString * GOLFHandicapAllowanceTitle(GOLFHandicapMethodIndex handicapMethod) {
	return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_ALLOWANCE", @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapAdjustedGrossTitle
//=================================================================
NSString * GOLFHandicapAdjustedGrossTitle(GOLFHandicapMethodIndex handicapMethod) {
	return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_ADJUSTED_GROSS", @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapDifferentialTitle
//=================================================================
NSString * GOLFHandicapDifferentialTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_HANDICAP_DIFFERENTIAL_ABBR" : @"TITLE_HANDICAP_DIFFERENTIAL"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapGradeTitle
//=================================================================
NSString * GOLFHandicapGradeTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_HANDICAP_GRADE_ABBR" : @"TITLE_HANDICAP_GRADE"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapCCRTitle
//=================================================================
NSString * GOLFHandicapCCRTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_CCR_ABBR" : @"TITLE_CCR"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapCSSTitle
//=================================================================
NSString * GOLFHandicapCSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_CSS_ABBR" : @"TITLE_CSS"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapSSSTitle
//=================================================================
NSString * GOLFHandicapSSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated) {
	return NSLocalizedStringFromTableInBundle((abbreviated ? @"TITLE_SSS_ABBR" : @"TITLE_SSS"), @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapMaximumNonLocalIndexForAuthority
//=================================================================
GOLFHandicapIndex GOLFHandicapMaximumNonLocalIndexForAuthority(GOLFHandicapAuthority *authority, BOOL playerIsFemale, BOOL for9Holes) {
	if (authority) {
		if ([authority isEqualToString:@"WHS"] || [authority isEqualToString:@"EGA"]) {
			//	Gender-independent
			return (for9Holes ? 27.0 : 54.0);
		} else if ([authority isEqualToString:@"USGA"] || [authority isEqualToString:@"RCGA"]) {
			if (playerIsFemale)
				return (for9Holes ? 20.2 : 40.4);
			else
				return (for9Holes ? 18.2 : 36.4);
		} else if ([authority isEqualToString:@"AGU"]) {
			if (playerIsFemale)
				return (for9Holes ? 22.7 : 45.4);
			else
				return (for9Holes ? 18.2 : 36.4);
		} else if ([authority isEqualToString:@"CONGU"]) {
			if (playerIsFemale)
				return (for9Holes ? 18.0 : 36.0);
			else
				return (for9Holes ? 14.0 : 28.0);
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"MULLIGAN"]) {
			//	Gender-independent
			return (for9Holes ? 20.0 : 40.0);
		} else if ([authority isEqualToString:@"SECONDBEST"]) {
			if (playerIsFemale)
				return (for9Holes ? 20.0 : 40.0);
			else
				return (for9Holes ? 18.0 : 36.0);
		} else if ([authority isEqualToString:@"PERSONAL"]) {
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
//	GOLFHandicapLocalIndexModifierForAuthority
//=================================================================
NSString * GOLFHandicapLocalIndexModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:@"WHS"]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:@"USGA"] || [authority isEqualToString:@"RCGA"]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:@"AGU"]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:@"EGA"]) {
			return @"C";	//	"Club"
		} else if ([authority isEqualToString:@"CONGU"]) {
			return @"C";	//	"Club"
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"MULLIGAN"]) {
			return @"L";	//	"Local"
		} else if ([authority isEqualToString:@"PERSONAL"]) {
			return [[NSUserDefaults standardUserDefaults] objectForKey:@"PHNonStandardModifier"];
#endif
		}
	}
	return @"C";
}

//=================================================================
//	GOLFHandicapNineHoleModifierForAuthority
//=================================================================
NSString * GOLFHandicapNineHoleModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:@"WHS"]) {
			return @"N";
		} else if ([authority isEqualToString:@"USGA"] || [authority isEqualToString:@"RCGA"]) {
			return @"N";
		} else if ([authority isEqualToString:@"EGA"]) {
			return @"N";
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"MULLIGAN"]) {
			return @"N";
		} else if ([authority isEqualToString:@"PERSONAL"]) {
			return @"N";
#endif
		}
	}
	return @"N";
}

//=================================================================
//	GOLFHandicapGradeTitleForAuthority
//=================================================================
NSString * GOLFHandicapGradeTitleForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:@"WHS"]) {
			return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_GRADE_ABBR", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"EGA"] || [authority isEqualToString:@"CONGU"]) {
			return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_CATEGORY_ABBR", @"GOLFKit", GOLFKitBundle(), @"");
		}
	}
	return NSLocalizedStringFromTableInBundle(@"TITLE_HANDICAP_GRADE_ABBR", @"GOLFKit", GOLFKitBundle(), @"");
}

//=================================================================
//	GOLFHandicapExceptionalScoringModifierForAuthority
//=================================================================
NSString * GOLFHandicapExceptionalScoringModifierForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if (([authority isEqualToString:@"USGA"]) || ([authority isEqualToString:@"RCGA"])) {
			return @"R";	//	"Restricted"
		} else if ([authority isEqualToString:@"CONGU"]) {
			return @"E";	//	"Exceptional Scoring Reduction"
		}
	}
	return @"R";
}

//=================================================================
//	GOLFRoundModifierTooltip
//=================================================================
NSString * GOLFRoundModifierTooltip(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:@"WHS"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_WHS", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"USGA"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_USGA", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"RCGA"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_RCGA", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"AGU"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_AGU", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"CONGU"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_CONGU", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"EGA"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_EGA", @"GOLFKit", GOLFKitBundle(), @"");
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"PERSONAL"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_USGA", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"MULLIGAN"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_MULLIGAN", @"GOLFKit", GOLFKitBundle(), @"");
		} else if ([authority isEqualToString:@"SECONDBEST"]) {
			return NSLocalizedStringFromTableInBundle(@"TOOLTIP_ROUNDS_MODIFIER_EGA", @"GOLFKit", GOLFKitBundle(), @"");
#endif
		}
	}
	return @"";
}

//=================================================================
//	GOLFHandicapStablefordRequiredForAuthority
//=================================================================
BOOL GOLFHandicapStablefordRequiredForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:@"EGA"]) {
			//	Stableford-based handicap computations
			return YES;
		} else if ([authority isEqualToString:@"AGU"]) {
			return NO;	//	Since Sep 2011
		} else if ([authority isEqualToString:@"CONGU"]) {
			return YES;	//	Since 2016
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"PERSONAL"]) {
			return NO;
#endif
		}
	}
	return NO;
}

//=================================================================
//	GOLFDoesTournamentAdjustmentForAuthority
//=================================================================
BOOL GOLFDoesTournamentAdjustmentForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		if ([authority isEqualToString:@"WHS"]) {
			return YES;
		} else if ([authority isEqualToString:@"USGA"]) {
			return YES;
		} else if ([authority isEqualToString:@"RCGA"]) {
			return YES;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"PERSONAL"]) {
			return [[[NSUserDefaults standardUserDefaults] objectForKey:@"PHFlagTournamentScores"] boolValue];
#endif
		}
	}
	return NO;
}

//=================================================================
//	GOLFHandicapCCRUsedForAuthority
//=================================================================
BOOL GOLFHandicapCCRUsedForAuthority(GOLFHandicapAuthority *authority, BOOL *required) {
	if (authority) {
		if ([authority isEqualToString:@"AGU"]) {
			//	CSS-based differential calculation (CSS = Competition Scratch Score) since 2016
			if (required) {
				*required = NO;
			}
			return YES;
		} else if ([authority isEqualToString:@"CONGU"]) {
			//	CSS-based differential calculation (CSS = Competition Scratch Score)
			if (required) {
				*required = YES;	//	Calculation must return CSS, SSS or par
			}
			return YES;
		} else if ([authority isEqualToString:@"EGA"]) {
			//	Buffer (threshold) adjustment (CBA = Computed Buffer Adjustment)
			if (required) {
				*required = NO;	//	Although default value is zero
			}
			return YES;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"PERSONAL"]) {
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
//	GOLFHandicapDefaultLimitsDifferenceForAuthority
//=================================================================
GOLFHandicapStrokes GOLFHandicapDefaultLimitsDifferenceForAuthority(GOLFHandicapAuthority *authority) {
	GOLFHandicapStrokes difference = 8;
	if (authority) {
		if ([authority isEqualToString:@"WHS"]) {
			difference = (NSInteger)8;
		} else if ([authority isEqualToString:@"USGA"]) {
			difference = (NSInteger)8;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"MULLIGAN"]) {
			difference = (NSInteger)10;
#endif
		}
	}
	return difference;
}

//=================================================================
//	GOLFHandicapDefaultLimitsPctAdjForAuthority
//=================================================================
float GOLFHandicapDefaultLimitsPctAdjForAuthority(GOLFHandicapAuthority *authority) {
	float adjustment = 10.0;
	if (authority) {
		if ([authority isEqualToString:@"WHS"]) {
			adjustment = (float)10.0;
		} else if ([authority isEqualToString:@"USGA"]) {
			adjustment = (float)10.0;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		} else if ([authority isEqualToString:@"MULLIGAN"]) {
			adjustment = (float)12.0;
#endif
		}
	}
	return adjustment;
}

//=================================================================
//	GOLFHandicapDifferentialsToUseForAuthority
//=================================================================
NSInteger GOLFHandicapDifferentialsToUseForAuthority(GOLFHandicapAuthority *authority, NSInteger numberOfScores) {
	if (authority) {
		if ([authority isEqualToString:@"USGA"] || [authority isEqualToString:@"RCGA"]) {
		
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
		} else if ([authority isEqualToString:@"AGU"]) {
		
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
		} else if ([authority isEqualToString:@"WHS"]) {
		
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
		} else if ([authority isEqualToString:@"PERSONAL"]) {
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
//	GOLFHandicapExceptionalScoringReductionForAuthority
//=================================================================
GOLFHandicapDifferential GOLFHandicapExceptionalScoringReductionForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex excessIndex, NSInteger eligibleScores) {
	if (authority) {
		if ([authority isEqualToString:@"USGA"] || [authority isEqualToString:@"RCGA"] || [authority isEqualToString:@"WHS"]) {
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

