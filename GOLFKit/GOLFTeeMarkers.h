//
//  GOLFTeeMarkers.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOLFColors.h"

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
//	secondColorIndex	NSNumber steeColorIndex of the other of the combination's solid colors (when isComboColor exists and is TRUE)
//
//	You are generally not required to keep a copy of this array, as a static version is built when first needed.  If you request
//	the array, you will receive a copy of it that you are free to discard after use.

GOLFAppColor * GOLFTeeColorFromTeeColorIndex(GOLFTeeColorIndex colorIndex);
