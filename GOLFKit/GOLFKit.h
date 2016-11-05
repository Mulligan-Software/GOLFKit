//
//  GOLFKit.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//
//	Umbrella header for the GolfKit framework

@import Foundation

//! Project version number for GOLFKit.
FOUNDATION_EXPORT double GOLFKitVersionNumber;

//! Project version string for GOLFKit.
FOUNDATION_EXPORT const unsigned char GOLFKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GolfKit/PublicHeader.h>

//	Models
//	#import <GOLFKit/GOLFClubs.h>

//	Documents (Scoring, Standings, etc.)
#if !TARGET_OS_WATCH
//	#import <GOLFKit/GOLFScoringDocument.h>
#endif

//	Presentation (Lists, Items, Results, etc.)
//	#import <GOLFKit/GOLFScoresPresenting.h>

//	User Interface (Colors, text, localization, etc.)
#import <GOLFKit/GOLFColors.h>

//	Custom Drawing (not available on the Watch)
#if !TARGET_OS_WATCH
//	#import <GOLFKit/GOLFDrawing.h>
#endif

//	iOS and Watch only
#if TARGET_OS_IOS || TARGET_OS_WATCH
//	#import <GOLFKit/GOLFiOSandWatchh>
#endif

//	iOS only
#if TARGET_OS_IOS
//	#import <GOLFKit/GOLFiOS.h>
#endif

//	Watch only
#if TARGET_OS_WATCH
//	#import <GOLFKit/GOLFWatch.h>
#endif

//	OS X (not embedded, no iOS, no Watch)
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
//	#import <GOLFKit/GOLFMac.h>
#endif
