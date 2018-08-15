//
//  GOLFUtilities.h
//  GOLFKit
//
//  Created by John Bishop on 3/7/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKitTypes.h"

//	No-value constants
#define kNotAnIntegerValue			-999		//	No-value for misc. NSInteger-based value storage
#define kNotAFloatValue				-999.0		//	No-value for misc. float-based value storage

NSString * GOLFUnlocalizedCurrentCountry(void);
//	The unlocalized name of the country for which the user's device is configured, discovered from NSLocale features

NSString * GOLFMonthAbbreviationString(void);
//	A 12-character string of the months' names - like "JFMAMJJASOND"

NSDictionary * GOLFCountriesInfo(void);
//	The entire GOLFCountries.plist localized

NSDictionary * GOLFCountriesInfoForCountryCode(NSString *countryCode);
//	Country information from GOLFCountries.plist - using the countryCode
//
//	Key				Type					Description
//	-------------	---------------------	--------------------------------------------
//	countryCode		NSString *				Country code from locale date on this device
//	countryName		NSString *				The localized name of the country
//	association		NSString *				The name of the country's golf association
//	URL				NSString *				The URL of the golf association
//	authority		GOLFHandicapAuthority	The default golf authority for handicapping in this country
//	states			NSArray *				Optional array of states dictionaries for this country - postalCode, stateName

NSDictionary * GOLFHomeCountryInfo(void);
//	Localized home country information from GOLFCountries.plist
//	See GOLFCountriesInfoForCountryCode() above

NSString * GOLFLocalizedString(NSString *key);
//	Localized NSString from a) GOLFKit.strings or b) the app's Localizable.strings

#pragma mark NSStringFrom… Utilities

NSString * NSStringFromPlayingHandicap(GOLFPlayingHandicap playingHandicap);
//	The Playing Handicap or 'kNotAPlayingHandicap'

NSString * NSStringFromHandicapIndex(GOLFHandicapIndex handicapIndex);
//	The Handicap Index or 'kNotAHandicapIndex'

NSString * NSStringForClickOrTap(void);
//	Localized 'click' or 'tap'

//=================================================================
//	Utilities:
//
//	NSStringFromNSComparisonResult(result)
//
//=================================================================
NSString * NSStringFromNSComparisonResult(NSComparisonResult result);
