//
//  GOLFTeeMarkers.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOLFKitTypes.h"
#import "GOLFColors.h"

#if TARGET_OS_IOS || TARGET_OS_WATCH

#define GOLFTeeImage UIImage

#elif TARGET_OS_MAC

#define GOLFTeeImage NSImage

#endif

NSArray * GOLFStandardTeeColorArray(void);
//	returns an array of tee color dictionaries, containing:
//	key					data
//	----------------	-------------------------------------------------------------------------------
//	teeColorIndex		NSNumber representing the tee color (unsigned integer)
//	teeColor			NSColor (macOS) or UIColor (iOS) visually approximating the color of such a tee
//	teeColorName		Localized NSString (ex: "Blue", "Green", "Red & Yellow", etc.)
//	teeIconName			NSString name of the tee icon (.ICNS), like "TeeMarkerBlueAndWhite"
//	teeImageName		NSString name of the tee image (.PNG), like "tee_marker_blueandwhite" (excluding any size or scale identification)
//	isComboColor		NSNumber optional boolean TRUE if entry represents a color combination (two colors)
//	firstColorIndex		NSNumber teeColorIndex of one of the combination's solid colors (when isComboColor exists and is TRUE)
//	secondColorIndex	NSNumber teeColorIndex of the other of the combination's solid colors (when isComboColor exists and is TRUE)
//
//	You are generally not required to keep a copy of this array, as a static version is built when first needed.  If you request
//	the array, you will receive a copy of it that you are free to discard after use.

GOLFColor * GOLFTeeColorFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex);
//	Returns the NSColor (macOS) or UIColor (iOS) that best represents the tee indicated by the proposedColorIndex
//	Returns a best-visual color for combo tees, a black color if there is no tee identified by the proposedColorIndex

GOLFTeeColorIndex GOLFTeeColorIndexFromTeeColor(GOLFColor *teeColor);
//	Returns a GOLFTeeColorIndex that identifies a tee whose color matches teeColor (exactly as predefined)
//	Returns GOLFTeeColorCustom if no exact match is found, GOLFTeeColorUnknown if no teeColor given.

NSString * GOLFTeeColorNameFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex);
//	Returns the localized name of the tee whose colorIndex matches proposedColorIndex, like "Blue", "Rouge et Blanc", etc.
//	Can also return "Custom", "Unknown", "Add" and "All" for special cases

GOLFTeeImage * GOLFTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex);
//	Returns a standard (32x32 pt.) tee marker image associated with the teeColorIndex provided
//	When teeColorIndex is GOLFTeeColorAdd, returns the special "Add" tee icon
//	If teeColorIndex is GOLFTeeColorCustom or not any of the above, returns the special "Generic" tee icon

GOLFTeeImage * GOLFLittleTeeMarkerImageFromTeeColorIndex(GOLFTeeColorIndex teeColorIndex);
//	Returns a small (16x16 pt.) tee marker image associated with the teeColorIndex provided
//	When teeColorIndex is GOLFTeeColorAdd, returns the special "Add" tee icon
//	If teeColorIndex is GOLFTeeColorCustom or not any of the above, returns the special "Generic" tee icon
