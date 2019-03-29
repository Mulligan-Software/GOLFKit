//
//  GOLFDynamicColor.h
//  GOLFKit
//
//  Created by John Bishop on 10/22/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <GOLFKit/GOLFColors.h>

@interface GOLFDynamicColor : GOLFColor

+ (GOLFColor *_Nonnull)dynamicColorWithAquaColor:(GOLFColor *_Nonnull)aquaColor darkAquaColor:(GOLFColor *__nullable)darkAquaColor;

- (instancetype _Nonnull )initWithAquaColor:(GOLFColor *_Nonnull)aquaColor darkAquaColor:(GOLFColor *__nullable)darkAquaColor;

- (GOLFColor *_Nonnull)effectiveColor;

@end
