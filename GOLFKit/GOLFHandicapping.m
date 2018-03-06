//
//  GOLFHandicapping.m
//  GOLFKit
//
//  Created by John Bishop on 3/6/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "GOLFHandicapping.h"

//	Globals
static NSArray *cachedGOLFHandicapAuthorities = nil;

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
//	GOLFHandicapAuthorities
//=================================================================
NSArray * GOLFHandicapAuthorities(void) {
	if (cachedGOLFHandicapAuthorities == nil) {
		NSBundle *ourBundle = GOLFKitBundle();
		NSMutableArray *workingArray = [NSMutableArray arrayWithObjects:
				[NSDictionary dictionaryWithObjectsAndKeys:
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodUSGA), @"authority",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_USGA", @"GOLFKit", ourBundle, @""), @"methodName",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodRCGA), @"authority",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_RCGA", @"GOLFKit", ourBundle, @""), @"methodName",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodAGU), @"authority",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_AGU", @"GOLFKit", ourBundle, @""), @"methodName",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodEGA), @"authority",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_EGA", @"GOLFKit", ourBundle, @""), @"methodName",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodCONGU), @"authority",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_CONGU", @"GOLFKit", ourBundle, @""), @"methodName",
						nil],
				[NSDictionary dictionaryWithObjectsAndKeys:
						GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodWHS), @"authority",
						NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_WHS", @"GOLFKit", ourBundle, @""), @"methodName",
						nil],
				nil];
		
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodMulligan), @"authority",
					NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_MULLIGAN", @"GOLFKit", ourBundle, @""), @"methodName",
					nil]];
		
		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodPersonal), @"authority",
					NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_PERSONAL", @"GOLFKit", ourBundle, @""), @"methodName",
					nil]];

		[workingArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
					GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodSecondBest), @"authority",
					NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_2ND_BEST", @"GOLFKit", ourBundle, @""), @"methodName",
					nil]];
#endif

		cachedGOLFHandicapAuthorities = [NSArray arrayWithArray:workingArray];
	}	//	if (cachedGOLFHandicapAuthorities == nil)
	return [cachedGOLFHandicapAuthorities copy];
}

NSString * GOLFHandicapMethodNameForAuthority(GOLFHandicapAuthority *authority) {
	if (authority) {
		for (NSDictionary *authorityDict in GOLFHandicapAuthorities()) {
			if ([authority isEqualToString:[authorityDict objectForKey:@"authority"]])
				return [authorityDict objectForKey:@"methodName"];
		}
	}
	return NSLocalizedStringFromTableInBundle(@"HANDICAP_SYSTEM_UNKNOWN", @"GOLFKit", GOLFKitBundle(), @"");
}

