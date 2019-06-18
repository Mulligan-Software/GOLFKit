//
//  NSString+GOLFExtensions.m
//  GOLFKit
//
//  Created by John Bishop on 6/17/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

#import "NSString+GOLFExtensions.h"
#import "GOLFKitTypes.h"

@implementation NSString (GOLFExtensions)

+ (id)stringForWageringStrokesAtHole:(GOLFHandicapStrokes)holeStrokes {
	//	returns a one-character string representing the number of handicap strokes used for wagering at a hole.
	//	Generally, a decimal integer character, but negative values (plus handicaps)
	//	represented by alphabetic characters ("A" == -1)
	
	if (holeStrokes != kNotHandicapStrokes) {
		return ((holeStrokes < 0)
				? [@"ABCDEFGHIJ" substringWithRange:NSMakeRange(((-holeStrokes - 1) % 10), 1)]
				: [NSString stringWithFormat:@"%ld", (long)(holeStrokes % 10)]);
	}
	return @"0";
}

- (GOLFHandicapStrokes)wageringStrokesAtIndex:(NSUInteger)holeIndex {
	//	returns handicap strokes used to determine the match play score used at a hole designated by its index.  
	//	Generally, a strokesString is a 9 or 18 character string of integer strokes, but alphabetic characters
	//	indicate negative values (plus handicaps, ie: "A" == -1)
	
	NSUInteger workingIndex = holeIndex % 18;
	
	if (workingIndex < [self length]) {
		NSString *strokeItem = [self substringWithRange:NSMakeRange(workingIndex, 1)];
		unichar character = [strokeItem characterAtIndex:0];
		if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character]) {
			return (GOLFHandicapStrokes)[strokeItem integerValue];
		} else {
			NSRange foundRange = [@"ABCDEFGHIJ" rangeOfString:strokeItem];
			if (foundRange.location != NSNotFound) {
				return (GOLFHandicapStrokes)(-(foundRange.location + 1));
			}
		}
	}	//	if (holeIndex < [self length])
	return 0;
}

@end
