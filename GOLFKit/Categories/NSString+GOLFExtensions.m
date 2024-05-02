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

NSString *ETagLetters = @"abcdefghijklmnopqrstuvwxyz0123456789";

+ (id)randomETagStringOfLength:(NSUInteger)length {
	//	returns a string of length "length" containing random lowercase alphabetic and numeric characters
	//	appropriate for creating HTTP ETags or similar random character strings
	NSMutableString *randomETagString = [NSMutableString stringWithCapacity:length];
	unsigned int bound = (unsigned int)[ETagLetters length];
	for (NSUInteger i = 0; i < length; i++) {
		[randomETagString appendFormat:@"%C", [ETagLetters characterAtIndex:arc4random_uniform(bound)]];
	}
	
	return [NSString stringWithString:randomETagString];
}

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

- (BOOL)isValidHandicapServiceAccountForAuthority:(GOLFHandicapAuthority *)authority {
	//	determines whether the this string (a GOLFHandicapServiceAccountID) is in a format
	//	valid for a user account at the handicapping service used by the designated authority.
	NSUInteger ourLength = self.length;
	if (ourLength > 0) {
		if ((authority && [authority length] > 1)) {
			if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityWHS2020]) {
				//	WHS uses GHIN, which uses 7 or fewer, 8 or 10 digit account numbers
				if ([self rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
					if ((ourLength <= 7) || (ourLength == 8) || (ourLength == 10)) {
						return YES;
					}
				}
			}
			if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
				//	AGU uses GOLFLink, which uses 10 digit account numbers
				if ([self rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
					if (ourLength == 10) {
						return YES;
					}
				}
#ifdef DEBUG
				NSLog(@"NSString -isValidHandicapServiceAccountForAuthority: Trying to validate GOLFLink account \'%@\'", self);
#endif
			}
			if ([authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
				//	USGA (superceded) uses GHIN, which uses 7 digit or fewer account numbers
				//	It requires decimal digits
				if ([self rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
					if (ourLength <= 7) {
						return YES;
					}
				}
			}
			return YES;	//	We don't have limitations on other handicapping services
		}	//	if ((authority && [authority length] > 1))
	}	//	if (self.length > 0)
	return NO;	//	By default, NO
}

@end
