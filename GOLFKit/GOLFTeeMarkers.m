//
//  GOLFTeeMarkers.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"
#import "GOLFTeeMarkers.h"
#import "GOLFColors.h"
#import "NSNumber+GOLFExtensions.h"

//	Private Prototypes
static NSArray *cachedStandardTeeColorArray = nil;

//=================================================================
//	GOLFStandardTeeColorArray()
//=================================================================
NSArray * GOLFStandardTeeColorArray(void) {
	if (cachedStandardTeeColorArray == nil) {
		NSBundle *ourBundle = GOLFKitBundle();
		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:kGOLFTeeColorsNumberOfStandard];

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
				@"GOLFTeeMarkerBlack", @"teeIconName",
				@"tee_marker_black", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"teeColorIndex",
				[GOLFColor blueColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BLUE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerBlue", @"teeIconName",
				@"tee_marker_blue", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"teeColorIndex",
				[GOLFColor whiteColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_WHITE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerWhite", @"teeIconName",
				@"tee_marker_white", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_GREEN", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerGreen", @"teeIconName",
				@"tee_marker_green", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Red
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"teeColorIndex",
				[GOLFColor redColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_RED", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerRed", @"teeIconName",
				@"tee_marker_red", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"teeColorIndex",
				[GOLFColor yellowColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_YELLOW", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerYellow", @"teeIconName",
				@"tee_marker_yellow", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Brown
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBrown], @"teeColorIndex",
				[GOLFColor brownColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BROWN", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerBrown", @"teeIconName",
				@"tee_marker_brown", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"teeColorIndex",
				[GOLFColor colorWithRed:(218.0 / 255.0) green:(203.0 / 255.0) blue:(129.0 / 255.0) alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_GOLD", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerGold", @"teeIconName",
				@"tee_marker_gold", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Silver
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorSilver], @"teeColorIndex",
				[GOLFColor colorWithRed:(0.6) green:(0.6) blue:(0.8) alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_SILVER", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerSilver", @"teeIconName",
				@"tee_marker_silver", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Purple
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPurple], @"teeColorIndex",
				[GOLFColor purpleColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_PURPLE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerPurple", @"teeIconName",
				@"tee_marker_purple", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Orange
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrange], @"teeColorIndex",
				[GOLFColor orangeColor], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_ORANGE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerOrange", @"teeIconName",
				@"tee_marker_orange", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Maroon
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorMaroon], @"teeColorIndex",
				[GOLFColor colorWithRed:0.5 green:0 blue:0.25 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_MAROON", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerMaroon", @"teeIconName",
				@"tee_marker_maroon", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Tan
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTan], @"teeColorIndex",
				[GOLFColor colorWithRed:0.792 green:0.675 blue:0.592 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_TAN", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerTan", @"teeIconName",
				@"tee_marker_tan", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Pink
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPink], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:0.753 blue:0.796 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_PINK", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerPink", @"teeIconName",
				@"tee_marker_pink", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Teal
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTeal], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.502 blue:0.502 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_TEAL", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerTeal", @"teeIconName",
				@"tee_marker_teal", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Azure
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorAzure], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.875 blue:1.0 alpha:1.0], @"teeColor",
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_AZURE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerAzure", @"teeIconName",
				@"tee_marker_azure", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlueAndWhite], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.06 blue:1.0 alpha:1.0], @"teeColor",	//	Not quite blue
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_BLUE_AND_WHITE", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerBlueAndWhite", @"teeIconName",
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
				@"GOLFTeeMarkerRedAndYellow", @"teeIconName",
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
				@"GOLFTeeMarkerYellowAndBlue", @"teeIconName",
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
				@"GOLFTeeMarkerRedAndWhite", @"teeIconName",
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
				@"GOLFTeeMarkerBlackAndGold", @"teeIconName",
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
				@"GOLFTeeMarkerWhiteAndGold", @"teeIconName",
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
				@"GOLFTeeMarkerBlackAndWhite", @"teeIconName",
				@"tee_marker_blackandwhite", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	U.S.A.
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorUSA], @"teeColorIndex",
				[GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0], @"teeColor",	//	"Old Glory" red
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_USA", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerUSA", @"teeIconName",
				@"tee_marker_usa", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];

		//	E.U.
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorEU], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0], @"teeColor",	//	E.U. Blue CMYK 100/67/0/40
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_EU", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerEU", @"teeIconName",
				@"tee_marker_eu", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	PGA
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPGA], @"teeColorIndex",
				[GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0], @"teeColor",	//	PGA Purple RGB 34/36/108
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_PGA", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerPGA", @"teeIconName",
				@"tee_marker_pga", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	USGA
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorUSGA], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144 / 255.0) alpha:1.0], @"teeColor",	//	USGA Blue Pantone 280 CVC
				NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_USGA", @"GOLFKit", ourBundle, @""), @"teeColorName",
				@"GOLFTeeMarkerUSGA", @"teeIconName",
				@"tee_marker_usga", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	NOT INCLUDED in this table:
		//	GOLFTeeColorCustom (50)
		//	GOLFTeeColorGeneric (98)
		//	GOLFTeeColorUnknown (99)
		//	GOLFTeeColorAdd (998)
		//	GOLFTeeColorAll (999)
		
		cachedStandardTeeColorArray = [NSArray arrayWithArray:workingList];
	}
	return [cachedStandardTeeColorArray copy];
}

//=================================================================
//	GOLFTeeColorFromTeeColorIndex
//=================================================================
GOLFColor * GOLFTeeColorFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex) {
	if (proposedColorIndex != kNotATeeColorIndex) {
		if ((proposedColorIndex >= GOLFTeeColorFirstSolid) && (proposedColorIndex <= GOLFTeeColorLastCombo)) {
			//	All GOLFTeeColorIndexes for solid and combo tee colors…
			for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
				if ([[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue] == proposedColorIndex)
					return [colorDict objectForKey:@"teeColor"];
			}
		}
		
		if (proposedColorIndex == GOLFTeeColorCustom) {
			//	Custom tee color means someone's keeping the color elsewhere for display
			//	We return off-white in case they need to pick up a tee marker image that they can draw the custom color onto…
			GOLFColor *offWhite = [GOLFColor colorWithRed:(253 / 255.0) green:(253 / 255.0) blue:(253 / 255.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
			return offWhite;
#elif TARGET_OS_MAC
			return [offWhite colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#endif
		}
		
		if (proposedColorIndex == GOLFTeeColorUSA) {
			//	Special USA tee marker - we'll pass back the proper "Old Glory" red…
			return [GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0];
		}
		
		if (proposedColorIndex == GOLFTeeColorEU) {
			//	Special EU tee marker - we'll pass back the proper "EU blue"…
			return [GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0];
		}
		
		if (proposedColorIndex == GOLFTeeColorPGA) {
			//	Special PGA tee marker - we'll pass back the proper "PGA purple"…
			return [GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0];
		}
		
		if (proposedColorIndex == GOLFTeeColorUSGA) {
			//	Special PGA tee marker - we'll pass back the proper "USGA Pantone 280 blue"…
			return [GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144 / 255.0) alpha:1.0];
		}
	}
	
	//	Last resort - return the generic tee color…
	GOLFColor *genericColor = [GOLFColor colorWithRed:(253 / 255.0) green:(253 / 255.0) blue:(253 / 255.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
	return genericColor;
#elif TARGET_OS_MAC
	return [genericColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
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
		CGFloat redTestComponent;
		CGFloat greenTestComponent;
		CGFloat blueTestComponent;

#if TARGET_OS_IOS || TARGET_OS_WATCH
		GOLFColor *rgb = teeColor;
		[rgb getRed:&redComponent green:&greenComponent blue:&blueComponent alpha:nil];
#elif TARGET_OS_MAC
		GOLFColor *rgb = [teeColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		redComponent = [rgb redComponent];
		greenComponent = [rgb greenComponent];
		blueComponent = [rgb blueComponent];
#endif
		//	Check for a standard color…
		GOLFColor *testColor;
		for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
			GOLFTeeColorIndex testColorIndex = [[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue];

			//	We'll try to find a matching color in the numerically identifiable colors…
#if TARGET_OS_IOS || TARGET_OS_WATCH
			testColor = [colorDict objectForKey:@"teeColor"];
			[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
			testColor = [[colorDict objectForKey:@"teeColor"] colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
			redTestComponent = [testColor redComponent];
			greenTestComponent = [testColor greenComponent];
			blueTestComponent = [testColor blueComponent];
#endif
			if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
				return testColorIndex;
			}
		}
		
		GOLFColor *oldGloryRed = [GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
		testColor = oldGloryRed;
		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
		testColor = [oldGloryRed colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		redTestComponent = [testColor redComponent];
		greenTestComponent = [testColor greenComponent];
		blueTestComponent = [testColor blueComponent];
#endif
		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
			return GOLFTeeColorUSA;
		}

		GOLFColor *euBlue = [GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
		testColor = euBlue;
		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
		testColor = [euBlue colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		redTestComponent = [testColor redComponent];
		greenTestComponent = [testColor greenComponent];
		blueTestComponent = [testColor blueComponent];
#endif
		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
			return GOLFTeeColorEU;
		}

		GOLFColor *pgaPurple = [GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
		testColor = pgaPurple;
		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
		testColor = [pgaPurple colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		redTestComponent = [testColor redComponent];
		greenTestComponent = [testColor greenComponent];
		blueTestComponent = [testColor blueComponent];
#endif
		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
			return GOLFTeeColorPGA;
		}
		
		GOLFColor *usgaBlue = [GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144.0 / 255.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
		testColor = usgaBlue;
		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
		testColor = [usgaBlue colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		redTestComponent = [testColor redComponent];
		greenTestComponent = [testColor greenComponent];
		blueTestComponent = [testColor blueComponent];
#endif
		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
			return GOLFTeeColorUSGA;
		}
		
		return GOLFTeeColorCustom;	//	Any color we don't recognize is a custom color!
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
	if (proposedColorIndex == GOLFTeeColorGeneric)
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_GENERIC", @"GOLFKit", ourBundle, @"");
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
	
	if (proposedColorIndex == GOLFTeeColorUSA) {
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_USA", @"GOLFKit", ourBundle, @"");
	}
	if (proposedColorIndex == GOLFTeeColorEU) {
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_EU", @"GOLFKit", ourBundle, @"");
	}
	if (proposedColorIndex == GOLFTeeColorPGA) {
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_PGA", @"GOLFKit", ourBundle, @"");
	}
	if (proposedColorIndex == GOLFTeeColorUSGA) {
		return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_USGA", @"GOLFKit", ourBundle, @"");
	}

	return NSLocalizedStringFromTableInBundle(@"GOLF_TEE_COLOR_NAME_UNKNOWN", @"GOLFKit", ourBundle, @"");
}

//=================================================================
//	GOLFTeeMarkerImageFromSpecs
//=================================================================
GOLFTeeImage * GOLFTeeMarkerImageFromSpecs(GOLFTeeColorIndex teeColorIndex, GOLFTeeMarkerImageSize imageSize) {
	NSBundle *ourBundle = GOLFKitBundle();

	//	Starting with defaults…
	NSUInteger workingSize = imageSize;
	NSString *workingTeeImageName = @"tee_marker_generic";
	
	//	Finalize the image size…
	switch (imageSize) {
  		case GOLFTeeMarkerImageSize16pt:
  		case GOLFTeeMarkerImageSize64pt:
    		break;

  		default:
  			workingSize = GOLFTeeMarkerImageSizeDefault;
    		break;
	}
	
	//	Finalize the image name…
	if (teeColorIndex != GOLFTeeColorGeneric) {
		if ((teeColorIndex >= GOLFTeeColorFirstSolid) && (teeColorIndex <= GOLFTeeColorLastCombo)) {
			for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
				if ([[colorDict objectForKey:@"teeColorIndex"] integerValue] == teeColorIndex) {
					workingTeeImageName = [colorDict objectForKey:@"teeImageName"];
					break;	//	Out of "for (NSDictionary *colorDict" loop
				}
			}
		} else if (teeColorIndex == GOLFTeeColorAdd) {
			workingTeeImageName = @"tee_marker_add";
		} else if (teeColorIndex == GOLFTeeColorAll) {
			workingTeeImageName = @"tee_marker_all";
		} else if (teeColorIndex == GOLFTeeColorUSA) {
			workingTeeImageName = @"tee_marker_usa";
		} else if (teeColorIndex == GOLFTeeColorEU) {
			workingTeeImageName = @"tee_marker_eu";
		} else if (teeColorIndex == GOLFTeeColorPGA) {
			workingTeeImageName = @"tee_marker_pga";
		} else if (teeColorIndex == GOLFTeeColorUSGA) {
			workingTeeImageName = @"tee_marker_usga";
		}
	}
#if TARGET_OS_IOS || TARGET_OS_WATCH
	return [GOLFTeeImage imageNamed:[workingTeeImageName stringByAppendingFormat:@"_%lu", (unsigned long)workingSize] inBundle:ourBundle compatibleWithTraitCollection:nil];
#elif TARGET_OS_MAC
	return (GOLFTeeImage *)[ourBundle imageForResource:[workingTeeImageName stringByAppendingFormat:@"_%lu", (unsigned long)workingSize]];
#endif

}

//=================================================================
//	GOLFTeeMarkerImageFromTeeColorIndex
//=================================================================
GOLFTeeImage * GOLFTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex) {
	return GOLFTeeMarkerImageFromSpecs(teeColorIndex, GOLFTeeMarkerImageSizeDefault);
}

//=================================================================
//	GOLFLittleTeeMarkerImageFromTeeColorIndex
//=================================================================
GOLFTeeImage * GOLFLittleTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex) {
	return GOLFTeeMarkerImageFromSpecs(teeColorIndex, GOLFTeeMarkerImageSize16pt);
}

//=================================================================
//	GOLFLargeTeeMarkerImageFromTeeColorIndex
//=================================================================
GOLFTeeImage * GOLFLargeTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex) {
	return GOLFTeeMarkerImageFromSpecs(teeColorIndex, GOLFTeeMarkerImageSize64pt);
}

