//
//  NSColor+GOLFExtensions.m
//  GOLFKit
//
//  Created by John Bishop on 10/23/17.
//  Copyright © 2017 Mulligan Software. All rights reserved.
//

#import "NSColor+GOLFExtensions.h"
#import "GOLFKitTypes.h"
#import "GOLFDynamicColor.h"

@implementation NSColor (GOLFExtensions)

- (NSColor *)effectiveColor {
	if (self.type == NSColorTypeCatalog) {
		return self;
	}
	return [[GOLFDynamicColor dynamicColorWithAquaColor:self darkAquaColor:nil] effectiveColor];
}

@end
