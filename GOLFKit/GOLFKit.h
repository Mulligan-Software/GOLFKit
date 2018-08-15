//
//  GOLFKit.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//
//	Umbrella header for the GolfKit framework

@import Foundation;

@protocol GOLFHandicapDataSource;

//! Project version number for GOLFKit.
//FOUNDATION_EXPORT double GOLFKitVersionNumber;

//! Project version string for GOLFKit.
//FOUNDATION_EXPORT const unsigned char GOLFKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GolfKit/PublicHeader.h>

//	Models
#import <GOLFKit/GOLFKitTypes.h>
#import <GOLFKit/GOLFUtilities.h>

//	Categories
#import <GOLFKit/GOLFExtensions.h>

//	Documents (Scoring, Standings, etc.)
#if !TARGET_OS_WATCH
//	#import <GOLFKit/GOLFScoringDocument.h>
#endif

//	Common Features (Handicapping, etc.)
#import <GOLFKit/GOLFClubs.h>
#import <GOLFKit/GOLFScoring.h>
#import <GOLFKit/GOLFHandicapping.h>
#import <GOLFKit/MulliganScoring.h>

//	Common category extensions
#import <GOLFKit/NSNumber+GOLFExtensions.h>

//	User Interface (Colors, text, localization, etc.)
#import <GOLFKit/GOLFColors.h>
#import <GOLFKit/GOLFTeeMarkers.h>

//	Custom Drawing (not available on the Watch)
#if !TARGET_OS_WATCH
//	#import <GOLFKit/GOLFDrawing.h>
#endif

//	iOS and Watch only
#if TARGET_OS_IOS || TARGET_OS_WATCH
//	#import <GOLFKit/GOLFiOSandWatch.h>
#endif

//	iOS only
#if TARGET_OS_IOS
#import <GOLFKit/GOLFiOSUtilities.h>
#endif

//	Watch only
#if TARGET_OS_WATCH
//	#import <GOLFKit/GOLFWatch.h>
#endif

//	OS X (not embedded, no iOS, no Watch)
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
//	#import <GOLFKit/GOLFMac.h>
#endif

#define GOLFKIT_BUNDLE_ID			@"com.mulligansoftware.GOLFKit"

//	Bundle identification etc.
NSBundle * GOLFKitBundle(void);
NSString * GOLFKitBundleShortVersionString(void);
NSString * GOLFKitBundleVersion(void);

@protocol GOLFHandicapDataSource <NSObject>

@optional

- (NSString *)handicapAuthority;
//	The handicap authority used for handicapping - usually available from events or rounds
//	return NSString*, nil if none or using a default

- (NSNumber *)handicapIndexForWomen:(BOOL *)women for9Holes:(BOOL *)nineHoles;
//	A previously determined handicapIndex - usually available from rounds
//	Non-nil *women, *nineHoles pre-set TRUE if ladies or nineHole response required - change if response requires
//	return float equivalent, nil for no data, *women = TRUE for ladies, *nineHoles = TRUE for 9-hole index

- (NSNumber *)teeSLOPERatingForWomen:(BOOL *)women for9Holes:(BOOL *)nineHoles;
//	A previously determined SLOPE Rating - usually available from rounds, sides or tees
//	Non-nil *women, *nineHoles pre-set TRUE if women's or nineHole's response required - change if response requires
//	return NSInteger equivalent, nil for no data, *women = TRUE for ladies, *for9Holes = TRUE for 9-hole rating

- (NSNumber *)teeCourseRatingForWomen:(BOOL *)women for9Holes:(BOOL *)nineHoles;
//	A previously determined Course Rating - usually available from rounds, sides or tees
//	Non-nil *women, *nineHoles pre-set TRUE if women's or nineHole's response required - change if response requires
//	return float equivalent, nil for no data, *women = TRUE for ladies, *for9Holes = TRUE for 9-hole rating

- (NSNumber *)teeParForWomen:(BOOL *)women for9Holes:(BOOL *)nineHoles;
//	Previously determined par - usually available from rounds, sides or tees
//	Non-nil *women, *nineHoles pre-set TRUE if women's or nineHole's response required - change if response requires
//	return NSInteger equivalent, nil for no data, *women = TRUE for ladies, *for9Holes = TRUE for 9-hole par

- (NSDictionary *)strokeControlInfo;
//	A dictionary of information required to do handicapping stroke control:
//
//	Key						Type			Description
//	----------------------	--------------	---------------------------------
//	numberOfHoles			NSNumber *		The number of holes against which stroke control should be applied (1 for a hole, 9 for a side, etc.)
//	par						NSNumber *		GOLFPar for this entity (may be estimated)
//	strokes					NSNumber *		GOLFHandicapStrokes for this entity (may be estimated)
//	competitor				id				Any associated competitor with this entity
//	competitorIsFemale		NSNumber *		A BOOL indicating whether competitor is female

@end
