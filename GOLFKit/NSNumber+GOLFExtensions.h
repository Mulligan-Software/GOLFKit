//
//  NSNumber+GOLFExtensions.h
//  GOLFKit
//
//  Created by John Bishop on 10/23/17.
//  Copyright © 2017 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "GOLFColors.h"

@interface NSNumber (GOLFExtensions)

+ (id)numberWithTeeColorIndex:(GOLFTeeColorIndex)teeColorIndex;
- (GOLFTeeColorIndex)teeColorIndexValue;

+ (id)numberWithHandicapIndex:(GOLFHandicapIndex)handicapIndex;
- (GOLFHandicapIndex)handicapIndexValue;

+ (id)numberWithHandicapAllowance:(GOLFHandicapAllowance)handicapAllowance;
- (GOLFHandicapAllowance)handicapAllowanceValue;

+ (id)numberWithPlayingHandicap:(GOLFPlayingHandicap)playingHandicap;
- (GOLFPlayingHandicap)playingHandicapValue;

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

@end
