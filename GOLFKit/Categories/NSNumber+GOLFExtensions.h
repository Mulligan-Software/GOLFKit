//
//  NSNumber+GOLFExtensions.h
//  GOLFKit
//
//  Created by John Bishop on 10/23/17.
//  Copyright © 2017 Mulligan Software. All rights reserved.
//

#import <GOLFKit/GOLFKit.h>
#import <GOLFKit/GOLFColors.h>
#import <GOLFKit/GOLFScoring.h>

@interface NSNumber (GOLFExtensions)

+ (id)numberWithTeeColorIndex:(GOLFTeeColorIndex)teeColorIndex;
- (GOLFTeeColorIndex)teeColorIndexValue;

+ (id)numberWithHandicapIndex:(GOLFHandicapIndex)handicapIndex;
- (GOLFHandicapIndex)handicapIndexValue;

+ (id)numberWithHandicapAllowance:(GOLFHandicapAllowance)handicapAllowance;
- (GOLFHandicapAllowance)handicapAllowanceValue;

+ (id)numberWithHandicapStrokes:(GOLFHandicapStrokes)handicapStrokes;
- (GOLFHandicapStrokes)handicapStrokesValue;

+ (id)numberWithHandicapGrade:(GOLFHandicapGrade)handicapGrade;
- (GOLFHandicapGrade)handicapGradeValue;

+ (id)numberWithHandicapDifferential:(GOLFHandicapDifferential)handicapDifferential;
- (GOLFHandicapDifferential)handicapDifferentialValue;

+ (id)numberWithOfficialHandicap:(GOLFOfficialHandicap)officialHandicap;
- (GOLFOfficialHandicap)officialHandicapValue;

+ (id)numberWithPlayingHandicap:(GOLFPlayingHandicap)playingHandicap;
- (GOLFPlayingHandicap)playingHandicapValue;

+ (id)numberWithUnroundedPlayingHandicap:(GOLFUnroundedPlayingHandicap)unroundedPlayingHandicap;
- (GOLFUnroundedPlayingHandicap)unroundedPlayingHandicapValue;

+ (id)numberWithTeeSLOPERating:(GOLFTeeSLOPERating)teeSLOPERating;
- (GOLFTeeSLOPERating)teeSLOPERatingValue;

+ (id)numberWithTeeCourseRating:(GOLFTeeCourseRating)teeCourseRating;
- (GOLFTeeCourseRating)teeCourseRatingValue;

+ (id)numberWithPar:(GOLFPar)par;
- (GOLFPar)parValue;

+ (id)numberWithYardage:(GOLFYardage)yardage;
- (GOLFYardage)yardageValue;

+ (id)numberWithHoleNumber:(GOLFHoleNumber)holeNumber;
- (GOLFHoleNumber)holeNumberValue;

+ (id)numberWithHoleHandicap:(GOLFHoleHandicap)holeHandicap;
- (GOLFHoleHandicap)holeHandicapValue;

+ (id)numberWithRoundCCR:(GOLFRoundCCR)roundCCR;
- (GOLFRoundCCR)roundCCRValue;

+ (id)numberWithPlayingConditionAdjustment:(GOLFPlayingConditionAdjustment)pcc;
- (GOLFPlayingConditionAdjustment)pccValue;

+ (id)numberWithScore:(GOLFScore)score;
- (GOLFScore)scoreValue;

+ (id)numberWithGrossScore:(GOLFGrossScore)grossScore;
- (GOLFGrossScore)grossScoreValue;

+ (id)numberWithNetScore:(GOLFNetScore)netScore;
- (GOLFNetScore)netScoreValue;

+ (id)numberWithCompScore:(GOLFCompScore)compScore;
- (GOLFCompScore)compScoreValue;

+ (id)numberWithPutts:(GOLFPutts)putts;
- (GOLFPutts)puttsValue;

+ (id)numberWithPlayType:(GOLFPlayType)playType;
- (GOLFPlayType)playTypeValue;

+ (id)numberWithAllowanceType:(GOLFAllowanceType)allowanceType;
- (GOLFAllowanceType)allowanceTypeValue;

- (NSString *)currencyString;
- (NSString *)currencyAccountingString;

@end
