//
//  GOLFTeeMarkers.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFTeeMarkers.h"
#import "GOLFKit.h"
#import "GOLFUtilities.h"
#import "GOLFColors.h"
#import "NSNumber+GOLFExtensions.h"

//	Private Prototypes
static NSArray *cachedStandardTeeColorArray = nil;
static NSMutableDictionary *cachedLittleTeeColorImages = nil;

//=================================================================
//	GOLFStandardTeeColorArray()
//=================================================================
NSArray * GOLFStandardTeeColorArray(void) {
	if (cachedStandardTeeColorArray == nil) {
		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:kGOLFTeeColorsNumberOfStandard];

		//	Each entry in GOLFStandardTeeColorArray is a NSDictionary with the following keyed items:
		//
		//	Key					Type			Description
		//	--------------		----------		------------------------------------------------------------------------------------------
		//	teeColorIndex		NSNumber		GOLFTeeColorIndex value representing the tee color
		//	teeColor			GOLFColor		NSColor (macOS) or UIColor (iOS) representing visual equivalent for display or tinting
		//	teeColorName		NSString		localized name of the color (ie: "Vert", "Black & White", "Rojo y Blanco")@"teeColorName",
		//	teeIconName			NSString		name of the tee icon (.ICNS), like "TeeMarkerBlueAndWhite"
		//	teeImageName		NSString		name of the tee image (.PNG), like "tee_marker_blueandwhite" (excluding any size or scale identification)
		//	isComboColor		NSNumber		optional boolean TRUE value if entry represents a color combination (two colors)
		//	firstColorIndex		NSNumber		teeColorIndex of one of the combination's solid colors (when isComboColor is TRUE)
		//	secondColorIndex	NSNumber		teeColorIndex of the other of the combination's solid colors (when isComboColor is TRUE)
		
		//	Black
		NSDictionary *colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"teeColorIndex",
				[GOLFColor blackColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK"), @"teeColorName",
				@"GOLFTeeMarkerBlack", @"teeIconName",
				@"tee_marker_black", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"teeColorIndex",
				[GOLFColor blueColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE"), @"teeColorName",
				@"GOLFTeeMarkerBlue", @"teeIconName",
				@"tee_marker_blue", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"teeColorIndex",
				[GOLFColor whiteColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE"), @"teeColorName",
				@"GOLFTeeMarkerWhite", @"teeIconName",
				@"tee_marker_white", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN"), @"teeColorName",
				@"GOLFTeeMarkerGreen", @"teeIconName",
				@"tee_marker_green", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Red
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"teeColorIndex",
				[GOLFColor redColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_RED"), @"teeColorName",
				@"GOLFTeeMarkerRed", @"teeIconName",
				@"tee_marker_red", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"teeColorIndex",
				[GOLFColor yellowColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW"), @"teeColorName",
				@"GOLFTeeMarkerYellow", @"teeIconName",
				@"tee_marker_yellow", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Brown
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBrown], @"teeColorIndex",
				[GOLFColor brownColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BROWN"), @"teeColorName",
				@"GOLFTeeMarkerBrown", @"teeIconName",
				@"tee_marker_brown", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGold], @"teeColorIndex",
				[GOLFColor colorWithRed:(218.0 / 255.0) green:(203.0 / 255.0) blue:(129.0 / 255.0) alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GOLD"), @"teeColorName",
				@"GOLFTeeMarkerGold", @"teeIconName",
				@"tee_marker_gold", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Silver
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorSilver], @"teeColorIndex",
				[GOLFColor colorWithRed:(0.6) green:(0.6) blue:(0.8) alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_SILVER"), @"teeColorName",
				@"GOLFTeeMarkerSilver", @"teeIconName",
				@"tee_marker_silver", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Purple
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPurple], @"teeColorIndex",
				[GOLFColor purpleColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_PURPLE"), @"teeColorName",
				@"GOLFTeeMarkerPurple", @"teeIconName",
				@"tee_marker_purple", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Orange
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrange], @"teeColorIndex",
				[GOLFColor orangeColor], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ORANGE"), @"teeColorName",
				@"GOLFTeeMarkerOrange", @"teeIconName",
				@"tee_marker_orange", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Maroon
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorMaroon], @"teeColorIndex",
				[GOLFColor colorWithRed:0.5 green:0 blue:0.25 alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_MAROON"), @"teeColorName",
				@"GOLFTeeMarkerMaroon", @"teeIconName",
				@"tee_marker_maroon", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Tan
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTan], @"teeColorIndex",
				[GOLFColor colorWithRed:0.792 green:0.675 blue:0.592 alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_TAN"), @"teeColorName",
				@"GOLFTeeMarkerTan", @"teeIconName",
				@"tee_marker_tan", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Pink
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPink], @"teeColorIndex",
				[GOLFColor colorWithRed:1.0 green:0.753 blue:0.796 alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_PINK"), @"teeColorName",
				@"GOLFTeeMarkerPink", @"teeIconName",
				@"tee_marker_pink", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Teal
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTeal], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.502 blue:0.502 alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_TEAL"), @"teeColorName",
				@"GOLFTeeMarkerTeal", @"teeIconName",
				@"tee_marker_teal", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Azure
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorAzure], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.875 blue:1.0 alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_AZURE"), @"teeColorName",
				@"GOLFTeeMarkerAzure", @"teeIconName",
				@"tee_marker_azure", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Bronze
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBronze], @"teeColorIndex",
				[GOLFColor colorWithRed:(125.0 / 255.0) green:(58.0 / 255.0) blue:(58.0 / 255.0) alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BRONZE"), @"teeColorName",
				@"GOLFTeeMarkerBronze", @"teeIconName",
				@"tee_marker_bronze", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Forest
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorForest], @"teeColorIndex",
				[GOLFColor colorWithRed:(12.0 / 255.0) green:(97.0 / 255.0) blue:(14.0 / 255.0) alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_FOREST"), @"teeColorName",
				@"GOLFTeeMarkerForest", @"teeIconName",
				@"tee_marker_forest", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlueAndWhite], @"teeColorIndex",
				[GOLFColor colorWithRed:0 green:0.06 blue:1.0 alpha:1.0], @"teeColor",	//	Not quite blue
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE_AND_WHITE"), @"teeColorName",
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
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_YELLOW"), @"teeColorName",
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
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW_AND_BLUE"), @"teeColorName",
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
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_WHITE"), @"teeColorName",
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
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_GOLD"), @"teeColorName",
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
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE_AND_GOLD"), @"teeColorName",
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
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_WHITE"), @"teeColorName",
				@"GOLFTeeMarkerBlackAndWhite", @"teeIconName",
				@"tee_marker_blackandwhite", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Blue & Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlueAndGreen], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(0.6) blue:0.9 alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE_AND_GREEN"), @"teeColorName",
				@"GOLFTeeMarkerBlueAndGreen", @"teeIconName",
				@"tee_marker_blueandgreen", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Green & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreenAndWhite], @"teeColorIndex",
				[GOLFColor colorWithRed:(68 / 255.0) green:(184 / 255.0) blue:(70 / 255.0) alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN_AND_WHITE"), @"teeColorName",
				@"GOLFTeeMarkerGreenAndWhite", @"teeIconName",
				@"tee_marker_greenandwhite", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorWhite], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Green & Red
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreenAndRed], @"teeColorIndex",
				[GOLFColor colorWithRed:(140.0 / 256.0) green:(175.0 / 256.0) blue:(120.0 / 256.0) alpha:1.0], @"teeColor",
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN_AND_RED"), @"teeColorName",
				@"GOLFTeeMarkerGreenAndRed", @"teeIconName",
				@"tee_marker_greenandred", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Yellow & Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellowAndGreen], @"teeColorIndex",
				[GOLFColor colorWithRed:0.04 green:1.0 blue:0.04 alpha:1.0], @"teeColor",	//	Not quite green
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW_AND_GREEN"), @"teeColorName",
				@"GOLFTeeMarkerYellowAndGreen", @"teeIconName",
				@"tee_marker_yellowandgreen", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorYellow], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Black & Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlackAndBlue], @"teeColorIndex",
				[GOLFColor colorWithRed:(30 / 255.0) green:(30 / 255.0) blue:(127 / 255.0) alpha:1.0], @"teeColor",	//	Dark blue
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_BLUE"), @"teeColorName",
				@"GOLFTeeMarkerBlackAndBlue", @"teeIconName",
				@"tee_marker_blackandblue", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Orange & Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrangeAndGreen], @"teeColorIndex",
				[GOLFColor colorWithRed:(253 / 255.0) green:(126 / 255.0) blue:(0.0) alpha:1.0], @"teeColor",	//	Not quite orange
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ORANGE_AND_GREEN"), @"teeColorName",
				@"GOLFTeeMarkerOrangeAndGreen", @"teeIconName",
				@"tee_marker_orangeandgreen", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrange], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Red & Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRedAndBlue], @"teeColorIndex",
				[GOLFColor colorWithRed:(226 / 255.0) green:(72 / 255.0) blue:(89 / 255.0) alpha:1.0], @"teeColor",	//	Not quite red
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_BLUE"), @"teeColorName",
				@"GOLFTeeMarkerRedAndBlue", @"teeIconName",
				@"tee_marker_redandblue", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlue], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Black & Orange
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlackAndOrange], @"teeColorIndex",
				[GOLFColor colorWithRed:(226 / 255.0) green:(92 / 255.0) blue:(61 / 255.0) alpha:1.0], @"teeColor",	//	Not quite orange
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_ORANGE"), @"teeColorName",
				@"GOLFTeeMarkerBlackAndOrange", @"teeIconName",
				@"tee_marker_blackandorange", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorBlack], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrange], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	Orange & Tan
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrangeAndTan], @"teeColorIndex",
				[GOLFColor colorWithRed:(199 / 255.0) green:(177 / 255.0) blue:(161 / 255.0) alpha:1.0], @"teeColor",	//	Not quite tan
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ORANGE_AND_TAN"), @"teeColorName",
				@"GOLFTeeMarkerOrangeAndTan", @"teeIconName",
				@"tee_marker_orangeandtan", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOrange], @"firstColorIndex",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTan], @"secondColorIndex", nil];
		[workingList addObject:colorDict];
		
		//	U.S.A.
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorUSA], @"teeColorIndex",
				[GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0], @"teeColor",	//	"Old Glory" red
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_USA"), @"teeColorName",
				@"GOLFTeeMarkerUSA", @"teeIconName",
				@"tee_marker_usa", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];

		//	E.U.
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorEU], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0], @"teeColor",	//	E.U. Blue CMYK 100/67/0/40
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_EU"), @"teeColorName",
				@"GOLFTeeMarkerEU", @"teeIconName",
				@"tee_marker_eu", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	PGA
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorPGA], @"teeColorIndex",
				[GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0], @"teeColor",	//	PGA Purple RGB 34/36/108
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_PGA"), @"teeColorName",
				@"GOLFTeeMarkerPGA", @"teeIconName",
				@"tee_marker_pga", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	USGA
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorUSGA], @"teeColorIndex",
				[GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144 / 255.0) alpha:1.0], @"teeColor",	//	USGA Blue Pantone 280 CVC
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_USGA"), @"teeColorName",
				@"GOLFTeeMarkerUSGA", @"teeIconName",
				@"tee_marker_usga", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	One (I)
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorOne], @"teeColorIndex",
				[GOLFColor colorWithRed:(231 / 255.0) green:(198 / 255.0) blue:(161 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 726 UP (icon 0% Pantone 729)
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ONE"), @"teeColorName",
				@"GOLFTeeMarkerOne", @"teeIconName",
				@"tee_marker_one", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Two (II)
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTwo], @"teeColorIndex",
				[GOLFColor colorWithRed:(217 / 255.0) green:(181 / 255.0) blue:(145 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 727 UP (icon 20% Pantone 729)
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_TWO"), @"teeColorName",
				@"GOLFTeeMarkerTwo", @"teeIconName",
				@"tee_marker_two", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Three (III)
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorThree], @"teeColorIndex",
				[GOLFColor colorWithRed:(198 / 255.0) green:(161 / 255.0) blue:(129 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 728 UP (icon 40% Pantone 729)
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_THREE"), @"teeColorName",
				@"GOLFTeeMarkerThree", @"teeIconName",
				@"tee_marker_three", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Four (IV)
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorFour], @"teeColorIndex",
				[GOLFColor colorWithRed:(183 / 255.0) green:(147 / 255.0) blue:(118 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 729 UP (icon 60% Pantone 729)
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_FOUR"), @"teeColorName",
				@"GOLFTeeMarkerFour", @"teeIconName",
				@"tee_marker_four", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Five (V)
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorFive], @"teeColorIndex",
				[GOLFColor colorWithRed:(183 / 255.0) green:(147 / 255.0) blue:(118 / 255.0) alpha:1.0], @"teeColor",	//	Pantone 729 UP (icon 80% Pantone 729)
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_FIVE"), @"teeColorName",
				@"GOLFTeeMarkerFive", @"teeIconName",
				@"tee_marker_five", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Square
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorSquare], @"teeColorIndex",
				[GOLFColor colorWithRed:(12.0 / 255.0) green:(97.0 / 255.0) blue:((14.0 + 5.0) / 255.0) alpha:1.0], @"teeColor",	//	Not quite Forest
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_SQUARE"), @"teeColorName",
				@"GOLFTeeMarkerSquare", @"teeIconName",
				@"tee_marker_square", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Circle
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorCircle], @"teeColorIndex",
				[GOLFColor colorWithRed:(12.0 / 255.0) green:(97.0 / 255.0) blue:((14.0 + 10.0) / 255.0) alpha:1.0], @"teeColor",	//	Not quite Forest
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_CIRCLE"), @"teeColorName",
				@"GOLFTeeMarkerCircle", @"teeIconName",
				@"tee_marker_circle", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Triangle
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorTriangle], @"teeColorIndex",
				[GOLFColor colorWithRed:(12.0 / 255.0) green:(97.0 / 255.0) blue:((14.0 + 15.0) / 255.0) alpha:1.0], @"teeColor",	//	Not quite Forest
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_TRIANGLE"), @"teeColorName",
				@"GOLFTeeMarkerTriangle", @"teeIconName",
				@"tee_marker_triangle", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Diamond
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorDiamond], @"teeColorIndex",
				[GOLFColor colorWithRed:(12.0 / 255.0) green:(97.0 / 255.0) blue:((14.0 + 20.0) / 255.0) alpha:1.0], @"teeColor",	//	Not quite Forest
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_DIAMOND"), @"teeColorName",
				@"GOLFTeeMarkerDiamond", @"teeIconName",
				@"tee_marker_diamond", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	Star
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorStar], @"teeColorIndex",
				[GOLFColor colorWithRed:(12.0 / 255.0) green:(97.0 / 255.0) blue:((14.0 + 25.0) / 255.0) alpha:1.0], @"teeColor",	//	Not quite Forest
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_STAR"), @"teeColorName",
				@"GOLFTeeMarkerStar", @"teeIconName",
				@"tee_marker_star", @"teeImageName",
				[NSNumber numberWithBool:NO], @"isComboColor", nil];
		[workingList addObject:colorDict];
		
		//	NOT INCLUDED in this table:
		//	GOLFTeeColorCustom (50)
		//	GOLFTeeColorCombo (80)
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
		if (IS_ANY_STANDARD_TEE_COLOR_INDEX(proposedColorIndex)) {
//		if ((proposedColorIndex >= GOLFTeeColorFirstSolid) && (proposedColorIndex <= GOLFTeeColorLastCombo)) {
			//	All GOLFTeeColorIndexes for solid, combo and special tee colors…
			for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
				if ([[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue] == proposedColorIndex)
					return [colorDict objectForKey:@"teeColor"];
			}
		}
		
		if (proposedColorIndex == GOLFTeeColorCombo) {
			//	Special Combo tee marker - we'll pass back the dark green part…
			return [GOLFColor colorWithRed:(0.0 / 256.0) green:(69.0 / 256.0) blue:(33.0 / 256.0) alpha:1.0];
		}
		
		if (proposedColorIndex == GOLFTeeColorCustom) {
			//	Custom tee color means someone's keeping the color elsewhere for display
			//	We return off-white in case they need to pick up a tee marker image that they can draw the custom color onto…
			GOLFColor *offWhite = [GOLFColor colorWithRed:(253 / 255.0) green:(253 / 255.0) blue:(253 / 255.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
			return offWhite;
#elif TARGET_OS_MAC
			return [offWhite colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
#endif
		}
		
//		if (proposedColorIndex == GOLFTeeColorUSA) {
//			//	Special USA tee marker - we'll pass back the proper "Old Glory" red…
//			return [GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0];
//		}
		
//		if (proposedColorIndex == GOLFTeeColorEU) {
//			//	Special EU tee marker - we'll pass back the proper "EU blue"…
//			return [GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0];
//		}
		
//		if (proposedColorIndex == GOLFTeeColorPGA) {
//			//	Special PGA tee marker - we'll pass back the proper "PGA purple"…
//			return [GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0];
//		}
		
//		if (proposedColorIndex == GOLFTeeColorUSGA) {
//			//	Special PGA tee marker - we'll pass back the proper "USGA Pantone 280 blue"…
//			return [GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144 / 255.0) alpha:1.0];
//		}
	}
	
	//	Last resort - return the generic tee color…
	GOLFColor *genericColor = [GOLFColor colorWithRed:(253 / 255.0) green:(253 / 255.0) blue:(253 / 255.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
	return genericColor;
#elif TARGET_OS_MAC
	return [genericColor colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
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
		GOLFColor *rgb = [teeColor colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
		redComponent = [rgb redComponent];
		greenComponent = [rgb greenComponent];
		blueComponent = [rgb blueComponent];
#endif
		//	Check for a standard color (solid, combo, special)…
		GOLFColor *testColor;
		for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
			GOLFTeeColorIndex testColorIndex = [[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue];

			//	We'll try to find a matching color in the numerically identifiable colors…
#if TARGET_OS_IOS || TARGET_OS_WATCH
			testColor = [colorDict objectForKey:@"teeColor"];
			[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
			testColor = [[colorDict objectForKey:@"teeColor"] colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
			redTestComponent = [testColor redComponent];
			greenTestComponent = [testColor greenComponent];
			blueTestComponent = [testColor blueComponent];
#endif
			if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
				return testColorIndex;
			}
		}
		
		//	Combo Tee…
		GOLFColor *comboGreen = [GOLFColor colorWithRed:(0.0 / 256.0) green:(69.0 / 256.0) blue:(33.0 / 256.0) alpha:1.0];
#if TARGET_OS_IOS || TARGET_OS_WATCH
		testColor = comboGreen;
		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
#elif TARGET_OS_MAC
		testColor = [comboGreen colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
		redTestComponent = [testColor redComponent];
		greenTestComponent = [testColor greenComponent];
		blueTestComponent = [testColor blueComponent];
#endif
		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
			return GOLFTeeColorCombo;
		}
		
//		//	USA Tee…
//		GOLFColor *oldGloryRed = [GOLFColor colorWithRed:0.698 green:0.132 blue:0.203 alpha:1.0];
//#if TARGET_OS_IOS || TARGET_OS_WATCH
//		testColor = oldGloryRed;
//		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
//#elif TARGET_OS_MAC
//		testColor = [oldGloryRed colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
//		redTestComponent = [testColor redComponent];
//		greenTestComponent = [testColor greenComponent];
//		blueTestComponent = [testColor blueComponent];
//#endif
//		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
//			return GOLFTeeColorUSA;
//		}

//		//	EU Tee…
//		GOLFColor *euBlue = [GOLFColor colorWithRed:0.0 green:(51 / 255.0) blue:(153 / 255.0) alpha:1.0];
//#if TARGET_OS_IOS || TARGET_OS_WATCH
//		testColor = euBlue;
//		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
//#elif TARGET_OS_MAC
//		testColor = [euBlue colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
//		redTestComponent = [testColor redComponent];
//		greenTestComponent = [testColor greenComponent];
//		blueTestComponent = [testColor blueComponent];
//#endif
//		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
//			return GOLFTeeColorEU;
//		}

//		//	PGA Tour Tee…
//		GOLFColor *pgaPurple = [GOLFColor colorWithRed:(34 / 255.0) green:(36 / 255.0) blue:(108 / 255.0) alpha:1.0];
//#if TARGET_OS_IOS || TARGET_OS_WATCH
//		testColor = pgaPurple;
//		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
//#elif TARGET_OS_MAC
//		testColor = [pgaPurple colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
//		redTestComponent = [testColor redComponent];
//		greenTestComponent = [testColor greenComponent];
//		blueTestComponent = [testColor blueComponent];
//#endif
//		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
//			return GOLFTeeColorPGA;
//		}
		
//		//	USGA Tee…
//		GOLFColor *usgaBlue = [GOLFColor colorWithRed:0.0 green:(73 / 255.0) blue:(144.0 / 255.0) alpha:1.0];
//#if TARGET_OS_IOS || TARGET_OS_WATCH
//		testColor = usgaBlue;
//		[testColor getRed:&redTestComponent green:&greenTestComponent blue:&blueTestComponent alpha:nil];
//#elif TARGET_OS_MAC
//		testColor = [usgaBlue colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
//		redTestComponent = [testColor redComponent];
//		greenTestComponent = [testColor greenComponent];
//		blueTestComponent = [testColor blueComponent];
//#endif
//		if ((redTestComponent == redComponent) && (greenTestComponent == greenComponent) && (blueTestComponent == blueComponent)) {
//			return GOLFTeeColorUSGA;
//		}
		
		return GOLFTeeColorCustom;	//	Any color we don't recognize is a custom color!
	}
	return GOLFTeeColorUnknown;
}

//=================================================================
//	GOLFTeeColorNameFromTeeColorIndex(colorIndex)
//=================================================================
NSString * GOLFTeeColorNameFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex) {
	if ((proposedColorIndex < 0) || (proposedColorIndex == kNotATeeColorIndex) || (proposedColorIndex == GOLFTeeColorUnknown))
		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_UNKNOWN");
	if (proposedColorIndex == GOLFTeeColorGeneric)
		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_GENERIC");
	if (proposedColorIndex == GOLFTeeColorCombo)
		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_COMBO");
	if (proposedColorIndex == GOLFTeeColorCustom)
		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_CUSTOM");
	if (proposedColorIndex == GOLFTeeColorAdd)
		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ADD");
	if (proposedColorIndex == GOLFTeeColorAll)
		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_ALL");

	for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
		if ([[colorDict objectForKey:@"teeColorIndex"] teeColorIndexValue] == proposedColorIndex) {
			return [colorDict objectForKey:@"teeColorName"];	//	The GOLFStandardTeeColorArray is localized!
		}
	}
	
//	if (proposedColorIndex == GOLFTeeColorUSA) {
//		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_USA");
//	}
//	if (proposedColorIndex == GOLFTeeColorEU) {
//		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_EU");
//	}
//	if (proposedColorIndex == GOLFTeeColorPGA) {
//		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_PGA");
//	}
//	if (proposedColorIndex == GOLFTeeColorUSGA) {
//		return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_USGA");
//	}

	return GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_UNKNOWN");
}

//=================================================================
//	GOLFLongestRangeOfAnyTeeColorNameInTeeName(teeName)
//=================================================================
NSRange GOLFLongestRangeOfAnyTeeColorNameInTeeName(NSString * _Nonnull teeName) {
	NSRange longestRange = NSMakeRange(NSNotFound, 0);
	NSString *testName = [teeName stringByAppendingString:@" "];	//	Pad with a space
	
	for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
		NSString *teeColorName = [[colorDict objectForKey:@"teeColorName"] stringByAppendingString:@" "];	//	Pad with trailing space
		NSRange testRange = [testName rangeOfString:teeColorName options:NSCaseInsensitiveSearch];
		if (testRange.location != NSNotFound) {
			NSUInteger foundLength = testRange.length - 1;	//	less the matching ending space
			if (foundLength > longestRange.length) {
				longestRange = NSMakeRange(testRange.location, foundLength);
			}
		}
	}
	return longestRange;	//	No tee color name found
}

//=================================================================
//	GOLFTeeMarkerImageFromSpecs(teeColorIndex, imageSize, teeColor)
//=================================================================
GOLFTeeImage * GOLFTeeMarkerImageFromSpecs(GOLFTeeColorIndex teeColorIndex, GOLFTeeMarkerImageSize imageSize, GOLFColor *teeColor) {
	NSBundle *ourBundle = GOLFKitBundle();
	if (ourBundle) {
		//	Starting with defaults…
		NSUInteger workingSize = imageSize;

#if TARGET_OS_IOS || TARGET_OS_WATCH
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
			if (IS_ANY_STANDARD_TEE_COLOR_INDEX(teeColorIndex)) {
				for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
					if ([[colorDict objectForKey:@"teeColorIndex"] integerValue] == teeColorIndex) {
						workingTeeImageName = [colorDict objectForKey:@"teeImageName"];
						break;	//	Out of "for (NSDictionary *colorDict" loop
					}
				}
			} else if (teeColorIndex == GOLFTeeColorCombo) {
				workingTeeImageName = @"tee_marker_combo";
			} else if (teeColorIndex == GOLFTeeColorAdd) {
				workingTeeImageName = @"tee_marker_add";
			} else if (teeColorIndex == GOLFTeeColorAll) {
				workingTeeImageName = @"tee_marker_all";
	//		} else if (teeColorIndex == GOLFTeeColorUSA) {
	//			workingTeeImageName = @"tee_marker_usa";
	//		} else if (teeColorIndex == GOLFTeeColorEU) {
	//			workingTeeImageName = @"tee_marker_eu";
	//		} else if (teeColorIndex == GOLFTeeColorPGA) {
	//			workingTeeImageName = @"tee_marker_pga";
	//		} else if (teeColorIndex == GOLFTeeColorUSGA) {
	//			workingTeeImageName = @"tee_marker_usga";
			}
		}
		return [GOLFTeeImage imageNamed:[workingTeeImageName stringByAppendingFormat:@"_%lu", (unsigned long)workingSize] inBundle:ourBundle compatibleWithTraitCollection:nil];
	
#elif TARGET_OS_MAC
		NSString *workingTeeIconName = @"GOLFTeeMarkerGeneric";
		GOLFTeeImage *workingTeeMarkerImage = nil;
		
		//	We can live with the requested size…
		
		if (teeColorIndex == GOLFTeeColorCustom) {
			NSRect offscreenRect = NSMakeRect(0.0, 0.0, 128.0, 128.0);
			NSBitmapImageRep *offscreenRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
					pixelsWide:offscreenRect.size.width pixelsHigh:offscreenRect.size.height 
					bitsPerSample:8 samplesPerPixel:4 
					hasAlpha:YES isPlanar:NO 
					colorSpaceName:NSCalibratedRGBColorSpace bitmapFormat:0 
					bytesPerRow:(4 * offscreenRect.size.width) bitsPerPixel:32];
			 
			[NSGraphicsContext saveGraphicsState];
			[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:offscreenRep]];
			 
			//	We need to draw an icon and a color dot in the graphics context
			if (teeColor == nil) {
				//	Requesting a GOLFTeeColorCustom icon, but the color hasn't been specified!
				[(GOLFTeeImage *)[ourBundle imageForResource:@"GOLFTeeMarkerGeneric"] drawAtPoint:offscreenRect.origin fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
			} else {
				//	Draw the white icon into the context
				GOLFColor *localTintingColor = [teeColor colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
				[(GOLFTeeImage *)[ourBundle imageForResource:@"GOLFTeeMarkerWhite"] drawAtPoint:offscreenRect.origin fromRect:NSZeroRect operation:NSCompositingOperationCopy fraction:1.0];
				//	The actual colored circle of the 128x128 image is 100 pixels wide, 14px left, 7 px top, 14 px right, 21 px bottom
				
				NSGradient *colorGradient = [[NSGradient alloc] initWithColorsAndLocations:
						[GOLFColor whiteColor], 0.0,
						[GOLFColor colorWithDeviceRed:[localTintingColor redComponent] green:[localTintingColor greenComponent] blue:[localTintingColor blueComponent] alpha:0.60], 0.2,
						[GOLFColor colorWithDeviceRed:[localTintingColor redComponent] green:[localTintingColor greenComponent] blue:[localTintingColor blueComponent] alpha:0.85], 0.5,
						localTintingColor, 0.9,
						[GOLFColor darkGrayColor], 1.0,
						nil];
				NSRect colorRect = NSMakeRect(offscreenRect.origin.x + 14.0, offscreenRect.origin.y + 21.0, offscreenRect.size.width - 28.0, offscreenRect.size.height - 28.0);
				NSBezierPath *circle = [NSBezierPath bezierPathWithOvalInRect:colorRect];
				[colorGradient drawInBezierPath:circle angle:-90.0];
				
	//			[colorGradient ah_release];
			}
			 
			[NSGraphicsContext restoreGraphicsState];
			
			workingTeeMarkerImage = [[GOLFTeeImage alloc] initWithSize:offscreenRect.size];
			[workingTeeMarkerImage addRepresentation:offscreenRep];	//	Add the image representation to the image
	//		[offscreenRep ah_release];	//	The image will retain the rep
		} else {
			//	Finalize the icon name…
			if (teeColorIndex != GOLFTeeColorGeneric) {
				if (IS_ANY_STANDARD_TEE_COLOR_INDEX(teeColorIndex)) {
					for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
						if ([[colorDict objectForKey:@"teeColorIndex"] integerValue] == teeColorIndex) {
							workingTeeIconName = [colorDict objectForKey:@"teeIconName"];
							break;	//	Out of "for (NSDictionary *colorDict" loop
						}
					}
				} else if (teeColorIndex == GOLFTeeColorCombo) {
					workingTeeIconName = @"GOLFTeeMarkerCombo";
				} else if (teeColorIndex == GOLFTeeColorAdd) {
					workingTeeIconName = @"GOLFTeeMarkerAdd";
				} else if (teeColorIndex == GOLFTeeColorAll) {
					workingTeeIconName = @"GOLFTeeMarkerAll";
	//			} else if (teeColorIndex == GOLFTeeColorUSA) {
	//				workingTeeIconName = @"GOLFTeeMarkerUSA";
	//			} else if (teeColorIndex == GOLFTeeColorEU) {
	//				workingTeeIconName = @"GOLFTeeMarkerEU";
	//			} else if (teeColorIndex == GOLFTeeColorPGA) {
	//				workingTeeIconName = @"GOLFTeeMarkerPGA";
	//			} else if (teeColorIndex == GOLFTeeColorUSGA) {
	//				workingTeeIconName = @"GOLFTeeMarkerUSGA";
				}
			}
			workingTeeMarkerImage = (GOLFTeeImage *)[ourBundle imageForResource:workingTeeIconName];	//	The icon as pulled from the bundle
		}
		NSImageRep *imageRep = [workingTeeMarkerImage bestRepresentationForRect:NSMakeRect(0.0, 0.0, workingSize, workingSize) context:[NSGraphicsContext currentContext] hints:nil];
		GOLFTeeImage *sizedImage = [[NSImage alloc] initWithSize:NSMakeSize(workingSize, workingSize)];
		[sizedImage addRepresentation:imageRep];
		return sizedImage;
	
#endif
	}	//	if (ourBundle)
	return nil;
}

//=================================================================
//	GOLFTeeMarkerImageFromTeeColorIndex(teeColorIndex, teeColor)
//=================================================================
GOLFTeeImage * GOLFTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex, GOLFColor *teeColor) {
	return GOLFTeeMarkerImageFromSpecs(teeColorIndex, GOLFTeeMarkerImageSizeDefault, teeColor);
}

//=================================================================
//	GOLFLittleTeeMarkerImageFromTeeColorIndex(teeColorIndex, teeColor)
//=================================================================
GOLFTeeImage * GOLFLittleTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex, GOLFColor *teeColor) {
	NSMutableDictionary *imageCache = cachedLittleTeeColorImages ?: [NSMutableDictionary dictionaryWithCapacity:5];
	NSNumber *imageKey = [NSNumber numberWithTeeColorIndex:teeColorIndex];
	GOLFTeeImage *cachedImage = [imageCache objectForKey:imageKey];
	if ((cachedImage == nil) || (teeColorIndex == GOLFTeeColorCustom)) {
		cachedImage = GOLFTeeMarkerImageFromSpecs(teeColorIndex, GOLFTeeMarkerImageSize16pt, teeColor);
		if (teeColorIndex != kNotATeeColorIndex) {
			[imageCache setObject:cachedImage forKey:imageKey];
			cachedLittleTeeColorImages = imageCache;
		}
	}
	return cachedImage;
}

//=================================================================
//	GOLFLargeTeeMarkerImageFromTeeColorIndex(teeColorIndex, teeColor)
//=================================================================
GOLFTeeImage * GOLFLargeTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex, GOLFColor *teeColor) {
	return GOLFTeeMarkerImageFromSpecs(teeColorIndex, GOLFTeeMarkerImageSize64pt, teeColor);
}

//=================================================================
//	GOLFTeeColorDictionaryForTeeColorIndex(GOLFTeeColorIndex teeColorIndex)
//=================================================================
NSDictionary * _Nullable GOLFTeeColorDictionaryForTeeColorIndex(GOLFTeeColorIndex teeColorIndex) {
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

	if (teeColorIndex == kNotATeeColorIndex) {
		return nil;
	} else if (teeColorIndex == GOLFTeeColorCombo) {
		//	GOLFTeeColorCombo is NOT in the GOLFStandardTeeColorArray
		NSDictionary *colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorCombo], @"teeColorIndex",
				[GOLFColor colorWithRed:(0.0 / 256.0) green:(69.0 / 256.0) blue:(33.0 / 256.0) alpha:1.0], @"teeColor",	//	Mostly green (dark)
				GOLFLocalizedString(@"GOLF_TEE_COLOR_NAME_COMBO"), @"teeColorName",
				@"GOLFTeeMarkerCombo", @"teeIconName",
				@"tee_marker_combo", @"teeImageName",
				[NSNumber numberWithBool:YES], @"isComboColor",
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorGreen], @"firstColorIndex",	//	Usually calibrated to a standard color
				[NSNumber numberWithUnsignedInteger:GOLFTeeColorRed], @"secondColorIndex",	//	Usually calibrated to a standard color
				nil];
		return colorDict;
	} else if (teeColorIndex == GOLFTeeColorCustom) {
		//	GOLFTeeColorCustom is NOT in the GOLFStandardTeeColorArray
		return nil;
	} else {
		for (NSDictionary *colorDict in GOLFStandardTeeColorArray()) {
			if ([[colorDict objectForKey:@"teeColorIndex"] integerValue] == teeColorIndex) {
				return colorDict;
			}
		}
	}
	return nil;
}
