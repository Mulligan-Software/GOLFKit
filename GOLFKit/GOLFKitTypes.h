//
//  GOLFKitTypes.h
//  GOLFKit
//
//  Created by John Bishop on 11/15/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#ifndef GOLFKitTypes_h
#define GOLFKitTypes_h
#endif /* GOLFKitTypes_h */

//	Clubs, courses, sides, tees, nines, etc.
typedef NSInteger GOLFPar;
typedef NSInteger GOLFYardage;
typedef NSInteger GOLFHoleNumber;
typedef NSInteger GOLFHoleHandicap;
typedef NSInteger GOLFTeeColorIndex;	//	Defined in GOLFColors.h
typedef NSInteger GOLFTeeSLOPERating;
typedef float GOLFTeeCourseRating;

//	Scoring - Events, Scorecards, rounds, etc.
typedef NSInteger GOLFRoundCCR;		//	Calculated course rating, Playing Condition Calculation, etc.
typedef NSInteger GOLFScore;		//	Gross (or whole number) score
typedef GOLFScore GOLFGrossScore;	//	Some might prefer this type description
typedef float GOLFNetScore;			//	Net score (might be computed to some smaller precision)
typedef float GOLFCompScore;		//	Competition score (might be strokes, points, etc. and have fractional parts)
typedef NSInteger GOLFPutts;		//	Putts

//	Handicapping
typedef float GOLFHandicapAllowance;			//	A whole or mixed handicap allowance used to compute a competition score from a gross score
typedef NSString GOLFHandicapAuthority;			//	The mnemonic for a golf handicapping authority (WHS, USGA, PERSONAL, etc.)
typedef float GOLFHandicapDifferential;			//	The intermediate adjusted handicapping "value" of a round used for handicap calculation
typedef float GOLFHandicapExpectedScore;		//	The Expected Score or Differential for 9-hole round or unplayed holes of a round
typedef NSInteger GOLFHandicapGrade;			//	Grade, category, classification, etc.
typedef float GOLFHandicapIndex;				//	The portable course and player independent evaluation of a golfer's skill
typedef float GOLFOfficialHandicap;				//	The course and player-independent numerical representation of a golfer's skill
typedef NSInteger GOLFPlayingHandicap;			//	The whole unadjusted course and player-dependent strokes calculated for a player
typedef float GOLFUnroundedPlayingHandicap;		//	The pre-rounding calculation result of a GOLFPlayingHandicap - full precision
typedef NSInteger GOLFHandicapStrokes;			//	Any value related to strokes earned, taken or used
typedef float GOLFPlayingConditionAdjustment;	//	An handicapping differential adjustment based on playing conditions
typedef NSString GOLFHandicapServiceAccountID;	//	A handicapping service account number or ID  (a GHIN, GolfLink or HandicapNetwork number)

