//
//  NSString+GOLFExtensions.h
//  GOLFKit
//
//  Created by John Bishop on 6/17/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"

@interface NSString (GOLFExtensions)

+ (id)randomETagStringOfLength:(NSUInteger)length;	//	For constructing HTTP ETags like W/"beacfba9aaa14875b2f1cf89fd46351b1"

+ (id)stringForWageringStrokesAtHole:(GOLFHandicapStrokes)holeStrokes;
- (GOLFHandicapStrokes)wageringStrokesAtIndex:(NSUInteger)holeIndex;

@end
