//
//  GOLFTeeMarkers.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFTeeMarkers.h"
#import "GOLFColors.h"
#import "NSNumber+GOLFExtensions.h"

//	Private Prototypes

//	Globals
static NSArray *StandardTeeColorArray = nil;
static NSBundle *GolfKitBundle = nil;

//=================================================================
//	GOLFKitBundle()
//=================================================================
NSBundle * GOLFKitBundle(void) {
	if (GolfKitBundle == nil) {
		GolfKitBundle = [NSBundle bundleWithIdentifier:@"com.mulligansoftware.GOLFKit"];
	}
	return GolfKitBundle;
}

//=================================================================
//	GOLFStandardTeeColorArray()
//=================================================================
NSArray * GOLFStandardTeeColorArray(void) {
	if (StandardTeeColorArray == nil) {
		NSBundle *ourBundle = GOLFKitBundle();
		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:GOLFNumberOfCandidateTeeColors];

		//	Each entry in GOLFStandardTeeColorArray is a NSDictionary with the following keyed items:
		//
		//	Key					Type			Description
		//	--------------		----------		------------------------------------------------------------------------------------------
		//	teeColorIndex		NSNumber		unsigned integer representing the tee color
		//	teeColor			GOLFColor		NSColor (macOS) or UIColor (iOS) representing visual equivalent for display or tinting
		//	teeColorName		NSString		localized name of the color (ie: "Vert", "Black & White", "Rojo y Blanco")@"teeColorName",
		//	teeIconName			NSString		name of the tee icon (.ICNS), like "TeeMarkerBlueAndWhite"
		//	teeImageName		NSString		name of the tee image (.PNG), like "tee_marker_blueandwhite" (excluding any size or scale identification)
		//	isComboColor		NSNumber		optional boolean TRUE if entry represents a color combination (two colors)
		//	firstColorIndex		NSNumber		teeColorIndex of one of the combination's solid colors (when isComboColor is TRUE)
		//	secondColorIndex	NSNumber		teeColorIndex of the other of the combination's solid colors (when isComboColor is TRUE)
		
		//	Black
		NSDictionary *colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"teeColorIndex",
				[GOLFColor blackColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BLACK", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerBlack", @"teeIconName",
				@"tee_marker_black", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"teeColorIndex",
				[GOLFColor blueColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BLUE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerBlue", @"teeIconName",
				@"tee_marker_blue", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"teeColorIndex",
				[GOLFColor whiteColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_WHITE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerWhite", @"teeIconName",
				@"tee_marker_white", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_GREEN", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerGreen", @"teeIconName",
				@"tee_marker_green", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Red
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"teeColorIndex",
				[GOLFColor redColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_RED", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerRed", @"teeIconName",
				@"tee_marker_red", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"teeColorIndex",
				[GOLFColor yellowColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_YELLOW", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerYellow", @"teeIconName",
				@"tee_marker_yellow", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Brown
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBrown], @"teeColorIndex",
				[GOLFColor brownColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BROWN", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerBrown", @"teeIconName",
				@"tee_marker_brown", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_GOLD", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerGold", @"teeIconName",
				@"tee_marker_gold", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Silver
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorSilver], @"teeColorIndex",
				[GOLFColor colorWithRed:(0.6) green:(0.6) blue:(0.8) alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_SILVER", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerSilver", @"teeIconName",
				@"tee_marker_silver", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Purple
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPurple], @"teeColorIndex",
				[GOLFColor purpleColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_PURPLE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerPurple", @"teeIconName",
				@"tee_marker_purple", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Orange
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrange], @"teeColorIndex",
				[GOLFColor orangeColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_ORANGE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerOrange", @"teeIconName",
				@"tee_marker_orange", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Maroon
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorMaroon], @"teeColorIndex",
				[GOLFColor colorWithRed:0.5 green:0 blue:0.25 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_MAROON", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerMaroon", @"teeIconName",
				@"tee_marker_maroon", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Tan
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTan], @"teeColorIndex",
				[GOLFColor colorWithRed:0.792 green:0.675 blue:0.592 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_TAN", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerTan", @"teeIconName",
				@"tee_marker_tan", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Pink
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPink], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:0.753 blue:0.796 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_PINK", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerPink", @"teeIconName",
				@"tee_marker_pink", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Teal
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTeal], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.502 blue:0.502 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_TEAL", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerTeal", @"teeIconName",
				@"tee_marker_teal", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Azure
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorAzure], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.875 blue:1.0 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_AZURE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerAzure", @"teeIconName",
				@"tee_marker_azure", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlueAndWhite], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.06 blue:1.0 alpha:1.0], @"teeColor",	//	Not quite blue
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BLUE_AND_WHITE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerBlueAndWhite", @"teeIconName",
				@"tee_marker_blueandwhite", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Red & Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRedAndYellow], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_RED_AND_YELLOW", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerRedAndYellow", @"teeIconName",
				@"tee_marker_redandyellow", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Yellow & Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellowAndBlue], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:1.0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite yellow
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_YELLOW_AND_BLUE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerYellowAndBlue", @"teeIconName",
				@"tee_marker_yellowandblue", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Red & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRedAndWhite], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:0.02 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_RED_AND_WHITE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerRedAndWhite", @"teeIconName",
				@"tee_marker_redandwhite", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Black & Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlackAndGold], @"teeColorIndex",
				[GOLFColor colorWithRed:0.1 green:0.06 blue:0.0 alpha:1.0], @"teeColor",	//	Dark gold
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BLACK_AND_GOLD", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerBlackAndGold", @"teeIconName",
				@"tee_marker_blackandgold", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	White & Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhiteAndGold], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:0.61 blue:0.01 alpha:1.0], @"teeColor",	//	Light gold
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_WHITE_AND_GOLD", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerWhiteAndGold", @"teeIconName",
				@"tee_marker_whiteandgold", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Black & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlackAndWhite], @"teeColorIndex",
				[GOLFColor darkGrayColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BLACK_AND_WHITE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"TeeMarkerBlackAndWhite", @"teeIconName",
				@"tee_marker_blackandwhite", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		StandardTeeColorArray = [NSArray arrayWithArray:workingList];
	}
	return [StandardTeeColorArray copy];
}

//=================================================================
//	GOLFTeeColorFromTeeColorIndex
//=================================================================
GOLFColor * GOLFTeeColorFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex) {
	if ((proposedColorIndex != kNotATeeColorIndex) && (proposedColorIndex >= 0) && (proposedColorIndex < GOLFTeeColorCustom)) {
		for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
			if ([[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue] == proposedColorIndex)
				return [colorDict objectForKey:@"teeColor"];
		}
	}
#if TARGET_OS_IOS || TARGET_OS_WATCH
	return [GOLFColor blackColor];
#elif TARGET_OS_MAC
	return [[GOLFColor blackColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#endif
}

//=================================================================
//	GOLFTeeColorIndexFromTeeColor
//=================================================================
GOLFTeeColorIndex GOLFTeeColorIndexFromTeeColor(GOLFColor *teeColor) {
	if (teeColor) {
	CGFloat redComponent;
	CGFloat greenComponent;
	CGFloat blueComponent;
#if TARGET_OS_IOS || TARGET_OS_WATCH
		GOLFColor *rgb = teeColor;
		[rgb getRed:&redComponent green:&greenComponent blue:&blueComponent alpha:nil];
#elif TARGET_OS_MAC
		GOLFColor *rgb = [teeColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		redComponent = [rgb redComponent];
		greenComponent = [rgb greenComponent];
		blueComponent = [rgb blueComponent];
#endif

		for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
			GOLFTeeColorIndex testColorIndex = [[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue];
			if (testColorIndex < GOLFTeeColorCustom) {
				//	We'll try to find a matching color in the numerically identifiable colors…
				CGFloat redTestComponent;
				CGFloat greenTestComponent;
				CGFloat blueTestComponent;
#if TARGET_OS_IOS || TARGET_OS_WATCH
				GOLFColor *testColor = [colorDict objectForKey:@"teeColor"];
				[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
				GOLFColor *testColor = [[colorDict objectForKey:@"teeColor"] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
				redTestComponent = [testColor redComponent];
				greenTestComponent = [testColor greenComponent];
				blueTestComponent = [testColor blueComponent];
#endif
				if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
					return testColorIndex;
				}
			}
		}
		return GOLFTeeColorCustom;
	}
	return GOLFTeeColorUnknown;
}

//=================================================================
//	GOLFTeeColorNameFromTeeColorIndex
//=================================================================
NSString * GOLFTeeColorNameFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex) {
	NSBundle *ourBundle = GOLFKitBundle();
	if ((proposedColorIndex < 0) || (proposedColorIndex == kNotATeeColorIndex) || (proposedColorIndex == GOLFTeeColorUnknown))
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_UNKNOWN", @"GOLFKit", ourBundle, @"");
	if (proposedColorIndex == GOLFTeeColorCustom)
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_CUSTOM", @"GOLFKit", ourBundle, @"");
	if (proposedColorIndex == GOLFTeeColorAdd)
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_ADD", @"GOLFKit", ourBundle, @"");
	if (proposedColorIndex == GOLFTeeColorAll)
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_ALL", @"GOLFKit", ourBundle, @"");

	for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
		if ([[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue] == proposedColorIndex) {
			return [colorDict objectForKey:@"teeColorName"];	//	The GOLFStandardTeeColorArray is localized!
		}
	}

	return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_UNKNOWN", @"GOLFKit", ourBundle, @"");
}

//=================================================================
//	GOLFTeeMarkerImageFromTeeColorIndex
//=================================================================
GOLFTeeImage * GOLFTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex) {
	NSBundle *ourBundle = GOLFKitBundle();
	if (teeColorIndex == GOLFTeeColorAdd) {
		return [GOLFTeeImage imageNamed:@"tee_marker_add_32" inBundle:ourBundle compatibleWithTraitCollection:nil];
	} else if ((teeColorIndex >= 0) && (teeColorIndex < GOLFTeeColorCustom)) {
		for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
			if ([[colorDict objectForKey:@"teeColorIndex"] intValue] == teeColorIndex) {
				return [GOLFTeeImage imageNamed:[[colorDict objectForKey:@"teeImageName"] stringByAppendingString:@"_32"] inBundle:ourBundle compatibleWithTraitCollection:nil];
			}
		}
	}
	return [GOLFTeeImage imageNamed:@"tee_marker_generic_32" inBundle:ourBundle compatibleWithTraitCollection:nil];
}

//=================================================================
//	GOLFLittleTeeMarkerImageFromTeeColorIndex
//=================================================================
GOLFTeeImage * GOLFLittleTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex) {
	NSBundle *ourBundle = GOLFKitBundle();
	if (teeColorIndex == GOLFTeeColorAdd) {
		return [GOLFTeeImage imageNamed:@"tee_marker_add_16" inBundle:ourBundle compatibleWithTraitCollection:nil];
	} else if ((teeColorIndex >= 0) && (teeColorIndex < GOLFTeeColorCustom)) {
		for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
			if ([[colorDict objectForKey:@"teeColorIndex"] intValue] == teeColorIndex) {
				return [GOLFTeeImage imageNamed:[[colorDict objectForKey:@"teeImageName"] stringByAppendingString:@"_16"] inBundle:ourBundle compatibleWithTraitCollection:nil];
			}
		}
	}
	return [GOLFTeeImage imageNamed:@"tee_marker_generic_16" inBundle:ourBundle compatibleWithTraitCollection:nil];
}

