//
//  NSNumber+GOLFExtensions.m
//  GOLFKit
//
//  Created by John Bishop on 10/23/17.
//  Copyright © 2017 Mulligan Software. All rights reserved.
//

#import "NSNumber+GOLFExtensions.h"
#import "GOLFKitTypes.h"

@implementation NSNumber (GOLFExtensions)

+ (id)numberWithTeeColorIndex:(GOLFTeeColorIndex)teeColorIndex {
    return [NSNumber numberWithInteger:(NSInteger)teeColorIndex];
}

- (GOLFTeeColorIndex)teeColorIndexValue {
    return (GOLFTeeColorIndex)[self integerValue];
}

+ (id)numberWithHandicapIndex:(GOLFHandicapIndex)handicapIndex {
	return [NSNumber numberWithFloat:handicapIndex];
}

- (GOLFHandicapIndex)handicapIndexValue {
	return (GOLFHandicapIndex)[self floatValue];
}

+ (id)numberWithPlayingHandicap:(GOLFPlayingHandicap)playingHandicap {
	return [NSNumber numberWithInteger:playingHandicap];
}

- (GOLFPlayingHandicap)playingHandicapValue {
	return (GOLFPlayingHandicap)[self integerValue];
}

+ (id)numberWithHandicapAllowance:(GOLFHandicapAllowance)handicapAllowance {
	return [NSNumber numberWithFloat:handicapAllowance];
}

- (GOLFHandicapAllowance)handicapAllowanceValue {
	return (GOLFHandicapAllowance)[self floatValue];
}

+ (id)numberWithHandicapStrokes:(GOLFHandicapStrokes)handicapStrokes {
	return [NSNumber numberWithInteger:handicapStrokes];
}

- (GOLFHandicapStrokes)handicapStrokesValue {
	return (GOLFHandicapStrokes)[self integerValue];
}

+ (id)numberWithHandicapGrade:(GOLFHandicapGrade)handicapGrade {
	return [NSNumber numberWithInteger:handicapGrade];
}

- (GOLFHandicapGrade)handicapGradeValue {
	return (GOLFHandicapGrade)[self integerValue];
}

+ (id)numberWithHandicapDifferential:(GOLFHandicapDifferential)handicapDifferential {
	return [NSNumber numberWithFloat:handicapDifferential];
}

- (GOLFHandicapDifferential)handicapDifferentialValue {
	return (GOLFHandicapDifferential)[self floatValue];
}

+ (id)numberWithTeeSLOPERating:(GOLFTeeSLOPERating)teeSLOPERating {
	return [NSNumber numberWithInteger:teeSLOPERating];
}

- (GOLFTeeSLOPERating)teeSLOPERatingValue {
	return (GOLFTeeSLOPERating)[self integerValue];
}

+ (id)numberWithTeeCourseRating:(GOLFTeeCourseRating)teeCourseRating {
	return [NSNumber numberWithFloat:teeCourseRating];
}

- (GOLFTeeCourseRating)teeCourseRatingValue {
	return (GOLFTeeCourseRating)[self floatValue];
}

+ (id)numberWithPar:(GOLFPar)par {
	return [NSNumber numberWithInteger:par];
}

- (GOLFPar)parValue {
	return (GOLFPar)[self integerValue];
}

+ (id)numberWithYardage:(GOLFYardage)yardage {
	return [NSNumber numberWithInteger:yardage];
}

- (GOLFYardage)yardageValue {
	return (GOLFYardage)[self integerValue];
}

+ (id)numberWithHoleNumber:(GOLFHoleNumber)holeNumber {
	return [NSNumber numberWithInteger:holeNumber];
}

- (GOLFHoleNumber)holeNumberValue {
	return (GOLFHoleNumber)[self integerValue];
}

+ (id)numberWithHoleHandicap:(GOLFHoleHandicap)holeHandicap {
	return [NSNumber numberWithInteger:holeHandicap];
}

- (GOLFHoleHandicap)holeHandicapValue {
	return (GOLFHoleHandicap)[self integerValue];
}

+ (id)numberWithRoundCCR:(GOLFRoundCCR)roundCCR {
	return [NSNumber numberWithInteger:roundCCR];
}

- (GOLFRoundCCR)roundCCRValue {
	return (GOLFRoundCCR)[self roundCCRValue];
}

+ (id)numberWithScore:(GOLFScore)score {
    return [NSNumber numberWithInteger:(NSInteger)score];
}

- (GOLFScore)scoreValue {
    return (GOLFScore)[self integerValue];
}

+ (id)numberWithGrossScore:(GOLFGrossScore)grossScore {
    return [NSNumber numberWithInteger:(NSInteger)grossScore];
}

- (GOLFGrossScore)grossScoreValue {
    return (GOLFGrossScore)[self integerValue];
}

+ (id)numberWithNetScore:(GOLFNetScore)netScore {
    return [NSNumber numberWithFloat:(float)netScore];
}

- (GOLFNetScore)netScoreValue {
    return (GOLFNetScore)[self floatValue];
}

+ (id)numberWithCompScore:(GOLFCompScore)compScore {
    return [NSNumber numberWithFloat:(float)compScore];
}

- (GOLFCompScore)compScoreValue {
    return (GOLFCompScore)[self floatValue];
}

+ (id)numberWithPutts:(GOLFPutts)putts {
    return [NSNumber numberWithInteger:(NSInteger)putts];
}

- (GOLFPutts)puttsValue {
    return (GOLFPutts)[self integerValue];
}

+ (id)numberWithPlayType:(GOLFPlayType)playType {
	return [NSNumber numberWithUnsignedInteger:playType];
}

- (GOLFPlayType)playTypeValue {
	return (GOLFPlayType)[self unsignedIntegerValue];
}

+ (id)numberWithAllowanceType:(GOLFAllowanceType)allowanceType {
	return [NSNumber numberWithUnsignedInteger:allowanceType];
}

- (GOLFAllowanceType)allowanceTypeValue {
	return (GOLFAllowanceType)[self unsignedIntegerValue];
}

@end
