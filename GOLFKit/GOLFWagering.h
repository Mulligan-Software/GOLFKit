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

@protocol GOLFWageringDataSource <NSObject>

@optional

//	Returns a permanent NSString or NSNumber used to identify a round, competitor, etc. 
//	from which the object might be reconstituted for re-creating match and wagering data
- (id)IDForWagering;

//	Returns an object (weakly retained here) reconstituted in context from the provided wageringID
+ (id)objectForWageringID:(id)wageringID inContext:(NSManagedObjectContext *)context;

//	Returns YES for rounds (or others) who are eligible (or required) for use in wagering
- (BOOL)isTeamForWagering;

//	Returns the GOLFPlayType for rounds (or others) for use in wagering
- (GOLFPlayType)playTypeForWagering;

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
- (GOLFNetScore)netScoreForWagering;

//	Compares two <GOLFWageringDataSource> objects using their own compare methods and returns the result
- (NSComparisonResult)compareGrossScoreForWagering:(id<GOLFWageringDataSource>)otherObject;

//	Compares two <GOLFWageringDataSource> objects using their own compare methods and returns the result
- (NSComparisonResult)compareNetScoreForWagering:(id<GOLFWageringDataSource>)otherObject;

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
@property (nonatomic, assign) NSUInteger handicappingStyle;
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

@end
