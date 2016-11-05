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
				@"tee_marker_black", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlue], @"teeColorIndex",
				[GOLFAppColor blueColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE", @""), @"teeColorName",
				@"tee_marker_blue", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorWhite], @"teeColorIndex",
				[GOLFAppColor whiteColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE", @""), @"teeColorName",
				@"tee_marker_white", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Green
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorGreen], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_GREEN", @""), @"teeColorName",
				@"tee_marker_green", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Red
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorRed], @"teeColorIndex",
				[GOLFAppColor redColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_RED", @""), @"teeColorName",
				@"tee_marker_red", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorYellow], @"teeColorIndex",
				[GOLFAppColor yellowColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW", @""), @"teeColorName",
				@"tee_marker_yellow", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Brown
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBrown], @"teeColorIndex",
				[GOLFAppColor brownColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BROWN", @""), @"teeColorName",
				@"tee_marker_brown", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorGold], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:(0.6) blue:0.0 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_GOLDE", @""), @"teeColorName",
				@"tee_marker_gold", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Silver
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorSilver], @"teeColorIndex",
				[GOLFAppColor colorWithRed:(0.6) green:(0.6) blue:(0.8) alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_SILVER", @""), @"teeColorName",
				@"tee_marker_silver", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Purple
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorPurple], @"teeColorIndex",
				[GOLFAppColor purpleColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_PURPLE", @""), @"teeColorName",
				@"tee_marker_purple", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Orange
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorOrange], @"teeColorIndex",
				[GOLFAppColor orangeColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_ORANGE", @""), @"teeColorName",
				@"tee_marker_orange", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Maroon
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorMaroon], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.5 green:0 blue:0.25 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_MAROON", @""), @"teeColorName",
				@"tee_marker_maroon", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Tan
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorTan], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.792 green:0.675 blue:0.592 alpha:1.0], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_TAN", @""), @"teeColorName",
				@"tee_marker_tan", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Blue & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlueAndWhite], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0 green:0.06 blue:1.0 alpha:1.0], @"teeColor",	//	Not quite blue
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLUE_AND_WHITE", @""), @"teeColorName",
				@"tee_marker_blueandwhite", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Red & Yellow
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorRedAndYellow], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_YELLOW", @""), @"teeColorName",
				@"tee_marker_redandyellow", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Yellow & Blue
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorYellowAndBlue], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:1.0 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite yellow
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_YELLOW_AND_BLUE", @""), @"teeColorName",
				@"tee_marker_yellowandblue", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Red & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorRedAndWhite], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:0.02 blue:0.02 alpha:1.0], @"teeColor",	//	Not quite red
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_RED_AND_WHITE", @""), @"teeColorName",
				@"tee_marker_redandwhite", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Black & Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlackAndGold], @"teeColorIndex",
				[GOLFAppColor colorWithRed:0.1 green:0.06 blue:0.0 alpha:1.0], @"teeColor",	//	Dark gold
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_GOLD", @""), @"teeColorName",
				@"tee_marker_blackandgold", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	White & Gold
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorWhiteAndGold], @"teeColorIndex",
				[GOLFAppColor colorWithRed:1.0 green:0.61 blue:0.01 alpha:1.0], @"teeColor",	//	Light gold
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_WHITE_AND_GOLD", @""), @"teeColorName",
				@"tee_marker_whiteandgold", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		//	Black & White
		colorDict = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:GOLFTeeColorBlackAndWhite], @"teeColorIndex",
				[GOLFAppColor darkGrayColor], @"teeColor",
				NSLocalizedString(@"GOLF_TEE_COLOR_NAME_BLACK_AND_WHITE", @""), @"teeColorName",
				@"tee_marker_blackandwhite", @"teeIconName", nil];
		[workingList addObject:colorDict];
		
		GOLFStandardColorArray = [NSArray arrayWithArray:workingList];
	}
	return [GOLFStandardColorArray copy];
}


