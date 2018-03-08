//
//  GOLFUtilities.m
//  GOLFKit
//
//  Created by John Bishop on 3/7/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFUtilities.h"

//=================================================================
//	GOLFUnlocalizedCurrentCountry
//=================================================================
NSString * GOLFUnlocalizedCurrentCountry(void) {
	NSString *country = @"United States";
	NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	NSString *displayNameString = [usLocale displayNameForKey:NSLocaleIdentifier value:[[NSLocale currentLocale] localeIdentifier]];	//	Result is like: "French (Canada)", unlocalized
	NSRange found = [displayNameString rangeOfString:@"(" options:NSLiteralSearch];
	if (found.location != NSNotFound) {
		country = [displayNameString substringWithRange:NSMakeRange(found.location + 1, [displayNameString length] - found.location - 2)];
	}
//#ifdef DEBUG
//	NSLog(@"UnlocalizedCurrentCountry() returns: %@", country);
//#endif
	return country;
}

//=================================================================
//	GOLFMonthAbbreviationString
//	something like: "JFMAMJJASOND"
//=================================================================
NSString * GOLFMonthAbbreviationString(void) {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] ah_autorelease];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setLocale:[NSLocale currentLocale]];	//	Set us up for the user's locale
	NSString *returnString = [NSString string];	//	Start empty
	NSRange firstCharRange = NSMakeRange(0,1);	//	First character range specifier
	for (NSString *monthAbbr in [dateFormatter veryShortStandaloneMonthSymbols]) {
		returnString = [returnString stringByAppendingString:[monthAbbr substringWithRange:firstCharRange]];
	}
	return returnString;
}

//=================================================================
//	HomeCountry
//=================================================================
//NSString * HomeCountry(void) {
//	NSString *bestCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeCountry"];
//	if (bestCountry == nil)
//		bestCountry = NSLocalizedStringFromTableInBundle(UnlocalizedCurrentCountry(), @"GOLFKit", ourBundle, @"");
//#ifdef DEBUG
//	NSLog(@"HomeCountry() returns: %@", bestCountry);
//#endif
//	return bestCountry;
//}


