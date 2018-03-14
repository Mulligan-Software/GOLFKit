//
//  GOLFUtilities.h
//  GOLFKit
//
//  Created by John Bishop on 3/7/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKitTypes.h"

NSString * GOLFUnlocalizedCurrentCountry(void);
//	The unlocalized name of the country for which the user's device is configured, discovered from NSLocale features

NSString * GOLFMonthAbbreviationString(void);
//	A 12-character string of the months' names - like "JFMAMJJASOND"

NSDictionary * GOLFHomeCountryInfo(void);
//	Localized home country information from GOLFCountries.plist
//
//	Key				Type					Description
//	-------------	---------------------	--------------------------------------------
//	countryCode		NSString *				Country code from locale date on this device
//	countryName		NSString *				The localized name of the country
//	association		NSString *				The name of the country's golf association
//	URL				NSString *				The URL of the golf association
//	authority		GOLFHandicapAuthority	The default golf authority for handicapping in this country
