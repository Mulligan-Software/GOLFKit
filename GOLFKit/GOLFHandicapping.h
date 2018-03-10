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
	GOLFRoundHandicapOptionUsed			= 1 << 0,		//	(1)			Round used in handicap latest calculation (ie: one of the best 10 of last 20)
	GOLFRoundHandicapOptionEligible		= 1 << 1,		//	(2)			Round is identified as eligible for use/review in calculations (stats and handicapping)
	GOLFRoundHandicapOptionTournament	= 1 << 2,		//	(4)			Round identified as a "tournament" round
	GOLFRoundHandicapOptionCombined		= 1 << 3,		//	(8)			18-hole round constructed from two 9-hole rounds
	GOLFRoundHandicapOption9Holes		= 1 << 4,		//	(16)		9-hole round
	GOLFRoundHandicapOptionAway			= 1 << 5,		//	(32)		Round identified as played "away" - not at home course
	GOLFRoundHandicapOptionHome			= 1 << 6,		//	(64)		Round identified as played at home course
	GOLFRoundHandicapOptionSpare1		= 1 << 7,		//	(128)
	GOLFRoundHandicapOptionSpare2		= 1 << 8,		//	(256)
	GOLFRoundHandicapOptionInternet		= 1 << 9,		//	(512)		Round recorded/entered via the internet
	GOLFRoundHandicapOptionPenalty		= 1 << 10		//	(1024)		Round identified as a "penalty" round - may adjust handicap
};

typedef NS_ENUM(NSUInteger, GOLFHandicapMethodIndex) {
	GOLFHandicapMethodNone = 0,			//	none (0)
	GOLFHandicapMethodUSGA,				//	USGA Handicap System (1)
	GOLFHandicapMethodRCGA,				//	RCGA (Golf Canada) Handicap System (2)
	GOLFHandicapMethodAGU,				//	AGU (Golf Australia) Handicap System (3)
	GOLFHandicapMethodEGA,				//	EGA (European Golf Association) Handicap System (4)
	GOLFHandicapMethodCONGU,			//	CONGU Unified Handicap System (5)
	GOLFHandicapMethodWHS,				//	World Handicap System (6)
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

extern GOLFHandicapAuthority * const GOLFHandicapAuthorityUSGA;			//	"USGA"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityRCGA;			//	"RCGA"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityAGU;			//	"AGU"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityEGA;			//	"EGA"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityCONGU;		//	"CONGU"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityWHS;			//	"WHS"
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityMulligan;		//	"MULLIGAN"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityPersonal;		//	"PERSONAL"
extern GOLFHandicapAuthority * const GOLFHandicapAuthoritySecondBest;	//	"SECONDBEST"
#endif

GOLFHandicapAuthority * GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodIndex methodIndex);
//	Returns the GOLFHandicapAuthority mnemonic that best represents the handicapping method indicated by the methodIndex.
//	The returned string mnemonic may be used to identify the organization responsible for administering the handicapping
//	system, or to lookup or calculate handicapping information related to the handicapping method.
//	Returns nil if the methodIndex is zero (GOLFHandicapMethodNone), unknown (GOLFHandicapMethodUnknown) or invalid.

GOLFHandicapMethodIndex GOLFHandicapBestMethodIndexFromAuthority(GOLFHandicapAuthority *authority);
//	Returns the best (guess/most likely) GOLFHandicapMethodIndex for a specified handicap authority mnemonic, whether good, bad, or missing
//	Will NOT return GOLFHandicapMethodUnknown

NSString * GOLFHandicapMethodName(GOLFHandicapAuthority *authority);
//	Returns the localized name of the handicap system or method supported by the provided GOLFHandicapAuthority

NSArray * GOLFHandicapAuthorities(void);	//	An array of dictionaries
//	Returns an NSArray of NSDictionaries, each with information about an available handicapping authority and the
//	handicapping system used by its golfers:
//
//	Type			Key						Description
//	--------------	----------------------	---------------------------------
//	NSNumber		methodIndex				GOLFHandicapMethodIndex identifying the handicapping authority
//	NSString		handicapAuthority		A mnemonic identifying the handicapping authority - used in most handicapping function calls
//	NSString		authorityDisplay		A mnemonic for display identifying the handicapping authority
//	NSString		association				The localized name of the handicapping association (authority)
//	NSString		methodName				The localized name of the handicap system supported by the authority
//	NSNumber		certifiable				A BOOL indicating whether the handicap method requires certification for use

NSString * GOLFHandicapIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title for an "official" calculated handicap ("Handicap Index®", "Índice de Handicap", "Exakt Handicapen", etc.)

NSString * GOLFHandicapCurrentIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title as above with a "current" qualifier ("Current Handicap Index", "Índice de Handicap Actual", "Aktuellen Exakt Handicapen")

NSString * GOLFPlayingHandicapTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title for the handicap strokes for play ("Playing Handicap", "Handicap de Campo", "EGA Handicap Jouer", etc.)

NSString * GOLFHandicapAllowanceTitle(GOLFHandicapMethodIndex handicapMethod);
//	Returns a localized title for the allowed handicap strokes in competition ("Handicap Allowance", "Allocation de Handicap", etc.)

NSString * GOLFHandicapAdjustedGrossTitle(GOLFHandicapMethodIndex handicapMethod);
//	Returns a localized title for the intermediate adjusted score used for handicap calculation ("Adjusted Gross Score", "Puntaje Bruto Adjustado", etc.)

NSString * GOLFHandicapDifferentialTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated);
//	Returns a localized title for the intermediate differential-from-scratch value used in handicap calculation ("Handicap Differential", etc.)

NSString * GOLFHandicapGradeTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated);
//	Returns, for handicap systems with grades or categories, a localized title for that division ("Handicap Grade", "Klasse", etc.)

NSString * GOLFHandicapCCRTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated);	//	Calculated Course Rating
//	Returns a localized title describing a daily-calculated conditions-dependent Course Rating to be applied to competitive rounds played

NSString * GOLFHandicapCSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated);	//	Competition Scratch Score
//	Returns a localized title describing a calculated conditions-dependent expert Scratch Score for adjusting competitive rounds played

NSString * GOLFHandicapSSSTitle(GOLFHandicapMethodIndex handicapMethod, BOOL abbreviated);	//	Standard Scratch Score
//	Returns a localized descriptive title for the "standard" score expected of an expert player without a handicap

//	Authority-specific data
BOOL GOLFHandicapCertifiableAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the use of the handicapping method of this authority requires certification

NSString * GOLFHandicapMethodNameForAuthority(GOLFHandicapAuthority *authority);
//	Returns the localized name of the handicapping method administered by this authority

GOLFHandicapIndex GOLFHandicapMaximumNonLocalIndexForAuthority(GOLFHandicapAuthority *authority, BOOL playerIsFemale, BOOL for9Holes);
//	Returns the highest "standard" or authorized handicap index allowed by this handicapping authority

NSString * GOLFHandicapLocalIndexModifierForAuthority(GOLFHandicapAuthority *authority);
//	Returns the short (1 character) modifier used to indicate that a handicap is for local (home club) use only - "L" (local), "C" (club), etc.

NSString * GOLFHandicapNineHoleModifierForAuthority(GOLFHandicapAuthority *authority);
//	Returns the short (1 character) modifier used to indicate that a handicap or score is for a 9-hole round - "N", "9", etc.

NSString * GOLFHandicapGradeTitleForAuthority(GOLFHandicapAuthority *authority);
//	Returns the localized short title identifying the classification of handicaps in some systems - "Grade", "Categorie", "Klasse", etc.

NSString * GOLFHandicapExceptionalScoringModifierForAuthority(GOLFHandicapAuthority *authority);
//	Returns the short (1 character) modified used to indicate that a handicap has been adjusted for exceptional scores in a player's scoring record

NSString * GOLFRoundModifierTooltip(GOLFHandicapAuthority *authority);
//	Returns the appropriate tooltip (with line feeds) tabulating the description of round modifiers ("* - used", "T - Torneo", "E - Estimado", etc.

BOOL GOLFHandicapStablefordRequiredForAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the handicapping method of this authority requires Stableford scores or equivalents for handicap calculation

BOOL GOLFDoesTournamentAdjustmentForAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the handicapping method of this authority accommodates adjustments or special handling for "tournament" (T) scores

BOOL GOLFHandicapCCRUsedForAuthority(GOLFHandicapAuthority *authority, BOOL *required);
//	Indicates whether the handicapping method for this authority uses (or requires) a conditions-dependent CCR or CSS returned for scores used for handicapping

GOLFHandicapStrokes GOLFHandicapDefaultLimitsDifferenceForAuthority(GOLFHandicapAuthority *authority);
//	In foursomes or partners competitions which limit the difference between partners' handicaps, the limit of that difference,
//	usually resulting in the adjustment (reduction) of the higher-handicapped partner's handicap allowance.

float GOLFHandicapDefaultLimitsPctAdjForAuthority(GOLFHandicapAuthority *authority);
//	In foursomes or partners competitions which limit the difference between partners' handicaps, the percentage reduction (0.0 - 100.0)
//	of BOTH partner's, or ALL teammates' handicap allowances.

NSInteger GOLFHandicapDifferentialsToUseForAuthority(GOLFHandicapAuthority *authority, NSInteger numberOfScores);
//	In handicapping methods based on the calculation of Handicap Differentials, the number of those "best" differentials to be used for handicap calculation
//	USGA - best 10 of last 20 differentials, WHS - best 8 of last 20 differentials, etc.

GOLFHandicapDifferential GOLFHandicapExceptionalScoringReductionForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex excessIndex, NSInteger eligibleScores);
//	In handicapping methods with adjustments for exceptional scoring, the amount of that adjustment based on the number of eligible scores and the amount
//	by which those scores exceed the player's expected performance.

