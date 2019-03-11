//
//  GOLFWagering.m
//  GOLFKit
//
//  Created by John Bishop on 3/10/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

#import "GOLFUtilities.h"
#import "GOLFExtensions.h"
#import "GOLFWagering.h"

@implementation GOLFBet

#pragma mark Initialization

+ (id)betWithName:(NSString *)newName reason:(NSInteger)reason startingAt:(NSInteger)first endingAt:(NSInteger)last {
	GOLFBet *newBet = [[GOLFBet alloc] init];
	newBet.betName = newName;
	newBet.reason = reason;
	newBet.firstHole = first;
	newBet.lastHole = last;
	
	return newBet;
}

- (id)init {
    if (self = [super init]) {
		self.presses = [NSMutableSet setWithCapacity:1];
		self.handicappingStyle = ([[NSUserDefaults standardUserDefaults] boolForKey:@"NetMatchPlay"]
				? [[[NSUserDefaults standardUserDefaults] objectForKey:@"HandicapStyle"] unsignedIntegerValue]
				: GOLFWageringGrossHandicapStyle);
		self.betStatus = GOLFBetNoStatus;
		self.reason = GOLFBetStandardReason;
		self.firstHole = 1;	//	Note these are 1-based!
		self.lastHole = 18;
		
		for (NSUInteger holeIndex = 0; holeIndex < 18; holeIndex++) {
			holeStatus[holeIndex] = GOLFBetNoHoleStatus;
		}
	}
    return self;
}

- (id)ARound {
	if (self.fromBet) {
		return [self.fromBet ARound];
	}
	return _ARound;
}

- (id)BRound {
	if (self.fromBet) {
		return [self.fromBet BRound];
	}
	return _BRound;
}

- (NSString *)aStrokesString {
	if (self.fromBet) {
		return [self.fromBet aStrokesString];
	}
	return _aStrokesString;
}

- (NSString *)bStrokesString {
	if (self.fromBet) {
		return [self.fromBet bStrokesString];
	}
	return _bStrokesString;
}

- (NSDictionary *)betInfo {
	//	betInfo NSDictionary supplied to all bottom-level bets…
	//	key				type			description
	//	--------------	--------------	----------------------------------------------------------------
	//	aRound			SCRRound *		A competitor's round (*** tentative ***)
	//	aScores			NSArray *		0, 9, or 18 (NSNumber *) A team competitor scores for match play
	//	aStrokesString	NSString *		18-character string of strokes given for A competitor (***)
	//	bRound			SCRRound *		B competitor's round (***)
	//	bScores			NSArray *		0, 9, or 18 (NSNumber *) B team competitor scores for match play
	//	bStrokesString	NSString *		18-character string of strokes given for B competitor (***)
	//	lowHandicap		NSNumber *		GOLFPlayingHandicap for the lowest handicap competitor
	//	lowName			NSString *		name of the lowest-handicapped competitor
			
	if (self.fromBet) {
		return [self.fromBet betInfo];
	}
	return _betInfo;
}

//- (void)setBetInfo:(NSDictionary *)info {
//	topLevelBetInfo = info;
//	
//	id<GOLFWageringDataSource> aRound = [info objectForKey:@"aRound"];
//	if (aRound) {
//		self.ARound = aRound;
//	}
//
//	id<GOLFWageringDataSource> bRound = [info objectForKey:@"bRound"];
//	if (bRound) {
//		self.BRound = bRound;
//	}
//	
//	NSString *aStrokesString = [info objecctForKey:@"aStrokesString"];
//	if (aStrokesString) {
//		self.aStrokesString = aStrokesString;
//	}
//	
//	NSString *bStrokesString = [info objecctForKey:@"bStrokesString"];
//	if (bStrokesString) {
//		self.bStrokesString = bStrokesString;
//	}
//}

- (NSArray *)aHoleScores {
	NSDictionary *info = self.betInfo;
	NSArray *holeScores = nil;
	if (info) {
		holeScores = [info objectForKey:@"aScores"];
	}
	if (holeScores == nil) {
		NSMutableArray *workingArray = [NSMutableArray arrayWithCapacity:18];
		NSNumber *workingNumber = [NSNumber numberWithInteger:kNotAScore];
		for (NSUInteger holeIndex = 0; holeIndex < 18; holeIndex++) {
			[workingArray addObject:workingNumber];
		}
		holeScores = [NSArray arrayWithArray:workingArray];
	}
	return holeScores;
}

- (NSArray *)bHoleScores {
	NSDictionary *info = self.betInfo;
	NSArray *holeScores = nil;
	if (info) {
		holeScores = [info objectForKey:@"bScores"];
	}
	if (holeScores == nil) {
		NSMutableArray *workingArray = [NSMutableArray arrayWithCapacity:18];
		NSNumber *workingNumber = [NSNumber numberWithInteger:kNotAScore];
		for (NSUInteger holeIndex = 0; holeIndex < 18; holeIndex++) {
			[workingArray addObject:workingNumber];
		}
		holeScores = [NSArray arrayWithArray:workingArray];
	}
	return holeScores;
}

- (GOLFPlayingHandicap)lowHandicap {
	NSDictionary *info = self.betInfo;
	if (info) {
		NSNumber *workingNumber = [info objectForKey:@"lowHandicap"];
		if (workingNumber) {
			return [workingNumber playingHandicapValue];
		}
	}
	return kNotAPlayingHandicap;
}

- (NSString *)lowName {
	NSDictionary *info = self.betInfo;
	if (info) {
		return [info objectForKey:@"lowName"];
	}
	return nil;
}

- (NSComparisonResult)compare:(GOLFBet *)otherBet {
	if (self.firstHole < otherBet.firstHole) {
		return NSOrderedAscending;
	} else if (self.firstHole > otherBet.firstHole) {
		return NSOrderedDescending;
	} else {
		//	Same beginning hole…  order by ending hole
		if (self.lastHole > otherBet.lastHole) {
			return NSOrderedAscending;
		} else if (self.lastHole < otherBet.lastHole) {
			return NSOrderedDescending;
		} else {
			//	Same beginning and end…  order by reason
			//	GOLFBetStandardReason,				//	(0)		Standard bet for the type of match (match-play, Nassau, etc.)
			//	GOLFBetAddedPressReason,			//	(1)		A manually added press bet
			//	GOLFBetAutomatic2DownPressReason,	//	(2)		An automatic press forced by a 2-down status 
			//	GOLFBetAutomatic1DownPressReason,	//	(3)		An automatic press forced by a 1-down status on the last hole
			//	GOLFBetCloseOutReason,				//	(4)		A new bet at next hole after the closeout of a match's standard bet
			//	GOLFBetUnknownReason = 99			//	(99)	Unknown or error reason
			if (self.reason < otherBet.reason) {
				return NSOrderedAscending;
			} else if (self.reason > otherBet.reason) {
				return NSOrderedDescending;
			}
		}
	}
	return NSOrderedSame;
}

- (NSArray *)pressesArray {
	return [[[self presses] allObjects] sortedArrayUsingSelector:@selector(compare:)];	//	Presses in order
}

- (NSArray *)selfAndPresses {
	NSMutableArray *resultArray = [NSMutableArray arrayWithObject:self];
	for (GOLFBet *press in [self pressesArray]) {
		[resultArray addObjectsFromArray:[press selfAndPresses]];
	}
	return [NSArray arrayWithArray:resultArray];
}

- (GOLFBet *)myAutomaticTwoDownPress {
	for (GOLFBet *press in self.presses) {
		if (press.reason == GOLFBetAutomatic2DownPressReason) {
			return press;
		}
	}
	return nil;
}

- (GOLFBet *)myAutomaticLastHoleOneDownPress {
	for (GOLFBet *press in self.presses) {
		if (press.reason == GOLFBetAutomatic1DownPressReason) {
			return press;
		}
	}
	return nil;
}

- (GOLFBet *)myCloseOutBet {
	for (GOLFBet *press in self.presses) {
		if (press.reason == GOLFBetCloseOutReason) {
			return press;
		}
	}
	return nil;
}

- (GOLFBet *)anyPress {
	GOLFBet *foundPress = [self myAutomaticTwoDownPress];
	if (foundPress == nil) {
		foundPress = [self myAutomaticLastHoleOneDownPress];
		if (foundPress == nil) {
			foundPress = [self myCloseOutBet];
			if (foundPress == nil) {
				foundPress = [self anyAddedPress];
			}
		}
	}
	return foundPress;
}

- (GOLFBet *)anyAddedPress {
	for (GOLFBet *press in self.presses) {
		if (press.reason == GOLFBetAddedPressReason)
			return press;
	}
	return nil;
}

- (NSArray *)addedPresses {
	NSMutableArray *added = [NSMutableArray arrayWithCapacity:1];
	for (GOLFBet *press in self.presses) {
		if (press.reason == GOLFBetAddedPressReason) {
			[added addObject:press];
		}
	}
	return [NSArray arrayWithArray:added];
}

- (void)addPress:(GOLFBet *)press {
	if (press) {
		[self.presses addObject:press];	//	Add it
		[press setFromBet:self];	//	Have the added press point to us
		[press update];	//	Get the hole-by-hole status updated
	}
}

- (void)removePress:(GOLFBet *)press {
	if (press) {
		GOLFBet *parentBet = press.fromBet;
		if (parentBet) {
			[parentBet.presses removeObject:press];
		}
	}
}

- (void)removeAllPresses {
	[self.presses removeAllObjects];
}

- (NSInteger)holeStatusForHoleAt18Index:(NSUInteger)holeIndex {
	return holeStatus[holeIndex % 18];
}

- (void)setHoleStatus:(NSInteger)newStatus forHoleAt18Index:(NSUInteger)holeIndex {
	holeStatus[holeIndex % 18] = newStatus;
}

- (BOOL)canBeDeleted {
	//	Only added presses can be deleted
	return (self.reason == GOLFBetAddedPressReason);
}

- (BOOL)canAddPressToHoleAt18Index:(NSUInteger)holeIndex {
	NSUInteger workingIndex = holeIndex % 18;
	if (workingIndex < self.lastHole) {
		NSInteger firstHoleIndex = self.firstHole - 1;
		if (workingIndex >= firstHoleIndex) {
			NSInteger status = holeStatus[workingIndex];
			
			//	Is the match for this bet already over?
			if ((status == GOLFBetAWonHoleStatus) || (status == GOLFBetBWonHoleStatus)) {
				return NO;
			}
			return ([[self addedPresses] count] < 1);
			
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
			//	At the moment, only Eagle has a setting that allows prohibiting multiple presses at a hole
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ProhibitMultiplePress"]) {
				//	Can't add if there's a 2-down in front of us…
				GOLFBet *testPress = [self automaticTwoDownPress];
				if ((testPress != nil) && ([testPress firstHole] <= holeIndex)) {
					return NO;
				}
				
				//	or a 1-down in front of us…
				testPress = [self automaticLastHoleOneDownPress];
				if ((testPress != nil) && ([testPress firstHole] <= holeIndex)) {
					return NO;
				}
				
				return ([[self addedPresses] count] < 1);
			} else {
				//	Multiple presses allowed
				return YES;
			}
#endif
		}
	}
	return NO;
}

- (GOLFBet *)addPressToHoleAt18Index:(NSUInteger)holeIndex {
	NSUInteger workingIndex = holeIndex % 18;
	GOLFBet *newBet = nil;
	if ([self canAddPressToHoleAt18Index:workingIndex]) {
		NSInteger holeNumber = workingIndex + 1;
		NSInteger fromFirst = self.firstHole;
		NSInteger last = self.lastHole;
		NSInteger first = MIN(MAX(holeNumber, fromFirst), last);
		newBet = [GOLFBet betWithName:@"" reason:GOLFBetAddedPressReason startingAt:first endingAt:last];

		NSInteger fromHole = MAX(first - 1, fromFirst);
		NSInteger fromStatus = ((first > fromFirst) ? [self holeStatusForHoleAt18Index:(fromHole - 1)] : GOLFBetNoHoleStatus);
		
		newBet.handicappingStyle = self.handicappingStyle;	//	Propagates
		newBet.does2DownAutomatics = self.does2DownAutomatics;
		newBet.does1DownLastHoleAutomatics = self.does1DownLastHoleAutomatics;
		newBet.fromHole = fromHole;
		newBet.fromUp = fromStatus;
		
		[self.presses addObject:newBet];	//	One of our presses
		newBet.fromBet = self;
		[newBet update];	//	Make sure it's up to date
		[newBet updateAutomatics];	//	And that any automatics are added
	}
	return newBet;
}

//- (BOOL)canAddCloseOutToHoleAt18Index:(NSUInteger)holeIndex {
//	NSUInteger workingIndex = holeIndex % 18;	//	For close-outs, this must be the hole on which our bet was won (but not the lastHole)
//	NSInteger lastHoleIndex = self.lastHole - 1;
//	if (workingIndex < lastHoleIndex) {
//		NSInteger firstHoleIndex = self.firstHole - 1;
//		if (workingIndex > firstHoleIndex) {
//			NSInteger status = holeStatus[workingIndex];	//	Status of proposed hole initiating a close-out
//			NSInteger precedingStatus = holeStatus[workingIndex - 1];	//	Status of the preceding hole
//			//	The bet must be over at the proposed hole
//			if ((status == GOLFBetAWonHoleStatus) || (status == GOLFBetBWonHoleStatus)) {
//				//	and NOT over at the preceding hole…
//				if ((status != GOLFBetAWonHoleStatus) && (status != GOLFBetBWonHoleStatus)) {
//					return YES;
//				}
//			}
//			return NO;
//			
//		}
//	}
//	return NO;
//}

//- (GOLFBet *)addCloseOutToHoleAt18Index:(NSUInteger)holeIndex {
//	NSUInteger fromIndex = holeIndex % 18;	//	The index of the hole ending our bet - we start at the next hole
//	NSInteger fromHole = fromIndex + 1;
//	GOLFBet *newBet = nil;
//	if ([self canAddCloseOutToHoleAt18Index:workingIndex]) {
//		NSInteger firstIndex = fromIndex + 1;	//	The index of the hole where the close-out starts
//		NSInteger holeNumber = firstIndex + 1;	//	The hole number (ie: the 17th or earlier)
//		NSInteger last = self.lastHole;
//		NSInteger first = MIN(holeNumber, last);
//		newBet = [GOLFBet betWithName:@"" reason:GOLFBetCloseOutReason startingAt:first endingAt:last];
//
//		NSInteger fromStatus = [self holeStatusForHoleAt18Index:fromIndex];	//	Either GOLFBetAWonHoleStatus or GOLFBetBWonHoleStatus
//		
//		newBet.handicappingStyle = self.handicappingStyle;	//	Propagates
//		newBet.does2DownAutomatics = self.does2DownAutomatics;	//	As far as we know, close-outs can be auto-pressed
//		newBet.does1DownLastHoleAutomatics = self.does1DownLastHoleAutomatics;	//	As far as we know, close-outs can be auto-pressed
//		newBet.doesCloseOuts = self.doesCloseOuts;
//		newBet.fromHole = fromHole;
//		newBet.fromUp = fromStatus;
//		
//		[self.presses addObject:newBet];	//	One of our presses
//		newBet.fromBet = self;
//		[newBet update];	//	Make sure it's up to date
//		[newBet updateAutomatics];	//	And that any automatics are added
//	}
//	return newBet;
//}

- (void)update {
	//	Hole Status
	//	GOLFBetNoHoleStatus = -999,				//	No hole status (show blank - white background)
	//	GOLFBetBWonHoleStatus = -99,			//	B has won (show • character on B background)
	//	GOLFBetB2UpHoleStatus = -2,
	//	GOLFBetB1UpHoleStatus = -1,
	//	GOLFBetAllSquareHoleStatus = 0,			//	Match is all square (show - character on white background)
	//	GOLFBetA1UpHoleStatus = 1,
	//	GOLFBetA2UpHoleStatus = 2,
	//	GOLFBetAWonHoleStatus = 99,				//	A has won (show • character on A background)
	//	GOLFBetPressAddedHoleStatus = 995,		//	Hole after which a manual press was added (causation arrow?)
	//	GOLFBetPress2DownHoleStatus = 996,		//	Hole after which auto 2-down press was added (causation arrow?)
	//	GOLFBetPress1DownHoleStatus = 997,		//	Hole after which auto 1-down press was added (causation arrow?)
	//	GOLFBetInvisibleHoleStatus = 998,		//	Invisible hole status (show no text field)
	//	GOLFBetErrorHoleStatus = 999			//	Error hole status (show X character on white background)
	//
	//	Bet Status
	//	GOLFBetNoStatus,						//	(0)		No bet status (beginning status)
	//	GOLFBetNoScores = GOLFBetNoStatus,		//			No scores (ie: no status)
	//	GOLFBetAllSquare = 1,					//	(1)		Match is all square (in progress)
	//	GOLFBetAAhead,							//	(2)		Round A is ahead
	//	GOLFBetBAhead,							//	(3)		Round B is ahead 
	//	GOLFBetHalved,							//	(4)		Match was halved (final)
	//	GOLFBetAWins,							//	(5)		Round A is the winner
	//	GOLFBetBWins,							//	(6)		Round B is the winner
	//	GOLFBetUnknownStatus = 99				//	(99)	Unknown or error status

	id<GOLFWageringDataSource> roundA = self.ARound;
	id<GOLFWageringDataSource> roundB = self.BRound;
	NSInteger ourFirstHole = self.firstHole;
	NSInteger ourLastHole = self.lastHole;
	NSInteger ourReason = self.reason;
	NSInteger precedingHoleStatus = GOLFBetInvisibleHoleStatus;
	NSInteger newBetStatus = GOLFBetNoStatus;
	NSInteger newBetUp = 0;
	NSInteger newBetToGo = ourLastHole - ourFirstHole + 1;
	BOOL aRoundIsTeam = NO;
	BOOL aRoundIsTeamOnlyPlayType = NO;
	BOOL aRoundUsesTeammatesScores = NO;
	BOOL bRoundIsTeam = NO;
	BOOL bRoundIsTeamOnlyPlayType = NO;
	BOOL bRoundUsesTeammatesScores = NO;
	
	if (roundA) {
		if ([roundA respondsToSelector:@selector(isTeamForWagering)]) {
			aRoundIsTeam = [roundA isTeamForWagering];
		}
		if (aRoundIsTeam) {
			if ([roundA respondsToSelector:@selector(playTypeForWagering)]) {
				aRoundIsTeamOnlyPlayType = IS_TEAM_ONLY_PLAY_TYPE([roundA playTypeForWagering]);
			}
			aRoundUsesTeammatesScores = !aRoundIsTeamOnlyPlayType;
		}
	}

	if (roundB) {
		if ([roundB respondsToSelector:@selector(isTeamForWagering)]) {
			bRoundIsTeam = [roundB isTeamForWagering];
		}
		if (bRoundIsTeam) {
			if ([roundB respondsToSelector:@selector(playTypeForWagering)]) {
				bRoundIsTeamOnlyPlayType = IS_TEAM_ONLY_PLAY_TYPE([roundB playTypeForWagering]);
			}
			bRoundUsesTeammatesScores = !bRoundIsTeamOnlyPlayType;
		}
	}

	for (NSUInteger holePosition = 1; holePosition < 19; holePosition++) {
		NSUInteger holeIndex = holePosition - 1;
		holeStatus[holeIndex] = GOLFBetErrorHoleStatus;	//	By default, an error
		
		if ((ourReason == GOLFBetAutomatic2DownPressReason) && (holePosition == (ourFirstHole - 1))) {
			holeStatus[holeIndex] = GOLFBetPress2DownLeaderHoleStatus;
			precedingHoleStatus = GOLFBetInvisibleHoleStatus;
		} else if ((ourReason == GOLFBetAutomatic1DownPressReason) && (holePosition == (ourFirstHole - 1))) {
			holeStatus[holeIndex] = GOLFBetPress1DownLeaderHoleStatus;
			precedingHoleStatus = GOLFBetInvisibleHoleStatus;
		} else if ((ourReason == GOLFBetAddedPressReason) && (holePosition == (ourFirstHole - 1))) {
			holeStatus[holeIndex] = GOLFBetPressAddedLeaderHoleStatus;
			precedingHoleStatus = GOLFBetInvisibleHoleStatus;
		} else if ((ourReason == GOLFBetCloseOutReason) && (holePosition == (ourFirstHole - 1))) {
			holeStatus[holeIndex] = GOLFBetCloseOutLeaderHoleStatus;
			precedingHoleStatus = GOLFBetInvisibleHoleStatus;
		} else if ((holePosition < ourFirstHole) || (holePosition > ourLastHole)) {
			holeStatus[holeIndex] = GOLFBetInvisibleHoleStatus;
			precedingHoleStatus = GOLFBetInvisibleHoleStatus;
		} else if ((roundA == nil) || (roundB == nil)) {
			holeStatus[holeIndex] = GOLFBetNoHoleStatus;
			precedingHoleStatus = GOLFBetNoHoleStatus;
			newBetStatus = GOLFBetNoStatus;
		} else {
			if (((holePosition > ourFirstHole) && (precedingHoleStatus == GOLFBetNoHoleStatus))
					|| (newBetStatus == GOLFBetHalved)) {
				holeStatus[holeIndex] = precedingHoleStatus;
				//	newBetStatus unchanged
			} else if (newBetStatus == GOLFBetAWins) {
				holeStatus[holeIndex] = GOLFBetAWonHoleStatus;
				precedingHoleStatus = GOLFBetAWonHoleStatus;
				//	newBetStatus unchanged
			} else if (newBetStatus == GOLFBetBWins) {
				holeStatus[holeIndex] = GOLFBetBWonHoleStatus;
				precedingHoleStatus = GOLFBetBWonHoleStatus;
				//	newBetStatus unchanged
			} else {
				NSInteger newHoleStatus = ((precedingHoleStatus == GOLFBetInvisibleHoleStatus) ? GOLFBetAllSquareHoleStatus : precedingHoleStatus);
				if (newHoleStatus > ((NSInteger)ourLastHole - (NSInteger)holePosition + 1)) {
					holeStatus[holeIndex] = GOLFBetAWonHoleStatus;
					newBetStatus = GOLFBetAWins;
					precedingHoleStatus = GOLFBetAWonHoleStatus;	//	Thereafter
				} else if (newHoleStatus < ((NSInteger)holePosition - (NSInteger)ourLastHole - 1)) {
					holeStatus[holeIndex] = GOLFBetBWonHoleStatus;
					newBetStatus = GOLFBetBWins;
					precedingHoleStatus = GOLFBetBWonHoleStatus;	//	Thereafter
				} else {
					id<GOLFWageringDataSource> aHole = [roundA holeAtIndexForWagering:holeIndex];
					id<GOLFWageringDataSource> bHole = [roundB holeAtIndexForWagering:holeIndex];
					GOLFScore aHoleScore = kNotAScore;
					GOLFScore bHoleScore = kNotAScore;
					BOOL aHoleDQ = NO;
					BOOL bHoleDQ = NO;
					if (aHole) {
						if ([aHole respondsToSelector:@selector(grossScoreForWagering)]) {
							aHoleScore = [aHole grossScoreForWagering];
						}
						if ([aHole respondsToSelector:@selector(isDisqualifiedForWagering)]) {
							aHoleDQ = [aHole isDisqualifiedForWagering];
						}
					}
					if (bHole) {
						if ([bHole respondsToSelector:@selector(grossScoreForWagering)]) {
							bHoleScore = [bHole grossScoreForWagering];
						}
						if ([bHole respondsToSelector:@selector(isDisqualifiedForWagering)]) {
							bHoleDQ = [bHole isDisqualifiedForWagering];
						}
					}
					if ((aHole == nil) || (bHole == nil) || (aHoleScore == kNotAScore) || (bHoleScore == kNotAScore)) {
						holeStatus[holeIndex] = GOLFBetNoHoleStatus;
						newBetStatus = ((newHoleStatus > 0)
								? GOLFBetAAhead
								: ((newHoleStatus < 0)
										? GOLFBetBAhead
										: ((holePosition > ourFirstHole)
												? GOLFBetAllSquare
												: GOLFBetNoStatus)));
						precedingHoleStatus = GOLFBetNoHoleStatus;	//	Thereafter
					} else {
						NSComparisonResult result = NSOrderedSame;

						if ((self.handicappingStyle == GOLFWageringGrossHandicapStyle) && [aHole respondsToSelector:@selector(compareGrossScoreForWagering:)]) {
							result = [aHole compareGrossScoreForWagering:bHole];
						} else if (aHoleDQ) {
							result = (bHoleDQ ? NSOrderedSame : NSOrderedDescending);
						} else if (bHoleDQ) {
							result = NSOrderedAscending;
						} else {
							NSRange strokesRange = NSMakeRange(holeIndex, 1);

							if (!aRoundUsesTeammatesScores && !bRoundUsesTeammatesScores && (self.handicappingStyle == GOLFWageringFullHandicapStyle) && [aHole respondsToSelector:@selector(compareNetScoreForWagering:)]) {
								result = [aHole compareNetScoreForWagering:bHole];
//								if (aRoundIsTeamOnlyPlayType) {
//									result = [aHole compareCompScore:bHole];	//	Team only scores always use comp!
//								} else {
//									result = [aHole compareNetScore:bHole];
//								}
							} else {
								NSInteger aNetScore = (aRoundUsesTeammatesScores
										? [(NSNumber *)[self.aHoleScores objectAtIndex:holeIndex] integerValue]
										: (aHoleScore - [[self.aStrokesString substringWithRange:strokesRange] integerValue]));
								NSInteger bNetScore = (bRoundUsesTeammatesScores
										? [(NSNumber *)[self.bHoleScores objectAtIndex:holeIndex] integerValue]
										: (bHoleScore - [[self.bStrokesString substringWithRange:strokesRange] integerValue]));
								
								if (aNetScore < bNetScore) {
									result = NSOrderedAscending;
								} else if (aNetScore > bNetScore) {
									result = NSOrderedDescending;
								}
							}
						}
						
						if (result == NSOrderedAscending)
							newHoleStatus++;
						else if (result == NSOrderedDescending)
							newHoleStatus--;

						holeStatus[holeIndex] = newHoleStatus;
						
						if ((holePosition == ourLastHole)
								|| (newHoleStatus > ((NSInteger)ourLastHole - (NSInteger)holePosition))
								|| (newHoleStatus < ((NSInteger)holePosition - (NSInteger)ourLastHole))) {
							newBetStatus = (newHoleStatus > 0 ? GOLFBetAWins : (newHoleStatus < 0 ? GOLFBetBWins : GOLFBetHalved));
						} else {
							newBetStatus = (newHoleStatus > 0 ? GOLFBetAAhead : (newHoleStatus < 0 ? GOLFBetBAhead : GOLFBetAllSquare));
						}
						newBetUp = labs((long)newHoleStatus);
						precedingHoleStatus = newHoleStatus;	
						newBetToGo = (NSInteger)ourLastHole - (NSInteger)holePosition;
					}	//	else !(if ((aHole == nil) || (bHole == nil) || (aHoleScore == kNotAScore) || (bHoleScore == kNotAScore)))
				}
			}
		}
	}	//	for (NSUInteger holePosition = 1; holePosition < 19; holePosition++)
	self.betStatus = newBetStatus;
	self.betUp = newBetUp;
	self.betToGo = newBetToGo;
	
	//	update does NOT iterate through its presses - all bets should be updated in sequence
}

- (void)updateAutomatics {
	//	Update the automatic 2-down and last hole 1-down presses,
	//	without screwing up the added presses if possible
	GOLFBet *old2Down = [self myAutomaticTwoDownPress];
	GOLFBet *oldLastHole1Down = [self myAutomaticLastHoleOneDownPress];
	GOLFBet *oldCloseOut = [self myCloseOutBet];
	
	GOLFBet *new2Down = nil;
	GOLFBet *newLastHole1Down = nil;
	GOLFBet *newCloseOut = nil;
	
	BOOL needAutomatic2Downs = self.does2DownAutomatics;
	BOOL needAutomaticLastHole1Downs = self.does1DownLastHoleAutomatics;
	BOOL needCloseOuts = self.doesCloseOuts;
	
	//	If repressing is prohibited and we have a manual press, don't do any automatics
	if (/* [[NSUserDefaults standardUserDefaults] boolForKey:@"ProhibitMultiplePress"] && */ [self anyAddedPress]) {
		needAutomatic2Downs = NO;
		needAutomaticLastHole1Downs = NO;
	}
	
	NSInteger ourFirstHole = self.firstHole;
	NSInteger ourLastHole = self.lastHole;
	NSInteger holePosition;
	NSInteger status;
	
	if (needAutomatic2Downs && (ourFirstHole < ourLastHole)) {
		for (holePosition = ourFirstHole; ((holePosition < ourLastHole) && (new2Down == nil)); holePosition++) {
			status = [self holeStatusForHoleAt18Index:(holePosition - 1)];
			if ((status == GOLFBetA2UpHoleStatus) || (status == GOLFBetA2UpHoleStatus)) {
				if ((old2Down != nil) && ([old2Down fromHole] == holePosition)) {
					new2Down = old2Down;
				} else {
					new2Down = [GOLFBet betWithName:@"" reason:GOLFBetAutomatic2DownPressReason startingAt:(holePosition + 1) endingAt:ourLastHole];
					new2Down.handicappingStyle = self.handicappingStyle;	//	Propagates
					new2Down.does2DownAutomatics = needAutomatic2Downs;	//	Propagates
					new2Down.does1DownLastHoleAutomatics = needAutomaticLastHole1Downs;	//	Propagates
					//	new2Down.fromBet = self;	//	In a moment…
					new2Down.fromHole = holePosition;
					new2Down.fromUp = status;
				}
			}
		}
	}

	if (needAutomaticLastHole1Downs && (ourFirstHole < ourLastHole) && (new2Down == nil)) {
		holePosition = ourLastHole - 1;
		status = [self holeStatusForHoleAt18Index:(holePosition - 1)];
		if ((newLastHole1Down == nil) && ((status == GOLFBetA1UpHoleStatus) || (status == GOLFBetB1UpHoleStatus))) {
			if (oldLastHole1Down != nil) {
				newLastHole1Down = oldLastHole1Down;
			} else {
				newLastHole1Down = [GOLFBet betWithName:@"" reason:GOLFBetAutomatic1DownPressReason startingAt:ourLastHole endingAt:ourLastHole];
				newLastHole1Down.handicappingStyle = self.handicappingStyle;	//	Propagates
				newLastHole1Down.does2DownAutomatics = needAutomatic2Downs;	//	Propagates
				newLastHole1Down.does1DownLastHoleAutomatics = needAutomaticLastHole1Downs;	//	Propagates
				//	newLastHole1Down.fromBet = self;	//	In a moment…
				newLastHole1Down.fromHole = holePosition;
				newLastHole1Down.fromUp = status;
			}
		}
	}
	
	if (needCloseOuts && ((self.fromBet == nil) || [self.fromBet doesCloseOuts]) && (newCloseOut == nil)) {
		for (holePosition = (ourLastHole - 1); ((holePosition > ourFirstHole) && (newCloseOut == nil)); holePosition--) {
			status = [self holeStatusForHoleAt18Index:holePosition];
			NSInteger precedingStatus = [self holeStatusForHoleAt18Index:(holePosition - 1)];
			if (((status == GOLFBetAWonHoleStatus) && (precedingStatus != GOLFBetAWonHoleStatus))
					|| ((status == GOLFBetBWonHoleStatus) && (precedingStatus != GOLFBetBWonHoleStatus))) {
				if ((oldCloseOut != nil) && ([oldCloseOut fromHole] == holePosition)) {
					newCloseOut = oldCloseOut;
				} else {
					newCloseOut = [GOLFBet betWithName:@"" reason:GOLFBetCloseOutReason startingAt:(holePosition + 1) endingAt:ourLastHole];
					newCloseOut.handicappingStyle = self.handicappingStyle;	//	Propagates
					newCloseOut.does2DownAutomatics = needAutomatic2Downs;	//	Propagates
					newCloseOut.does1DownLastHoleAutomatics = needAutomaticLastHole1Downs;	//	Propagates
					newCloseOut.doesCloseOuts = needCloseOuts;	//	Propagates
					newCloseOut.fromBet = self;
					newCloseOut.fromHole = holePosition;
					newCloseOut.fromUp = status;
				}
			}
		}
	}
	
	//	Remove any old and add any new 2-down press
	if (old2Down != new2Down) {
		[self removePress:old2Down];
		if (new2Down) {
			//	Until now, not linked to us, scorecard or rounds
			[self addPress:new2Down];	//	Which will do an update on the new press
		}
	}
	
	//	Remove any old and add any new last hole 1-down press
	if (oldLastHole1Down != newLastHole1Down) {
		[self removePress:oldLastHole1Down];
		if (newLastHole1Down) {
			//	Until now, not linked to us, scorecard or rounds
			[self addPress:newLastHole1Down];	//	Which will update the new press
		}
	}
	
	//	Remove any old and add any new close-out bet
	if (oldCloseOut != newCloseOut) {
		[self removePress:oldCloseOut];
		if (newCloseOut) {
			//	Until now, not linked to us, scorecard or rounds
			[self addPress:newCloseOut];	//	Which will update the new press
		}
	}
	
	//	Now we need to have all our presses (including added presses) update their automatics
	for (GOLFBet *aBet in [self pressesArray]) {
		[aBet updateAutomatics];
	}
}

#pragma mark Helpers

- (void)setHandicappingStyle:(NSUInteger)newStyle {
	_handicappingStyle = newStyle;

	//	Now tell all our presses
	for (GOLFBet *press in [self pressesArray]) {
		press.handicappingStyle = newStyle;
	}
}

- (void)setDoes2DownAutomatics:(BOOL)doesEm {
	_does2DownAutomatics = doesEm;

	//	Now tell all our presses
	for (GOLFBet *press in [self pressesArray]) {
		press.does2DownAutomatics = doesEm;
	}
}

- (void)setDoes1DownLastHoleAutomatics:(BOOL)doesEm {
	_does1DownLastHoleAutomatics = doesEm;

	//	Now tell all our presses
	for (GOLFBet *press in [self pressesArray]) {
		press.does1DownLastHoleAutomatics = doesEm;
	}
}

- (void)setDoesCloseOuts:(BOOL)doesEm {
	_doesCloseOuts = doesEm;
}

@end
