//
//  GOLFWagering.m
//  GOLFKit
//
//  Created by John Bishop on 3/10/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "GOLFUtilities.h"
#import "GOLFExtensions.h"
#import "GOLFWagering.h"

static NSArray *cachedGOLFWageringMatchStyles = nil;
static NSArray *cachedGOLFWageringTeamMatchStyles = nil;
static NSArray *cachedGOLFWageringHandicapStyles = nil;

NSArray * GOLFWageringMatchStylesArray(void) {
	//	Returns an array of NSDictionary for localized match play style descriptions
	//	key					type			description
	//	------------------	--------------	----------------------------------------------------------------
	//	styleCode			NSNumber *		GOLFWageringMatchStyle style code for individual match play (as below)
	//	styleName			NSString *		The localized name of the match play style
	//	styleDescription	NSString *		Localized descriptive text about the match play style

	//	GOLFWageringMatchPlayMatchStyle,		//	(0)
	//	GOLFWageringNassauMatchStyle,			//	(1)
	//	GOLFWageringFrontAndBackMatchStyle,		//	(2)
	//	GOLFWageringThreeBySixMatchStyle,		//	(3)

	if (cachedGOLFWageringMatchStyles == nil) {
		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:5];
		
		//	Match Play
		NSDictionary *styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringMatchPlayMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_MATCH_PLAY"), @"styleName",
				GOLFLocalizedString(@"DESCRIPTION_MATCH_PLAY"), @"styleDescription", nil];
		[workingList addObject:styleDict];
		
		//	Nassau
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringNassauMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_NASSAU"), @"styleName",
				GOLFLocalizedString(@"DESCRIPTION_NASSAU"), @"styleDescription", nil];
		[workingList addObject:styleDict];
		
		//	Front & Back
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringFrontAndBackMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_FRONT_BACK"), @"styleName",
				GOLFLocalizedString(@"DESCRIPTION_FRONT_BACK"), @"styleDescription", nil];
		[workingList addObject:styleDict];
		
		//	3 x 6
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringThreeBySixMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_3_BY_6"), @"styleName",
				GOLFLocalizedString(@"DESCRIPTION_3_BY_6"), @"styleDescription", nil];
		[workingList addObject:styleDict];
				
		cachedGOLFWageringMatchStyles = [NSArray arrayWithArray:workingList];
	}
	return [cachedGOLFWageringMatchStyles copy];
}

NSArray * GOLFWageringTeamMatchStylesArray(NSDictionary *info) {
	//	info NSDictionary for customized style descriptions
	//	key					type			description
	//	------------------	--------------	----------------------------------------------------------------
	//	styleCode			NSNumber *		GOLFWageringMatchStyle style code for individual match play
	//	teamPlayType		NSNumber *		GOLFPlayType team competition play type (fourball, total, avg. etc.
	//	short				NSNumber *		BOOL indicating need for short (abbreviated?) return (if available)
	//	bestRoundsN			NSNumber *		Integer N of TeamBestNPlayType (Team total of best N rounds) - default: 4
	//	reload				NSNumber *		BOOL to force re-creating the cachedGOLFWageringTeamMatchStyles

	//	Returns an array of NSDictionary for localized match play style descriptions
	//	key					type			description
	//	------------------	--------------	----------------------------------------------------------------
	//	styleCode			NSNumber *		GOLFWageringMatchStyle style code for individual match play (as below)
	//	styleName			NSString *		The localized name of the match play style
	//	styleDescription	NSString *		Localized descriptive text about the match play style

	//	GOLFWageringDefaultTeamMatchStyle,				//	(0)
	//	GOLFWageringLowBallLowTotalTeamMatchStyle,		//	(1)
	//	GOLFWageringLowBallHighBallTeamMatchStyle,		//	(2)
	//	GOLFWageringLowBallSecondBallTeamMatchStyle,	//	(3)

	//	Set up defaults for player match play, in case they're not provided…
	GOLFWageringMatchStyle playerMatchPlayStyle = GOLFWageringMatchPlayMatchStyle;	//	Default = 18-hole Match Play
	GOLFPlayType teamPlayType = TotalTeamPlayType;	//	Default = Team Total
	NSMutableDictionary *localInfo = (info
			? [NSMutableDictionary dictionaryWithDictionary:info]
			: [NSMutableDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:GOLFWageringMatchPlayMatchStyle], @"styleCode",
					[NSNumber numberWithUnsignedInteger:TotalTeamPlayType], @"teamPlayType",
					nil]);
	
	NSNumber *workingNumber = [localInfo objectForKey:@"styleCode"];
	if (workingNumber) {
		playerMatchPlayStyle = [workingNumber unsignedIntegerValue];
	} 
	workingNumber = [localInfo objectForKey:@"teamPlayType"];
	if (workingNumber) {
		teamPlayType = [workingNumber unsignedIntegerValue];
	}
	BOOL reload = [[localInfo objectForKey:@"reload"] boolValue];
	
	if ((cachedGOLFWageringTeamMatchStyles == nil) || reload) {
		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:5];
		
		//	Default - Team match play uses team gross / net / competition scores
		NSDictionary *styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringDefaultTeamMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_DEFAULT_TEAM_MATCH_STYLE"), @"styleName",
				[NSString stringWithFormat:GOLFLocalizedString(@"DESCRIPTION_DEFAULT_TEAM_MATCH_STYLE_%@"), NSStringFromGOLFWageringMatchStyle(playerMatchPlayStyle, nil), NSStringFromPlayType(teamPlayType, localInfo, nil)], @"styleDescription", nil];
		[workingList addObject:styleDict];
		
		//	Low Ball / Low Total - 1 team point for low teammate score, 1 team point for low team total
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringLowBallLowTotalTeamMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_LOW_BALL_LOW_TOTAL"), @"styleName",
				GOLFLocalizedString(@"DESCRIPTION_LOW_BALL_LOW_TOTAL"), @"styleDescription", nil];
		[workingList addObject:styleDict];
		
		//	Low Ball / High Ball - 1 team point for low teammate score, 1 point for best highest teammate
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringLowBallHighBallTeamMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_LOW_BALL_HIGH_BALL"), @"styleName",
				GOLFLocalizedString(@"DESCRIPTION_LOW_BALL_HIGH_BALL"), @"styleDescription", nil];
		[workingList addObject:styleDict];
		
		//	Low Ball / Second Ball - 1 team point for low teammate, 1 point for best second-best teammate
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringLowBallSecondBallTeamMatchStyle], @"styleCode",
				GOLFLocalizedString(@"TITLE_LOW_BALL_SECOND_BALL"), @"styleName",
				GOLFLocalizedString(@"DESCRIPTION_LOW_BALL_SECOND_BALL"), @"styleDescription", nil];
		[workingList addObject:styleDict];
				
		cachedGOLFWageringTeamMatchStyles = [NSArray arrayWithArray:workingList];
	}
	return [cachedGOLFWageringTeamMatchStyles copy];
}

NSString * NSStringFromGOLFWageringMatchStyle(GOLFWageringMatchStyle styleCode, NSString **descriptiveText) {
	//	GOLFWageringMatchPlayMatchStyle,		//	(0)
	//	GOLFWageringNassauMatchStyle,			//	(1)
	//	GOLFWageringFrontAndBackMatchStyle,		//	(2)
	//	GOLFWageringThreeBySixMatchStyle,		//	(3)
	
	if (styleCode > GOLFWageringLastMatchStyle) {
		if (descriptiveText) {
			*descriptiveText = @"";
		}
		return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	} else {
		NSDictionary *styleDict = [GOLFWageringMatchStylesArray() objectAtIndex:styleCode];
		if (descriptiveText) {
			*descriptiveText = [styleDict objectForKey:@"styleDescription"];
		}
		return [styleDict objectForKey:@"styleName"];
	}
}

NSString * NSStringFromGOLFWageringTeamMatchStyle(GOLFWageringTeamMatchStyle styleCode, NSString **descriptiveText, NSDictionary *info) {
	//	GOLFWageringDefaultTeamMatchStyle,				//	(0)
	//	GOLFWageringLowBallLowTotalTeamMatchStyle,		//	(1)
	//	GOLFWageringLowBallHighBallTeamMatchStyle,		//	(2)
	//	GOLFWageringLowBallSecondBallTeamMatchStyle,	//	(3)
	
	if (styleCode > GOLFWageringLastTeamMatchStyle) {
		if (descriptiveText) {
			*descriptiveText = @"";
		}
		return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	} else {
		NSDictionary *styleDict = [GOLFWageringTeamMatchStylesArray(info) objectAtIndex:styleCode];
		if (descriptiveText) {
			*descriptiveText = [styleDict objectForKey:@"styleDescription"];
		}
		return [styleDict objectForKey:@"styleName"];
	}
}

NSArray * GOLFWageringHandicapStylesArray(void) {
	//	GOLFWageringFullHandicapStyle,			//	(0)
	//	GOLFWageringDifferenceHandicapStyle,	//	(1)
	//	GOLFWageringGrossHandicapStyle = 10,	//	(10)

	if (cachedGOLFWageringHandicapStyles == nil) {
		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:5];
		GOLFHandicapMethodIndex methodIndex = GOLFHandicapBestMethodIndexFromAuthority(GOLFDefaultHandicapAuthority());
		NSString *hdcpTitle = GOLFPlayingHandicapTitle(methodIndex, NO);
		
		//	Full Handicap
		NSDictionary *styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringFullHandicapStyle], @"styleCode",
				GOLFLocalizedString(@"ALLOWANCE_TYPE_FULL_HANDICAP"), @"styleName",
				[NSString stringWithFormat:GOLFLocalizedString(@"FORMAT_%@_OF_EACH_PLAYER"), hdcpTitle], @"styleDescription",
				nil];
		[workingList addObject:styleDict];
		
		//	Difference
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringDifferenceHandicapStyle], @"styleCode",
				[NSString stringWithFormat:GOLFLocalizedString(@"FORMAT_%@_DIFFERENCE"), hdcpTitle], @"styleName",
				GOLFLocalizedString(@"ALLOWANCE_TYPE_DIFFERENCE_DESC"), @"styleDescription",
				nil];
		[workingList addObject:styleDict];
		
		//	Gross
		styleDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:GOLFWageringGrossHandicapStyle], @"styleCode",
				[GOLFLocalizedString(@"ALLOWANCE_TYPE_GROSS") capitalizedString], @"styleName",
				GOLFLocalizedString(@"ALLOWANCE_TYPE_GROSS_DESC"), @"styleDescription", nil];
		[workingList addObject:styleDict];
		
		cachedGOLFWageringHandicapStyles = [NSArray arrayWithArray:workingList];
	}
	return [cachedGOLFWageringHandicapStyles copy];
}

NSString * NSStringFromGOLFWageringHandicapStyle(GOLFWageringHandicapStyle styleCode, NSString **descriptiveText) {
	//	GOLFWageringFullHandicapStyle,			//	(0)
	//	GOLFWageringDifferenceHandicapStyle,	//	(1)
	//	GOLFWageringGrossHandicapStyle = 10,	//	(10)

	if (styleCode > GOLFWageringGrossHandicapStyle) {
		if (descriptiveText) {
			*descriptiveText = @"";
		}
		return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	} else if (styleCode == GOLFWageringFullHandicapStyle) {
		NSDictionary *styleDict = [GOLFWageringHandicapStylesArray() objectAtIndex:0];
		if (descriptiveText) {
			*descriptiveText = [styleDict objectForKey:@"styleDescription"];
		}
		return [styleDict objectForKey:@"styleName"];
	} else if (styleCode == GOLFWageringDifferenceHandicapStyle) {
		NSDictionary *styleDict = [GOLFWageringHandicapStylesArray() objectAtIndex:1];
		if (descriptiveText) {
			*descriptiveText = [styleDict objectForKey:@"styleDescription"];
		}
		return [styleDict objectForKey:@"styleName"];
	} else {
		NSDictionary *styleDict = [GOLFWageringMatchStylesArray() objectAtIndex:2];
		if (descriptiveText) {
			*descriptiveText = [styleDict objectForKey:@"styleDescription"];
		}
		return [styleDict objectForKey:@"styleName"];
	}
}

NSString * NSStringFromGOLFWageringTrashOption(GOLFWageringTrashOption trashOption, NSString **descriptiveText) {
	//	Returns a localized title/name of a Trash/Dots option ("Greenie", "Sandie", "Stobbie", etc.) and
	//	optionally (when the address of descriptiveText is provided), a localized description of the
	//	option ("Closest to flagstick in regulation on a par 3", etc.)

	if (trashOption & GOLFWageringTrashCover) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_COVER");
		}
		return GOLFLocalizedString(@"TITLE_COVER");
	} else if (trashOption & GOLFWageringTrashGreenie) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_GREENIE");
		}
		return GOLFLocalizedString(@"TITLE_GREENIE");
	} else if (trashOption & GOLFWageringTrashSandie) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SANDIE");
		}
		return GOLFLocalizedString(@"TITLE_SANDIE");
	} else if (trashOption & GOLFWageringTrashStobbie) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_STOBBIE");
		}
		return GOLFLocalizedString(@"TITLE_STOBBIE");
	} else if (trashOption & GOLFWageringTrashFairway) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_FAIRWAY");
		}
		return [GOLFLocalizedString(@"TERM_FAIRWAY") capitalizedString];
	} else if (trashOption & GOLFWageringTrashArnie) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_ARNIE");
		}
		return GOLFLocalizedString(@"TITLE_ARNIE");
	} else if (trashOption & GOLFWageringTrashChipinski) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_CHIPINSKI");
		}
		return GOLFLocalizedString(@"TITLE_CHIPINSKI");
	} else if (trashOption & GOLFWageringTrashHogan) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_HOGAN");
		}
		return GOLFLocalizedString(@"TITLE_HOGAN");
	} else if (trashOption & GOLFWageringTrashSeve) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SEVE");
		}
		return GOLFLocalizedString(@"TITLE_SEVE");
	} else if (trashOption & GOLFWageringTrashPolie) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_POLIE");
		}
		return GOLFLocalizedString(@"TITLE_POLIE");
	} else if (trashOption & GOLFWageringTrashBingo) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_BINGO");
		}
		return GOLFLocalizedString(@"TITLE_BINGO");
	} else if (trashOption & GOLFWageringTrashBango) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_BANGO");
		}
		return GOLFLocalizedString(@"TITLE_BANGO");
	} else if (trashOption & GOLFWageringTrashBongo) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_BONGO");
		}
		return GOLFLocalizedString(@"TITLE_BONGO");
	} else if (trashOption & GOLFWageringTrashGurglie) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_GURGLIE");
		}
		return GOLFLocalizedString(@"TITLE_GURGLIE");
	} else if (trashOption & GOLFWageringTrashBarkie) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_BARKIE");
		}
		return GOLFLocalizedString(@"TITLE_BARKIE");
	} else if (trashOption & GOLFWageringTrashAsphalt) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_ASPHALT");
		}
		return GOLFLocalizedString(@"TITLE_ASPHALT");
	} else if (trashOption & GOLFWageringTrashSnake) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SNAKE");
		}
		return GOLFLocalizedString(@"TITLE_SNAKE");
	} else if (trashOption == GOLFWageringTrashNone) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_NO_TRASH");
		}
		return [GOLFLocalizedString(@"TERM_NONE") capitalizedString];
	} else {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"");
		}
		return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

NSString * NSStringFromGOLFWageringGameStyle(GOLFWageringGameStyle gameStyle, NSString **descriptiveText) {
	//	Returns a localized title/name of a wagering game style ("Trash", "Wolf", "Bingo-Bango-Bongo", etc.) and
	//	optionally (when the address of descriptiveText is provided), a localized description of the
	//	style ("Player, optional partner vs. rest at each hole", etc.)

	//	GOLFWageringGameTrash,					//	(1)		Trash, Dots or Wickers
	//	GOLFWageringGameAnimals,				//	(2)		Snake, Camel, Gorilla, etc.
	//	GOLFWageringGameHollywood,				//	(3)		Hollywood, Sixes, Round-Robin (6 hole matches)
	//	GOLFWageringGameSwing,					//	(4)		Swing Game - 2 vs. 3 or more
	//	GOLFWageringGameWolf,					//	(5)		Wolf - 3 or more
	//	GOLFWageringGameBingoBangoBongo,		//	(6)		Bingo, Bango, Bongo - 3 or more

	if (gameStyle == GOLFWageringGameTrash) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_TRASH");
		}
		return GOLFLocalizedString(@"TITLE_TRASH");
	} else if (gameStyle == GOLFWageringGameAnimals) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_ANIMALS");
		}
		return GOLFLocalizedString(@"TITLE_ANIMALS");
	} else if (gameStyle == GOLFWageringGameHollywood) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_HOLLYWOOD");
		}
		return GOLFLocalizedString(@"TITLE_HOLLYWOOD");
	} else if (gameStyle == GOLFWageringGameSwing) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_SWING_GAME");
		}
		return GOLFLocalizedString(@"TITLE_SWING_GAME");
	} else if (gameStyle == GOLFWageringGameWolf) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_WOLF");
		}
		return GOLFLocalizedString(@"TITLE_WOLF");
	} else if (gameStyle == GOLFWageringGameBingoBangoBongo) {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"DESCRIPTION_BINGO_BANGO_BONGO");
		}
		return GOLFLocalizedString(@"TITLE_BINGO_BANGO_BONGO");
	} else {
		if (descriptiveText) {
			*descriptiveText = GOLFLocalizedString(@"");
		}
		return [GOLFLocalizedString(@"TERM_UNKNOWN") capitalizedString];
	}
}

NSString * NSStringFromGOLFWageringHoleStrokes(GOLFHandicapStrokes holeStrokes) {
//	See:	NSString  + (id)stringForWageringStrokesAtHole:(GOLFHandicapStrokes)holeStrokes

//	returns a one-character string representing the number of handicap
//	strokes used for wagering at a hole.
//	Generally, a decimal integer character, but negative values (plus handicaps)
//	represented by alphabetic characters ("A" == -1)
	
	if (holeStrokes != kNotHandicapStrokes) {
		return ((holeStrokes < 0)
				? [@"ABCDEFGHIJ" substringWithRange:NSMakeRange(((-holeStrokes - 1) % 10), 1)]
				: [NSString stringWithFormat:@"%ld", (long)(holeStrokes % 10)]);
	}
	return @"0";
}

GOLFHandicapStrokes GOLFWageringStrokesFromStringByIndex(NSString *strokesString, NSUInteger holeIndex) {
	//	See also:  NSString+GOLFExtensions.h --> wageringStrokesAtIndex:
	
	//	returns handicap strokes applied (or to be applied) to determine the
	//	match play score used at a hole designated by its index.  
	//	Generally strokesString is a 9 or 18 character string of integer strokes,
	//	But alphabetic characters indicate negative values (plus handicaps)
	//	("A" == -1)
	
	NSUInteger workingIndex = holeIndex % 18;
	
	if (workingIndex < [strokesString length]) {		
		NSString *strokeItem = [strokesString substringWithRange:NSMakeRange(workingIndex, 1)];
		unichar character = [strokeItem characterAtIndex:0];
		if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character]) {
			return (GOLFHandicapStrokes)[strokeItem integerValue];
		} else {
			NSRange foundRange = [@"ABCDEFGHIJ" rangeOfString:strokeItem];
			if (foundRange.location != NSNotFound) {
				return (GOLFHandicapStrokes)(-(foundRange.location + 1));
			}
		}
	}	//	if (workingIndex < [strokesString length])
	return 0;
}


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
		self.handicapStyle = ([[NSUserDefaults standardUserDefaults] boolForKey:@"NetMatchPlay"]
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

- (GOLFHandicapStrokes)aMatchStrokesForHoleAtIndex:(NSUInteger)holeIndex {
	return [self.aStrokesString wageringStrokesAtIndex:holeIndex];
}

- (GOLFHandicapStrokes)bMatchStrokesForHoleAtIndex:(NSUInteger)holeIndex {
	return [self.bStrokesString wageringStrokesAtIndex:holeIndex];
}

- (NSDictionary *)betInfo {
	//	betInfo NSDictionary supplied to all bottom-level bets…
	//	key					type			description
	//	------------------	--------------	----------------------------------------------------------------
	//	aRound				SCRRound *		A competitor's round
	//	aScores				NSArray *		0, 9, or 18 (NSNumber *) A competitor hole-by-hole match scores
	//	aStrokesString		NSString *		18-character string of strokes given for A competitor
	//	aWageringStrokes	NSNumber *		Adjusted wagering strokes for A competitor (un-diff'd)
	//	bRound				SCRRound *		B competitor's round
	//	bScores				NSArray *		0, 9, or 18 (NSNumber *) B competitor hole-by-hole match scores
	//	bStrokesString		NSString *		18-character string of strokes given for B competitor
	//	bWageringStrokes	NSNumber *		Adjusted wagering strokes for B competitor (un-diff'd)
	//	lowHandicap			NSNumber *		GOLFPlayingHandicap for the lowest handicap competitor
	//	lowName				NSString *		name of the lowest-handicapped competitor
			
	if (self.fromBet) {
		return [self.fromBet betInfo];
	}
	return _betInfo;
}

- (NSArray *)aHoleScores {
	NSArray *holeScores = nil;
	if (self.betInfo) {
		holeScores = [self.betInfo objectForKey:@"aScores"];
	}
	if (holeScores == nil) {
		NSMutableArray *workingArray = [NSMutableArray arrayWithCapacity:18];
		for (NSUInteger holeIndex = 0; holeIndex < 19; holeIndex++) {
			id<GOLFWageringDataSource> aHole = ((self.ARound != nil) ? [self.ARound holeAtIndexForWagering:holeIndex] : nil);
			GOLFScore holeScore = ((aHole != nil) ? [aHole grossScoreForWagering] : kNotAScore);
			[workingArray addObject:[NSNumber numberWithScore:holeScore]];
		}
		holeScores = [NSArray arrayWithArray:workingArray];
	}
	return holeScores;
}

- (NSArray *)bHoleScores {
	NSArray *holeScores = nil;
	if (self.betInfo) {
		holeScores = [self.betInfo objectForKey:@"bScores"];
	}
	if (holeScores == nil) {
		NSMutableArray *workingArray = [NSMutableArray arrayWithCapacity:18];
		for (NSUInteger holeIndex = 0; holeIndex < 19; holeIndex++) {
			id<GOLFWageringDataSource> aHole = ((self.BRound != nil) ? [self.BRound holeAtIndexForWagering:holeIndex] : nil);
			GOLFScore holeScore = ((aHole != nil) ? [aHole grossScoreForWagering] : kNotAScore);
			[workingArray addObject:[NSNumber numberWithScore:holeScore]];
		}
		holeScores = [NSArray arrayWithArray:workingArray];
	}
	return holeScores;
}

- (GOLFScore)aMatchScoreForHoleAt18Index:(NSUInteger)holeIndex {
	NSArray *holeScores = [self aHoleScores];
	if (holeScores) {
		NSUInteger workingIndex = (holeIndex % 18);
		if (workingIndex < [holeScores count]) {
			return [[holeScores objectAtIndex:workingIndex] scoreValue];
		}
	}
	return kNotAScore;
}

- (GOLFScore)bMatchScoreForHoleAt18Index:(NSUInteger)holeIndex {
	NSArray *holeScores = [self bHoleScores];
	if (holeScores) {
		NSUInteger workingIndex = (holeIndex % 18);
		if (workingIndex < [holeScores count]) {
			return [[holeScores objectAtIndex:workingIndex] scoreValue];
		}
	}
	return kNotAScore;
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
//			return ([[self addedPresses] count] < 1);
			
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
			//	At the moment, only Eagle has a setting that allows prohibiting multiple presses at a hole
			if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ProhibitMultiplePress"]) {
				//	Can't add if there's a 2-down in front of us…
				GOLFBet *testPress = [self myAutomaticTwoDownPress];
				if ((testPress != nil) && ([testPress firstHole] <= holeIndex)) {
					return NO;
				}
				
				//	or a 1-down in front of us…
				testPress = [self myAutomaticLastHoleOneDownPress];
				if ((testPress != nil) && ([testPress firstHole] <= holeIndex)) {
					return NO;
				}
				
				return ([[self addedPresses] count] < 1);
			} else {
				//	Multiple presses allowed
				return YES;
			}
#else
			//	At the moment, all iOS apps prohibit multiple presses
			return ([[self addedPresses] count] < 1);

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
		
		newBet.handicapStyle = self.handicapStyle;	//	Propagates
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
//	BOOL aRoundIsTeam = NO;
//	BOOL aRoundIsTeamOnlyPlayType = NO;
//	BOOL aRoundUsesTeammatesScores = NO;
//	BOOL bRoundIsTeam = NO;
//	BOOL bRoundIsTeamOnlyPlayType = NO;
//	BOOL bRoundUsesTeammatesScores = NO;
	
//	if (roundA) {
//		if ([roundA respondsToSelector:@selector(isTeamForWagering)]) {
//			aRoundIsTeam = [roundA isTeamForWagering];
//		}
//		if (aRoundIsTeam) {
//			if ([roundA respondsToSelector:@selector(playTypeForWagering)]) {
//				aRoundIsTeamOnlyPlayType = IS_TEAM_ONLY_PLAY_TYPE([roundA playTypeForWagering]);
//			}
//			aRoundUsesTeammatesScores = !aRoundIsTeamOnlyPlayType;
//		}
//	}
//
//	if (roundB) {
//		if ([roundB respondsToSelector:@selector(isTeamForWagering)]) {
//			bRoundIsTeam = [roundB isTeamForWagering];
//		}
//		if (bRoundIsTeam) {
//			if ([roundB respondsToSelector:@selector(playTypeForWagering)]) {
//				bRoundIsTeamOnlyPlayType = IS_TEAM_ONLY_PLAY_TYPE([roundB playTypeForWagering]);
//			}
//			bRoundUsesTeammatesScores = !bRoundIsTeamOnlyPlayType;
//		}
//	}

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
					GOLFScore aHoleMatchScore = [self aMatchScoreForHoleAt18Index:holeIndex];
					GOLFScore bHoleMatchScore = [self bMatchScoreForHoleAt18Index:holeIndex];
//					GOLFScore aHoleScore = kNotAScore;
//					GOLFScore bHoleScore = kNotAScore;
//					BOOL aHoleDQ = ([aHole respondsToSelector:@selector(isDisqualifiedForWagering)] ? [aHole isDisqualifiedForWagering] : NO);
//					BOOL bHoleDQ = ([bHole respondsToSelector:@selector(isDisqualifiedForWagering)] ? [bHole isDisqualifiedForWagering] : NO);
//					if (aHole) {
//						if ([aHole respondsToSelector:@selector(grossScoreForWagering)]) {
//							aHoleScore = [aHole grossScoreForWagering];
//						}
//						if ([aHole respondsToSelector:@selector(isDisqualifiedForWagering)]) {
//							aHoleDQ = [aHole isDisqualifiedForWagering];
//						}
//					}
//					if (bHole) {
//						if ([bHole respondsToSelector:@selector(grossScoreForWagering)]) {
//							bHoleScore = [bHole grossScoreForWagering];
//						}
//						if ([bHole respondsToSelector:@selector(isDisqualifiedForWagering)]) {
//							bHoleDQ = [bHole isDisqualifiedForWagering];
//						}
//					}
					if ((aHole == nil) || (bHole == nil) || (aHoleMatchScore == kNotAScore) || (bHoleMatchScore == kNotAScore)) {
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
						BOOL aHoleDQ = ([aHole respondsToSelector:@selector(isDisqualifiedForWagering)] ? [aHole isDisqualifiedForWagering] : NO);
						BOOL bHoleDQ = ([bHole respondsToSelector:@selector(isDisqualifiedForWagering)] ? [bHole isDisqualifiedForWagering] : NO);
						NSComparisonResult result = NSOrderedSame;

//						if ((self.handicapStyle == GOLFWageringGrossHandicapStyle) && [aHole respondsToSelector:@selector(compareGrossScoreForWagering:)]) {
//							result = [aHole compareGrossScoreForWagering:bHole];
//						} else
						if (aHoleDQ) {
							result = (bHoleDQ ? NSOrderedSame : NSOrderedDescending);
						} else if (bHoleDQ) {
							result = NSOrderedAscending;
						} else if (aHoleMatchScore < bHoleMatchScore) {
							result = NSOrderedAscending;
						} else if (aHoleMatchScore > bHoleMatchScore) {
							result = NSOrderedDescending;
						}
						
//						} else {
//							NSRange strokesRange = NSMakeRange(holeIndex, 1);
//
//							if (!aRoundUsesTeammatesScores
//									&& !bRoundUsesTeammatesScores
//									&& (self.handicapStyle == GOLFWageringFullHandicapStyle)
//									&& [aHole respondsToSelector:@selector(compareNetScoreForWagering:)]) {
//								result = [aHole compareNetScoreForWagering:bHole];
////								if (aRoundIsTeamOnlyPlayType) {
////									result = [aHole compareCompScore:bHole];	//	Team only scores always use comp!
////								} else {
////									result = [aHole compareNetScore:bHole];
////								}
//							} else {
//								NSInteger aNetScore = (aRoundUsesTeammatesScores
//										? [(NSNumber *)[self.aHoleScores objectAtIndex:holeIndex] integerValue]
//										: (aHoleScore - [[self.aStrokesString substringWithRange:strokesRange] integerValue]));
//								NSInteger bNetScore = (bRoundUsesTeammatesScores
//										? [(NSNumber *)[self.bHoleScores objectAtIndex:holeIndex] integerValue]
//										: (bHoleScore - [[self.bStrokesString substringWithRange:strokesRange] integerValue]));
//								
//								if (aNetScore < bNetScore) {
//									result = NSOrderedAscending;
//								} else if (aNetScore > bNetScore) {
//									result = NSOrderedDescending;
//								}
//							}
//						}
						
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
	GOLFBetHoleStatus holeStatus;
	
	if (needAutomatic2Downs && (ourFirstHole < ourLastHole)) {
		for (holePosition = ourFirstHole; ((holePosition < ourLastHole) && (new2Down == nil)); holePosition++) {
			holeStatus = [self holeStatusForHoleAt18Index:(holePosition - 1)];
			if ((holeStatus == GOLFBetA2UpHoleStatus) || (holeStatus == GOLFBetB2UpHoleStatus)) {
				if ((old2Down != nil) && ([old2Down fromHole] == holePosition)) {
					new2Down = old2Down;
				} else {
					new2Down = [GOLFBet betWithName:@"" reason:GOLFBetAutomatic2DownPressReason startingAt:(holePosition + 1) endingAt:ourLastHole];
					new2Down.handicapStyle = self.handicapStyle;	//	Propagates
					new2Down.does2DownAutomatics = needAutomatic2Downs;	//	Propagates
					new2Down.does1DownLastHoleAutomatics = needAutomaticLastHole1Downs;	//	Propagates
//					new2Down.fromBet = self;	//	Done when we addPress:
					new2Down.fromHole = holePosition;
					new2Down.fromUp = holeStatus;
				}
			}
		}
	}

	if (needAutomaticLastHole1Downs && (ourFirstHole < ourLastHole) && (new2Down == nil)) {
		holePosition = ourLastHole - 1;
		holeStatus = [self holeStatusForHoleAt18Index:(holePosition - 1)];
		if ((newLastHole1Down == nil) && ((holeStatus == GOLFBetA1UpHoleStatus) || (holeStatus == GOLFBetB1UpHoleStatus))) {
			if (oldLastHole1Down != nil) {
				newLastHole1Down = oldLastHole1Down;
			} else {
				newLastHole1Down = [GOLFBet betWithName:@"" reason:GOLFBetAutomatic1DownPressReason startingAt:ourLastHole endingAt:ourLastHole];
				newLastHole1Down.handicapStyle = self.handicapStyle;	//	Propagates
				newLastHole1Down.does2DownAutomatics = needAutomatic2Downs;	//	Propagates
				newLastHole1Down.does1DownLastHoleAutomatics = needAutomaticLastHole1Downs;	//	Propagates
//				newLastHole1Down.fromBet = self;	//	//	Done when we addPress:
				newLastHole1Down.fromHole = holePosition;
				newLastHole1Down.fromUp = holeStatus;
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
	
	if (needCloseOuts && ((self.fromBet == nil) || [self.fromBet doesCloseOuts]) && (newCloseOut == nil)) {
		for (holePosition = (ourLastHole - 1); ((holePosition > ourFirstHole) && (newCloseOut == nil)); holePosition--) {
			holeStatus = [self holeStatusForHoleAt18Index:holePosition];
			NSInteger precedingStatus = [self holeStatusForHoleAt18Index:(holePosition - 1)];
			if (((holeStatus == GOLFBetAWonHoleStatus) && (precedingStatus != GOLFBetAWonHoleStatus))
					|| ((holeStatus == GOLFBetBWonHoleStatus) && (precedingStatus != GOLFBetBWonHoleStatus))) {
				//	We've found the point at which a newCloseOut might start
				NSInteger startHole = 0;
				[self.myAutomaticTwoDownPress updateAutomatics];	//	Fully expand 2-down presses
				[self.myAutomaticLastHoleOneDownPress updateAutomatics];	//	Fully expand 1-down presses
				//	Starting with the candidate position, find the first hole at which there are no active bets of any kind
				//	excluding us and oldCloseOut (which will be removed or replaced anyway)
				for (NSUInteger holeToCheck = (holePosition + 1); (holeToCheck <= ourLastHole); holeToCheck++) {
					BOOL interference = NO;
					for (GOLFBet *interferingBet in [self selfAndPresses]) {
						if ((interferingBet != self) && (interferingBet != oldCloseOut)) {
							GOLFBetHoleStatus testStatus = [interferingBet holeStatusForHoleAt18Index:(holeToCheck - 1)];
							if ((testStatus != GOLFBetAWonHoleStatus) && (testStatus != GOLFBetBWonHoleStatus)) {
								//	Any bet must be won/lost, otherwise it interferes
								interference = YES;
								break;	//	Back to try the next hole
							}
						}
					}	//	for (GOLFBet *interferingBet in self.presses)
					if (!interference) {
						//	Checked all the bets - found no interference
						startHole = holeToCheck;
						break;
					}
				}	//	for (NSUInteger holeToCheck = (holePosition + 1); (holeToCheck <= ourLastHole); holeToCheck++)
				
				if (startHole > 0) {
					if ((oldCloseOut != nil) && ([oldCloseOut fromHole] == holePosition)) {
						newCloseOut = oldCloseOut;
					} else {
						newCloseOut = [GOLFBet betWithName:@"" reason:GOLFBetCloseOutReason startingAt:startHole endingAt:ourLastHole];
						newCloseOut.handicapStyle = self.handicapStyle;	//	Propagates
						newCloseOut.does2DownAutomatics = needAutomatic2Downs;	//	Propagates
						newCloseOut.does1DownLastHoleAutomatics = needAutomaticLastHole1Downs;	//	Propagates
						newCloseOut.doesCloseOuts = needCloseOuts;	//	Propagates
//						newCloseOut.fromBet = self;	//	Done when we addPress:
						newCloseOut.fromHole = holePosition;
						newCloseOut.fromUp = holeStatus;	//	Should be GOLFBetAWonHoleStatus or GOLFBetBWonHoleStatus
					}
				}
			}	//	if (((status == GOLFBetAWonHoleStatus) && (precedingStatus != GOLFBetAWonHoleStatus)) || (...)
		}	//	for (holePosition = (ourLastHole - 1); ((holePosition > ourFirstHole) && (newCloseOut == nil)); holePosition--)
	}	//	if (needCloseOuts && ((self.fromBet == nil) || [self.fromBet doesCloseOuts]) && (newCloseOut == nil))
	
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

- (void)setHandicapStyle:(GOLFWageringHandicapStyle)newHandicapStyle {
	_handicapStyle = newHandicapStyle;

	//	Now tell all our presses
	for (GOLFBet *press in [self pressesArray]) {
		press.handicapStyle = newHandicapStyle;
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
	_doesCloseOuts = (((self.fromBet == nil) || (self.reason == GOLFBetCloseOutReason)) ? doesEm : NO);

	//	Now tell all our presses
	for (GOLFBet *press in [self pressesArray]) {
		if ((press.fromBet == nil) || (press.reason == GOLFBetCloseOutReason)) { 
			press.doesCloseOuts = doesEm;
		}
	}
}

#pragma mark Property List Storage

- (NSDictionary *)dictionaryRepresentation {
	//	A dictionary representation of a GOLFBet
	//	key							type			description
	//	--------------------------	--------------	-----------------------------------------------------------------------
	//	ARoundIDForWagering			id				NSString* or NSNumber* identifying ARound as a <GOLFWageringDataSource>
	//	BRoundIDForWagering			id				NSString* or NSNumber* identifying BRound as a <GOLFWageringDataSource>
	//	AStrokesString				NSString *		18-character string of strokes given for A competitor
	//	BStrokesString				NSString *		18-character string of strokes given for B competitor
	//	betInfo						NSDictionary *	Top level bet data
	//	betName						NSString *		Name of bet ("F", "Back", "18", "Match", etc.)
	//	does2DownAutomatics			NSNumber *		BOOL set if an automatic 2-down press is available for this bet
	//	does1DownLastHoleAutomatics	NSNumber *		BOOL set if an automatic 1-down press at the last hole is available
	//	doesCloseOuts				NSNumber *		BOOL set if Close Out presses are available on this bet
	//	holesStatus					NSString *		18-character hole-by-hole status
	//	presses						NSArray *		Presses (GOLFBet) connected to this bet
	//	reason						NSNumber *		GOLFBetReason for the bet's existence (press type, etc.)
	//	handicapStyle				NSNumber *		GOLFWageringHandicapStyle handicapping style (Gross, Full, Difference)
	//	betStatus					NSNumber *		GOLFBetStatus overall bet status
	//	firstHole					NSNumber *		The first hole for the bet
	//	fromHole					NSNumber *		The number (index) of the hole after which the bet began
	//	lastHole					NSNumber *		The last scored hole for this bet
	//	betUp						NSNumber *		The last determined "up", "down" or "even" status of the bet
	//	betToGo						NSNumber *		The number of holes remaining at the time betUp was determined
	//	upString					NSString *		Bet & Presses status string ("3/1/-1", etc.)
	
	NSMutableDictionary *representationDict = [NSMutableDictionary dictionaryWithCapacity:10];
	
	//	Main level bets hold the ARound, BRound, aStrokesString, bStrokesString, betInfo
	if ((self.ARound != nil) && [self.ARound respondsToSelector:@selector(IDForWagering)]) {
		id IDForWagering = [(id<GOLFWageringDataSource>)self.ARound IDForWagering];
		if (IDForWagering != nil) {
			[representationDict setObject:IDForWagering forKey:@"ARoundIDForWagering"];
		}
	}
	
	if ((self.BRound != nil) && [self.BRound respondsToSelector:@selector(IDForWagering)]) {
		id IDForWagering = [(id<GOLFWageringDataSource>)self.BRound IDForWagering];
		if (IDForWagering != nil) {
			[representationDict setObject:IDForWagering forKey:@"BRoundIDForWagering"];
		}
	}
	
	NSString *workingString = self.aStrokesString;
	if (workingString != nil) {
		[representationDict setObject:workingString forKey:@"AStrokesString"];
	}
	workingString = self.bStrokesString;
	if (workingString != nil) {
		[representationDict setObject:workingString forKey:@"BStrokesString"];
	}
	
	if (self.betInfo != nil) {
		NSMutableDictionary *betInfoDict = [NSMutableDictionary dictionaryWithCapacity:6];
		//	key					type			description
		//	------------------	--------------	----------------------------------------------------------------
		//	aRound				SCRRound *		A competitor's round
		//	aScores				NSArray *		0, 9, or 18 (NSNumber *) A competitor hole-by-hole match scores
		//	aStrokesString		NSString *		18-character string of strokes given for A competitor
		//	aWageringStrokes	NSNumber *		Adjusted wagering strokes for A competitor (un-diff'd)
		//	bRound				SCRRound *		B competitor's round
		//	bScores				NSArray *		0, 9, or 18 (NSNumber *) B competitor hole-by-hole match scores
		//	bStrokesString		NSString *		18-character string of strokes given for B competitor
		//	bWageringStrokes	NSNumber *		Adjusted wagering strokes for B competitor (un-diff'd)
		//	lowHandicap			NSNumber *		GOLFPlayingHandicap for the lowest handicap competitor
		//	lowName				NSString *		name of the lowest-handicapped competitor
		
		NSArray *workingArray = [self.betInfo objectForKey:@"aScores"];
		if (workingArray != nil) {
			[betInfoDict setObject:workingArray forKey:@"aScores"];
		}
		workingString = [self.betInfo objectForKey:@"aStrokesString"];
		if (workingString != nil) {
			[betInfoDict setObject:workingString forKey:@"aStrokesString"];
		}
		workingArray = [self.betInfo objectForKey:@"bScores"];
		if (workingArray != nil) {
			[betInfoDict setObject:workingArray forKey:@"bScores"];
		}
		workingString = [self.betInfo objectForKey:@"bStrokesString"];
		if (workingString != nil) {
			[betInfoDict setObject:workingString forKey:@"bStrokesString"];
		}
		NSNumber *workingNumber = [self.betInfo objectForKey:@"lowHandicap"];
		if (workingNumber != nil) {
			[betInfoDict setObject:workingString forKey:@"lowHandicap"];
		}
		workingString = [self.betInfo objectForKey:@"lowName"];
		if (workingString != nil) {
			[betInfoDict setObject:workingString forKey:@"lowName"];
		}
		
		[representationDict setObject:[NSDictionary dictionaryWithDictionary:betInfoDict] forKey:@"betInfo"];
	}
	
	workingString = self.betName;
	if (workingString != nil) {
		[representationDict setObject:workingString forKey:@"betName"];
	}
	[representationDict setObject:[NSNumber numberWithInteger:self.reason] forKey:@"reason"];
	[representationDict setObject:[NSNumber numberWithUnsignedInteger:self.handicapStyle] forKey:@"handicapStyle"];
	[representationDict setObject:[NSNumber numberWithInteger:self.betStatus] forKey:@"betStatus"];
	workingString = self.holesStatus;
	if (workingString != nil) {
		[representationDict setObject:workingString forKey:@"holesStatus"];
	}
	[representationDict setObject:[NSNumber numberWithInteger:self.firstHole] forKey:@"firstHole"];
	[representationDict setObject:[NSNumber numberWithInteger:self.fromHole] forKey:@"fromHole"];
	[representationDict setObject:[NSNumber numberWithInteger:self.lastHole] forKey:@"lastHole"];
	[representationDict setObject:[NSNumber numberWithInteger:self.betUp] forKey:@"betUp"];
	[representationDict setObject:[NSNumber numberWithInteger:self.betToGo] forKey:@"betToGo"];
	[representationDict setObject:[NSNumber numberWithBool:self.does2DownAutomatics] forKey:@"does2DownAutomatics"];
	[representationDict setObject:[NSNumber numberWithBool:self.does1DownLastHoleAutomatics] forKey:@"does1DownLastHoleAutomatics"];
	[representationDict setObject:[NSNumber numberWithBool:self.doesCloseOuts] forKey:@"doesCloseOuts"];
	
	NSMutableArray *presses = [NSMutableArray arrayWithCapacity:2];
	NSString *pressesUpString;
	NSInteger pressesSquare = 0;
	NSInteger pressesAAhead = 0;
	NSInteger pressesBAhead = 0;
	NSInteger pressesHalved = 0;
	NSInteger pressesAWins = 0;
	NSInteger pressesBWins = 0;
	for (GOLFBet *aPress in self.presses) {
		NSDictionary *pressDict = [aPress dictionaryRepresentation];
		NSString *pressUpString = [pressDict objectForKey:@"upString"];
		pressesSquare = [[pressDict objectForKey:@"betsSquare"] integerValue];
		pressesAAhead = [[pressDict objectForKey:@"betsAAhead"] integerValue];
		pressesBAhead = [[pressDict objectForKey:@"betsBAhead"] integerValue];
		pressesHalved = [[pressDict objectForKey:@"betsHalved"] integerValue];
		pressesAWins = [[pressDict objectForKey:@"betsAWins"] integerValue];
		pressesBWins = [[pressDict objectForKey:@"betsBWins"] integerValue];
		[presses addObject:pressDict];
		
		if (pressUpString) {
			pressesUpString = (pressesUpString ? [pressesUpString stringByAppendingFormat:@"•%@", pressUpString] : pressUpString);
		}
	}
	
	NSString *betStatusString = GOLFLocalizedString(@"ALL_SQUARE_CHARACTER");
	if (IS_ANY_BET_SCORED_STATUS(self.betStatus)) {
		if (IS_ANY_UP_BET_STATUS(self.betStatus)) {
			betStatusString = [NSString stringWithFormat:@"%ld%@", (long)self.betUp, GOLFLocalizedString(@"UPWARD_ARROW")];	//	"3↑"
		} else if (IS_ANY_DOWN_BET_STATUS(self.betStatus)) {
			betStatusString = [NSString stringWithFormat:@"%ld%@", (long)self.betUp, GOLFLocalizedString(@"DOWNWARD_ARROW")];	//	@"1↓"
		} else {
			betStatusString = [NSString stringWithFormat:@"%ld", (long)self.betUp];	//	@"0"
		}
	}

	if (pressesUpString) {
		betStatusString = [betStatusString stringByAppendingFormat:@"/%@", pressesUpString];
	}
	NSInteger betsSquare = ((self.betStatus == GOLFBetAllSquare) ? (pressesSquare + 1) : pressesSquare);
	NSInteger betsAAhead = ((self.betStatus == GOLFBetAAhead) ? (pressesAAhead + 1) : pressesAAhead);
	NSInteger betsBAhead = ((self.betStatus == GOLFBetBAhead) ? (pressesBAhead + 1) : pressesBAhead);
	NSInteger betsHalved = ((self.betStatus == GOLFBetHalved) ? (pressesHalved + 1) : pressesHalved);
	NSInteger betsAWins = ((self.betStatus == GOLFBetAWins) ? (pressesAWins + 1) : pressesAWins);
	NSInteger betsBWins = ((self.betStatus == GOLFBetBWins) ? (pressesBWins + 1) : pressesBWins);

	[representationDict setObject:betStatusString forKey:@"upString"];
	
	[representationDict setObject:[NSNumber numberWithInteger:betsSquare] forKey:@"betsSquare"];
	[representationDict setObject:[NSNumber numberWithInteger:betsAAhead] forKey:@"betsAAhead"];
	[representationDict setObject:[NSNumber numberWithInteger:betsBAhead] forKey:@"betsBAhead"];
	[representationDict setObject:[NSNumber numberWithInteger:betsHalved] forKey:@"betsHalved"];
	[representationDict setObject:[NSNumber numberWithInteger:betsAWins] forKey:@"betsAWins"];
	[representationDict setObject:[NSNumber numberWithInteger:betsBWins] forKey:@"betsBWins"];

	[representationDict setObject:[NSArray arrayWithArray:presses] forKey:@"presses"];
	return [NSDictionary dictionaryWithDictionary:representationDict];
}

- (void)setDictionaryRepresentation:(NSDictionary *)dictionary {
	//	Assuming we've just been created and initialized, initialize and create our associated presses…
	//	Original top-level bets must include (GOLFWageringDataSource> "ARound" and "BRound" from appropriate context
	if (dictionary != nil) {
		id<GOLFWageringDataSource> workingRound = [dictionary objectForKey:@"ARound"];
		if (workingRound) {
			self.ARound = workingRound;
		}
		workingRound = [dictionary objectForKey:@"BRound"];
		if (workingRound) {
			self.BRound = workingRound;
		}

		NSString *workingString = [dictionary objectForKey:@"AStrokesString"];
		if (workingString != nil) {
			self.aStrokesString = workingString;
		}
		workingString = [dictionary objectForKey:@"BStrokesString"];
		if (workingString != nil) {
			self.bStrokesString = workingString;
		}
	
		NSDictionary *workingDict = [dictionary objectForKey:@"betInfo"];
		if (workingDict != nil) {
			self.betInfo = workingDict;
		}

		workingString = [dictionary objectForKey:@"betName"];
		if (workingString != nil) {
			self.betName = workingString;
		}
		self.reason = ([dictionary objectForKey:@"reason"] ? [[dictionary objectForKey:@"reason"] integerValue] : GOLFBetStandardReason);
		self.handicapStyle = ([dictionary objectForKey:@"handicapStyle"] ? [[dictionary objectForKey:@"handicapStyle"] unsignedIntegerValue] : GOLFWageringUnknownHandicapStyle);
		self.betStatus = ([dictionary objectForKey:@"betStatus"] ? [[dictionary objectForKey:@"betStatus"] integerValue] : GOLFBetUnknownStatus);
		
		workingString = [dictionary objectForKey:@"holesStatus"];
		if (workingString != nil) {
			self.holesStatus = workingString;
		}
		
		self.firstHole = [[dictionary objectForKey:@"firstHole"] integerValue];
		self.fromHole = [[dictionary objectForKey:@"fromHole"] integerValue];
		self.lastHole = [[dictionary objectForKey:@"lastHole"] integerValue];
		self.betUp = [[dictionary objectForKey:@"betUp"] integerValue];
		self.betToGo = [[dictionary objectForKey:@"betToGo"] integerValue];
		
		self.does2DownAutomatics = [[dictionary objectForKey:@"does2DownAutomatics"] boolValue];
		self.does1DownLastHoleAutomatics = [[dictionary objectForKey:@"does1DownLastHoleAutomatics"] boolValue];
		self.doesCloseOuts = [[dictionary objectForKey:@"doesCloseOuts"] boolValue];
		
		NSArray *workingArray = [dictionary objectForKey:@"presses"];
		if (workingArray != nil) {
			for (NSDictionary *pressDict in workingArray) {
				GOLFBet *newPress = [[GOLFBet alloc] init];
				newPress.fromBet = self;
				[newPress setDictionaryRepresentation:pressDict];
			}
		}
	}
}

@end
