//
//  NSNumber+GOLFExtensions.h
//  GOLFKit
//
//  Created by John Bishop on 10/23/17.
//  Copyright © 2017 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"

@interface NSNumber (MULExtensions)

+ (id)numberWithTeeColorIndex:(GOLFTeeColorIndex)teeColorIndex;
- (GOLFTeeColorIndex)teeColorIndexValue;

@end
