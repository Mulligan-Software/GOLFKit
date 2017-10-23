//
//  NSNumber+GOLFExtensions.m
//  GOLFKit
//
//  Created by John Bishop on 10/23/17.
//  Copyright © 2017 Mulligan Software. All rights reserved.
//

#import "NSNumber+GOLFExtensions.h"

@implementation NSNumber (GOLFExtensions)

+ (id)numberWithTeeColorIndex:(GOLFTeeColorIndex)teeColorIndex {
    return [NSNumber numberWithInteger:(NSInteger)teeColorIndex];
}

- (GOLFTeeColorIndex)teeColorIndexValue {
    return (GOLFTeeColorIndex)[self integerValue];
}

@end
