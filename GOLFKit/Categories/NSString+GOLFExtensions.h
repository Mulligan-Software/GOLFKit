//
//  NSString+GOLFExtensions.h
//  GOLFKit
//
//  Created by John Bishop on 6/17/19.
//  Copyright © 2019 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"

@interface NSString (GOLFExtensions)

+ (id)stringForWageringStrokesAtHole:(GOLFHandicapStrokes)holeStrokes;
- (GOLFHandicapStrokes)wageringStrokesAtIndex:(NSUInteger)holeIndex;

@end
