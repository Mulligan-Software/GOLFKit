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

//	Globals
CGFloat GOLFColorDefaultYardageContrast = 0.40;	//	Somewhere around 0.35

@implementation GOLFColor (GOLFColorCategories)

+ (BOOL)darkMode {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	if (@available(iOS 13.0, *)) {
		UITraitCollection *currentTraits = [UITraitCollection currentTraitCollection];
		return ([currentTraits userInterfaceStyle] == UIUserInterfaceStyleDark);
	}
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

	return (GOLFColor *)[UIColor systemPurpleColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryEagleColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemPurpleColor] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
	}
	return [GOLFColor purpleColor];
	
#endif
}

+ (id)GOLFFactoryBirdieScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return (GOLFColor *)[UIColor systemRedColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryBirdieColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemRedColor] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
	}
	return [GOLFColor redColor];
	
#endif
}

+ (id)GOLFFactoryParScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	return (GOLFColor *)[UIColor systemBlueColor];

#elif TARGET_OS_MAC

	if (@available (macOS 10.13, *)) {
		return [GOLFColor GOLFFactoryParColor];
	}
	if (@available (macOS 10.10, *)) {
		return (GOLFColor *)[[NSColor systemBlueColor] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
	}
	return [GOLFColor blueColor];
	
#endif
}

+ (id)GOLFFactoryBogeyScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	if (@available(iOS 13.0, *)) {
		return (GOLFColor *)[UIColor labelColor];
	}
	return [GOLFColor darkTextColor];

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
	return [GOLFColor GOLFFactoryEagleScoreColor];
}

+ (id)GOLFFactoryDarkBirdieScoreColor {
	return [GOLFColor GOLFFactoryBirdieScoreColor];
}

+ (id)GOLFFactoryDarkParScoreColor {
	return [GOLFColor GOLFFactoryParScoreColor];
}

+ (id)GOLFFactoryDarkBogeyScoreColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	if (@available(iOS 13.0, *)) {
		return (GOLFColor *)[UIColor labelColor];
	}
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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryBirdieColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemRedColor];

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

	if (@available(iOS 13.0, *)) {
		return (GOLFColor *)[UIColor labelColor];
	}
	return [GOLFColor darkTextColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryEagleColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemPurpleColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryErrorHighlightColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemYellowColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryErrorHighlightColor" bundle:GOLFKitBundle()];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor yellowColor] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryMatchAColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchAColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemBlueColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchAColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemBlueColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchBColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemRedColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryMatchBColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemRedColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryParColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemBlueColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPeoriaBackgroundColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemBlueColor];

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

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingPrimaryColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return [GOLFColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingPrimaryColor" bundle:GOLFKitBundle()];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor colorWithCalibratedRed:0.0 green:(0.5) blue:0.0 alpha:1.0] darkAquaColor:nil];
	
#endif
}

+ (id)GOLFFactoryPlottingSecondaryColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingSecondaryColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return [GOLFColor darkTextColor];

#elif TARGET_OS_MAC

	if (@available(macOS 10.13, *)) {
		return [GOLFColor colorNamed:@"GOLFFactoryPlottingSecondaryColor" bundle:GOLFKitBundle()];
	}
	return [GOLFDynamicColor dynamicColorWithAquaColor:[NSColor blackColor] darkAquaColor:[NSColor whiteColor]];
	
#endif
}

+ (id)GOLFFactorySkinsBackgroundColor {
#if TARGET_OS_IOS || TARGET_OS_WATCH

	if (@available(iOS 13.0, *)) {
		return [GOLFColor colorNamed:@"GOLFFactorySkinsBackgroundColor" inBundle:GOLFKitBundle() compatibleWithTraitCollection:[UITraitCollection currentTraitCollection]];
	}
	return (GOLFColor *)[UIColor systemGreenColor];

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

- (CGFloat)colorimetricDistanceToGOLFColor:(GOLFColor *)compareColor {
	//	Determining a colorimetric difference (contrast) between our color and compareColor
	//	Formula is: diff = sqrt( (kR x (red1 - red2)^2) + (kG x (green1 - green2)^2) + (kB x (blue1 - blue2)^2) )
	//	where kR = 0.299, kG = 0.587, kB = 0.114

	CGFloat ourRed, ourGreen, ourBlue;
	CGFloat otherRed, otherGreen, otherBlue;

#if TARGET_OS_IOS || TARGET_OS_WATCH

	BOOL converted = [self getRed:&ourRed green:&ourGreen blue:&ourBlue alpha:nil];
	converted = [compareColor getRed:&otherRed green:&otherGreen blue:&otherBlue alpha:nil];
	
#elif TARGET_OS_MAC

	NSColor *ourColor = [self colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
	NSColor *otherColor = [compareColor colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
	[ourColor getRed:&ourRed green:&ourGreen blue:&ourBlue alpha:nil];
	[otherColor getRed:&otherRed green:&otherGreen blue:&otherBlue alpha:nil];
	
#endif

	return sqrtf((0.299 * powf((ourRed - otherRed), 2.0)) + (0.587 * powf((ourGreen - otherGreen), 2.0)) + (0.114 * powf((ourBlue - otherBlue), 2.0)));
}

@end
