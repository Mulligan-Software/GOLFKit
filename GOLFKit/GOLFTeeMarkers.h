//
//  GOLFTeeMarkers.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GOLFKit/GOLFKitTypes.h>
#import <GOLFKit/GOLFColors.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH

#define GOLFTeeImage UIImage

#elif TARGET_OS_MAC

#define GOLFTeeImage NSImage

#endif

//
typedef NS_ENUM(NSUInteger, GOLFTeeMarkerImageSize) {
        GOLFTeeMarkerImageSize16pt		= 16,
        GOLFTeeMarkerImageSize32pt		= 32,
        GOLFTeeMarkerImageSize64pt		= 64,
	
        GOLFTeeMarkerImageSizeDefault	= GOLFTeeMarkerImageSize32pt,
        GOLFTeeMarkerImageSizeLittle	= GOLFTeeMarkerImageSize16pt,
        GOLFTeeMarkerImageSizeBig		= GOLFTeeMarkerImageSize64pt,
        GOLFTeeMarkerImageSizeSmall		= GOLFTeeMarkerImageSize16pt,
        GOLFTeeMarkerImageSizeMedium	= GOLFTeeMarkerImageSize32pt,
        GOLFTeeMarkerImageSizeLarge		= GOLFTeeMarkerImageSize64pt
};

NSArray * _Nonnull GOLFStandardTeeColorArray(void);
//	returns an array of tee color dictionaries, containing:
//	key					data
//	----------------	-------------------------------------------------------------------------------
//	teeColorIndex		NSNumber representing the tee color (unsigned integer)
//	teeColor			NSColor (macOS) or UIColor (iOS) visually approximating the color of such a tee
//	teeColorName		Localized NSString (ex: "Blue", "Green", "Red & Yellow", etc.)
//	teeIconName			NSString name of the tee icon (.ICNS), like "GOLFTeeMarkerBlueAndWhite"
//	teeImageName		NSString name of the tee image (.PNG), like "tee_marker_blueandwhite" (excluding any size or scale identification)
//	isComboColor		NSNumber optional boolean TRUE if entry represents a color combination (two colors)
//	firstColorIndex		NSNumber teeColorIndex of one of the combination's solid colors (when isComboColor exists and is TRUE)
//	secondColorIndex	NSNumber teeColorIndex of the other of the combination's solid colors (when isComboColor exists and is TRUE)
//
//	You are generally not required to keep a copy of this array, as a static version is built when first needed.  If you request
//	the array, you will receive a copy of it that you are free to discard after use.

GOLFColor * _Nonnull GOLFTeeColorFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex);
//	Returns the NSColor (macOS) or UIColor (iOS) that best represents the tee indicated by the proposedColorIndex
//	Returns a best-visual color for combo tees, a black color if there is no tee identified by the proposedColorIndex

GOLFTeeColorIndex GOLFTeeColorIndexFromTeeColor(GOLFColor *  _Nullable teeColor);
//	Returns a GOLFTeeColorIndex that identifies a tee whose color matches teeColor (exactly as predefined)
//	Returns GOLFTeeColorCustom if no exact match is found, GOLFTeeColorUnknown if no teeColor given.

NSString * _Nonnull GOLFTeeColorNameFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex);
//	Returns the localized name of the tee whose colorIndex matches proposedColorIndex, like "Blue", "Rouge et Blanc", etc.
//	Can also return "Custom", "Unknown", "Combo", "Add" and "All" for special cases

NSRange GOLFLongestRangeOfAnyTeeColorNameInTeeName(NSString * _Nonnull teeName);
//	Returns the longest occurrance of any standard tee color name within the provided teeName string.
//	Returns NSNotFound in range.location if no tee color name is found in the string.

GOLFTeeImage * _Nonnull GOLFTeeMarkerImageFromSpecs(GOLFTeeColorIndex teeColorIndex, GOLFTeeMarkerImageSize imageSize, GOLFColor * _Nullable teeColor);
//	Returns a tee marker image of the specified size associated with the teeColorIndex provided
//	When teeColorIndex is GOLFTeeColorCombo, GOLFTeeColorAdd or GOLFTeeColorAll, returns the special tee icon
//	When teeColorIndex is GOLFTeeColorCustom, returns a custom-colored (teeColor) tee icon
//	If teeColorIndex is not any of the above, returns the special "Generic" tee icon
//	if imageSize is GOLFTeeMarkerImageSizeDefault or not any of the above GOLFTeeMarkerImageSize options, returns a 32pt. image

GOLFTeeImage * _Nonnull GOLFTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex, GOLFColor * _Nullable teeColor);
//	Returns a standard (32x32 pt.) tee marker image associated with the teeColorIndex provided
//	When teeColorIndex is GOLFTeeColorCombo, GOLFTeeColorAdd or GOLFTeeColorAll, returns the special tee icon
//	When teeColorIndex is GOLFTeeColorCustom, returns a custom-colored (teeColor) tee icon
//	If teeColorIndex is not any of the above, returns the special "Generic" tee icon

GOLFTeeImage * _Nonnull GOLFLittleTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex, GOLFColor * _Nullable teeColor);
//	Returns a small (16x16 pt.) tee marker image associated with a standard teeColorIndex provided
//	When teeColorIndex is GOLFTeeColorCombo, GOLFTeeColorAdd or GOLFTeeColorAll, returns the special tee icon
//	When teeColorIndex is GOLFTeeColorCustom, returns a custom-colored (teeColor) tee icon
//	If teeColorIndex is not any of the above, returns the special "Generic" tee icon

GOLFTeeImage * _Nonnull GOLFLargeTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex, GOLFColor * _Nullable teeColor);
//	Returns a large (64x64 pt.) tee marker image associated with the teeColorIndex provided
//	When teeColorIndex is GOLFTeeColorCombo, GOLFTeeColorAdd or GOLFTeeColorAll, returns the special tee icon
//	When teeColorIndex is GOLFTeeColorCustom, returns a custom-colored (teeColor) tee icon
//	If teeColorIndex is not any of the above, returns the special "Generic" tee icon
