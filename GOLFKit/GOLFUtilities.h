//
//  GOLFUtilities.h
//  GOLFKit
//
//  Created by John Bishop on 3/7/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

@import Foundation;
#import <GOLFKit/GOLFKitTypes.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH

@import UIKit;

#define GOLFImage UIImage

#elif TARGET_OS_MAC

@import Cocoa;

#define GOLFImage NSImage

#endif

//	External constants
extern NSString * const GOLFLocalizedStringNotFound;

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
//	Key					Type					Description
//	-----------------	---------------------	--------------------------------------------
//	countryCode			NSString *				Country code from locale date on this device
//	countryName			NSString *				The localized name of the country
//	association			NSString *				The name of the country's golf association
//	URL					NSString *				The URL of the golf association
//	authority			GOLFHandicapAuthority	The default golf authority for handicapping in this country
//	USGACountryCode		NSNumber *				Integer key to USGA Data Services GetCountryCodes (ie: "240" = U.S.A.)		†
//	USGADescription		NSString *				Full country name (ie: United States of America)							†
//	ISOCountryCode		NSString *				ISO-standard alphabetic country identifier (ie: "USA")						†
//	USGAStringValue		NSString *				String-equivalent country identifier (ie: "USA")							†
//	states				NSArray *				Optional array of states dictionaries for this country
//												as follows…
//	postalCode			NSString *				International 2-3 character postal code  (ie: "TX")
//	stateName			NSString *				State name  (ie" "Texas")
//	USGAStateCode		NSNumber *				Integer key to USGA Data Services GetStateCodes (ie: "200008" = Delaware)	†
//	USGACountryCode		NSNumber *				The related USGA CountryCode for this state (ie: "240" = U.S.A.)			†
//	ISOStateCode		NSString *				ISO-standard alphabetic state identifier (ie: "US-DE")						†		
//	USGADescription		NSString *				Full state name (ie: "Delaware")											†
//	USGAStringValue		NSString *				USGA country_state string (ie: "US_DE")										†
//	†	derived from USGA GetCountryCodes and GetStateCodes

NSDictionary * GOLFHomeCountryInfo(void);
//	Localized home country information from GOLFCountries.plist
//	See GOLFCountriesInfoForCountryCode() above

NSString * GOLFLocalizedString(NSString *key);
//	Localized NSString from a) GOLFKit.strings or b) the app's Localizable.strings

GOLFImage * GOLFImageWithName(NSString *imageName);
//	An NSImage or UIImage available in GOLFKit by name

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
