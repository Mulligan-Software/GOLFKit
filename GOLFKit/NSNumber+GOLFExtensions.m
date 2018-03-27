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

@end
