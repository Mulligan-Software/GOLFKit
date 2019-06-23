//
//  GOLFWagering.h
//  GOLFKit
//
//  Created by John Bishop on 3/10/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKit.h"

//	Misc constants
//#define	kGOLFWageringSupportsCloseOuts		YES			//	Whether GOLFKit supports "Close-Out" bets

typedef NS_ENUM(NSUInteger, GOLFWageringMatchStyle) {
	GOLFWageringMatchPlayMatchStyle,		//	(0)
	GOLFWageringNassauMatchStyle,			//	(1)
	GOLFWageringFrontAndBackMatchStyle,		//	(2)
	GOLFWageringThreeBySixMatchStyle,		//	(3)
	GOLFWageringLastMatchStyle = GOLFWageringThreeBySixMatchStyle,
	GOLFWageringUnknownMatchStyle = 99		//	Unknown
};

typedef NS_ENUM(NSUInteger, GOLFWageringHandicapStyle) {
	GOLFWageringFullHandicapStyle,			//	(0)
	GOLFWageringDifferenceHandicapStyle,	//	(1)
	GOLFWageringGrossHandicapStyle = 10,	//	(10)
	GOLFWageringUnknownHandicapStyle = 99	//	Unknown
};

typedef NS_ENUM(NSInteger, GOLFBetHoleStatus) {
	GOLFBetNoHoleStatus = -999,					//	No hole status (show blank - white background)
	GOLFBetBWonHoleStatus = -99,				//	B has won (show • character on B background)
	GOLFBetB2UpHoleStatus = -2,
	GOLFBetB1UpHoleStatus = -1,					//	Negative status -1 and down - B leads abs(status)-up
	GOLFBetAllSquareHoleStatus = 0,				//	Match is all square (show - character on white background)
	GOLFBetA1UpHoleStatus = 1,					//	Positive status +1 and up - A leads abs(status)-up
	GOLFBetA2UpHoleStatus = 2,
	GOLFBetAWonHoleStatus = 99,					//	A has won (show • character on A background)
	GOLFBetCloseOutLeaderHoleStatus = 994,		//	Hole after which a close-out begins (causation arrow?)
	GOLFBetPressAddedLeaderHoleStatus = 995,	//	Hole after which a manual press was added (causation arrow?)
	GOLFBetPress2DownLeaderHoleStatus = 996,	//	Hole after which auto 2-down press was added (causation arrow?)
	GOLFBetPress1DownLeaderHoleStatus = 997,	//	Hole after which auto 1-down press was added (causation arrow?)
	GOLFBetInvisibleHoleStatus = 998,			//	Invisible hole status (show no text field)
	GOLFBetErrorHoleStatus = 999				//	Error hole status (show X character on white background)
};

typedef NS_ENUM(NSUInteger, GOLFBetReason) {
	GOLFBetStandardReason,					//	Standard bet for the type of match (match-play, Nassau, etc.)
	GOLFBetAddedPressReason,				//	A manually added press bet
	GOLFBetAutomatic2DownPressReason,		//	An automatic press forced by a 2-down status 
	GOLFBetAutomatic1DownPressReason,		//	An automatic press forced by a 1-down status on the last hole
	GOLFBetCloseOutReason,					//	A new bet at next hole after the closeout of a match's standard bet
	GOLFBetUnknownReason = 99				//	Unknown or error reason
};

typedef NS_ENUM(NSUInteger, GOLFBetStatus) {
	GOLFBetNoStatus,						//	No bet status (beginning status)
	GOLFBetNoScores = GOLFBetNoStatus,		//	No scores (ie: no status)
	GOLFBetAllSquare = 1,					//	Match is all square (in progress)
	GOLFBetAAhead,							//	Round A is ahead
	GOLFBetBAhead,							//	Round B is ahead 
	GOLFBetHalved,							//	Match was halved (final)
	GOLFBetAWins,							//	Round A is the winner
	GOLFBetBWins,							//	Round B is the winner
	GOLFBetUnknownStatus = 99				//	Unknown or error status
};

typedef NS_ENUM(NSUInteger, GOLFWageringGameStyle) {
	GOLFWageringGameNone,					//	(0)		No wagering game
	GOLFWageringGameTrash,					//	(1)		Trash, Dots or Wickers
	GOLFWageringGameAnimals,				//	(2)		Snake, Camel, Gorilla, etc.
	GOLFWageringGameHollywood,				//	(3)		Hollywood, Sixes, Round-Robin (6 hole matches)
	GOLFWageringGameSwing,					//	(4)		Swing Game - 2 vs. 3 or more
	GOLFWageringGameWolf,					//	(5)		Wolf - 3 or more
	GOLFWageringGameUnknownStyle = 99		//	Unknown
};

//typedef NS_ENUM(NSUInteger, GOLFWageringScoringSource) {
//	GOLFWageringScoringSourceGross,				//	(0)		Match Play using gross scores
//	GOLFWageringScoringSourceNet = 10,			//	(10)	Match Play using full handicap net scores 
//	GOLFWageringScoringSourceComp = 20,			//	(20)	Match Play using allowance adjusted competition scores
//	GOLFWageringScoringSourceCalculated = 30,	//	(30)	Match Play using calculated scores
//	GOLFWageringScoringSourceTeammates = 40,	//	(40)	Match Play using teammate scores
//	GOLFWageringScoringSourceUnknown = 99		//	Unknown
//};

typedef NS_OPTIONS(NSUInteger, GOLFWageringTrashOption) {
	GOLFWageringTrashNone				= 0,			//	(0)
	GOLFWageringTrashCover				= 1 << 0,		//	(1)			Birdie or better covering opponent's completed birdie or better
	GOLFWageringTrashGreenie			= 1 << 1,		//	(2)			Closest to pin in regulation, par 3 - voided with 3-putt
	GOLFWageringTrashSandie				= 1 << 2,		//	(4)			Up and down from a greenside bunker
	GOLFWageringTrashStobbie			= 1 << 3,		//	(8)			Green in regulation within length of the pin
	GOLFWageringTrashOption4			= 1 << 4,		//	(16)
	GOLFWageringTrashArnie				= 1 << 5,		//	(32)		Par or better without visiting fairway
	GOLFWageringTrashChipinski			= 1 << 6,		//	(64)		Chip-in or hole out from off the green
	GOLFWageringTrashHogan				= 1 << 7,		//	(128)		Par hitting fairway, green in regulation, 2 putts
	GOLFWageringTrashSeve				= 1 << 8,		//	(256)		Birdie or better missing fairway and green
	GOLFWageringTrashPolie				= 1 << 9,		//	(512)		Putt made from outside length of flagstick
	GOLFWageringTrashBingo				= 1 << 10,		//	(1024)		Of three or more, first player to reach the green
	GOLFWageringTrashBango				= 1 << 11,		//	(2048)		Once all players of three or more have reached the green, the closest to the pin
	GOLFWageringTrashBongo				= 1 << 12,		//	(4096)		Of three or more, ball away putting, the first to hole their putt
	GOLFWageringTrashGurglie			= 1 << 13,		//	(8192)		Par or better from, or skipping off, water
	GOLFWageringTrashBarkie				= 1 << 14,		//	(16384)		Par or better off a tree
	GOLFWageringTrashAsphalt			= 1 << 15,		//	(32768)		Par or better from a cart path
	GOLFWageringTrashSnake				= 1 << 16,		//	(65536)		3-putt, last 3-putt, shortest 3-putt
	GOLFWageringTrashOption17			= 1 << 17,		//	(131072)
	GOLFWageringTrashOption18			= 1 << 18,		//	(262144)
	GOLFWageringTrashOption19			= 1 << 19,		//	(524288)
	GOLFWageringTrashOption20			= 1 << 20,		//	(1048576)
	GOLFWageringTrashOption21			= 1 << 21,		//	(2097152)
	GOLFWageringTrashOption22			= 1 << 22,		//	(4194304)
	GOLFWageringTrashOption23			= 1 << 23,		//	(8388608)
	GOLFWageringTrashOption24			= 1 << 24		//	(16777216)
};


@protocol GOLFWageringDataSource <NSObject>

@optional

//	Returns a permanent NSString or NSNumber used to identify a round, competitor, etc. 
//	from which the object might be reconstituted for re-creating match and wagering data
- (id)IDForWagering;

//	Returns YES for rounds (or others) who are eligible (or required) for use in wagering
- (BOOL)isTeamForWagering;

//	Returns the GOLFPlayType for rounds (or others) for use in wagering
- (GOLFPlayType)playTypeForWagering;

//	Returns the GOLFWageringScoringSource for rounds (or others) for use in wagering
//- (GOLFWageringScoringSource)scoringSourceForWagering;

//	Returns the object (itself a <GOLFWageringDataSource>) from the provided zero-based holeIndex
//	Can return nil
- (id)holeAtIndexForWagering:(NSUInteger)holeIndex;

//	Returns a zero-based index from a hole<GOLFWageringDataSource> in a round 
- (NSUInteger)holeIndexForWagering;

//	Returns the hole number (1, 2, ... 18, 19, ... of a hole<GOLFWageringDataSource>  (can be kNotAHoleNumber)
- (GOLFHoleNumber)holeNumberForWagering;

//	Returns the score to be used for match play scoring for a hole<GOLFWageringDataSource>
- (GOLFScore)grossScoreForWagering;

//	Returns the score to be used for match play scoring for a hole<GOLFWageringDataSource>
//- (GOLFNetScore)netScoreForWagering;

//	Returns the score to be used for match play scoring for a hole<GOLFWageringDataSource>
//- (GOLFCompScore)compScoreForWagering;

//	Compares two <GOLFWageringDataSource> objects using their own compare methods and returns the result
//- (NSComparisonResult)compareGrossScoreForWagering:(id<GOLFWageringDataSource>)otherObject;

//	Compares two <GOLFWageringDataSource> objects using their own compare methods and returns the result
//- (NSComparisonResult)compareNetScoreForWagering:(id<GOLFWageringDataSource>)otherObject;

//	Compares two <GOLFWageringDataSource> objects using their own compare methods and returns the result
//- (NSComparisonResult)compareCompScoreForWagering:(id<GOLFWageringDataSource>)otherObject;

//	Compares two <GOLFWageringDataSource> objects net scores calculated from gross score and specified strokes
//- (NSComparisonResult)compareDifferenceNetScoreForWagering:(id<GOLFWageringDataSource>)otherObject;

//	Compares two <GOLFWageringDataSource> objects wagering scores
- (NSComparisonResult)compareMatchScoreForWagering:(id<GOLFWageringDataSource>)otherObject;

//	Returns YES if a round or hole is disqualified ("X" for a hole) in betting calculations
- (BOOL)isDisqualifiedForWagering;

@end


//=================================================================
//	GOLFWageringMatchStylesArray()
//=================================================================
NSArray * GOLFWageringMatchStylesArray(void);
//	returns an NSArray of NSDictionarys with info about Handicap styles
//	used in Match Play and wagering
//
//	key					type		description
//	------------------	----------	--------------------------------------------------
//	styleCode			NSNumber *	GOLFWageringMatchStyle style identifier
//	styleName			NSString *	localized name or title of the match style
//	styleDescription	NSString *	localized additional description of match style

//=================================================================
//	NSStringFromGOLFWageringMatchStyle(styleCode, &descriptiveText)
//=================================================================
NSString * NSStringFromGOLFWageringMatchStyle(GOLFWageringMatchStyle styleCode, NSString **descriptiveText);
//	returns a localized name or title of a match style designated by styleCode
//	When an NSString * designated by descriptiveText is supplied, it contains
//	localized additional descriptive text about the match style

//=================================================================
//	GOLFWageringHandicapStylesArray()
//=================================================================
NSArray * GOLFWageringHandicapStylesArray(void);
//	returns an NSArray of NSDictionarys with info about Handicap styles
//	used in Match Play and wagering
//
//	key					type		description
//	------------------	----------	--------------------------------------------------
//	styleCode			NSNumber *	GOLFWageringHandicapStyle style identifier
//	styleName			NSString *	localized name or title of the handicap style
//	styleDescription	NSString *	localized additional description of handicap style

//=================================================================
//	NSStringFromGOLFWageringHandicapStyle(styleCode, &descriptiveText)
//=================================================================
NSString * NSStringFromGOLFWageringHandicapStyle(GOLFWageringHandicapStyle styleCode, NSString **descriptiveText);
//	returns a localized name or title of a handicap style designated by styleCode
//	When an NSString * designated by descriptiveText is supplied, it contains
//	localized additional descriptive text about the handicap style


//=================================================================
//	NSStringFromTrashOption(trashOption, &descriptiveText)
//=================================================================
NSString * NSStringFromTrashOption(GOLFWageringTrashOption trashOption, NSString **descriptiveText);
//	Returns a localized title/name of a Trash/Dots option ("Greenie", "Sandie", "Stobbie", etc.) and
//	optionally (when the address of descriptiveText is provided), a localized description of the
//	option ("Closest to flagstick in regulation on a par 3", etc.)


//=================================================================
//	NSStringFromGOLFWageringScoringSource(sourceCode)
//=================================================================
//NSString * NSStringFromGOLFWageringScoringSource(GOLFWageringScoringSource sourceCode);
//	returns a localized name or title of a match style designated by styleCode
//	When an NSString * designated by descriptiveText is supplied, it contains
//	localized additional descriptive text about the match style


//=================================================================
//	NSStringFromGOLFWageringHoleStrokes(holeStrokes)
//=================================================================
NSString * NSStringFromGOLFWageringHoleStrokes(GOLFHandicapStrokes holeStrokes);
//	returns a one-character string representing the number of handicap
//	strokes used for wagering at a hole.
//	Generally, a decimal integer character, but negative values (plus handicaps)
//	represented by alphabetic characters ("A" == -1)


//=================================================================
//	GOLFWageringStrokesFromStringByIndex(strokesString, holeIndex)
//=================================================================
GOLFHandicapStrokes GOLFWageringStrokesFromStringByIndex(NSString *strokesString, NSUInteger holeIndex);
//	returns handicap strokes applied (or to be applied) to determine the
//	match play score used at a hole.  
//	Generally strokesString is a 9 or 18 character string of integer characters,
//	But alphabetic characters indicate negative values (plus handicaps) - ("A" == -1)


@interface GOLFBet : NSObject
{
	NSInteger holeStatus[18];	//	The hole status ("up" status) at each hole (transient data)
}

@property (nonatomic, weak) id<GOLFWageringDataSource> ARound;
@property (nonatomic, weak) id<GOLFWageringDataSource> BRound;
@property (nonatomic, strong) NSString *aStrokesString;	//	Lowest-level bet keeps the strokes string
@property (nonatomic, strong) NSString *bStrokesString;	//	Lowest-level bet keeps the strokes string
@property (nonatomic, strong) NSDictionary *betInfo;	//	Lowest-level bet info

@property (nonatomic, weak) GOLFBet *fromBet;
@property (nonatomic, strong) NSMutableSet *presses;	//	Our presses

@property (nonatomic, strong) NSString *betName;

@property (nonatomic, assign) NSInteger reason;
@property (nonatomic, assign) GOLFWageringHandicapStyle handicapStyle;
@property (nonatomic, assign) NSInteger betStatus;
@property (nonatomic, retain) NSString *holesStatus;
@property (nonatomic, assign) NSInteger firstHole;
@property (nonatomic, assign) NSInteger fromHole;
@property (nonatomic, assign) NSInteger fromUp;
@property (nonatomic, assign) NSInteger lastHole;
@property (nonatomic, assign) NSInteger betUp;
@property (nonatomic, assign) NSInteger betToGo;

@property (nonatomic, assign) BOOL does2DownAutomatics;
@property (nonatomic, assign) BOOL does1DownLastHoleAutomatics;
@property (nonatomic, assign) BOOL doesCloseOuts;

#pragma mark Initialization
+ (id)betWithName:(NSString *)newName reason:(NSInteger)reason startingAt:(NSInteger)first endingAt:(NSInteger)last;

- (NSArray *)aHoleScores;	//	from betInfo
- (NSArray *)bHoleScores;	//	from betInfo
- (GOLFScore)aMatchScoreForHoleAt18Index:(NSUInteger)holeIndex;
- (GOLFScore)bMatchScoreForHoleAt18Index:(NSUInteger)holeIndex;
- (GOLFHandicapStrokes)aMatchStrokesForHoleAtIndex:(NSUInteger)holeIndex;
- (GOLFHandicapStrokes)bMatchStrokesForHoleAtIndex:(NSUInteger)holeIndex;
- (GOLFPlayingHandicap)lowHandicap;	//	from betInfo
- (NSString *)lowName;	//	from betInfo

- (NSComparisonResult)compare:(GOLFBet *)otherBet;
- (NSArray *)pressesArray;
- (NSArray *)selfAndPresses;
- (GOLFBet *)myAutomaticTwoDownPress;
- (GOLFBet *)myAutomaticLastHoleOneDownPress;
- (GOLFBet *)myCloseOutBet;
- (GOLFBet *)anyPress;
- (GOLFBet *)anyAddedPress;
- (NSArray *)addedPresses;
- (void)addPress:(GOLFBet *)press;
- (void)removePress:(GOLFBet *)press;
- (void)removeAllPresses;
- (NSInteger)holeStatusForHoleAt18Index:(NSUInteger)holeIndex;
- (void)setHoleStatus:(NSInteger)newStatus forHoleAt18Index:(NSUInteger)holeIndex;
- (BOOL)canBeDeleted;
- (BOOL)canAddPressToHoleAt18Index:(NSUInteger)holeIndex;	//	Manual press
- (GOLFBet *)addPressToHoleAt18Index:(NSUInteger)holeIndex;	//	Manual press
- (void)update;
- (void)updateAutomatics;

#pragma mark Property List Storage
- (NSDictionary *)dictionaryRepresentation;
- (void)setDictionaryRepresentation:(NSDictionary *)dictionary;

@end
