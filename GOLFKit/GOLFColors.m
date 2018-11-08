//
//  GOLFColors.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFColors.h"
#import "GOLFKit.h"
#import "GOLFDynamicColor.h"

#if TARGET_OS_IOS || TARGET_OS_WATCH

#define GOLFColor UIColor

#elif TARGET_OS_MAC

#define GOLFColor NSColor

#endif


//	#undef GOLFColor


@implementation GOLFColor (GOLFColorCategories)

+ (BOOL)dark {
	if (@available(macOS 10.14, *)) {
		NSAppearance *appearance = [NSAppearance currentAppearance] ?: [NSApp effectiveAppearance];
		NSAppearanceName appearanceName = [appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
		
		return [appearanceName isEqualToString:NSAppearanceNameDarkAqua];
	}
	return NO;	
}

+ (id)GOLFFactoryEagleScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryEagleColor];
	}
	
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemPurpleColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
		
	return [GOLFColor purpleColor];
}

+ (id)GOLFFactoryBirdieScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryBirdieColor];
	}
	
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemRedColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}	
	return [GOLFColor redColor];
}

+ (id)GOLFFactoryParScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryParColor];
	}
	
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemBlueColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}	
	return [GOLFColor blueColor];
}

+ (id)GOLFFactoryBogeyScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryBogeyColor];
	}
	
	return [GOLFColor blackColor];
}

+ (id)GOLFFactoryUnderParScoreColor {
	return [GOLFColor GOLFFactoryBirdieScoreColor];
}

+ (id)GOLFFactoryOverParScoreColor {
	return [GOLFColor GOLFFactoryBogeyScoreColor];
}

+ (id)GOLFFactoryDarkEagleScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryEagleColor];
	}
	
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemPurpleColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}	
	return [GOLFColor purpleColor];
}

+ (id)GOLFFactoryDarkBirdieScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryBirdieColor];
	}
	
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemRedColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}	
	return [GOLFColor redColor];
}

+ (id)GOLFFactoryDarkParScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryParColor];
	}
	
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemBlueColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}	
	return [GOLFColor blueColor];
}

+ (id)GOLFFactoryDarkBogeyScoreColor {
	if (@available (macOS 10.13, *)) {
		return [GOLFColor textColor];
	}
	return [GOLFColor whiteColor];
}

//	From GOLFColors.xcassets…
+ (id)GOLFFactoryBirdieColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryBirdieColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemRedColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor redColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryBogeyColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryBogeyColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor textColor];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blackColor] darkAquaColor:[NSColor whiteColor]];
}

+ (id)GOLFFactoryEagleColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryEagleColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemPurpleColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor purpleColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryErrorHighlightColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryErrorHighlightColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor findHighlightColor];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor yellowColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryMatchAColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchAColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryDarkMatchAColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryMatchAColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryMatchBColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchBColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemRedColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor redColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryDarkMatchBColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryMatchBColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemRedColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor redColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryParColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryParColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryPeoriaBackgroundColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPeoriaBackgroundColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
}

+ (id)GOLFFactoryPlottingPrimaryColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingPrimaryColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor colorWithCalibratedRed:0.0 green:(0.5) blue:0.0 alpha:1.0];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor colorWithCalibratedRed:0.0 green:(0.5) blue:0.0 alpha:1.0] darkAquaColor:nil];
}

+ (id)GOLFFactoryPlottingSecondaryColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingSecondaryColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor blackColor];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blackColor] darkAquaColor:[NSColor whiteColor]];
}

+ (id)GOLFFactorySkinsBackgroundColor {
	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactorySkinsBackgroundColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemGreenColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor greenColor] darkAquaColor:nil];
}

@end
