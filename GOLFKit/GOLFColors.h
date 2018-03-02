//
//  GOLFColors.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKitTypes.h"

#if TARGET_OS_IOS || TARGET_OS_WATCH

@import UIKit;

#define GOLFColor UIColor

#elif TARGET_OS_MAC

@import Cocoa;

#define GOLFColor NSColor

#endif


//	#undef GOLFAppColor

//	Misc constants
#define	GOLFNumberOfCandidateTeeColors	24
#define kNotATeeColorIndex -1

typedef NS_ENUM(GOLFTeeColorIndex, teeColorIndexEnumeration) {
	GOLFTeeColorBlack = 0,				//	Black (0)
	GOLFTeeColorFirstSolid = GOLFTeeColorBlack,
	GOLFTeeColorBlue = 1,				//	Blue (1)
	GOLFTeeColorWhite,					//	White (2)
	GOLFTeeColorGreen,					//	Green (3)
	GOLFTeeColorRed,					//	Red (4)
	GOLFTeeColorYellow,					//	Yellow (5)
	GOLFTeeColorBrown,					//	Brown (6)
	GOLFTeeColorGold,					//	Gold (7)
	GOLFTeeColorSilver,					//	Silver (8)
	GOLFTeeColorPurple,					//	Purple (9)
	GOLFTeeColorOrange,					//	Orange (10)
	GOLFTeeColorMaroon,					//	Maroon (11)
	GOLFTeeColorTan,					//	Tan (12)
	GOLFTeeColorPink,					//	Pink (13)
	GOLFTeeColorTeal,					//	Teal (14)
	GOLFTeeColorAzure,					//	Azure (15)
	GOLFTeeColorLastSolid = GOLFTeeColorAzure,
	GOLFTeeColorBlueAndWhite = 20,		//	Blue & White (20)
	GOLFTeeColorFirstCombo = GOLFTeeColorBlueAndWhite,
	GOLFTeeColorRedAndYellow = 21,		//	Red & Yellow (21)
	GOLFTeeColorYellowAndBlue,			//	Yellow & Blue (22)
	GOLFTeeColorRedAndWhite,			//	Red & White (23)
	GOLFTeeColorBlackAndGold,			//	Black & Gold (24)
	GOLFTeeColorWhiteAndGold,			//	White & Gold (25)
	GOLFTeeColorBlackAndWhite,			//	Black & White (26)
	GOLFTeeColorLastCombo = GOLFTeeColorBlackAndWhite,
	GOLFTeeColorCustom = 50,			//	Custom tee color (50)
	GOLFTeeColorUSA,					//	Custom tee marker (U.S.A) (51)
	GOLFTeeColorEU,						//	Custom tee marker (E.U.) (52)
	GOLFTeeColorUnknown = 99,			//	Unknown tee color
	GOLFTeeColorAdd = 998,				//	"Add" tee color
	GOLFTeeColorAll = 999				//	"All" tee color
};


@interface GOLFColor (GOLFColorCategories)

+ (id)GOLFFactoryEagleScoreColor;
+ (id)GOLFFactoryBirdieScoreColor;
+ (id)GOLFFactoryParScoreColor;
+ (id)GOLFFactoryBogeyScoreColor;
+ (id)GOLFFactoryUnderParScoreColor;
+ (id)GOLFFactoryOverParScoreColor;

@end
