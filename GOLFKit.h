//
//  GOLFKit.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//
//	Umbrella header for the GolfKit framework

@import Foundation;

//	GOLFKit Errors
extern NSString * _Nonnull const GOLFKitErrorDomain;	//	The error domain name

typedef NS_ENUM(NSInteger, GOLFKitErrorDomainError) {
	GOLFKitDataError					= 18000,	// generic error
	GOLFKitMultipleErrorsError			= 18010,	// generic message for error containing multiple validation errors
	GOLFKitDataBaseAccessError			= 18050,	// something wrong with retrieval from or storage to CoreData
	GOLFKitReachabilityError			= 18060,	// a service (Dropbox, iCloud, USGA Data Services, etc.) is unreachable
};

@protocol GOLFHandicapDataSource;

//! Project version number for GOLFKit.
//FOUNDATION_EXPORT double GOLFKitVersionNumber;

//! Project version string for GOLFKit.
//FOUNDATION_EXPORT const unsigned char GOLFKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GolfKit/PublicHeader.h>

//	Models
#import <GOLFKit/GOLFKitTypes.h>
#import <GOLFKit/GOLFUtilities.h>

//	Categories - all targets
#import <GOLFKit/GOLFExtensions.h>

//	Documents (Scoring, Standings, etc.)
#if !TARGET_OS_WATCH
//	#import <GOLFKit/GOLFScoringDocument.h>
#endif

//	Common Features (Handicapping, etc.)
#import <GOLFKit/GOLFClubs.h>
#import <GOLFKit/GOLFScoring.h>
#import <GOLFKit/GOLFHandicapping.h>
#import <GOLFKit/GOLFWagering.h>
#import <GOLFKit/MulliganScoring.h>
#import <GOLFKit/USGADataServices.h>

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
#import <GOLFKit/GOLFCustomTableViewCells.h>
#endif

//	Watch only
#if TARGET_OS_WATCH
//	#import <GOLFKit/GOLFWatch.h>
#endif

//	macOS (not embedded, no iOS, no Watch)
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
#import <GOLFKit/GOLFmacOSUtilities.h>
#import <GOLFKit/GOLFDynamicColor.h>
#endif

#define GOLFKIT_BUNDLE_ID			@"com.mulligansoftware.GOLFKit"

//	Bundle identification etc.
NSBundle * _Nonnull GOLFKitBundle(void);
NSString * _Nonnull GOLFKitBundleShortVersionString(void);
NSString * _Nonnull GOLFKitBundleVersion(void);

@protocol GOLFHandicapDataSource <NSObject>

@optional

- (NSString *_Nullable)handicapAuthority;
//	The handicap authority used for handicapping - usually available from events or rounds
//	return NSString*, nil if none or using a default

- (NSNumber *_Nullable)handicapIndexForWomen:(nullable BOOL *)women for9Holes:(nullable BOOL *)nineHoles;
//	A previously determined handicapIndex - usually available from rounds
//	Non-nil *women, *nineHoles pre-set TRUE if ladies or nineHole response required - change if response requires
//	return float equivalent, nil for no data, *women = TRUE for ladies, *nineHoles = TRUE for 9-hole index

- (NSNumber *_Nullable)teeSLOPERatingForWomen:(nullable BOOL *)women for9Holes:(nullable BOOL *)nineHoles;
//	A previously determined SLOPE Rating - usually available from rounds, sides or tees
//	Non-nil *women, *nineHoles pre-set TRUE if women's or nineHole's response required - change if response requires
//	return NSInteger equivalent, nil for no data, *women = TRUE for ladies, *for9Holes = TRUE for 9-hole rating

- (NSNumber *_Nullable)teeCourseRatingForWomen:(nullable BOOL *)women for9Holes:(nullable BOOL *)nineHoles;
//	A previously determined Course Rating - usually available from rounds, sides or tees
//	Non-nil *women, *nineHoles pre-set TRUE if women's or nineHole's response required - change if response requires
//	return float equivalent, nil for no data, *women = TRUE for ladies, *for9Holes = TRUE for 9-hole rating

- (NSNumber *_Nullable)teeParForWomen:(nullable BOOL *)women for9Holes:(nullable BOOL *)nineHoles;
//	Previously determined par - usually available from rounds, sides or tees
//	Non-nil *women, *nineHoles pre-set TRUE if women's or nineHole's response required - change if response requires
//	return NSInteger equivalent, nil for no data, *women = TRUE for ladies, *for9Holes = TRUE for 9-hole par

- (NSDictionary *_Nonnull)strokeControlInfo;
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
