//
//  GOLFUtilities.m
//  GOLFKit
//
//  Created by John Bishop on 3/7/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "GOLFUtilities.h"
#import "GOLFHandicapping.h"
#import "GOLFHandicapLookup.h"

//	External constants
NSString * const GOLFLocalizedStringNotFound = @"*-*";

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
//	GOLFCountriesInfo()
//=================================================================
NSDictionary * GOLFCountriesInfo(void) {
	//	Returns the entire GOLFCountries.plist
	//	Each country dictionary is indexed by its universal country code (US, UK, JP, etc.) or sub-code (UK-EN, UK-SC, etc.)
	//	Key				Type						Description
	//	-------------	-------------------------	------------------------------------------
	//	countryCode		NSString *					Universal country postal code or sub-code
	//	countryName		NSString *					unlocalized (en) country name
	//	authority		GOLFHandicapAuthority *		Handicapping authority mnemonic
	//	association		NSString *					Localized name of the national golf association
	//	URL				NSString *					Web site URL of national golf association
	
	return [NSDictionary dictionaryWithContentsOfFile:[GOLFKitBundle() pathForResource:@"GOLFCountries" ofType:@"plist"]];
}

//=================================================================
//	GOLFCountriesInfoForCountryCode(countryCode)
//=================================================================
NSDictionary * GOLFCountriesInfoForCountryCode(NSString *countryCode) {
	//	Returns localized country information from GOLFCountries.plist
	//	Returns US info (without states) if country code isn't found
	
	//	Key				Type						Description
	//	-------------	-------------------------	--------------------------------------------
	//	countryCode		NSString *					Country code from locale date on this device
	//	countryName		NSString *					The localized name of the country
	//	association		NSString *					The name of the country's golf association
	//	URL				NSString *					The URL of the golf association
	//	authority		GOLFHandicapAuthority *		The default golf authority for handicapping in this country
	//	states			NSArray *					Optional array of states dictionaries for this country - postalCode, stateName
	
//	NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:[GOLFKitBundle() pathForResource:@"GOLFCountries" ofType:@"plist"]];
	NSDictionary *rootDict = GOLFCountriesInfo();
	NSMutableDictionary *workingDict = (rootDict ? [[rootDict objectForKey:countryCode] mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:6]);
	BOOL returnStates = YES;	//	Include the 'states' part of the country dictionary
	NSString *countryName = [workingDict objectForKey:@"countryName"];	//	Pick it up (might be nil)
	GOLFHandicapAuthority * authority = [workingDict objectForKey:@"authority"];
	if (workingDict == nil) {
		workingDict = [[rootDict objectForKey:@"US"] mutableCopy];
		returnStates = NO;
	}
	
	[workingDict setObject:countryCode forKey:@"countryCode"];	//	In case we need to diagnose a missing country code
	
	if (countryName) {
		//	Best… a localized version of the country name (otherwise, unlocalized)
		countryName = GOLFLocalizedString(countryName);
	} else {
		//	Without one, use the home country default, if available
		countryName = [[NSUserDefaults standardUserDefaults] objectForKey:@"HomeCountry"];
		if (countryName == nil) {
			//	Worst… "Unknown"
			countryName = [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
		}
	}
	[workingDict setObject:countryName forKey:@"countryName"];	//	Replace with our best version of countryName

	authority = (authority ?: GOLFHandicapAuthorityUSGA);
	[workingDict setObject:@"authority" forKey:authority];	//	Replace with the best version of authority
	
	//	Peel off the states part of the dictionary if requested…
	if (!returnStates) {
		[workingDict removeObjectForKey:@"states"];
	}
	
	return [NSDictionary dictionaryWithDictionary:workingDict];
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
	//	states			NSArray *				Optional array of states dictionaries for this country - postalCode, stateName
	
	NSLocale *ourLocale = [NSLocale autoupdatingCurrentLocale];
//	NSString *countryCode = @"US";
	NSString *countryCode = ourLocale.countryCode;
//	if (@available(macOS 10.12, iOS 10.0, *)) {
//		countryCode = ourLocale.countryCode;
//	} else {
//		NSDictionary *localeDict = [NSLocale componentsFromLocaleIdentifier:[ourLocale localeIdentifier]];
//		countryCode = [localeDict objectForKey:NSLocaleCountryCode];
//	}
	
	return GOLFCountriesInfoForCountryCode(countryCode);
}

NSString * GOLFLocalizedString(NSString *key) {
	if (key && (key.length > 0)) {
		//	[NSBundle localizedStringForKey:key value:value table:table] returns the following when key is nil or not found in table:
		//	•	If key is nil and value is nil, returns an empty string.	(We simply return nil or zero-length key)
		//	•	If key is nil and value is non-nil, returns value.
		//	•	If key is not found and value is nil or an empty string, returns key.
		//	•	If key is not found and value is non-nil and not empty, return value.	(our technique looking to 2 places)
		
		NSString *notFound = GOLFLocalizedStringNotFound;
		NSString *prospectiveLocalization = [GOLFKitBundle() localizedStringForKey:key value:notFound table:@"GOLFKit"];
		if (![prospectiveLocalization isEqualToString:notFound]) { return prospectiveLocalization; }
		prospectiveLocalization = [[NSBundle mainBundle] localizedStringForKey:key value:notFound table:@"Localizable"];
		if (![prospectiveLocalization isEqualToString:notFound]) { return prospectiveLocalization; }
		
		//	We didn't find a localization…
#ifdef DEBUG
		NSLog(@"GOLFLocalizedString() can't localize: \"%@\"", key);
#endif
	}
	return key;
}

GOLFImage * GOLFImageWithName(NSString *imageName) {
	GOLFImage *prospectiveImage = nil;
	if (imageName && (imageName.length > 0)) {
		NSBundle *ourBundle = GOLFKitBundle();
#if TARGET_OS_IOS || TARGET_OS_WATCH
		//	imageName should include file extension, except for PNG images
		prospectiveImage = [GOLFImage imageNamed:imageName inBundle:ourBundle compatibleWithTraitCollection:nil];
		if (prospectiveImage == nil) {
			prospectiveImage = [GOLFImage imageNamed:imageName inBundle:nil compatibleWithTraitCollection:nil];	//	nil NSBundle searches main bundle
		}
		if (prospectiveImage == nil) {
	#ifdef DEBUG
		NSLog(@"GOLFImageWithName() can't find UIImage named: \"%@\"", imageName);
	#endif
		}
#elif TARGET_OS_MAC
		prospectiveImage = [ourBundle imageForResource:imageName];
		if (prospectiveImage == nil) {
			prospectiveImage = [[NSBundle mainBundle] imageForResource:imageName];
		}
		if (prospectiveImage == nil) {
	#ifdef DEBUG
		NSLog(@"GOLFImageWithName() can't find NSImage named: \"%@\"", imageName);
	#endif
		}
#endif
	}
	return prospectiveImage;
}

#pragma mark NSStringFrom… Utilities

//=================================================================
//	NSStringFromDragAndDropDelimiterType(delimiterType)
//=================================================================
NSString * NSStringFromDragAndDropDelimiterType(GOLFDragAndDropDelimiterType delimiterType) {
	switch (delimiterType) {
		case GOLFDragAndDropDelimiterTypeTab:
			return GOLFLocalizedString(@"TERM_TAB_DELIMITED");
			
		case GOLFDragAndDropDelimiterTypeComma:
			return GOLFLocalizedString(@"TERM_COMMA_SEPARATED");
			
		case GOLFDragAndDropDelimiterTypeSemicolon:
			return GOLFLocalizedString(@"TERM_SEMICOLON_SEPARATED");
			
		case GOLFDragAndDropDelimiterTypeUnknown:
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
			
		default:
			return [GOLFLocalizedString(@"TERM_ERROR") capitalizedString];
	}
}

//=================================================================
//	NSStringFromPlayingHandicap(playingHandicap)
//=================================================================
NSString * NSStringFromPlayingHandicap(GOLFPlayingHandicap playingHandicap) {
	if (playingHandicap == kNotAPlayingHandicap) {
		return @"kNotAPlayingHandicap";
	} else if (playingHandicap < 0) {
		return [NSString stringWithFormat:@"+%ld", (long)-playingHandicap];
	} else {
		return [NSString stringWithFormat:@"%ld", (long)playingHandicap];
	}
}

//=================================================================
//	NSStringFromUnroundedPlayingHandicap(unroundedPlayingHandicap)
//=================================================================
NSString * NSStringFromUnroundedPlayingHandicap(GOLFUnroundedPlayingHandicap unroundedPlayingHandicap) {
	if (unroundedPlayingHandicap == kNotAnUnroundedPlayingHandicap) {
		return @"kNotAnUnroundedPlayingHandicap";
	} else if (unroundedPlayingHandicap < 0.0) {
		return [NSString stringWithFormat:@"+%1.2f", -unroundedPlayingHandicap];
	} else {
		return [NSString stringWithFormat:@"%1.2f", unroundedPlayingHandicap];
	}
}

//=================================================================
//	NSStringFromHandicapIndex(handicapIndex)
//=================================================================
NSString * NSStringFromHandicapIndex(GOLFHandicapIndex handicapIndex) {
	if (handicapIndex == kNotAHandicapIndex) {
		return @"kNotAHandicapIndex";
	} else if (handicapIndex >= 0.0) {
		return [NSString localizedStringWithFormat:@"%1.1f", handicapIndex];
	} else {
		return [NSString localizedStringWithFormat:@"+%1.1f", -handicapIndex];
	}
}

//=================================================================
//	NSStringFromHandicapAllowance(handicapAllowance)
//=================================================================
NSString * NSStringFromHandicapAllowance(GOLFHandicapAllowance handicapAllowance) {
	if (handicapAllowance == kNotAHandicapAllowance) {
		return @"kNotAHandicapAllowance";
	} else {
		return [NSString stringWithFormat:@"%1.1f", handicapAllowance];
	}
}

//=================================================================
//	NSStringForClickOrTap()
//=================================================================
NSString * NSStringForClickOrTap(void) {
	//	returns localized 'click' or 'tap'
#if TARGET_OS_IOS || TARGET_OS_WATCH
	return GOLFLocalizedString(@"TERM_TAP");
#elif TARGET_OS_MAC
	return GOLFLocalizedString(@"TERM_CLICK");
#endif

	//	Huh?
	return GOLFLocalizedString(@"TERM_INDICATE");
}

//=================================================================
//	NSStringFromNSComparisonResult(result)
//=================================================================
NSString * NSStringFromNSComparisonResult(NSComparisonResult result) {
	switch (result) {
		case NSOrderedSame:
			return @"NSOrderedSame";
		case NSOrderedAscending:
			return @"NSOrderedAscending";
		case NSOrderedDescending:
			return @"NSOrderedDescending";
		default:
			return @"";
    }
}

//=================================================================
//	NSStringFromNSStringEncoding(encoding)
//=================================================================
NSString * NSStringFromNSStringEncoding(NSStringEncoding encoding) {
	switch(encoding) {
		case NSASCIIStringEncoding:
			return @"ASCII";
			
		case NSNEXTSTEPStringEncoding:
			return @"NEXTSTEP";
			
		case NSJapaneseEUCStringEncoding:
			return @"JapaneseEUC";
			
		case NSUTF8StringEncoding:
			return @"UTF8";
			
		case NSISOLatin1StringEncoding:
			return @"ISOLatin1";
			
		case NSSymbolStringEncoding:
			return @"Symbol";
			
		case NSNonLossyASCIIStringEncoding:
			return @"NonLossyASCII";
			
		case NSShiftJISStringEncoding:
			return @"ShiftJIS";
			
		case NSISOLatin2StringEncoding:
			return @"ISOLatin2";
			
		case NSWindowsCP1251StringEncoding:
			return @"WindowsCP1251";
			
		case NSWindowsCP1252StringEncoding:
			return @"WindowsCP1252";
			
		case NSWindowsCP1253StringEncoding:
			return @"WindowsCP1253";
			
		case NSWindowsCP1254StringEncoding:
			return @"WindowsCP1254";
			
		case NSWindowsCP1250StringEncoding:
			return @"WindowsCP1250";
			
		case NSISO2022JPStringEncoding:
			return @"ISO2022JP";
			
		case NSMacOSRomanStringEncoding:
			return @"MacOSRoman";
			
		case NSUTF16StringEncoding:
			return @"UTF16";
			
		case NSUTF16BigEndianStringEncoding:
			return @"UTF16BigEndian";
			
		case NSUTF16LittleEndianStringEncoding:
			return @"UTF16LittleEndian";
			
		case NSUTF32StringEncoding:
			return @"UTF32";
			
		case NSUTF32BigEndianStringEncoding:
			return @"UTF32BigEndian";
			
		case NSUTF32LittleEndianStringEncoding:
			return @"UTF32LittleEndian";
			
		case NSProprietaryStringEncoding:
			return @"Proprietary";
			
		default:
			return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

