//
//  MulliganScoring.m
//  GOLFKit
//
//  Created by John Bishop on 4/2/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "MulliganScoring.h"

//	Mulligan Software iCloud credentials
NSString * const MulliganSoftwareDevelopmentTeamID = @"T439NGX64L";
NSString * const MulliganScoringBundleID = @"com.mulligansoftware.MulliganScoring";

//	Dropbox credentials
NSString * const DropboxMulliganScoringAppFolder = @"Mulligan Scoring";
NSString * const DropboxMulliganScoringAppID = @"gxf00c0992zv93i";
NSString * const DropboxMulliganScoringAppSecret = @"fvfrn80ajtymaap";
NSString * const DropboxiPressAppID = @"81bcdu0w9b0m7aa";
NSString * const DropboxiPressAppSecret = @"jegefhzaqhbaj68";
NSString * const DropboxScoringMachineAppID = @"hwtrjpqkcpd5h4y";
NSString * const DropboxScoringMachineAppSecret = @"u85es056y5canf4";

//	Google Drive credentials
NSString * const GoogleDriveAPIKey = @"AIzaSyBxmnUjaWYXFnc6vAvJDMGWyYzOqHTRRTA";
NSString * const GoogleDriveEagleClientID = @"1008932362539.apps.googleusercontent.com";
NSString * const GoogleDriveEagleClientSecret = @"zuMDhzsR5H0C3XBU7FjI_SBy";
NSString * const GoogleDriveScoringMachineClientID = @"1008932362539-jhpjoqg85i60i0f8gulr88hmeejstlda.apps.googleusercontent.com";
NSString * const GoogleDriveScoringMachineClientSecret = @"iQ4KcPqFlyfgPQKdSOY9_xHa";

//	Evernote credentials
NSString * const EvernoteConsumerKey = @"mulligangolf";
NSString * const EvernoteConsumerSecret = @"589d644f45ece686";

//	PinIt credentials
NSString * const PinItScoringMachineAppID = @"1443072";

//	Mulligan Scoring UTI's, etc.
NSString * const MulliganScoringCourseIDUniversalTypeIdentifier = @"com.mulligansoftware.scoring.courseID";
NSString * const MulliganScoringCompetitorIDUniversalTypeIdentifier = @"com.mulligansoftware.scoring.competitorID";
NSString * const MulliganScoringTeamIDUniversalTypeIdentifier = @"com.mulligansoftware.scoring.teamID";
NSString * const MulliganScoringScorecardIDUniversalTypeIdentifier = @"com.mulligansoftware.scoring.scorecardID";
NSString * const MulliganScoringEventIDUniversalTypeIdentifier = @"com.mulligansoftware.scoring.eventID";
NSString * const MulliganScoringRoundIDUniversalTypeIdentifier = @"com.mulligansoftware.scoring.roundID";
NSString * const MulliganScoringTeamRoundIDUniversalTypeIdentifier = @"com.mulligansoftware.scoring.teamRoundID";

//	iTunes URL's for Mulligan & iOS apps
NSString * const iTunesEagleURL = @"https://apps.apple.com/us/app/eagle/id403115926?mt=12";
NSString * const iTunesMulliganAppsURL = @"https://apps.apple.com/us/developer/mulligan-software/id334049704?mt=12";
NSString * const iTunesTeeChartURL = @"https://apps.apple.com/us/app/teechart/id334049701";
NSString * const iTunesiPressURL = @"https://apps.apple.com/us/app/ipress/id481425041";
NSString * const iTunesScoringMachineURL = @"https://apps.apple.com/us/app/the-scoring-machine/id831912888";

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
NSString * const iTunesMacAppStoreForEagleURL = @"https://apps.apple.com/us/app/eagle/id403115926?mt=12";	//	Not useful from iOS
#endif

//	Mulligan Software online data URLs
NSString * const MulliganSoftwareWebSiteURL = @"https://www.mulligansoftware.com";
NSString * const MulliganSoftwareDisplayURL = @"www.mulligansoftware.com";
NSString * const MulliganSoftwareVersionsDictionaryURL = @"https://www.mulligansoftware.com/golf/data/versions.xml";
NSString * const MulliganSoftwareClubsListDictionaryURL = @"https://www.mulligansoftware.com/golf/data/clubs_list.xml";
NSString * const MulliganSoftwareCountriesDictionaryURL = @"https://www.mulligansoftware.com/golf/data/countries_list.xml";
NSString * const MulliganSoftwareForEagleURL = @"https://www.mulligansoftware.com/responsive/mulligans-eagle.html";
NSString * const MulliganSoftwareForiPressURL = @"https://www.mulligansoftware.com/responsive/ipress.html";

//	Mulligan Software related data
NSString * const MulliganSoftwareSupportEMailAddress = @"support@mulligansoftware.com";
