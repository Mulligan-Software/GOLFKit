//
//  MulliganScoring.h
//  GOLFKit
//
//  Created by John Bishop on 4/2/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKitTypes.h"

//	Mulligan Software iCloud credentials
extern NSString * const MulliganSoftwareDevelopmentTeamID;
extern NSString * const MulliganScoringBundleID;

//	Dropbox credentials
extern NSString * const DropboxMulliganScoringAppFolder;
extern NSString * const DropboxMulliganScoringAppID;
extern NSString * const DropboxMulliganScoringAppSecret;
extern NSString * const DropboxiPressAppID;
extern NSString * const DropboxiPressAppSecret;
extern NSString * const DropboxScoringMachineAppID;
extern NSString * const DropboxScoringMachineAppSecret;

//	Google Drive credentials
extern NSString * const GoogleDriveAPIKey;
extern NSString * const GoogleDriveEagleClientID;
extern NSString * const GoogleDriveEagleClientSecret;
extern NSString * const GoogleDriveScoringMachineClientID;
extern NSString * const GoogleDriveScoringMachineClientSecret;

//	Evernote credentials
extern NSString * const EvernoteConsumerKey;
extern NSString * const EvernoteConsumerSecret;

//	PinIt credentials
extern NSString * const PinItScoringMachineAppID;

//	Mulligan Scoring UTI's, etc.
extern NSString * const MulliganScoringCourseIDUniversalTypeIdentifier;
extern NSString * const MulliganScoringCompetitorIDUniversalTypeIdentifier;
extern NSString * const MulliganScoringTeamIDUniversalTypeIdentifier;
extern NSString * const MulliganScoringScorecardIDUniversalTypeIdentifier;
extern NSString * const MulliganScoringEventIDUniversalTypeIdentifier;
extern NSString * const MulliganScoringRoundIDUniversalTypeIdentifier;
extern NSString * const MulliganScoringTeamRoundIDUniversalTypeIdentifier;

//	iTunes URL's for Eagle & iOS apps
extern NSString * const iTunesEagleURL;	//	Not really usable in iOS - calls go to generic Apple apps page
extern NSString * const iTunesMulliganAppsURL;;
extern NSString * const iTunesTeeChartURL;
extern NSString * const iTunesiPressURL;
extern NSString * const iTunesScoringMachineURL;

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
extern NSString * const iTunesMacAppStoreForEagleURL;
#endif

//	Mulligan Software online data URLs
extern NSString * const MulliganSoftwareWebSiteURL;
extern NSString * const MulliganSoftwareDisplayURL;
extern NSString * const MulliganSoftwareVersionsDictionaryURL;
extern NSString * const MulliganSoftwareClubsListDictionaryURL;
extern NSString * const MulliganSoftwareCountriesDictionaryURL;
extern NSString * const MulliganSoftwareForEagleURL;
extern NSString * const MulliganSoftwareForiPressURL;

//	Mulligan Software related data
extern NSString * const MulliganSoftwareSupportEMailAddress;
