//
//  GOLFHandicapping.h
//  GOLFKit
//
//  Created by John Bishop on 3/6/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <GOLFKit/GOLFKit.h>

//	Misc constants
#define	kGOLFHandicapMethodsNumberOfCertifiable		7			//	USGA (1) through WHS (6), WHS2020 (10), total of 7
#define	kGOLFHandicapMethodsNumberOfMiscellaneous	3			//	Mulligan (20) through Second-Best (22), total of 3
//													---
#define kGOLFHandicapNumberOfMethods				10			//	Total number of handicapping methods

#define kNotAHandicapIndex							-999.0		//	No-value for GOLFHandicapIndex
#define kNotAnOfficialHandicap						-999.0		//	No-value for GOLFOfficialHandicap
#define kNotAPlayingHandicap						-999		//	No-value for GOLFPlayingHandicap
#define kNotAnUnroundedPlayingHandicap				-999.0		//	No-value for GOLFUnroundedPlayingHandicap
#define kNotAHandicapGrade							-999		//	No-value for GOLFHandicapGrade
#define kNotHandicapStrokes							-999		//	No-value for GOLFHandicapStrokes
#define kNotAHandicapAllowance						-999.0		//	No-value for GOLFHandicapAllowance
#define kNotAHandicapDifferential					-999.0		//	No-value for GOLFHandicapDifferential
#define kMaximumStrokeControlLimit					999			//	Highest limit for stroke control of a GOLFScore
#define kNotAPlayingConditionAdjustment				-999.0		//	No-value for GOLFPlayingConditionAdjustment
#define kNotAnExpectedScore							-999.0		//	No-value for GOLFHandicapExpectedScore

typedef NS_OPTIONS(NSUInteger, GOLFHandicapCalculationOption) {
	GOLFHandicapCalculationOptionNone				= 0,			//	(0)
	GOLFHandicapCalculationOptionsNone				= GOLFHandicapCalculationOptionNone,
	GOLFHandicapCalculationOptionNeed9HoleResult	= 1 << 0,		//	(1)		Need return of a 9-hole handicap
	GOLFHandicapCalculationOptionNeedWomensResult	= 1 << 1,		//	(2)		Need return of a woman's handicap
	GOLFHandicapCalculationOption9HoleHandicap		= 1 << 2,		//	(4)		Provided GOLFHandicapIndex or GOLFPlaying Handicap is for 9 holes
	GOLFHandicapCalculationOption9HoleRating		= 1 << 3,		//	(8)		Provided GOLFTeeCourseRating is for 9 holes
	GOLFHandicapCalculationOption9HoleSLOPE			= 1 << 4,		//	(16)	Provided GOLFTeeSLOPERating is for 9 holes
	GOLFHandicapCalculationOption9HolePar			= 1 << 5,		//	(32)	Provided GOLFPar is for 9 holes
	GOLFHandicapCalculationOptionSpare6				= 1 << 6,		//	(64)
	GOLFHandicapCalculationOptionSpare7				= 1 << 7,		//	(128)
	GOLFHandicapCalculationOptionSuppressVsParAdj	= 1 << 8,		//	(256)	If authority includes it, suppress (Course Rating - Par) adjustment
	GOLFHandicapCalculationOptionEnforceVsParAdj	= 1 << 9,		//	(512)	Do (Course Rating - Par) adjustment if Authority doesn't include it
	GOLFHandicapCalculationOptionSpare10			= 1 << 10		//	(1024)
};

//	For handicap records
typedef NS_OPTIONS(NSUInteger, GOLFRoundHandicapOption) {
	GOLFRoundHandicapOptionNone						= 0,			//	(0)
	GOLFRoundHandicapOptionsNone					= GOLFRoundHandicapOptionNone,
	GOLFRoundHandicapOptionUsed						= 1 << 0,		//	(1)		Round used in handicap latest calculation (ie: one of the best n of last n+)
	GOLFRoundHandicapOptionEligible					= 1 << 1,		//	(2)		Round is identified as eligible for use/review in calculations (stats and handicapping)
	GOLFRoundHandicapOptionTournament				= 1 << 2,		//	(4)		Round identified as a "tournament" or "competition" (vs. "general play") round
	GOLFRoundHandicapOptionCombined					= 1 << 3,		//	(8)		18-hole round constructed (combined) from two 9-hole rounds
	GOLFRoundHandicapOption9Holes					= 1 << 4,		//	(16)	9-hole round
	GOLFRoundHandicapOptionAway						= 1 << 5,		//	(32)	Round identified as played "away" - not at home course
	GOLFRoundHandicapOptionHome						= 1 << 6,		//	(64)	Round identified as played at home course (not exclusive of GOLFRoundHandicapOptionAway)
	GOLFRoundHandicapOptionMatchPlay				= 1 << 7,		//	(128)	Round contested under Match Play
	GOLFRoundHandicapOptionExceptional				= 1 << 8,		//	(256)	Round identified as "exceptional" per handicapping technique
	GOLFRoundHandicapOptionInternet					= 1 << 9,		//	(512)	Round recorded/entered via the internet
	GOLFRoundHandicapOptionPenalty					= 1 << 10,		//	(1024)	Round identified as a "penalty" round - may have adjusted handicap
	GOLFRoundHandicapOptionDiffAdjusted				= 1 << 11,		//	(2048)	Round differential has been adjusted (reduced or increased)
	GOLFRoundHandicapOptionHasExpectedScore			= 1 << 12,		//	(4096)	Round has Expected Score (differential) determined for missing hole scores
	GOLFRoundHandicapOptionSpare13					= 1 << 13		//	(8192)
};

typedef NS_OPTIONS(NSUInteger, GOLFHandicapRecordStatus) {
	GOLFHandicapRecordStatusNone					= 0,			//	(0)
	GOLFHandicapRecordStatusSpare0					= 1 << 0,		//	(1)
	GOLFHandicapRecordStatusLookedUp				= 1 << 1,		//	(2)		Handicap record was constructed from data looked up on the internet
	GOLFHandicapRecordStatusManualAdjustment		= 1 << 2,		//	(4)		Handicap record reflects data for a manually initiated handicap adjustment
	GOLFHandicapRecordStatusSpare3					= 1 << 3,		//	(8)
	GOLFHandicapRecordStatusSpare4					= 1 << 4,		//	(16)
	GOLFHandicapRecordStatusSpare5					= 1 << 5,		//	(32)
	GOLFHandicapRecordStatusSpare6					= 1 << 6,		//	(64)
	GOLFHandicapRecordStatusSpare7					= 1 << 7,		//	(128)
	GOLFHandicapRecordStatusSpare8					= 1 << 8,		//	(256)
	GOLFHandicapRecordStatusSpare9					= 1 << 9,		//	(512)
	GOLFHandicapRecordStatusSpare10					= 1 << 10		//	(1024)
};

typedef NS_ENUM(NSUInteger, GOLFHandicapMethodIndex) {
	GOLFHandicapMethodNone = 0,					//	none (0)
	GOLFHandicapMethodUSGA,						//	USGA Handicap System (1)
	GOLFHandicapMethodRCGA,						//	RCGA (Golf Canada) Handicap System (2)
	GOLFHandicapMethodAGU,						//	AGU (Golf Australia) Handicap System (3)
	GOLFHandicapMethodEGA,						//	EGA (European Golf Association) Handicap System (4)
	GOLFHandicapMethodCONGU,					//	CONGU Unified Handicap System (5)
	GOLFHandicapMethodWHS,						//	World Handicap System (USGA/Generic/current) (6)
	GOLFHandicapMethodWHS2020 = 10,				//	World Handicap System (eff. 1/1/2020) (10)
	GOLFHandicapMethodMulligan = 20,			//	Mulligan Handicap System (20)			*
	GOLFHandicapMethodPersonal = 21,			//	Personalized Handicap System (21)		*
	GOLFHandicapMethodSecondBest = 22,			//	Second-Best Score Handicap System (22)	*
	GOLFHandicapMethodUnknown = 999				//	Unknown handicapping type
	//	* - created only on macOS - used without alteration in iOS	
};

typedef NS_ENUM(NSUInteger, GOLFHandicapStrokeControl) {
	GOLFHandicapStrokeControlNone = 0,			//	Don't adjust strokes for handicapping				(0)
	GOLFHandicapStrokeControlDoubleBogey,		//	Limit to gross double-bogey							(1)
	GOLFHandicapStrokeControlNetDoubleBogey,	//	Limit to net double-bogey							(2)
	GOLFHandicapStrokeControlDoubleBogeyPlus10,	//	Limit to double-bogey plus 10% of playing handicap	(3)
	GOLFHandicapStrokeControlTripleBogey,		//	Limit to gross triple-bogey							(4)
	GOLFHandicapStrokeControlNetTripleBogey,	//	Limit to net triple-bogey							(5)
	GOLFHandicapStrokeControlESC = 10,			//	Equitable Stroke Control (ESC) limit				(10)
	GOLFHandicapStrokeControlUnknown = 99		//	Unknown stroke control technique
};

typedef NS_ENUM(NSUInteger, GOLFHandicapExpectedScoreMethod) {
	GOLFHandicapExpectedScoreMethodNone = 0,			//	Don't calculate Expected Scores						(0)
	GOLFHandicapExpectedScoreMethodNetPar,				//	Calculate net par (nines or unplayed holes)			(1)
	GOLFHandicapExpectedScoreMethodNetParPlus1,			//	Calculate net par (nines or unplayed holes)			(2)
	GOLFHandicapExpectedScoreMethodUsingRecord,			//	Calculate from active scores record (last 20?)		(3) *
	GOLFHandicapExpectedScoreMethodUsingHistory,		//	Calculate from scoring history (last 365 days?)		(4)	*
	GOLFHandicapExpectedScoreMethodUSGATable = 10,		//	Calculate with USGA Expected Score table			(10)
	GOLFHandicapExpectedScoreMethodUnknown = 99			//	Unknown method for Expected Score calculations
};

typedef NS_ENUM(NSUInteger, GOLFHandicapDifferentialType) {
	GOLFHandicapDifferentialTypeOverPar = 0,			//	Strokes over par						(0)
	GOLFHandicapDifferentialTypeOverRating,				//	Strokes over course rating				(1)
	GOLFHandicapDifferentialTypeOverCCR,				//	Strokes over CCR or CSS					(2)
	GOLFHandicapDifferentialTypeStableford,				//	Relationship to Stableford points		(3)
	GOLFHandicapDifferentialTypeSlopeAndRating = 10,	//	Slope & Rating based					(10)
	GOLFHandicapDifferentialTypeAdjustedSlopeAndRating,	//	Slope & Rating par adjusted (like WHS)	(11)
	GOLFHandicapDifferentialTypeUnknown = 99			//	Unknown differential type
};

typedef NS_ENUM(NSUInteger, GOLFPlayingHandicapType) {
	GOLFPlayingHandicapTypeUnadjusted = 0,			//	Playing handicap is same as handicap index						(0)
	GOLFPlayingHandicapTypeRatingAdjusted,			//	Handicap index adjusted to par with course rating				(1)
	GOLFPlayingHandicapTypeFullyAdjusted,			//	Handicap index adjusted to par with slope and course ratings	(2)
	GOLFPlayingHandicapTypeSlopeAdjusted = 10,		//	Playing handicap adjusted to course rating with slope rating	(10)
	GOLFPlayingHandicapTypeUnknown = 99				//	Unknown playing handicap style
};

typedef NS_ENUM(NSUInteger, GOLFHandicapCalculationScheduleType) {
	GOLFHandicapCalculationScheduleTypeNone = 0,		//	No handicap calculation schedule set (None)				(0)
	GOLFHandicapCalculationScheduleTypeDaily,			//	Handicap calculation daily								(1)
	GOLFHandicapCalculationScheduleTypeWeekly = 10,		//	Handicap calculation weekly on a specified weekday		(10)
	GOLFHandicapCalculationScheduleTypeMonthly = 20,	//	Handicap calculation monthly on a specified day			(20)
	GOLFHandicapCalculationScheduleTypeMonthEnd			//	Handicap calculation on the last day of the month		(21)
};

typedef NS_ENUM(NSUInteger, GOLFPlayersSelectionType) {
	GOLFPlayersSelectionTypeAll = 0,		//	All eligible players							(0)
	GOLFPlayersSelectionTypeClubMembers,	//	Members of the selected home club				(1)
	GOLFPlayersSelectionTypeAuthority,		//	Players handicapped by a selected authority		(2)
	GOLFPlayersSelectionTypeSelected,		//	Selected in the Players list					(3)
	GOLFPlayersSelectionTypeUnknown = 99	//	Unknown selectionType or error					(99)
};

extern GOLFHandicapAuthority * const GOLFHandicapAuthorityUSGA;			//	"USGA"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityRCGA;			//	"RCGA"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityAGU;			//	"AGU"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityEGA;			//	"EGA"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityCONGU;		//	"CONGU"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityWHS;			//	"WHS"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityWHS2020;		//	"WHS2020"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityMulligan;		//	"MULLIGAN"
extern GOLFHandicapAuthority * const GOLFHandicapAuthoritySecondBest;	//	"SECONDBEST"
extern GOLFHandicapAuthority * const GOLFHandicapAuthorityPersonal;		//	"PERSONAL"

GOLFHandicapAuthority * GOLFDefaultHandicapAuthority(void);
//	Without any further help, return an appropriate GOLFHandicapAuthority
//	Last resort is "WHS"

GOLFHandicapAuthority * GOLFHandicapAuthorityFromMethodIndex(GOLFHandicapMethodIndex methodIndex);
//	Returns the GOLFHandicapAuthority mnemonic that best represents the handicapping method indicated by the methodIndex.
//	The returned string mnemonic may be used to identify the organization responsible for administering the handicapping
//	system, or to lookup or calculate handicapping information related to the handicapping method.
//	Returns nil if the methodIndex is zero (GOLFHandicapMethodNone), unknown (GOLFHandicapMethodUnknown) or invalid.

GOLFHandicapMethodIndex GOLFHandicapBestMethodIndexFromAuthority(GOLFHandicapAuthority *authority);
//	Returns the best (guess/most likely) GOLFHandicapMethodIndex for a specified handicap authority mnemonic, whether good, bad, or missing
//	Will NOT return GOLFHandicapMethodUnknown

NSArray * GOLFHandicapAuthorities(void);	//	An array of dictionaries
//	Returns an NSArray of NSDictionaries, each with information about an available handicapping authority and the
//	handicapping system used by its golfers:
//
//	Key						Type			Description
//	----------------------	--------------	---------------------------------
//	methodIndex				NSNumber *		GOLFHandicapMethodIndex identifying the handicapping authority
//	handicapAuthority		NSString *		A mnemonic identifying the handicapping authority - used in most handicapping function calls
//	authorityDisplay		NSString *		A mnemonic for display identifying the handicapping authority
//	association				NSString *		The localized name of the handicapping association (authority)
//	URL						NSString *		The URL of the handicapping association (authority) web site
//	methodName				NSString *		The localized name of the handicap SYSTEM supported by the authority
//	certifiable				NSNumber *		A BOOL indicating whether the handicap method requires certification for use
//	obsolete				NSNumber *		A BOOL indicating that handicapping method can't be a default setting

NSString * GOLFHandicapIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title for an "official" calculated handicap ("Handicap Index®", "Índice de Handicap", "Exakt Handicapen", etc.)

NSString * GOLFHandicapIndexCasualTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title for a calculated handicap, without marks ("Handicap Index", "Índice de Handicap", "Exakt Handicapen", etc.)

NSString * GOLFHandicapCurrentIndexTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title as above with a "current" qualifier ("Current Handicap Index", "Índice de Handicap Actual", "Aktuellen Exakt Handicapen")

NSString * GOLFOfficialHandicapTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title for an "official" calculated handicap ("Handicap Index®", "Índice de Handicap", "Exakt Handicapen", etc.)

NSString * GOLFPlayingHandicapTitle(GOLFHandicapMethodIndex handicapMethod, BOOL plural);
//	Returns a localized title for the handicap strokes for play ("Course Handicap", "Handicap de Campo", "EGA Handicap Jouer", etc.)

NSString * GOLFHandicapAccountNumberTitle(GOLFHandicapMethodIndex handicapMethod);
//	Returns a localized title describing the handicapping account number name ("GHIN Number", "Handicap ID", etc.)

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

NSString * GOLFHandicapTableBlurb(GOLFHandicapMethodIndex handicapMethod);	//	Slope Chart (Handicap Table) definition blurb
//	Returns a localized descriptive blurb for how the contents of a Playing Handicap table are determined

NSString * GOLFHandicapTableInstruction(GOLFHandicapMethodIndex handicapMethod);	//	Slope Chart (Handicap Table) selection instruction
//	Returns a localized instruction for identifying your playing handicap on the right from the range of handicap indexes on the left

NSString * GOLFHandicapCalculationFormula(GOLFHandicapMethodIndex handicapMethod, BOOL usingSSS);	//	Playing Handicap formula
//	Returns a localized descriptive formula for the computation of a Playing Handicap ("Handicap Index x Slope Rating / 113 (rounded)", etc.)

//	Authority-specific data
BOOL GOLFHandicapCertifiableAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the use of the handicapping method of this authority requires certification

BOOL GOLFHandicapValidAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether this authority is (still?) valid for use

NSDictionary * GOLFHandicapInfoForAuthority(GOLFHandicapAuthority *authority);
//	Returns the entry in GOLFHandicapAuthorities() with information about the handicapping authority and the
//	handicapping system used by its golfers.  Returns nil if there is no such authority.

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
//	Returns the short (1 character) modified used to indicate that a handicap has been adjusted for exceptional scores in a player's scoring record ("R", etc.)

NSString * GOLFHandicapCombinedScoresModifierForAuthority(GOLFHandicapAuthority *authority);
//	Returns the short (1 character) modified used to indicate that a round is composed from the consolidation of 2 9-hole rounds ("C", etc.)

NSString * GOLFHandicapTournamentScoreModifierForAuthority(GOLFHandicapAuthority *authority);
//	Returns the short (1 character) modified used to indicate that a round was contested in a tournament or designated competition ("T", etc.)

NSString * GOLFHandicapTournamentTitleForAuthority(GOLFHandicapAuthority *authority);
//	Returns a localized title used to identify a tournament or designated competition round ("Tournament", "Designate Competition", etc.)

NSString * GOLFHandicapServiceAccountIDForAuthority(GOLFHandicapAuthority *authority);
//	Returns a localized name of the handicapping service identifier ("GHIN number", "GOLFLink account", etc.)

NSString * GOLFRoundModifierTooltip(GOLFHandicapAuthority *authority);
//	Returns the appropriate tooltip (with line feeds) tabulating the description of round modifiers ("* - used", "T - Torneo", "E - Estimado", etc.

BOOL GOLFHandicap9HoleHandicapsSupported(GOLFHandicapAuthority *authority);
//	Indicates whether the handicapping method of this authority supports 9-hole handicap indexes

BOOL GOLFHandicapStablefordRequiredForAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the handicapping method of this authority requires Stableford scores or equivalents for handicap calculation

BOOL GOLFHandicapIncludesRatingsAdjustmentForAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the handicapping method of this authority includes an adjustment for course rating (and perhaps par) in its playing handicap calculation

BOOL GOLFDoesTournamentAdjustmentForAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the handicapping method of this authority accommodates adjustments or special handling for "tournament" (T) scores

BOOL GOLFHandicapCCRUsedForAuthority(GOLFHandicapAuthority *authority, BOOL *required);
//	Indicates whether the handicapping method for this authority uses (or requires) a conditions-dependent CCR or CSS returned for scores used for handicapping

BOOL GOLFHandicapPreciseAllowancesForAuthority(GOLFHandicapAuthority *authority);
//	Indicates whether the handicapping method for this authority uses (if available) unrounded playing handicaps to calculate allowances (rounded or not)

GOLFHandicapExpectedScoreMethod GOLFHandicapExpectedScoreMethodForAuthority(GOLFHandicapAuthority *authority);
//	Indicates the method for this authority by which an expected score or differential is calculated.

GOLFPlayingConditionAdjustment GOLFHandicapPCCMinimumAdjustmentForAuthority(GOLFHandicapAuthority *authority);
//	Returns the minimum legal PCC (Playing Condition Calculation) adjustment for this authority (usually a WHS authority)

GOLFPlayingConditionAdjustment GOLFHandicapPCCMaximumAdjustmentForAuthority(GOLFHandicapAuthority *authority);
//	Returns the maximum legal PCC (Playing Condition Calculation) adjustment for this authority (usually a WHS authority)

GOLFHandicapStrokes GOLFHandicapDefaultLimitsDifferenceForAuthority(GOLFHandicapAuthority *authority);
//	In foursomes or partners competitions which limit the difference between partners' handicaps, the limit of that difference,
//	usually resulting in the adjustment (reduction) of the higher-handicapped partner's handicap allowance.

float GOLFHandicapDefaultLimitsPctAdjForAuthority(GOLFHandicapAuthority *authority);
//	In foursomes or partners competitions which limit the difference between partners' handicaps, the percentage reduction (0.0 - 100.0)
//	of BOTH partner's, or ALL teammates' handicap allowances.

NSUInteger GOLFHandicapScoringRecordSizeForAuthority(GOLFHandicapAuthority *authority);
//	The maximum number of valid rounds (9 or 18-hole) that constitute a full scoring record from which a current official
//	handicap can be derived - excluding earlier (historical) rounds that might be examined to establish handicapping limits.

NSInteger GOLFHandicapDifferentialsToUseForAuthority(GOLFHandicapAuthority *authority, NSInteger numberOfScores, float *newHandicapAdj);
//	In handicapping methods based on the calculation of Handicap Differentials, the number of those "best" differentials to be used for handicap calculation
//	USGA - best 10 of last 20 differentials, WHS - best 8 of last 20 differentials with adjustment, etc.

GOLFHandicapDifferential GOLFHandicapExceptionalScoringReductionForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex excessIndex, NSInteger eligibleScores);
//	In handicapping methods with adjustments for exceptional scoring, the amount of that adjustment based on the number of eligible scores and the amount
//	by which those scores exceed the player's expected performance.

GOLFTeeSLOPERating GOLFHandicapUnratedSLOPERatingForAuthority(GOLFHandicapAuthority *authority);
//	The appropriate SLOPE Rating to be used for unrated tees

GOLFScore GOLFHandicapStrokeControlLimitForAuthority(GOLFHandicapAuthority *authority, GOLFPlayingHandicap playingHandicap, GOLFHandicapCalculationOption options, NSDictionary *info);
//	Handicapping stroke control for rounds, roundSides, roundHoles
//
//	GOLFHandicapAuthority *			authority		required		Handicap authority
//	GOLFPlayingHandicap *			playingHandicap	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAPlayingHandicap is valid)
//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
//	NSDictionary *					info			optional		optional parameters (described below)
//
//	options:
//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFPlayingHandicap is for 9 holes
//
//	info:
//	key					type			description
//	------------------	--------------	-------------------------------------------------------
//	referenceObject		id				a <GOLFHandicapDataSource> that responds to strokeControlInfo:

GOLFPlayingHandicap GOLFPlayingHandicapFor(GOLFHandicapAuthority *authority, GOLFHandicapIndex handicapIndex, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, NSDictionary *info, GOLFUnroundedPlayingHandicap *unRounded);
//	Playing handicap calculation per the authority
//
//	GOLFHandicapAuthority *			authority		required		Handicap authority
//	GOLFHandicapIndex				handicapIndex	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAHandicapIndex is valid)
//	GOLFTeeCourseRating				courseRating	required		18 holes unless GOLFHandicapCalculationOption9HoleRating (kNotACourseRating is valid)
//	GOLFTeeSLOPERating				slopeRating		required		18 holes unless GOLFHandicapCalculationOption9HoleSLOPE (kNotASLOPERating is valid)
//	GOLFPar							par				required		18 holes unless GOLFHandicapCalculationOption9HolePar (kNotAPar is valid)
//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
//	NS(Mutable)Dictionary *			info			optional		optional parameters (described below)
//	GOLFUnroundedPlayingHandicap *	unrounded		optional		optional unrounded result destination
//
//	options:
//	GOLFHandicapCalculationOptionNeed9HoleResult	(1)		Need return of a 9-hole handicap
//	GOLFHandicapCalculationOptionNeedWomensResult	(2)		Need return of a woman's handicap
//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFHandicapIndex or GOLFPlayingHandicap is for 9 holes
//	GOLFHandicapCalculationOption9HoleRating		(8)		Provided GOLFTeeCourseRating is for 9 holes
//	GOLFHandicapCalculationOption9HoleSLOPE			(16)	Provided GOLFTeeSLOPERating is for 9 holes
//	GOLFHandicapCalculationOption9HolePar			(32)	Provided GOLFPar is for 9 holes
//	GOLFHandicapCalculationOptionSuppressVsParAdj	(256)	If authority includes it, suppress (Course Rating - Par) adjustment
//	GOLFHandicapCalculationOptionEnforceVsParAdj	(512)	Do (Course Rating - Par) adjustment if Authority doesn't include it
//
//	info:
//	key					type			description
//	------------------	--------------	-------------------------------------------------------
//	is9HoleResult		NSNumber *		BOOL indicating result is for 9-hole play
//	isWomensResult		NSNumber *		BOOL indicating result is for women
//	unroundedResult		NSNumber *		GOLFUnroundedPlayingHandicap of the returned GOLFPlayingHandicap
//	referenceObject		id				a <GOLFHandicapDataSource> with data of interest
//	need9HoleHandicap	NSNumber *		(legacy) BOOL (TRUE --> courseRating and/or par are 9-hole values)
//	needWomensHandicap	NSNumber *		(legacy) BOOL (TRUE --> courseRating and/or par are women's values)
//	event				id				(legacy) an event <GOLFHandicapDataSource> with handicap data
//	roundSide			id				(legacy) a side <GOLFHandicapDataSource> with handicap data
//	round				id				(legacy) a round <GOLFHandicapDataSource> with handicap data
//	courseRating		NSNumber *		(legacy) 9 or 18-hole course rating value
//	par					NSNumber *		(legacy) 9 or 18-hole par

CGPoint GOLFLowHighIndexesAsPointFor(GOLFHandicapAuthority *authority, GOLFPlayingHandicap playingHandicap, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, id <GOLFHandicapDataSource>referenceSource);
//	Handicap Index range for a Playing Handicap
//
//	GOLFHandicapAuthority *			authority		required		Handicap authority
//	GOLFPlayingHandicap				playingHandicap	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAPlayingHandicap is valid)
//	GOLFTeeCourseRating				courseRating	optional		18 holes unless GOLFHandicapCalculationOption9HoleRating (kNotACourseRating is valid)
//	GOLFTeeSLOPERating				slopeRating		optional		18 holes unless GOLFHandicapCalculationOption9HoleSLOPE (kNotASLOPERating is valid)
//	GOLFPar							par				optional		18 holes unless GOLFHandicapCalculationOption9HolePar (kNotAPar is valid)
//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
//	GOLFHandicapDataSource			referenceSource	optional		optional <GOLFHandicapDataSource> - most likely a tee
//
//	options:
//	GOLFHandicapCalculationOptionNeed9HoleResult	(1)		Need return of a 9-hole Handicap Index range
//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFPlayingHandicap is for 9 holes
//	GOLFHandicapCalculationOption9HoleRating		(8)		Provided GOLFTeeCourseRating is for 9 holes
//	GOLFHandicapCalculationOption9HoleSLOPE			(16)	Provided GOLFTeeSLOPERating is for 9 holes
//	GOLFHandicapCalculationOption9HolePar			(32)	Provided GOLFPar is for 9 holes
//	GOLFHandicapCalculationOptionSuppressVsParAdj	(256)	If authority includes it, suppress (Course Rating - Par) adjustment
//	GOLFHandicapCalculationOptionEnforceVsParAdj	(512)	Do (Course Rating - Par) adjustment if Authority doesn't include it

GOLFPlayingHandicap GOLFFirstLocalHandicapForAuthority(GOLFHandicapAuthority *authority, GOLFHandicapIndex limitingIndex, GOLFTeeCourseRating courseRating, GOLFTeeSLOPERating slopeRating, GOLFPar par, GOLFHandicapCalculationOption options, id <GOLFHandicapDataSource>referenceSource);
//	The first local (club) handicap following the last (limiting) official handicap index
//
//	GOLFHandicapAuthority *			authority		required		Handicap authority
//	GOLFHandicapIndex				limitingIndex	required		18 holes unless GOLFHandicapCalculationOption9HoleHandicap (kNotAHandicapIndex is valid)
//	GOLFTeeCourseRating				courseRating	required		18 holes unless GOLFHandicapCalculationOption9HoleRating (kNotACourseRating is valid)
//	GOLFTeeSLOPERating				slopeRating		required		18 holes unless GOLFHandicapCalculationOption9HoleSLOPE (kNotASLOPERating is valid)
//	GOLFPar							par				required		18 holes unless GOLFHandicapCalculationOption9HolePar (kNotAPar is valid)
//	GOLFHandicapCalculationOption	options			required		Calculations options or GOLFHandicapCalculationOptionNone
//	GOLFHandicapDataSource			referenceSource	optional		optional <GOLFHandicapDataSource> - most likely a tee
//
//	options:
//	GOLFHandicapCalculationOptionNeed9HoleResult	(1)		Need return of a 9-hole handicap
//	GOLFHandicapCalculationOptionNeedWomensResult	(2)		Need return of a woman's handicap
//	GOLFHandicapCalculationOption9HoleHandicap		(4)		Provided GOLFPlayingHandicap is for 9 holes
//	GOLFHandicapCalculationOption9HoleRating		(8)		Provided GOLFTeeCourseRating is for 9 holes
//	GOLFHandicapCalculationOption9HoleSLOPE			(16)	Provided GOLFTeeSLOPERating is for 9 holes
//	GOLFHandicapCalculationOption9HolePar			(32)	Provided GOLFPar is for 9 holes
//	GOLFHandicapCalculationOptionSuppressVsParAdj	(256)	If authority includes it, suppress (Course Rating - Par) adjustment
//	GOLFHandicapCalculationOptionEnforceVsParAdj	(512)	Do (Course Rating - Par) adjustment if Authority doesn't include it

#pragma mark Localization & non-authority utilities

NSString * NSStringFromGOLFHandicapExpectedScoreMethod(GOLFHandicapExpectedScoreMethod method, NSString **descriptiveText);
//	Returns an appropriate localized title identifying an Expected Score calculation method.  Optionally returns a description.

NSString * NSStringFromGOLFHandicapCalculationScheduleType(GOLFHandicapCalculationScheduleType type, NSString **descriptiveText, NSInteger *specifiedDay);
//	Returns an appropriate localized title identifying a handicap calculation schedule type.  Optionally returns a description.

