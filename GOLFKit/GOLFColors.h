//
//  GOLFColors.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

@import Foundation;


typedef NS_ENUM(NSInteger, GOLFTeeColorIndex) {
	GOLFTeeColorBlack = 0,			//	Black (0)
	GOLFTeeColorBlue,				//	Blue (1)
	GOLFTeeColorWhite,				//	White (2)
	GOLFTeeColorGreen,				//	Green (3)
	GOLFTeeColorRed,				//	Red (4)
	GOLFTeeColorYellow,				//	Yellow (5)
	GOLFTeeColorBrown,				//	Brown (6)
	GOLFTeeColorGold,				//	Gold (7)
	GOLFTeeColorSilver,				//	Silver (8)
	GOLFTeeColorPurple,				//	Purple (9)
	GOLFTeeColorOrange,				//	Orange (10)
	GOLFTeeColorMaroon,				//	Maroon (11)
	GOLFTeeColorTan,				//	Tan (12)
	GOLFTeeColorBlueAndWhite = 20,	//	Blue & White (20)
	GOLFTeeColorRedAndYellow,		//	Red & Yellow (21)
	GOLFTeeColorYellowAndBlue,		//	Yellow & Blue (22)
	GOLFTeeColorRedAndWhite,		//	Red & White (23)
	GOLFTeeColorBlackAndGold,		//	Black & Gold (24)
	GOLFTeeColorWhiteAndGold,		//	White & Gold (25)
	GOLFTeeColorBlackAndWhite,		//	Black & White (26)
	GOLFTeeColorCustom = 50,		//	Custom tee color
	GOLFTeeColorUnknown = 99,		//	Unknown tee color
	GOLFTeeColorAdd = 998,			//	"Add" tee color
	GOLFTeeColorAll = 999			//	"All" tee color
};

#if TARGET_OS_IOS || TARGET_OS_WATCH

@import UIKit;

#define GOLFAppColor UIColor

#elif TARGET_OS_MAC

@import Cocoa;

#define GOLFAppColor NSColor

#endif


#undef GOLFAppColor
