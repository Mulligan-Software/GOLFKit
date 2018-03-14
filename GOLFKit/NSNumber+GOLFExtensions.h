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

@end
