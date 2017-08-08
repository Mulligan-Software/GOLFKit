//
//  GOLFTeeMarkers.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFTeeMarkers.h"
#import "GOLFColors.h"

//	Private Prototypes

//	Globals
static NSArray *GOLFStandardColorArray = nil;

//=================================================================
//	GOLFStandardTeeColorArray
//=================================================================
NSArray * GOLFStandardTeeColorArray(void) {
	if (GOLFStandardColorArray == nil) {
		NSMutableArray *workingList = [NSMutableArray arrayWithCapacity:numberOfCandidateTeeColors];
		
		//	Black
		NSDictionary *colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlack], @"teeColorIndex",
				[GOLFAppColor blackColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK", @""), @"teeColorName",
				@"TeeMarkerBlack", @"teeIconName",
				@"tee_marker_black", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlue], @"teeColorIndex",
				[GOLFAppColor blueColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE", @""), @"teeColorName",
				@"TeeMarkerBlue", @"teeIconName",
				@"tee_marker_blue", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorWhite], @"teeColorIndex",
				[GOLFAppColor whiteColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE", @""), @"teeColorName",
				@"TeeMarkerWhite", @"teeIconName",
				@"tee_marker_white", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorGreen], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN", @""), @"teeColorName",
				@"TeeMarkerGreen", @"teeIconName",
				@"tee_marker_green", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Red
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorRed], @"teeColorIndex",
				[GOLFAppColor redColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_RED", @""), @"teeColorName",
				@"TeeMarkerRed", @"teeIconName",
				@"tee_marker_red", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorYellow], @"teeColorIndex",
				[GOLFAppColor yellowColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW", @""), @"teeColorName",
				@"TeeMarkerYellow", @"teeIconName",
				@"tee_marker_yellow", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Brown
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBrown], @"teeColorIndex",
				[GOLFAppColor brownColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BROWN", @""), @"teeColorName",
				@"TeeMarkerBrown", @"teeIconName",
				@"tee_marker_brown", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorGold], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_GOLDE", @""), @"teeColorName",
				@"TeeMarkerGold", @"teeIconName",
				@"tee_marker_gold", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Silver
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorSilver], @"teeColorIndex",
				[GOLFAppColor colorWithRed:(0.6) green:(0.6) blue:(0.8) alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_SILVER", @""), @"teeColorName",
				@"TeeMarkerSilver", @"teeIconName",
				@"tee_marker_silver", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Purple
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorPurple], @"teeColorIndex",
				[GOLFAppColor purpleColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_PURPLE", @""), @"teeColorName",
				@"TeeMarkerPurple", @"teeIconName",
				@"tee_marker_purple", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Orange
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorOrange], @"teeColorIndex",
				[GOLFAppColor orangeColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_ORANGE", @""), @"teeColorName",
				@"TeeMarkerOrange", @"teeIconName",
				@"tee_marker_orange", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Maroon
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorMaroon], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.5 green:0 blue:0.25 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_MAROON", @""), @"teeColorName",
				@"TeeMarkerMaroon", @"teeIconName",
				@"tee_marker_maroon", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Tan
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorTan], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.792 green:0.675 blue:0.592 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_TAN", @""), @"teeColorName",
				@"TeeMarkerTan", @"teeIconName",
				@"tee_marker_tan", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Pink
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorPink], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:0.753 blue:0.796 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_PINK", @""), @"teeColorName",
				@"TeeMarkerPink", @"teeIconName",
				@"tee_marker_pink", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Teal
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorTeal], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0 green:0.502 blue:0.502 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_TEAL", @""), @"teeColorName",
				@"TeeMarkerTeal", @"teeIconName",
				@"tee_marker_teal", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Azure
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorAzure], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0 green:0.875 blue:1.0 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_AZURE", @""), @"teeColorName",
				@"TeeMarkerAzure", @"teeIconName",
				@"tee_marker_azure", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Blue & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlueAndWhite], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0 green:0.06 blue:1.0 alpha:1.0], @"teeColor",	//	Not quite blue
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE_AND_WHITE", @""), @"teeColorName",
				@"TeeMarkerBlueAndWhite", @"teeIconName",
				@"tee_marker_blueandwhite", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Red & Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorRedAndYellow], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_YELLOW", @""), @"teeColorName",
				@"TeeMarkerRedAndYellow", @"teeIconName",
				@"tee_marker_redandyellow", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Yellow & Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorYellowAndBlue], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:1.0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite yellow
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW_AND_BLUE", @""), @"teeColorName",
				@"TeeMarkerYellowAndBlue", @"teeIconName",
				@"tee_marker_yellowandblue", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Red & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorRedAndWhite], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:0.02 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_WHITE", @""), @"teeColorName",
				@"TeeMarkerRedAndWhite", @"teeIconName",
				@"tee_marker_redandwhite", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Black & Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlackAndGold], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.1 green:0.06 blue:0.0 alpha:1.0], @"teeColor",	//	Dark gold
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_GOLD", @""), @"teeColorName",
				@"TeeMarkerBlackAndGold", @"teeIconName",
				@"tee_marker_blackandgold", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	White & Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorWhiteAndGold], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:0.61 blue:0.01 alpha:1.0], @"teeColor",	//	Light gold
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE_AND_GOLD", @""), @"teeColorName",
				@"TeeMarkerWhiteAndGold", @"teeIconName",
				@"tee_marker_whiteandgold", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		//	Black & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlackAndWhite], @"teeColorIndex",
				[GOLFAppColor darkGrayColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_WHITE", @""), @"teeColorName",
				@"TeeMarkerBlackAndWhite", @"teeIconName",
				@"tee_marker_blackandwhite", @"teeImageName", nil];
		[workingList addObject:colorDict];
		
		GOLFStandardColorArray = [NSArray arrayWithArray:workingList];
	}
	return [GOLFStandardColorArray copy];
}


