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

@protocol GOLFTeeColorInfoSource;


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
//	the array, you will receive a copy of it that you are free to use, modify, enhance (see GOLFComboTeeInfoSource protocol) and
//	discard after use.

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

NSDictionary * _Nullable GOLFTeeColorDictionaryForTeeColorIndex(GOLFTeeColorIndex teeColorIndex);
//	Returns the NSDictionary entry in GOLFStandardTeeColorArray() that matches the provided teeColorIndex
//	If there is no such NSDictionary, return nil.


@protocol GOLFTeeColorInfoSource <NSObject>

@optional

- (NSDictionary * _Nonnull)GOLFTeeColorInfoFromStandardTeeColorItem:(NSDictionary * _Nonnull)comboDict;
//	Key					Type			Description
//	--------------		----------		------------------------------------------------------------------------------------------
//	teeColorIndex		NSNumber		unsigned integer representing the tee color
//	teeColor			GOLFColor		NSColor (macOS) or UIColor (iOS) representing visual equivalent for display or tinting
//	teeColorName		NSString		localized name of the color (ie: "Vert", "Black & White", "Rojo y Blanco")
//	teeIconName			NSString		name of the tee icon (.ICNS), like "TeeMarkerBlueAndWhite"
//	teeImageName		NSString		name of the tee image (.PNG), like "tee_marker_blueandwhite" (excluding any size or scale identification)
//	isComboColor		NSNumber		optional boolean TRUE if entry represents a color combination (two colors)
//	firstColorIndex		NSNumber		teeColorIndex of one of the combination's solid colors (when isComboColor is TRUE)
//	secondColorIndex	NSNumber		teeColorIndex of the other of the combination's solid colors (when isComboColor is TRUE)
//	frontColoration		NSString 		optional 9 characters indicating (1) use 1st color, (2) use 2nd color, (3) use both colors (like totals)
//	backColoration		NSString 		optional 9 characters indicating (1) use 1st color, (2) use 2nd color, (3) use both colors (like totals)
//	course				id				optional golf course which has tees configured for combo coloration
//	round				id				optional round which might require special tee color presentation
//	tee					id				The golf tee associated with the original comboDict or its calibrated equivalent
//	side				id				The side or roundSide associated with the original comboDict or its calibrated equivalent
//
//	Passed a standard combo teeColor NSDictionary or the "Combo" teeColor NSDictionary,
//	returns (from a course, side, tee, round, or roundSide) an enhanced NSDictionary identifying any of those objects,
//	the data derived from the original teeColor dictionary (the "combo" tee), course, round, sides or tee itself known to the GOLFComboTeeInfoSource
//	and the StandardTeeColor NSDictionary items of the 2 solid color tees that best match the yardage of the master Combo (or "Combo") tee
//	represented by comboDict.
//
//	That is, if the comboDict identifies as the "Red & White" tees (which the standard says will use the Red and White
//	solid tees for hole-by-hole recognition) or comboDict designates a "Combo" tee, the course or round can tell us which
//	ACTUAL solid color tees have yardages that best match 2 solid-colored tees (which might not be red and/or white or
//	could be red AND white at certain holes).
//	In the returned "calibrated" combo tee color NSDictionary, the "firstColorIndex" and "secondColorIndex" items will
//	be set to corrected teeColor references, the "isComboColor" boolean will be set to TRUE and the display mapping for
//	18 holes (color designator) will be provided by the GOLFComboTeeInfoSource if possible.  The GOLFComboTeeInfoSource provider
//	will supply this dictionary full of stuff, but interested party has to provide comboDict and do the right thing with these
//	specs - like picking out a color or tee marker image, or paint text boxes.

@end
