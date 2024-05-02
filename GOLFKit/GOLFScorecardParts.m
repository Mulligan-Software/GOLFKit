//
//  GOLFTeeMarkers.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFScorecardParts.h"
#import "GOLFKit.h"
#import "GOLFUtilities.h"
#import "GOLFColors.h"
#import "NSNumber+GOLFExtensions.h"

//	Private Prototypes
//static NSArray *cachedStandardTeeColorArray = nil;
//static NSMutableDictionary *cachedLittleTeeColorImages = nil;

//=================================================================
//	GOLFStandardTeeColorArray()
//=================================================================
//NSArray * GOLFStandardTeeColorArray(void) {
//	if (cachedStandardTeeColorArray == nil) {
//		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:kGOLFTeeColorsNumberOfStandard];
//
//		//	Each entry in GOLFStandardTeeColorArray is a NSDictionary with the following keyed items:
//		//
//		//	Key					Type			Description
//		//	--------------		----------		------------------------------------------------------------------------------------------
//		//	teeColorIndex		NSNumber		unsigned integer representing the tee color
//		//	teeColor			GOLFColor		NSColor (macOS) or UIColor (iOS) representing visual equivalent for display or tinting
//		//	teeColorName		NSString		localized name of the color (ie: "Vert", "Black & White", "Rojo y Blanco")@"teeColorName",
//		//	teeIconName			NSString		name of the tee icon (.ICNS), like "TeeMarkerBlueAndWhite"
//		//	teeImageName		NSString		name of the tee image (.PNG), like "tee_marker_blueandwhite" (excluding any size or scale identification)
//		//	isComboColor		NSNumber		optional boolean TRUE if entry represents a color combination (two colors)
//		//	firstColorIndex		NSNumber		teeColorIndex of one of the combination's solid colors (when isComboColor is TRUE)
//		//	secondColorIndex	NSNumber		teeColorIndex of the other of the combination's solid colors (when isComboColor is TRUE)
//		
//		//	Black
//		NSDictionary *colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"teeColorIndex",
//				[GOLFColor blackColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK"), @"teeColorName",
//				@"GOLFTeeMarkerBlack", @"teeIconName",
//				@"tee_marker_black", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Blue
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"teeColorIndex",
//				[GOLFColor blueColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE"), @"teeColorName",
//				@"GOLFTeeMarkerBlue", @"teeIconName",
//				@"tee_marker_blue", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	White
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"teeColorIndex",
//				[GOLFColor whiteColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE"), @"teeColorName",
//				@"GOLFTeeMarkerWhite", @"teeIconName",
//				@"tee_marker_white", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Green
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN"), @"teeColorName",
//				@"GOLFTeeMarkerGreen", @"teeIconName",
//				@"tee_marker_green", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Red
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"teeColorIndex",
//				[GOLFColor redColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_RED"), @"teeColorName",
//				@"GOLFTeeMarkerRed", @"teeIconName",
//				@"tee_marker_red", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Yellow
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"teeColorIndex",
//				[GOLFColor yellowColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW"), @"teeColorName",
//				@"GOLFTeeMarkerYellow", @"teeIconName",
//				@"tee_marker_yellow", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Brown
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBrown], @"teeColorIndex",
//				[GOLFColor brownColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BROWN"), @"teeColorName",
//				@"GOLFTeeMarkerBrown", @"teeIconName",
//				@"tee_marker_brown", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Gold
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"teeColorIndex",
//				[GOLFColor colorWithRed:(218.0 / 255.0) green:(203.0 / 255.0) blue:(129.0 / 255.0) alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GOLD"), @"teeColorName",
//				@"GOLFTeeMarkerGold", @"teeIconName",
//				@"tee_marker_gold", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Silver
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorSilver], @"teeColorIndex",
//				[GOLFColor colorWithRed:(0.6) green:(0.6) blue:(0.8) alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_SILVER"), @"teeColorName",
//				@"GOLFTeeMarkerSilver", @"teeIconName",
//				@"tee_marker_silver", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Purple
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPurple], @"teeColorIndex",
//				[GOLFColor purpleColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_PURPLE"), @"teeColorName",
//				@"GOLFTeeMarkerPurple", @"teeIconName",
//				@"tee_marker_purple", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Orange
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrange], @"teeColorIndex",
//				[GOLFColor orangeColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ORANGE"), @"teeColorName",
//				@"GOLFTeeMarkerOrange", @"teeIconName",
//				@"tee_marker_orange", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Maroon
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorMaroon], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.5 green:0 blue:0.25 alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_MAROON"), @"teeColorName",
//				@"GOLFTeeMarkerMaroon", @"teeIconName",
//				@"tee_marker_maroon", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Tan
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTan], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.792 green:0.675 blue:0.592 alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_TAN"), @"teeColorName",
//				@"GOLFTeeMarkerTan", @"teeIconName",
//				@"tee_marker_tan", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Pink
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPink], @"teeColorIndex",
//				[GOLFColor colorWithRed:1.0 green:0.753 blue:0.796 alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_PINK"), @"teeColorName",
//				@"GOLFTeeMarkerPink", @"teeIconName",
//				@"tee_marker_pink", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Teal
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTeal], @"teeColorIndex",
//				[GOLFColor colorWithRed:0 green:0.502 blue:0.502 alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_TEAL"), @"teeColorName",
//				@"GOLFTeeMarkerTeal", @"teeIconName",
//				@"tee_marker_teal", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Azure
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorAzure], @"teeColorIndex",
//				[GOLFColor colorWithRed:0 green:0.875 blue:1.0 alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_AZURE"), @"teeColorName",
//				@"GOLFTeeMarkerAzure", @"teeIconName",
//				@"tee_marker_azure", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Bronze
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBronze], @"teeColorIndex",
//				[GOLFColor colorWithRed:(125.0 / 255.0) green:(58.0 / 255.0) blue:(58.0 / 255.0) alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BRONZE"), @"teeColorName",
//				@"GOLFTeeMarkerBronze", @"teeIconName",
//				@"tee_marker_bronze", @"teeImageName", nil];
//		[workingList addObject:colorDict];
//		
//		//	Blue & White
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlueAndWhite], @"teeColorIndex",
//				[GOLFColor colorWithRed:0 green:0.06 blue:1.0 alpha:1.0], @"teeColor",	//	Not quite blue
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE_AND_WHITE"), @"teeColorName",
//				@"GOLFTeeMarkerBlueAndWhite", @"teeIconName",
//				@"tee_marker_blueandwhite", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Red & Yellow
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRedAndYellow], @"teeColorIndex",
//				[GOLFColor colorWithRed:1.0 green:0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_YELLOW"), @"teeColorName",
//				@"GOLFTeeMarkerRedAndYellow", @"teeIconName",
//				@"tee_marker_redandyellow", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Yellow & Blue
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellowAndBlue], @"teeColorIndex",
//				[GOLFColor colorWithRed:1.0 green:1.0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite yellow
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW_AND_BLUE"), @"teeColorName",
//				@"GOLFTeeMarkerYellowAndBlue", @"teeIconName",
//				@"tee_marker_yellowandblue", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Red & White
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRedAndWhite], @"teeColorIndex",
//				[GOLFColor colorWithRed:1.0 green:0.02 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_WHITE"), @"teeColorName",
//				@"GOLFTeeMarkerRedAndWhite", @"teeIconName",
//				@"tee_marker_redandwhite", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Black & Gold
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlackAndGold], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.1 green:0.06 blue:0.0 alpha:1.0], @"teeColor",	//	Dark gold
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_GOLD"), @"teeColorName",
//				@"GOLFTeeMarkerBlackAndGold", @"teeIconName",
//				@"tee_marker_blackandgold", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	White & Gold
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhiteAndGold], @"teeColorIndex",
//				[GOLFColor colorWithRed:1.0 green:0.61 blue:0.01 alpha:1.0], @"teeColor",	//	Light gold
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE_AND_GOLD"), @"teeColorName",
//				@"GOLFTeeMarkerWhiteAndGold", @"teeIconName",
//				@"tee_marker_whiteandgold", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Black & White
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlackAndWhite], @"teeColorIndex",
//				[GOLFColor darkGrayColor], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_WHITE"), @"teeColorName",
//				@"GOLFTeeMarkerBlackAndWhite", @"teeIconName",
//				@"tee_marker_blackandwhite", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Blue & Green
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlueAndGreen], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.0 green:(0.6) blue:0.9 alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE_AND_GREEN"), @"teeColorName",
//				@"GOLFTeeMarkerBlueAndGreen", @"teeIconName",
//				@"tee_marker_blueandgreen", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Green & White
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreenAndWhite], @"teeColorIndex",
//				[GOLFColor colorWithRed:(68 / 255.0) green:(184 / 255.0) blue:(70 / 255.0) alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN_AND_WHITE"), @"teeColorName",
//				@"GOLFTeeMarkerGreenAndWhite", @"teeIconName",
//				@"tee_marker_greenandwhite", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Green & Red
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreenAndRed], @"teeColorIndex",
//				[GOLFColor colorWithRed:(140.0 / 256.0) green:(175.0 / 256.0) blue:(120.0 / 256.0) alpha:1.0], @"teeColor",
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN_AND_RED"), @"teeColorName",
//				@"GOLFTeeMarkerGreenAndRed", @"teeIconName",
//				@"tee_marker_greenandred", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Yellow & Green
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellowAndGreen], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.04 green:1.0 blue:0.04 alpha:1.0], @"teeColor",	//	Not quite green
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW_AND_GREEN"), @"teeColorName",
//				@"GOLFTeeMarkerYellowAndGreen", @"teeIconName",
//				@"tee_marker_yellowandgreen", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	Black & Blue
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlackAndBlue], @"teeColorIndex",
//				[GOLFColor colorWithRed:(30 / 255.0) green:(30 / 255.0) blue:(127 / 255.0) alpha:1.0], @"teeColor",	//	Dark blue
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_BLUE"), @"teeColorName",
//				@"GOLFTeeMarkerBlackAndBlue", @"teeIconName",
//				@"tee_marker_blackandblue", @"teeImageName",
//				[NSNumber numberWithBool:YES], @"isComboColor",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"secondColorIndex", nil];
//		[workingList addObject:colorDict];
//		
//		//	U.S.A.
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorUSA], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0], @"teeColor",	//	"Old Glory" red
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_USA"), @"teeColorName",
//				@"GOLFTeeMarkerUSA", @"teeIconName",
//				@"tee_marker_usa", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//
//		//	E.U.
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorEU], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0], @"teeColor",	//	E.U. Blue CMYK 100/67/0/40
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_EU"), @"teeColorName",
//				@"GOLFTeeMarkerEU", @"teeIconName",
//				@"tee_marker_eu", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//		
//		//	PGA
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPGA], @"teeColorIndex",
//				[GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0], @"teeColor",	//	PGA Purple RGB 34/36/108
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_PGA"), @"teeColorName",
//				@"GOLFTeeMarkerPGA", @"teeIconName",
//				@"tee_marker_pga", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//		
//		//	USGA
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorUSGA], @"teeColorIndex",
//				[GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144 / 255.0) alpha:1.0], @"teeColor",	//	USGA Blue Pantone 280 CVC
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_USGA"), @"teeColorName",
//				@"GOLFTeeMarkerUSGA", @"teeIconName",
//				@"tee_marker_usga", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//		
//		//	One (I)
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOne], @"teeColorIndex",
//				[GOLFColor colorWithRed:(231 / 255.0) green:(198 / 255.0) blue:(161 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 726 UP (icon 0% Pantone 729)
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ONE"), @"teeColorName",
//				@"GOLFTeeMarkerOne", @"teeIconName",
//				@"tee_marker_one", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//		
//		//	Two (II)
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTwo], @"teeColorIndex",
//				[GOLFColor colorWithRed:(217 / 255.0) green:(181 / 255.0) blue:(145 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 727 UP (icon 20% Pantone 729)
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_TWO"), @"teeColorName",
//				@"GOLFTeeMarkerTwo", @"teeIconName",
//				@"tee_marker_two", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//		
//		//	Three (III)
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorThree], @"teeColorIndex",
//				[GOLFColor colorWithRed:(198 / 255.0) green:(161 / 255.0) blue:(129 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 728 UP (icon 40% Pantone 729)
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_THREE"), @"teeColorName",
//				@"GOLFTeeMarkerThree", @"teeIconName",
//				@"tee_marker_three", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//		
//		//	Four (IV)
//		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
//				[NSNumber numberWithUnsignedInteger:GOLFTeeColorFour], @"teeColorIndex",
//				[GOLFColor colorWithRed:(183 / 255.0) green:(147 / 255.0) blue:(118 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 729 UP (icon 60% Pantone 729)
//				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_FOUR"), @"teeColorName",
//				@"GOLFTeeMarkerFour", @"teeIconName",
//				@"tee_marker_four", @"teeImageName",
//				[NSNumber numberWithBool:NO], @"isComboColor", nil];
//		[workingList addObject:colorDict];
//		
//		//	NOT INCLUDED in this table:
//		//	GOLFTeeColorCustom (50)
//		//	GOLFTeeColorCombo (80)
//		//	GOLFTeeColorGeneric (98)
//		//	GOLFTeeColorUnknown (99)
//		//	GOLFTeeColorAdd (998)
//		//	GOLFTeeColorAll (999)
//		
//		cachedStandardTeeColorArray = [NSArray arrayWithArray:workingList];
//	}
//	return [cachedStandardTeeColorArray copy];
//}

//=================================================================
//	GOLFTeeColorFromTeeColorIndex
//=================================================================
//GOLFColor * GOLFTeeColorFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex) {
//	if (proposedColorIndex != kNotATeeColorIndex) {
//		if (IS_ANY_STANDARD_TEE_COLOR_INDEX(proposedColorIndex)) {
////		if ((proposedColorIndex >= GOLFTeeColorFirstSolid) && (proposedColorIndex <= GOLFTeeColorLastCombo)) {
//			//	All GOLFTeeColorIndexes for solid, combo and special tee colors…
//			for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
//				if ([[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue] == proposedColorIndex)
//					return [colorDict objectForKey:@"teeColor"];
//			}
//		}
//		
//		if (proposedColorIndex == GOLFTeeColorCombo) {
//			//	Special Combo tee marker - we'll pass back the dark green part…
//			return [GOLFColor colorWithRed:(0.0 / 256.0) green:(69.0 / 256.0) blue:(33.0 / 256.0) alpha:1.0];
//		}
//		
//		if (proposedColorIndex == GOLFTeeColorCustom) {
//			//	Custom tee color means someone's keeping the color elsewhere for display
//			//	We return off-white in case they need to pick up a tee marker image that they can draw the custom color onto…
//			GOLFColor *offWhite = [GOLFColor colorWithRed:(253 / 255.0) green:(253 / 255.0) blue:(253 / 255.0) alpha:1.0];
//#if TARGET_OS_IOS || TARGET_OS_WATCH
//			return offWhite;
//#elif TARGET_OS_MAC
//			return [offWhite colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
//#endif
//		}
//		
////		if (proposedColorIndex == GOLFTeeColorUSA) {
////			//	Special USA tee marker - we'll pass back the proper "Old Glory" red…
////			return [GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0];
////		}
//		
////		if (proposedColorIndex == GOLFTeeColorEU) {
////			//	Special EU tee marker - we'll pass back the proper "EU blue"…
////			return [GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0];
////		}
//		
////		if (proposedColorIndex == GOLFTeeColorPGA) {
////			//	Special PGA tee marker - we'll pass back the proper "PGA purple"…
////			return [GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0];
////		}
//		
////		if (proposedColorIndex == GOLFTeeColorUSGA) {
////			//	Special PGA tee marker - we'll pass back the proper "USGA Pantone 280 blue"…
////			return [GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144 / 255.0) alpha:1.0];
////		}
//	}
//	
//	//	Last resort - return the generic tee color…
//	GOLFColor *genericColor = [GOLFColor colorWithRed:(253 / 255.0) green:(253 / 255.0) blue:(253 / 255.0) alpha:1.0];
//#if TARGET_OS_IOS || TARGET_OS_WATCH
//	return genericColor;
//#elif TARGET_OS_MAC
//	return [genericColor colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
//#endif
//}

#if TARGET_OS_MAC

@implementation ScorecardPartView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    	self.ourColor = [GOLFColor GOLFFactoryBogeyColor];	//	This is white in dark mode, black in aqua
    	self.partType = ScorecardPartTypeBaseView;
		self.borders = NSEdgeInsetsMake(0, 0, 1, 1);	//	bottom, right
		[self setAutoresizesSubviews:NO];	//	If we resize, leave the subviews alone
		[self setPostsFrameChangedNotifications:YES];	//	Notifies anyone interested of frame changes
		[self invalidateIntrinsicContentSize];	//	For layout purposes, we provide an intrinsicContentSize for height
    }
    return self;
}

- (ScorecardPartType)partType {
	return ScorecardPartTypeBaseView;	//	No Scorecard Part superview - we're the base view
}

//- (NSRect)margins { return _margins; }

//- (void)setMargins:(NSRect)newMargins {
//	_margins = newMargins;
//}

//- (BOOL)insertPagebreaks { return _insertPagebreaks; }
//
//- (void)setInsertPagebreaks:(BOOL)insert {
//	_insertPagebreaks = insert;
//}

//- (void)insertView:(NSView *)viewToBeInserted atIndex:(NSInteger)index {
//	NSInteger realIndex = ([self insertPagebreaks] ? index * 2 : index);
//	[self sortSubviewsUsingFunction:CompareSubviewsByPosition context:NULL];	//	Get the subviews in the right order
//	NSRect ourOldFrame = [self frame];	//	origin and size in our superview's coordinates
//	NSRect viewFrame = [viewToBeInserted frame];
//	NSView *aSubview;
//	NSInteger subviewCount = [[self subviews] count];	//	Count of subviews (including pagebreaks)
//	NSSize ourNewSize;
//	if (subviewCount > 0)
//		ourNewSize = NSMakeSize(MAX(ourOldFrame.size.width, viewFrame.size.width + _margins.origin.x + _margins.origin.y),
//								ourOldFrame.size.height + viewFrame.size.height + _margins.size.width + _margins.size.height);
//	else
//		ourNewSize = NSMakeSize(viewFrame.size.width + _margins.origin.x + _margins.origin.y,
//								viewFrame.size.height + _margins.size.width + _margins.size.height);
//
//	[self setFrameSize:ourNewSize];	//	Expand us to fit another subview - no change DOESN'T present a notification
//	[self invalidateIntrinsicContentSize];
//	[[self superview] setNeedsLayout:YES];
//	
//	NSPoint insertLocation = NSMakePoint(0.0 + _margins.origin.x, 0.0 + _margins.size.width);	//	Insert location default is bottom left
//	NSView *followingView = nil;
//	if (realIndex < subviewCount) {
//		followingView = [[self subviews] objectAtIndex:realIndex];	//	Find the subview that will follow this one
//		NSRect followingFrame = [followingView frame];
//		insertLocation = NSMakePoint(followingFrame.origin.x,
//									followingFrame.origin.y + followingFrame.size.height + _margins.size.width + _margins.size.height);
//	}
//	[viewToBeInserted setFrameOrigin:insertLocation];
//	NSInteger position;
//	NSInteger limit = ([self insertPagebreaks] ? realIndex - 1 : realIndex);
//	for (position = 0; position < limit; position++) {
//		//	Move all the preceding subviews up by the height of the inserted view
//		aSubview = [[self subviews] objectAtIndex:position];
//		NSRect oldFrame = [aSubview frame];
//		[aSubview setFrameOrigin:NSMakePoint(oldFrame.origin.x, oldFrame.origin.y + viewFrame.size.height + _margins.size.width + _margins.size.height)];
//		[aSubview setNeedsDisplay:YES];
//	}
//	[viewToBeInserted setAutoresizingMask:(NSViewMinYMargin | NSViewMaxXMargin)];
//	[self addSubview:viewToBeInserted positioned:NSWindowAbove relativeTo:followingView];
//	[viewToBeInserted setNeedsDisplay:YES];
//	if ([self insertPagebreaks]) {
//		EAGPageBreak *pagebreak = nil;
//		if (followingView != nil) {
//			pagebreak = [EAGPageBreak pageBreakOfWidth:ourNewSize.width];
//			[pagebreak setFrameOrigin:NSMakePoint(0.0, insertLocation.y - _margins.size.width)];	//	After inserted, before following
//			[pagebreak setAutoresizingMask:(NSViewMinYMargin | NSViewMaxXMargin)];
//			[self addSubview:pagebreak positioned:NSWindowAbove relativeTo:followingView];
//		} else if (realIndex > 0) {
//			pagebreak = [EAGPageBreak pageBreakOfWidth:ourNewSize.width];
//			[pagebreak setFrameOrigin:NSMakePoint(0.0, insertLocation.y + viewFrame.size.height + _margins.size.height)];	//	In front of inserted
//			[pagebreak setAutoresizingMask:(NSViewMinYMargin | NSViewMaxXMargin)];
//			[self addSubview:pagebreak positioned:NSWindowAbove relativeTo:viewToBeInserted];
//		}
//		[pagebreak setNeedsDisplay:YES];
//	}
//	[self updateKeyViews];	//	Does nothing
//	[self setNeedsDisplay:YES];
//}

//- (void)removeViewAtIndex:(NSInteger)index {
//	NSInteger realIndex = ([self insertPagebreaks] ? index * 2 : index);
//	//	NSInteger pagebreakIndex = (realIndex > 0 ? realIndex - 1 : realIndex + 1);
//	NSInteger subviewCount = [[self subviews] count];
//	if ((subviewCount > 0) && (realIndex < subviewCount)) {
//		[self sortSubviewsUsingFunction:CompareSubviewsByPosition context:NULL];	//	Get the subviews in the right order
//		NSView *viewToBeRemoved = [[self subviews] objectAtIndex:realIndex];
//		NSView *pagebreakToBeRemoved = nil;
//		if ([self insertPagebreaks]) {
//			if (realIndex > 0)
//				pagebreakToBeRemoved = [[self subviews] objectAtIndex:realIndex - 1];	//	Pagebreak before is gone
//			else if ((realIndex < 1) && (subviewCount > 1))
//				pagebreakToBeRemoved = [[self subviews] objectAtIndex:1];	//	Pagebreak after is gone
//		}
//		NSRect viewFrame = [viewToBeRemoved frame];
//		NSRect oldFrame;
//		NSInteger position;
//		for (position = 0; position < realIndex; position++) {
//			//	Move preceding subviews toward the origin
//			NSView *subview = [[self subviews] objectAtIndex:position];
//			oldFrame = [subview frame];
//			[subview setFrameOrigin:NSMakePoint(oldFrame.origin.x, oldFrame.origin.y - viewFrame.size.height - _margins.size.width - _margins.size.height)];
//		}
//		oldFrame = [self frame];	//	origin and size in our superview's coordinates
//		NSSize newSize = NSMakeSize(oldFrame.size.width, oldFrame.size.height - viewFrame.size.height - _margins.size.width - _margins.size.height);
//		[viewToBeRemoved removeFromSuperview];	//	This removes the view and releases it
//		if (pagebreakToBeRemoved != nil) {
//			[pagebreakToBeRemoved removeFromSuperview];
//		}
//			
//		[self setFrameSize:newSize];	//	Shrink us by the size of the removed subview - no change DOESN'T present a notification
//		[self invalidateIntrinsicContentSize];
//		[[self superview] setNeedsLayout:YES];
//		
//		[self updateKeyViews];
//		[self setNeedsDisplay:YES];
//	}
//}

//- (void)removeLastView {
//	NSInteger numberOfSubviews = [[self subviews] count];
//	if (numberOfSubviews > 0) {
//		NSInteger index = ([self insertPagebreaks] ? (numberOfSubviews - 1) / 2 : numberOfSubviews - 1);
//		[self removeViewAtIndex:index];
//	}
//}

- (void)updateKeyViews {
	/*
	NSEnumerator *subviewsE = [[self subviews] reverseObjectEnumerator];	//	We're going to run the subviews backward and link them
	NSView *followingView = nil;
	NSView *aSubview;
	while (aSubview = [subviewsE nextObject]) {
		[aSubview setNextKeyView:followingView];
		followingView = aSubview;
	}
	*/
}

#pragma mark NSView overrides

- (NSSize)intrinsicContentSize {
	NSSize intrinsicSize = [super intrinsicContentSize];

	return NSMakeSize(intrinsicSize.width, self.frame.size.height);	//	We need to advertise an intrinsic size height for autoLayout
}

//- (NSRect)rectForPage:(NSInteger)page {
//	//	Page numbers start at 1!
//	NSInteger realIndex = ([self insertPagebreaks] ? (page - 1) * 2 : page - 1);
//	[self sortSubviewsUsingFunction:CompareSubviewsByPosition context:NULL];	//	Get the subviews in the right order
//	NSRect result = [[[self subviews] objectAtIndex:realIndex] frame];
//
//	return result;
//}

//- (BOOL)knowsPageRange:(NSRange *)pageRange {
//	// Page numbers start at 1
//	pageRange->location = 1;
//	pageRange->length = ([self insertPagebreaks] ? ([[self subviews] count] + 1) / 2 : [[self subviews] count]);
//	//	NSLog(@"%@ -%@ pageBreaks: %@ %@", [self className], NSStringFromSelector(_cmd), ([self insertPagebreaks] ? @"YES" : @"NO"), NSStringFromRange(NSMakeRange(pageRange->location, pageRange->length)));
//	return YES;
//}

//- (NSAttributedString *)pageHeader {
//	//	Actually, the footer in an unflipped environment!
//	NSString *timeString = [[MULTeeTimeFormatter sharedTeeTimeFormatter] stringFromDate:[NSDate date]];
//	NSString *dateString = [[MULShortDateFormatter sharedShortDateFormatter] stringFromDate:[NSDate date]];
//	NSString *dateTimeString = [NSString stringWithFormat:@"%@ %@", dateString, timeString];
//	NSString *eagleString = NSLocalizedString(@"EagleT", @""); 
//	NSString *pageString = nil; 
//	NSPrintOperation *op = [NSPrintOperation currentOperation];
//	if (op != nil) {
//		NSInteger currentPage = [op currentPage];
//		//	NSPrintInfo *info = [op printInfo];
//		NSRange pageRange;
//		if ([self knowsPageRange:&pageRange]) {
//			pageString = [NSString stringWithFormat:NSLocalizedString(@"Page %d of %d", @""), (int)currentPage, (int)(pageRange.length)];
//		} else {
//			pageString = [NSString stringWithFormat:NSLocalizedString(@"Page %d", @""), (int)currentPage];
//		}
//	}
//	NSAttributedString *newHeader = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\t%@\t%@", dateTimeString, eagleString, pageString] attributes:[self footerAttributes]];
//	return [newHeader ah_autorelease];
//}

//- (NSAttributedString *)pageFooter {
//	//	Actually, the header in an unflipped environment!
//	NSAttributedString *newFooter = [NSAttributedString attributedStringWithString:@"" fontAndRulerAttributesOf:[super pageFooter]];
//	return newFooter;
//}

//- (NSMutableDictionary *)footerAttributes {
//	// The attributes of the text to be printed
//	NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
//	[attributes setObject:[NSFont fontWithName:@"Helvetica" size:8.0] forKey:NSFontAttributeName];
//	[attributes setObject:[NSNumber numberWithFloat:8.0] forKey:NSBaselineOffsetAttributeName];
//	
//	NSMutableParagraphStyle *paragraphStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] ah_autorelease];
//	[paragraphStyle setAlignment:NSTextAlignmentCenter];
//	[paragraphStyle setTabStops:[self footerTabStops]];
//	[paragraphStyle setFirstLineHeadIndent:0.0];
//
//	[attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//
//	return [attributes ah_autorelease];
//}

//- (NSArray *)footerTabStops {
//	//	May be overridden - usually we can use the bodyTabStops
//	//	A center tab and a far right tab
//	NSRect imageableRect = [[[NSPrintOperation currentOperation] printInfo] imageablePageBounds];
//	NSMutableArray *tabStops = [NSMutableArray arrayWithCapacity:2];
//	[tabStops addObject:[[[NSTextTab alloc] initWithType:NSCenterTabStopType location:(imageableRect.size.width / 2.0) - 8.0] ah_autorelease]];
//	[tabStops addObject:[[[NSTextTab alloc] initWithType:NSRightTabStopType location:imageableRect.size.width - 8.0] ah_autorelease]];
//	return [NSArray arrayWithArray:tabStops];
//}

- (void)drawRect:(NSRect)dirtyRect {
	[self.ourColor setFill];	//	This is dark mode compatible
	[NSBezierPath fillRect:dirtyRect];	//	Fill with the color
}

- (void)setColor:(NSColor *)newColor {
    self.ourColor = newColor;
	[self setNeedsDisplay:YES];
}

- (BOOL)isOpaque {
	//	If we're the base level, it's possible we have non-opaque areas and we don't make borders
	//	If we do make borders (partial or otherwise), our technique of drawing the border by filling our
	//	area with the reverse (dark / light) of the current appearance might not work.
	return NO;	
}

@end

#endif
