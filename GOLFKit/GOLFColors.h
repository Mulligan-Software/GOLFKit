//
//  GOLFColors.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

@import Foundation;


#if TARGET_OS_IOS || TARGET_OS_WATCH

@import UIKit;

#define GOLFAppColor UIColor

#elif TARGET_OS_MAC

@import Cocoa;

#define GOLFAppColor NSColor

#endif


//	#undef GOLFAppColor

//	Misc constants
#define	numberOfCandidateTeeColors	23
#define kNotATeeColorIndex -1

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
	GOLFTeeColorPink,				//	Pink (13)
	GOLFTeeColorTeal,				//	Teal (14)
	GOLFTeeColorAzure,				//	Azure (15)
	GOLFTeeColorLastSolid = GOLFTeeColorAzure,
	GOLFTeeColorBlueAndWhite = 20,	//	Blue & White (20)
	GOLFTeeColorFirstCombo = GOLFTeeColorBlueAndWhite,
	GOLFTeeColorRedAndYellow = 21,		//	Red & Yellow (21)
	GOLFTeeColorYellowAndBlue,		//	Yellow & Blue (22)
	GOLFTeeColorRedAndWhite,		//	Red & White (23)
	GOLFTeeColorBlackAndGold,		//	Black & Gold (24)
	GOLFTeeColorWhiteAndGold,		//	White & Gold (25)
	GOLFTeeColorBlackAndWhite,		//	Black & White (26)
	GOLFTeeColorLastCombo = GOLFTeeColorBlackAndWhite,
	GOLFTeeColorCustom = 50,		//	Custom tee color
	GOLFTeeColorUnknown = 99,		//	Unknown tee color
	GOLFTeeColorAdd = 998,			//	"Add" tee color
	GOLFTeeColorAll = 999			//	"All" tee color
};


@interface GOLFAppColor (GOLFColorCategories)

+ (id)GOLFFactoryEagleScoreColor;
+ (id)GOLFFactoryBirdieScoreColor;
+ (id)GOLFFactoryParScoreColor;
+ (id)GOLFFactoryBogeyScoreColor;
+ (id)GOLFFactoryUnderParScoreColor;
+ (id)GOLFFactoryOverParScoreColor;

@end
