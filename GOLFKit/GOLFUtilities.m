//
//  GOLFUtilities.m
//  GOLFKit
//
//  Created by John Bishop on 3/7/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
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
	return country;
}

//=================================================================
//	GOLFMonthAbbreviationString
//	something like: "JFMAMJJASOND"
//=================================================================
NSString * GOLFMonthAbbreviationString(void) {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
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
//	GOLFHomeCountryInfo
//=================================================================
NSDictionary * GOLFHomeCountryInfo(void) {
	//	Returns localized home country information from GOLFCountries.plist
	
	//	Key				Type					Description
	//	-------------	---------------------	--------------------------------------------
	//	countryCode		NSString *				Country code from locale date on this device
	//	countryName		NSString *				The localized name of the country
	//	association		NSString *				The name of the country's golf association
	//	URL				NSString *				The URL of the golf association
	//	authority		GOLFHandicapAuthority	The default golf authority for handicapping in this country
	
	NSLocale *ourLocale = [NSLocale autoupdatingCurrentLocale];
	NSString *countryCode = ourLocale.countryCode;
	NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:[GOLFKitBundle() pathForResource:@"GOLFCountries" ofType:@"plist"]];
	NSMutableDictionary *workingDict = [[rootDict objectForKey:countryCode] mutableCopy];
	NSString *countryName = [workingDict objectForKey:@"countryName"];	//	Pick it up (might be nil)
	GOLFHandicapAuthority * authority = [workingDict objectForKey:@"authority"];
	if (workingDict == nil) {
		workingDict = [[rootDict objectForKey:@"US"] mutableCopy];
	}
	
	[workingDict setObject:countryCode forKey:@"countryCode"];	//	In case we need to diagnose a missing country code
	
	if (countryName) {
		countryName = NSLocalizedStringFromTableInBundle(countryName, @"GOLFKit", GOLFKitBundle(), @"");	//	Localize the country name
	}
	countryName = (countryName ?: [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeCountry"]);	//	From manual setting, if any (already localized)
	[workingDict setObject:countryName forKey:@"countryName"];	//	Replace with our best version of countryName

	authority = (authority ?: @"USGA");
	[workingDict setObject:@"authority" forKey:authority];	//	Replace with the best version of authority
	
	return [NSDictionary dictionaryWithDictionary:workingDict];
}

#pragma mark NSStringFrom… Utilities

//=================================================================
//	NSStringFromPlayingHandicap(playingHandicap)
//=================================================================
NSString * NSStringFromPlayingHandicap(GOLFPlayingHandicap playingHandicap) {
	if (playingHandicap == kNotAPlayingHandicap) {
		return @"kNotAPlayingHandicap";
	} else {
		return [NSString stringWithFormat:@"%ld", (long)playingHandicap];
	}
}

//=================================================================
//	NSStringFromHandicapIndex(handicapIndex)
//=================================================================
NSString * NSStringFromHandicapIndex(GOLFHandicapIndex handicapIndex) {
	if (handicapIndex == kNotAHandicapIndex) {
		return @"kNotAHandicapIndex";
	} else {
		return [NSString stringWithFormat:@"%1.1f", handicapIndex];
	}
}


