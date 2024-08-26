//
//  GOLFColors.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GOLFKit/GOLFKitTypes.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH

#import <UIKit/UIKit.h>

#define GOLFColor UIColor

#elif TARGET_OS_MAC

#import <Cocoa/Cocoa.h>

#define GOLFColor NSColor

#endif


//	#undef GOLFAppColor

//	Globals
extern CGFloat GOLFColorDefaultYardageContrast;	//	Somewhere around 0.35

//	Misc constants
#define	kGOLFTeeColorsNumberOfSolid		17		//	Black (0) through Bronze (16), total of 17
#define	kGOLFTeeColorsNumberOfCombo		13		//	Blue & White (20) through Orange & Green (32), total of 13
#define kGOLFTeeColorsNumberOfCustom	8		//	U.S.A. (51) through IV (58), total of 8
//										---
#define kGOLFTeeColorsNumberOfStandard	38		//	Total Standard tee colors

#define kNotATeeColorIndex				-999	//	No-value GOLFTeeColorIndex specification

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
	GOLFTeeColorBronze,					//	Bronze (16)
	GOLFTeeColorLastSolid = GOLFTeeColorBronze,
	GOLFTeeColorBlueAndWhite = 20,		//	Blue & White (20)
	GOLFTeeColorFirstCombo = GOLFTeeColorBlueAndWhite,
	GOLFTeeColorRedAndYellow = 21,		//	Red & Yellow (21)
	GOLFTeeColorYellowAndBlue,			//	Yellow & Blue (22)
	GOLFTeeColorRedAndWhite,			//	Red & White (23)
	GOLFTeeColorBlackAndGold,			//	Black & Gold (24)
	GOLFTeeColorWhiteAndGold,			//	White & Gold (25)
	GOLFTeeColorBlackAndWhite,			//	Black & White (26)
	GOLFTeeColorBlueAndGreen,			//	Blue & Green (27)
	GOLFTeeColorGreenAndWhite,			//	Green & White (28)
	GOLFTeeColorGreenAndRed,			//	Green & Red (29)
	GOLFTeeColorYellowAndGreen,			//	Yellow & Green (30)
	GOLFTeeColorBlackAndBlue,			//	Black & Blue (31)
	GOLFTeeColorOrangeAndGreen,			//	Orange & Green (32)
	GOLFTeeColorLastCombo = GOLFTeeColorOrangeAndGreen,
	GOLFTeeColorCustom = 50,			//	Custom tee color (50)
	GOLFTeeColorUSA,					//	Custom tee marker (U.S.A.) (51)
	GOLFTeeColorFirstSpecial = GOLFTeeColorUSA,
	GOLFTeeColorEU,						//	Custom tee marker (E.U.) (52)
	GOLFTeeColorPGA,					//	Custom tee marker (PGA) (53)
	GOLFTeeColorUSGA,					//	Custom tee marker (USGA) (54)
	GOLFTeeColorOne,					//	Custom tee marker (I) (55)
	GOLFTeeColorTwo,					//	Custom tee marker (II) (56)
	GOLFTeeColorThree,					//	Custom tee marker (III) (57)
	GOLFTeeColorFour,					//	Custom tee marker (IV) (58)
	GOLFTeeColorLastSpecial = GOLFTeeColorFour,
	GOLFTeeColorCombo = 80,				//	Combo tee color (80)
	GOLFTeeColorGeneric = 98,			//	Generic tee color (98)
	GOLFTeeColorUnknown = 99,			//	Unknown tee color
	GOLFTeeColorAdd = 998,				//	"Add" tee color
	GOLFTeeColorAll = 999				//	"All" tee color
};

#if !defined(IS_ANY_SOLID_TEE_COLOR_INDEX)
	#define IS_ANY_SOLID_TEE_COLOR_INDEX(_index)	((((_index) >= GOLFTeeColorFirstSolid) && ((_index) <= GOLFTeeColorLastSolid)) ? YES : NO)
#endif

#if !defined(IS_ANY_COMBO_TEE_COLOR_INDEX)
	#define IS_ANY_COMBO_TEE_COLOR_INDEX(_index)	((((_index) >= GOLFTeeColorFirstCombo) && ((_index) <= GOLFTeeColorLastCombo)) ? YES : NO)
#endif

#if !defined(IS_ANY_SPECIAL_TEE_COLOR_INDEX)
	#define IS_ANY_SPECIAL_TEE_COLOR_INDEX(_index)	((((_index) >= GOLFTeeColorFirstSpecial) && ((_index) <= GOLFTeeColorLastSpecial)) ? YES : NO)
#endif

#if !defined(IS_ANY_STANDARD_TEE_COLOR_INDEX)
	#define IS_ANY_STANDARD_TEE_COLOR_INDEX(_index)	((IS_ANY_SOLID_TEE_COLOR_INDEX(_index) || IS_ANY_COMBO_TEE_COLOR_INDEX(_index) || IS_ANY_SPECIAL_TEE_COLOR_INDEX(_index)) ? YES : NO)
#endif


@interface GOLFColor (GOLFColorCategories)
+ (BOOL)darkMode;	//	When a dark-themed NSAppearance is active on the current thread or in the App

+ (id)GOLFFactoryEagleScoreColor;
+ (id)GOLFFactoryBirdieScoreColor;
+ (id)GOLFFactoryParScoreColor;
+ (id)GOLFFactoryBogeyScoreColor;
+ (id)GOLFFactoryUnderParScoreColor;
+ (id)GOLFFactoryOverParScoreColor;

//	From GOLFColors.xcassets (Appearance sensitive)
+ (id)GOLFFactoryBirdieColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryBogeyColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryEagleColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryErrorHighlightColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryMatchAColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryMatchBColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryParColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryPeoriaBackgroundColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryPlottingPrimaryColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryPlottingSecondaryColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactorySkinsBackgroundColor API_AVAILABLE(macos(10.10),ios(9.0));

//	Dark Mode
+ (id)GOLFFactoryDarkEagleScoreColor;
+ (id)GOLFFactoryDarkBirdieScoreColor;
+ (id)GOLFFactoryDarkParScoreColor;
+ (id)GOLFFactoryDarkBogeyScoreColor;
+ (id)GOLFFactoryDarkMatchAColor API_AVAILABLE(macos(10.10),ios(9.0));
+ (id)GOLFFactoryDarkMatchBColor API_AVAILABLE(macos(10.10),ios(9.0));

//	Color difference (colorimetric distance)
- (CGFloat)colorimetricDistanceToGOLFColor:(GOLFColor *)compareColor;

@end

