//
//  GOLFScoring.h
//  GOLFKit
//
//  Created by John Bishop on 4/2/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKitTypes.h"

#define kNotAScore						-999		//	No-value for a whole-number score - GOLFScore
#define kNotAGrossScore					-999		//	No-value for a gross score - GOLFGrossScore
#define kNotPutts						-999		//	No-value for number of putts - GOLFPutts
#define kNotANetScore					-999.0		//	No-value for net score - GOLFNetScore
#define kNotACompScore					-999.0		//	No-value for comp score - GOLFCompScore
#define kNotARoundCCR					-999		//	No-value for round's calculated course rating - GOLFRoundCCR

typedef NS_ENUM(NSUInteger, GOLFAllowanceType) {
	StandardAllowanceType = 0,			//	Regular allowance (for players)
	GrossAllowanceType,					//	Gross - no handicap
	NetAllowanceType,					//	Net team allowance - use team members compScores
	FullHandicapAllowanceType = 10,		//	Full handicap  (Total stroke play)
	Men90Women95AllowanceType,			//	Men 90%, Women 95%  (Best-ball of 2, 2 Best-balls of 4)
	Men80Women90AllowanceType,			//	Men 80%, Women 90%	(Best-ball of 4)
	A60B40AllowanceType,				//	A player 60%, B player 40%	(Chapman/Pinehurst)
	A50B20AllowanceType,				//	A player 50%, B player 20%
	SpecifiedPercentAllowanceType,		//	A specified percentage of course handicap
	AverageCombinedAllowanceType = 20,	//	Average team handicap  (Foursomes)
	AverageCombined80AllowanceType,		//	80% of average team handicap  (Foursomes w/ selected drive, Scramble)
	Aggregate3EighthsAllowanceType,		//	3/8 of aggregate (37.5% of average) team handicap  (American Foursomes)
	DifferenceAllowanceType = 30,		//	Handicap Difference vs Opponent  (Single Player or Team)
	QuotaAllowanceType,					//	Point Quota (36 / 38 / 18 less Full handicap)		(31)
	ScrambleA50AllowanceType = 40,		//	50% of A Player  (2+ Player Scramble)
	ScrambleA35B15AllowanceType,		//	35% of A Player + 15% of B Player  (2+ Player Scramble)
	ScrambleA25B15C10AllowanceType,		//	25% of A Player + 15% of B Player + 10% of C Player  (3+ Player Scramble)
	ScrambleA20B15C10D5AllowanceType,	//	20% of A Player + 15% of B Player + 10% of C Player + 5% of D Player  (4+ Player Scramble)
	ScrambleScheidAllowanceType = 48,	//	Modified Scheid Scramble  (Single Team 1-time)
	ScrambleZigZagAllowanceType = 49,	//	ZIG-ZAG  (Single Team 1-time)
	CallawayAllowanceType = 50,			//	"Official" Callaway handicap  (Single Player 1-time)
	ScheidAllowanceType,				//	Scheid handicap  (Single Player 1-time)
	PeoriaAllowanceType,				//	Peoria handicap  (Single Player 1-time)
	ModifiedPeoriaAllowanceType,		//	Modified Peoria handicap  (Single Player 1-time)
	System36AllowanceType,				//	System 36 handicap  (Single Player 1-time)
	UnknownAllowanceType = 99			//	Unknown or error allowance type
};

#if !defined(IS_ONE_TIME_SCRAMBLE_ALLOWANCE_TYPE)
	#define IS_ONE_TIME_SCRAMBLE_ALLOWANCE_TYPE(_type)	((((_type) == ScrambleScheidAllowanceType) || ((_type) == ScrambleZigZagAllowanceType)) ? YES : NO)
#endif

#if !defined(IS_ONE_TIME_PLAYER_ALLOWANCE_TYPE)
	#define IS_ONE_TIME_PLAYER_ALLOWANCE_TYPE(_type)	((((_type) >= CallawayAllowanceType) && ((_type) <= System36AllowanceType)) ? YES : NO)
#endif

#if !defined(IS_ANY_ONE_TIME_ALLOWANCE_TYPE)
	#define IS_ANY_ONE_TIME_ALLOWANCE_TYPE(_type)	((IS_ONE_TIME_SCRAMBLE_ALLOWANCE_TYPE(_type) || IS_ONE_TIME_PLAYER_ALLOWANCE_TYPE(_type)) ? YES : NO)
#endif

#if !defined(IS_ANY_PLAYER_DEPENDENT_TEAM_ALLOWANCE_TYPE)
	#define IS_ANY_PLAYER_DEPENDENT_TEAM_ALLOWANCE_TYPE(_type)	(((((_type) >= ScrambleA50AllowanceType) && ((_type) <= ScrambleA20B15C10D5AllowanceType)) || ((_type) == A60B40AllowanceType) || ((_type) == A50B20AllowanceType) || ((_type) == AverageCombinedAllowanceType) || ((_type) == AverageCombined80AllowanceType) || ((_type) == Aggregate3EighthsAllowanceType)) ? YES : NO)
#endif

typedef NS_ENUM(NSUInteger, GOLFPlayType) {
	MedalPlayType = 1,					//	Medal play												(1)
	SelectedHolesPlayType,				//	Medal play with selected holes							(2)
	StablefordPlayType = 10,			//	Stableford												(10)
	FirstStablefordPlayType = StablefordPlayType,
	ModifiedStablefordPlayType,			//	Modified Stableford										(11)
	HalfStablefordPlayType,				//	Half-Stableford											(12)
	ChicagoPlayType,					//	Chicago (modified Stableford)							(13)
	InternationalPlayType,				//	International scoring									(14)
	LastStablefordPlayType = InternationalPlayType,
	NinePointGamePlayType = 20,			//	9's (9-Point Game)										(20)
	SixPointGamePlayType,				//	6-Point Game											(21)
	MedalMatchPlayType,					//	Medal Match Play (2 pts/hole per co-competitor)			(22)
	LastPlayerPlayType = MedalMatchPlayType,
	BetterBallTeamPlayType = 30,		//	Better-ball (1 best ball of team)						(30)
	TwoBestBallsTeamPlayType,			//	2-ball total (2 best balls of team)						(31)
	ThreeBestBallsTeamPlayType,			//	3-ball total (3 best balls of team)						(32)
	TheRitzTeamPlayType,				//	The Ritz (best gross, best net)							(33)
	TheRitzReverseTeamPlayType,			//	The Ritz in Reverse (best net, best gross)				(34)
	FourBallTeamPlayType,				//	Four-ball (1 best ball of 2)							(35)
	FoursomesTeamPlayType = 40,			//	Multi-player ball (Foursomes)							(40)
	FirstTeamOnlyPlayType = FoursomesTeamPlayType,
	GreensomesTeamPlayType,				//	Multi-player ball (Foursomes with selected drive)		(41)
	ScrambleTeamPlayType,				//	Multi-player ball (Scramble)							(42)
	ChapmanTeamPlayType,				//	Multi-player ball (Chapman/Pinehurst)					(43)
	LastTeamOnlyPlayType = ChapmanTeamPlayType,
	AnyTeamOnlyPlayType = 49,			//	Multi-player ball (any type)							(49)
	WaltzTeamPlayType = 50,				//	3-ball (par 3's), 2-ball (par 4's), 1-ball (par 5's)	(50)
	ModifiedWaltzTeamPlayType,			//	2-ball (par 3's and 4's), 1-ball (par 5's)				(51)
	ChaChaChaTeamPlayType,				//	1-ball, 2-balls, 3-balls (repeated)						(52)
	ChaChaTeamPlayType,					//	1-ball, 2-balls (repeated)								(53)
	IrishFourBallTeamPlayType,			//	1-ball (x6), 2-balls (x5), 3-balls (x4), 4-balls (x3)	(54)
	BowmakerThreeBallTeamPlayType,		//	1-ball (x6), 2-balls (x6), 3-balls (x6)					(55)
	TotalTeamPlayType = 80,				//	Team total												(80)
	PlayerAverageTeamPlayType,			//	Team-member average										(81)
	TeamBestNPlayType,					//	Team total of best N rounds	(N = "bestRoundsN")			(82)
	FourballComboTeamPlayType = 89,		//	Multi-teams per scorecard								(89)
	NoTeamPlayType = 90,				//	Individual-only competition								(90)
	TeamOnlyPlayType,					//	Team-only scoring (no individual scoring)				(91)
	UnknownPlayType = 99				//	Unknown or erroneous play type / round style			(99)
};

#if !defined(IS_ANY_PLAYER_PLAY_TYPE)
	#define IS_ANY_PLAYER_PLAY_TYPE(_type)	((((_type) >= MedalPlayType) && ((_type) <= LastPlayerPlayType)) ? YES : NO)
#endif

#if !defined(IS_MEDAL_OR_STABLEFORD_PLAY_TYPE)
	#define IS_MEDAL_OR_STABLEFORD_PLAY_TYPE(_type)	((((_type) >= MedalPlayType) && ((_type) <= LastStablefordPlayType)) ? YES : NO)
#endif

#if !defined(IS_ANY_STABLEFORD_PLAY_TYPE)
	#define IS_ANY_STABLEFORD_PLAY_TYPE(_type)	((((_type) >= FirstStablefordPlayType) && ((_type) <= LastStablefordPlayType)) ? YES : NO)
#endif

#if !defined(IS_SCORECARD_GAME_PLAY_TYPE)
	#define IS_SCORECARD_GAME_PLAY_TYPE(_type)	((((_type) == NinePointGamePlayType) || ((_type) == SixPointGamePlayType) || ((_type) == MedalMatchPlayType)) ? YES : NO)
#endif

#if !defined(IS_ANY_POINTS_PLAY_TYPE)
	#define IS_ANY_POINTS_PLAY_TYPE(_type)	((IS_ANY_STABLEFORD_PLAY_TYPE(_type) || IS_SCORECARD_GAME_PLAY_TYPE(_type)) ? YES : NO)
#endif

#if !defined(IS_TEAM_ONLY_PLAY_TYPE)
	#define IS_TEAM_ONLY_PLAY_TYPE(_type)	((((_type) >= FirstTeamOnlyPlayType) && ((_type) <= LastTeamOnlyPlayType)) ? YES : NO)
#endif

#if !defined(IS_ANY_POINT_QUOTA_PLAY_TYPE)
	#define IS_ANY_POINT_QUOTA_PLAY_TYPE(_type)	((((_type) >= StablefordPlayType) && ((_type) <= ChicagoPlayType)) ? YES : NO)
#endif

#if !defined(IS_POINT_QUOTA_COMPATIBLE_PLAY_TYPE)
	#define IS_POINT_QUOTA_COMPATIBLE_PLAY_TYPE(_type)	((((_type) == NoTeamPlayType) || ((_type) == TotalTeamPlayType) || ((_type) == TeamBestNPlayType)) ? YES : NO)
#endif

typedef NS_ENUM(NSUInteger, GOLFTiebreakerMethod) {
	GOLFTiebreakerMethodNone = 0,			//	No tie-breaking
	GOLFTiebreakerMethodUSGA,				//	USGA scorecard tie-breaking method (back nine, last 6, last 3, last hole)
	GOLFTiebreakerMethodCountBack = GOLFTiebreakerMethodUSGA,
	GOLFTiebreakerMethodHandicapsForward,	//	Hole-by-hole handicap tie-breaking method (no. 1 handicap, no. 2 handicap, etc.)
	GOLFTiebreakerMethodHandicapsBackward,	//	Hole-by-hole handicap tie-breaking method (no. 18 handicap, no. 17 handicap, etc.)
	GOLFTiebreakerMethodHolesForward,		//	Hole-by-hole handicap tie-breaking method (1st hole, 2nd hole, etc.)
	GOLFTiebreakerMethodHolesBackward,		//	Hole-by-hole handicap tie-breaking method (18th hole, 17th hole, etc.)
	GOLFTiebreakerMethodHigherHandicap,		//	Higher team or individual handicap wins
	GOLFTiebreakerMethodLowerHandicap,		//	Lower team or individual handicap wins
	GOLFTiebreakerMethodUnknown = 99		//	Unknown or error method
};

typedef NS_ENUM(NSUInteger, GOLFTiebreakerOutcome) {
	GOLFTiebreakerOutcomeTied = 0,			//	Couldn't break tie
	GOLFTiebreakerOutcomeHoleScore,			//	Tie was broken by score at a particular hole (forward, backward, hole handicaps, hole numbers)
	GOLFTiebreakerOutcomeLastHole,			//	Tie was broken based on score of last hole
	GOLFTiebreakerOutcomeLast3Holes,		//	Tie was broken based on total score of last 3 holes
	GOLFTiebreakerOutcomeLast6Holes,		//	Tie was broken based on total score of last 6 holes
	GOLFTiebreakerOutcomeLast9Holes,		//	Tie was broken based on total score of last 9 holes
	GOLFTiebreakerOutcomeLast18Holes,		//	Tie was broken based on total score of last 18 holes
	GOLFTiebreakerOutcomeRoundTotal,		//	Tie was broken based on total round score
	GOLFTiebreakerOutcomeHandicap,			//	Tie was broken based on individual or team handicap
	GOLFTiebreakerOutcomeRoundComplete,		//	Tie was broken based on complete / incomplete round
	GOLFTiebreakerOutcomeCoinFlip = 98,		//	Tie was broken by lot
	GOLFTiebreakerOutcomeUnknown = 99		//	Unknown or error result
};

typedef NS_ENUM(NSUInteger, GOLFFairwayStatus) {
	GOLFFairwayStatusUnknown = 0,			//	We don't know if a fairway was hit, or there's no fairway (par 3)	(0)
	GOLFFairwayStatusMissed,				//	Fairway designated as missed	(1)
	GOLFFairwayStatusHit,					//	Fairway designated as hit		(2)
	GOLFFairwayStatusForceMissed = 99		//	Force a FairwayMissed setting	(99)
};

//	Status Masks

typedef NS_OPTIONS(NSUInteger, GOLFRoundStatus) {
	GOLFRoundStatusNone						= 0,			//	(0)
	GOLFRoundStatusNoFairways				= 1 << 0,		//	(1)			No fairways hit (not the same as all fairways unknown)
	GOLFRoundStatusIgnoreForHandicapping	= 1 << 1,		//	(2)			Ignored for stats and handicapping
	GOLFRoundStatusIsPenaltyRound			= 1 << 2,		//	(4)			Penalty Round
	GOLFRoundStatusUsesMultipleTees			= 1 << 3,		//	(8)			Round is contested on more than 1 tee
	GOLFRoundStatusUsesSSS					= 1 << 4,		//	(16)		Round's course rated with a Standard Scratch Score
	GOLFRoundStatusNetScoreInTenths			= 1 << 5,		//	(32)		Net scores report to a tenth
	GOLFRoundStatusIsDisqualified			= 1 << 6,		//	(64)		Competitor's round disqualified
	GOLFRoundStatusUses9HoleOverrides		= 1 << 7,		//	(128)		Override handicaps are 9-hole values
	GOLFRoundStatusIsInternetPostedRound	= 1 << 8,		//	(256)		Round has been posted via the internet
	GOLFRoundStatusIsHandicapPostedRound	= 1 << 9,		//	(512)		Round has been posted for handicapping
	GOLFRoundStatusIsMatchRound				= 1 << 10,		//	(1024)		Round was played during Match Play
	GOLFRoundStatusHigherIsBetter			= 1 << 11,		//	(2048)		Comp scoring is in points (higher is better)
	GOLFRoundStatusOptedOutOfSkins			= 1 << 12,		//	(4096)		Competitor has opted out of skins competition in this round
	GOLFRoundStatus13						= 1 << 13,		//	(8192)
	GOLFRoundStatus14						= 1 << 14,		//	(16384)
	GOLFRoundStatusIsMissingCompetitor		= 1 << 15		//	(32768)		Core Data fault on access
};

typedef NS_OPTIONS(NSUInteger, GOLFRoundProcessingStatus) {
	GOLFRoundProcessingStatusNone							= 0,			//	(0)
	GOLFRoundProcessingStatusNeedsYdgUpdate					= 1 << 0,		//	(1)			Need to update yardages and/or totals
	GOLFRoundProcessingStatusNeedsParUpdate					= 1 << 1,		//	(2)			Need to update par and/or totals
	GOLFRoundProcessingStatusNeedsCompParUpdate				= 1 << 2,		//	(4)			Need to update competition par and/or totals
	GOLFRoundProcessingStatusNeedsScoreUpdate				= 1 << 3,		//	(8)			Need to update gross scores and/or totals
	GOLFRoundProcessingStatusNeedsNetScoreUpdate			= 1 << 4,		//	(16)		Need to update net scores and/or totals	
	GOLFRoundProcessingStatusNeedsCompScoreUpdate			= 1 << 5,		//	(32)		Need to update competition scores and/or totals
	GOLFRoundProcessingStatusNeedsPuttsUpdate				= 1 << 6,		//	(64)		Need to update putts and/or totals
	GOLFRoundProcessingStatusOption7						= 1 << 7,		//	(128)
	GOLFRoundProcessingStatusOption8						= 1 << 8,		//	(256)
	GOLFRoundProcessingStatusOption9						= 1 << 9,		//	(512)
	GOLFRoundProcessingStatusOption10						= 1 << 10,		//	(1024)
	GOLFRoundProcessingStatusOption11						= 1 << 11,		//	(2048)
	GOLFRoundProcessingStatusOption12						= 1 << 12,		//	(4096)
	GOLFRoundProcessingStatusOption13						= 1 << 13,		//	(8192)
	GOLFRoundProcessingStatusOption14						= 1 << 14,		//	(16384)
	GOLFRoundProcessingStatusOption15						= 1 << 15,		//	(32768)
	GOLFRoundProcessingStatusNeedsCourseHandicapUpdate		= 1 << 16,		//	(65536)
	GOLFRoundProcessingStatusNeedsHandicapAllowanceUpdate	= 1 << 17		//	(131072)
};

typedef NS_OPTIONS(NSUInteger, GOLFRoundSideStatus) {
	GOLFRoundSideStatusNone						= 0,			//	(0)
	GOLFRoundSideStatusOption0					= 1 << 0,		//	(1)
	GOLFRoundSideStatusOption1					= 1 << 1,		//	(2)
	GOLFRoundSideStatusOption2					= 1 << 2,		//	(4)
	GOLFRoundSideStatusOption3					= 1 << 3,		//	(8)
	GOLFRoundSideStatusIsFront					= 1 << 4,		//	(16)		Round's front side
	GOLFRoundSideStatusOption5					= 1 << 5,		//	(32)
	GOLFRoundSideStatusOption6					= 1 << 6,		//	(64)
	GOLFRoundSideStatusOption7					= 1 << 7,		//	(128)
	GOLFRoundSideStatusOption8					= 1 << 8,		//	(256)
	GOLFRoundSideStatusOption9					= 1 << 9,		//	(512)
	GOLFRoundSideStatusOption10					= 1 << 10,		//	(1024)
	GOLFRoundSideStatusHigherIsBetter			= 1 << 11		//	(2048)		Comp scoring is in points (higher is better)
};

typedef NS_OPTIONS(NSUInteger, GOLFRoundSideProcessingStatus) {
	GOLFRoundSideProcessingStatusNone					= 0,			//	(0)
	GOLFRoundSideProcessingStatusNeedsYdgUpdate			= 1 << 0,		//	(1)			Need to update yardages and/or totals
	GOLFRoundSideProcessingStatusNeedsParUpdate			= 1 << 1,		//	(2)			Need to update par and/or totals
	GOLFRoundSideProcessingStatusNeedsCompParUpdate		= 1 << 2,		//	(4)			Need to update competition par and/or totals
	GOLFRoundSideProcessingStatusNeedsScoreUpdate		= 1 << 3,		//	(8)			Need to update gross scores and/or totals
	GOLFRoundSideProcessingStatusNeedsNetScoreUpdate	= 1 << 4,		//	(16)		Need to update net scores and/or totals	
	GOLFRoundSideProcessingStatusNeedsCompScoreUpdate	= 1 << 5,		//	(32)		Need to update competition scores and/or totals
	GOLFRoundSideProcessingStatusNeedsPuttsUpdate		= 1 << 6,		//	(64)		Need to update putts and/or totals
	GOLFRoundSideProcessingStatusOption7				= 1 << 7,		//	(128)
	GOLFRoundSideProcessingStatusOption8				= 1 << 8		//	(256)
};

typedef NS_OPTIONS(NSUInteger, GOLFRoundHoleStatus) {
	GOLFRoundHoleStatusNone					= 0,			//	(0)
	GOLFRoundHoleStatusGreensideBunkerHit	= 1 << 0,		//	(1)			Greenside bunker hit
	GOLFRoundHoleStatusUpAndDown			= 1 << 1,		//	(2)			Up and Down recorded
	GOLFRoundHoleStatusOption2				= 1 << 2,		//	(4)
	GOLFRoundHoleStatusIsX					= 1 << 3,		//	(8)			Hole is flagged as disqualified
	GOLFRoundHoleStatusIsNetSkin			= 1 << 4,		//	(16)		Hole wins a net skin
	GOLFRoundHoleStatusIsGrossSkin			= 1 << 5,		//	(32)		Hole wins a gross skin
	GOLFRoundHoleStatusIsCompSkin			= 1 << 6,		//	(64)		Hole wins a competition skin
	GOLFRoundHoleStatusOption7				= 1 << 7,		//	(128)
	GOLFRoundHoleStatusOption8				= 1 << 8,		//	(256)
	GOLFRoundHoleStatusOption9				= 1 << 9,		//	(512)
	GOLFRoundHoleStatusOption10				= 1 << 10,		//	(1024)
	GOLFRoundHoleStatusHigherIsBetter		= 1 << 11		//	(2048)		Comp scoring is in points (higher is better)
};


//=================================================================
//	GOLFHoleSelectionInstructionsForAllowanceType(allowanceType)
//=================================================================
NSString * GOLFHoleSelectionInstructionsForAllowanceType(GOLFAllowanceType allowanceType);
//	Returns an appropriate localized instruction string concerning the selection of the holes associated with the specified GOLFAllowanceType


#pragma mark NSStringFrom… Utilities

//=================================================================
//	NSStringOrdinalSuffixFromRank(rank)
//=================================================================
NSString * NSStringOrdinalSuffixFromRank(NSUInteger rank);
//	Returns a localized suffix for a positive integer rank
//	In English, "st", "nd", "rd", "th", "th", etc.


//=================================================================
//	NSStringFromAllowanceType(allowanceType, info, descriptiveText)
//=================================================================
NSString * NSStringFromAllowanceType(GOLFAllowanceType allowanceType, NSDictionary *info, NSString **descriptiveText);
//	Returns a localized title/name of the allowanceType ("Full Handicap", "Callaway", "Handicap Difference", etc.) and
//	optionally (when the address of descriptiveText is provided), a localized description of the type of
//	allowance ("no strokes", "calculated team handicap", etc.)
//
//	info (optional):
//	key					type						description
//	-----------------	-------------------------	-------------------------------------------------------------------------------------
//	handicapAuthority	GOLFHandicapAuthority *		The handicap authority associated with this presentation (default provided if missing)
//	short				NSNumber *					BOOL indicating need for short (abbreviated?) return (if available)
//	allowancePct		NSNumber *					The allowance percentage (of 100) for the SpecifiedPercentAllowanceType (default provided if missing)


//=================================================================
//	NSStringFromPlayType(playType, info, descriptiveText)
//=================================================================
NSString * NSStringFromPlayType(GOLFPlayType playType, NSDictionary *info, NSString **descriptiveText);
//	Returns a localized title/name of the playType ("Medal Play", "Chapman", "Irish Four-Ball", etc.) and
//	optionally (when the address of descriptiveText is provided), a localized description of the style
//	of play ("Ball played alternately after selected drive", etc.)
//
//	info (optional):
//	key					type			description
//	------------------	--------------	-------------------------------------------------------
//	short				NSNumber *		BOOL indicating need for short (abbreviated?) return (if available)
//	bestRoundsN			NSNumber *		Integer N of TeamBestNPlayType (Team total of best N rounds) - default: 4


//=================================================================
//	NSStringFromTiebreakerMethod(method, descriptiveText)
//=================================================================
NSString * NSStringFromTiebreakerMethod(GOLFTiebreakerMethod method, NSString **descriptiveText);
//	Returns a localized title/name of the tiebreaking method ("USGA", "Low Handicap", "Holes, backward", etc.) and
//	optionally (when the address of descriptiveText is provided), a localized description of the tiebreaker
//	("last 9 holes", "hole 18, hole 17, etc.", etc.)


//=================================================================
//	NSStringFromTiebreakerOutcome(outcome, result)
//=================================================================
NSString * NSStringFromTiebreakerOutcome(GOLFTiebreakerOutcome outcome, NSNumber *result);
//	Returns a localized description of the reason a tiebreaker was invoked ("last 6 holes", "complete round", etc.)
//	If available, provide a numeric result that identifies the hole (or handicap, etc.) involved in the tiebreak.

