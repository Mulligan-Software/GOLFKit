//
//  GOLFHandicapping.h
//  GOLFKit
//
//  Created by John Bishop on 3/6/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKitTypes.h"

//	Misc constants
#define	kGOLFHandicapMethodsNumberOfCertifiable		6		//	WHS (1) through CONGU (6), total of 6
#define	kGOLFHandicapMethodsNumberOfMiscellaneous	3		//	Mulligan (20) through Second-Best (22), total of 3
//													---
#define kGOLFHandicapNumberOfMethods				9		//	Total number of handicapping methods

typedef NS_OPTIONS(NSUInteger, GOLFRoundHandicapOption) {
	GOLFRoundHandicapOptionNone			= 0,			//	(0)
	GOLFRoundHandicapOptionUsed			= 1 << 0,		//	(1)
	GOLFRoundHandicapOptionEligible		= 1 << 1,		//	(2)
	GOLFRoundHandicapOptionTournament	= 1 << 2,		//	(4)
	GOLFRoundHandicapOptionCombined		= 1 << 3,		//	(8)
	GOLFRoundHandicapOption9Holes		= 1 << 4,		//	(16)
	GOLFRoundHandicapOptionAway			= 1 << 5,		//	(32)
	GOLFRoundHandicapOptionHome			= 1 << 6,		//	(64)
	GOLFRoundHandicapOptionSpare1		= 1 << 7,		//	(128)
	GOLFRoundHandicapOptionSpare2		= 1 << 8,		//	(256)
	GOLFRoundHandicapOptionInternet		= 1 << 9,		//	(512)
	GOLFRoundHandicapOptionPenalty		= 1 << 10		//	(1024)
};

typedef NS_ENUM(NSUInteger, GOLFHandicapMethodIndex) {
	GOLFHandicapMethodNone = 0,			//	none (0)
	GOLFHandicapMethodWHS,				//	World Handicap System (1)
	GOLFHandicapMethodUSGA,				//	USGA Handicap System (2)
	GOLFHandicapMethodRCGA,				//	RCGA (Golf Canada) Handicap System (3)
	GOLFHandicapMethodAGU,				//	AGU (Golf Australia) Handicap System (4)
	GOLFHandicapMethodEGA,				//	EGA (European Golf Association) Handicap System (5)
	GOLFHandicapMethodCONGU,			//	CONGU Unified Handicap System (6)
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
	GOLFHandicapMethodMulligan = 20,	//	Mulligan Handicap System (20)
	GOLFHandicapMethodPersonal,			//	Personalized Handicap System (21)
	GOLFHandicapMethodSecondBest,		//	Second-Best Score Handicap System (22)
#endif
	GOLFHandicapMethodUnknown = 999		//	Unknown handicapping type
};

typedef NS_ENUM(NSUInteger, GOLFHandicapStrokeControl) {
	GOLFHandicapStrokeControlNone = 0,		//	Don't adjust strokes for handicapping	(0)
	GOLFHandicapStrokeControlDouble,		//	Limit to gross double-bogey				(1)
	GOLFHandicapStrokeControlNetDouble,		//	Limit to net double-bogey				(2)
	GOLFHandicapStrokeControlDoublePlus10,	//	Limit to double-bogey plus 10% of playing handicap	(3)
	GOLFHandicapStrokeControlTriple,		//	Limit to gross triple-bogey				(4)
	GOLFHandicapStrokeControlNetTriple,		//	Limit to net triple-bogey				(5)
	GOLFHandicapStrokeControlESC = 10,		//	Equitable Stroke Control (ESC) limit	(10)
	GOLFHandicapStrokeControlUnknown = 99	//	Unknown stroke control technique
};

typedef NS_ENUM(NSUInteger, GOLFHandicapDifferentialType) {
	GOLFHandicapDifferentialTypeOverPar = 0,			//	Strokes over par					(0)
	GOLFHandicapDifferentialTypeOverRating,				//	Strokes over course rating			(1)
	GOLFHandicapDifferentialTypeOverCCR,				//	Strokes over CCR or CSS				(2)
	GOLFHandicapDifferentialTypeStableford,				//	Relationship to Stableford points	(3)
	GOLFHandicapDifferentialTypeSlopeAndRating = 10,	//	Slope & Rating based				(10)
	GOLFHandicapDifferentialTypeUnknown = 99			//	Unknown stroke control technique
};

typedef NS_ENUM(NSUInteger, GOLFPlayingHandicapType) {
	GOLFPlayingHandicapTypeUnadjusted = 0,			//	Playing handicap is same as handicap index						(0)
	GOLFPlayingHandicapTypeRatingAdjusted,			//	Handicap index adjusted to par with course rating				(1)
	GOLFPlayingHandicapTypeFullyAdjusted,			//	Handicap index adjusted to par with slope and course ratings	(2)
	GOLFPlayingHandicapTypeSlopeAdjusted = 10,		//	Playing handicap adjusted to course rating with slope rating	(10)
	GOLFPlayingHandicapTypeUnknown = 99				//	Unknown playing handicap style
};

typedef NSString GOLFHandicapAuthority;
typedef float GOLFHandicapDifferential;		//	The intermediate adjusted handicapping "value" of a round used for handicap calculation
typedef float GOLFHandicapIndex;			//	The portable course and player independent evaluation of a golfer's skill
typedef NSInteger GOLFPlayingHandicap;		//	The whole unadjusted course and player-dependent strokes calculated for a player
typedef NSInteger GOLFHandicapStrokes;		//	Any value related to strokes earned, taken or used

GOLFHandicapAuthority * GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodIndex methodIndex);
//	Returns the GOLFHandicapAuthority mnemonic that best represents the handicapping method indicated by the methodIndex.
//	The returned string mnemonic may be used to identify the organization responsible for administering the handicapping
//	system, or to lookup or calculate handicapping information related to the handicapping method.
//	Returns nil if the methodIndex is zero (GOLFHandicapMethodNone), unknown (GOLFHandicapMethodUnknown) or invalid.


#pragma mark Functions
NSArray * GOLFHandicapAuthorities(void);	//	An array of dictionaries
GOLFHandicapAuthority * DefaultHandicapAuthority(void);
//	MULGolfAssociation * GolfAssociationWithAcronym(NSString *acronym);
BOOL CertifiableAuthority(GOLFHandicapAuthority *authority);
//GOLFPlayingHandicap CourseHandicap(GOLFHandicapAuthority *authority, GOLFHandicapIndex handicapIndex, BOOL is9HoleIndex, GOLFTeeSlope slope, id roundOrEvent);
GOLFHandicapStrokes StrokeControlLimit(GOLFHandicapAuthority *authority, GOLFPlayingHandicap courseHandicap, BOOL for9Holes, NSObject *anObject);
NSInteger WorstNHoles(NSArray *worstHoles, NSInteger numberOfHoles, BOOL andAHalf);
GOLFHandicapIndex MaximumNonLocalIndex(GOLFHandicapAuthority *authority, BOOL playerIsFemale, BOOL for9Holes);
BOOL CCRUsedForHandicapping(GOLFHandicapAuthority *authority, BOOL *required);
BOOL StablefordRequiredForHandicapping(GOLFHandicapAuthority *authority);
BOOL DoesTournamentAdjustment(GOLFHandicapAuthority *authority);
//GOLFHandicapDifferential Differential(GOLFHandicapAuthority *authority, GOLFRound *aRound);
//GOLFHandicapDifferential SideDifferential(GOLFHandicapAuthority *authority, GOLFRoundSide *aSide);
NSInteger DifferentialSort(id dict1, id dict2, void *context);
NSInteger ScoreSort(id dict1, id dict2, void *context);
//NSString * DifferentialString(GOLFHandicapAuthority *authority, GOLFRound *aRound);
NSString * HandicapIndexString(GOLFHandicapAuthority *authority, GOLFHandicapIndex hdcpIndex, BOOL playerIsFemale, BOOL nineHoles);
NSString * RoundModifierKeyString(GOLFHandicapAuthority *authority);
NSInteger DifferentialsToUseFrom(GOLFHandicapAuthority *authority, NSInteger numberOfScores);
GOLFHandicapIndex HandicapReductionFrom(GOLFHandicapAuthority *authority, GOLFHandicapIndex excessIndex, NSInteger eligibleScores);
//NSMutableArray * ScoringRecordFor(GOLFCompetitor *competitor, GOLFHandicapAuthority *authority, NSDate *date);
NSMutableArray * TournamentRecordFrom(NSArray *scoringRecord);
//BOOL ValidateRound(GOLFRound *aRound);
//NSString * TrendHandicapStringThrough(GOLFCompetitor *competitor, GOLFHandicapAuthority *authority, NSDate *date);
GOLFHandicapStrokes DefaultHandicapLimitsDifference(GOLFHandicapAuthority *authority);
float DefaultHandicapLimitsPctAdj(GOLFHandicapAuthority *authority);

#pragma mark User Interface Info
NSString * HandicappingAuthorityMethodName(GOLFHandicapAuthority *authority);	//	The handicapping system name
NSString * AdjustedGrossTitle(GOLFHandicapAuthority *authority);
NSString * DifferentialTitle(GOLFHandicapAuthority *authority);
NSString * LocalIndexModifier(GOLFHandicapAuthority *authority);
NSString * ExceptionalScoringModifier(GOLFHandicapAuthority *authority);
NSString * NineHoleModifier(GOLFHandicapAuthority *authority);
NSString * GradeTitle(GOLFHandicapAuthority *authority);
NSString * CCRTitle(GOLFHandicapAuthority *authority);
NSString * HandicapIndexTitle(GOLFHandicapAuthority *authority, BOOL plural);
NSString * CourseHandicapTitle(GOLFHandicapAuthority *authority, BOOL plural);
NSString * HandicapAllowanceTitle(GOLFHandicapAuthority *authority);

#pragma mark Golf Australia / Australian Golf Union (AGU) functions
NSInteger AGUGradeFromHandicap(GOLFPlayingHandicap handicap);
NSInteger AGUBufferLimitFromHandicap(GOLFPlayingHandicap handicap);
float AGUPerStrokeAdjustmentFromHandicap(GOLFPlayingHandicap handicap);
//GOLFHandicapIndex AGUAnchorHandicapTo(GOLFCompetitor *competitor, NSDate *date);
//GOLFHandicapIndex GACapPointTo(GOLFCompetitor *competitor, NSDate *date);

#pragma mark Congress of National Golf Unions (CONGU) functions
float CONGUBufferZoneLimitFromCategory(NSInteger category);
NSInteger CONGUCategoryFromExactHandicap(GOLFHandicapIndex exactHandicap, BOOL playerIsFemale);
float CONGUPerStrokeAdjustmentBelowBufferZoneInCategory(NSInteger category);
float CONGUAdjustmentAboveBufferZoneInCategory(NSInteger category);
float CONGUExceptionalScoringReductionForNetDifferentials(NSArray *netDifferentials);

#pragma mark European Golf Association (EGA)
NSInteger EGACategoryFromEGAHandicap(GOLFHandicapIndex EGAHandicap, BOOL playerIsFemale);
float EGABufferLimitFromCategory(NSInteger category, BOOL is9HoleRound);
float EGAPerStrokeHandicapReductionFromCategory(NSInteger category);
float EGAHandicapAdditionFromCategory(NSInteger category);

