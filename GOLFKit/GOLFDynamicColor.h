//
//  GOLFDynamicColor.h
//  GOLFKit
//
//  Created by John Bishop on 10/22/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <GOLFKit/GOLFColors.h>

@interface GOLFDynamicColor : GOLFColor

+ (GOLFColor *)dynamicColorWithAquaColor:(GOLFColor *)aquaColor darkAquaColor:(GOLFColor *__nullable)darkAquaColor;

- (instancetype)initWithAquaColor:(GOLFColor *)aquaColor darkAquaColor:(GOLFColor *__nullable)darkAquaColor;

- (GOLFColor *)effectiveColor;

@end
