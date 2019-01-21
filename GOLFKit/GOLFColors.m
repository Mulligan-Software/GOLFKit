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
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return NO;

#elif TARGET_OS_MAC

	if (@available(macOS 10.14, *)) {
		NSAppearance *appearance = [NSAppearance currentAppearance] ?: [NSApp effectiveAppearance];
		NSAppearanceName appearanceName = [appearance bestMatchFromAppearancesWithNames:@[NSAppearanceNameAqua, NSAppearanceNameDarkAqua]];
		
		return [appearanceName isEqualToString:NSAppearanceNameDarkAqua];
	}
	return NO;	

#endif
}

+ (id)GOLFFactoryEagleScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor purpleColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryEagleColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemPurpleColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	return [GOLFColor purpleColor];
	
#endif
}

+ (id)GOLFFactoryBirdieScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor redColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryBirdieColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemRedColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	return [GOLFColor redColor];
	
#endif
}

+ (id)GOLFFactoryParScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blueColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryParColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemBlueColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	return [GOLFColor blueColor];
	
#endif
}

+ (id)GOLFFactoryBogeyScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blackColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryBogeyColor];
	}
	return [GOLFColor blackColor];
	
#endif
}

+ (id)GOLFFactoryUnderParScoreColor {
	return [GOLFColor GOLFFactoryBirdieScoreColor];
}

+ (id)GOLFFactoryOverParScoreColor {
	return [GOLFColor GOLFFactoryBogeyScoreColor];
}

+ (id)GOLFFactoryDarkEagleScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor purpleColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryEagleColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemPurpleColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	return [GOLFColor purpleColor];
	
#endif
}

+ (id)GOLFFactoryDarkBirdieScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor redColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryBirdieColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemRedColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	return [GOLFColor redColor];
	
#endif
}

+ (id)GOLFFactoryDarkParScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blueColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryParColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemBlueColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	}
	return [GOLFColor blueColor];
	
#endif
}

+ (id)GOLFFactoryDarkBogeyScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor whiteColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor textColor];
	}
	return [GOLFColor whiteColor];
	
#endif
}

//	From GOLFColors.xcassets…
+ (id)GOLFFactoryBirdieColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor redColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryBirdieColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemRedColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor redColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryBogeyColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blackColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryBogeyColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor textColor];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[GOLFColor blackColor] darkAquaColor:[GOLFColor whiteColor]];
	
#endif
}

+ (id)GOLFFactoryEagleColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor purpleColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryEagleColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemPurpleColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor purpleColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryErrorHighlightColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor yellowColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryErrorHighlightColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor findHighlightColor];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor yellowColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryMatchAColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blueColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchAColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
#endif
}

+ (id)GOLFFactoryDarkMatchAColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blueColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryMatchAColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryMatchBColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor redColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchBColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemRedColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor redColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryDarkMatchBColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor redColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryMatchBColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemRedColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor redColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryParColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blueColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryParColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryPeoriaBackgroundColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blueColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPeoriaBackgroundColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemBlueColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blueColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryPlottingPrimaryColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingPrimaryColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor colorWithCalibratedRed:0.0 green:(0.5) blue:0.0 alpha:1.0];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor colorWithCalibratedRed:0.0 green:(0.5) blue:0.0 alpha:1.0] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryPlottingSecondaryColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor blackColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingSecondaryColor" bundle:GOLFKitBundle()];
	}
//	if (@available (macOS 10.10, *)) {
//		return (GOLFColor *)[NSColor blackColor];
//	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blackColor] darkAquaColor:[NSColor whiteColor]];
	
#endif
}

+ (id)GOLFFactorySkinsBackgroundColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return [GOLFColor greenColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactorySkinsBackgroundColor" bundle:GOLFKitBundle()];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[NSColor systemGreenColor];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor greenColor] darkAquaColor:nil];
	
#endif
}

@end
