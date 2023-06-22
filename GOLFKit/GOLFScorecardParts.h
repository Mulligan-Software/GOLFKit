//
//  GOLFScorecardParts.h
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GOLFKit/GOLFKitTypes.h>
#import <GOLFKit/GOLFColors.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH

#define ScorecardView UIView

#elif TARGET_OS_MAC

#define ScorecardView NSView

#endif

typedef NS_ENUM(NSUInteger, ScorecardPartType) {
        ScorecardPartTypeBaseView	= 0,	//	(0) Overall transparent non-drawing coordinating view
        ScorecardPartTypeRoundView,			//	(1)	Side views and total
        ScorecardPartTypeSideView,			//	(2)	hole views and total
        ScorecardPartTypeHoleView,			//	(3)	text label or entry field
};

typedef NS_OPTIONS(NSUInteger, ScorecardPartBorder) {
	ScorecardPartBorderNone				= 0,			//	(0)
	ScorecardPartBorderTop				= 1 << 0,		//	(1)		Visible border (or drawing space)
	ScorecardPartBorderLeft				= 1 << 1,		//	(2)		around the dynamically-sized part
	ScorecardPartBorderBottom			= 1 << 2,		//	(4)
	ScorecardPartBorderRight			= 1 << 3,		//	(8)
};


//GOLFColor * _Nonnull GOLFTeeColorFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex);
////	Returns the NSColor (macOS) or UIColor (iOS) that best represents the tee indicated by the proposedColorIndex
////	Returns a best-visual color for combo tees, a black color if there is no tee identified by the proposedColorIndex
//
//GOLFTeeColorIndex GOLFTeeColorIndexFromTeeColor(GOLFColor *  _Nullable teeColor);
////	Returns a GOLFTeeColorIndex that identifies a tee whose color matches teeColor (exactly as predefined)
////	Returns GOLFTeeColorCustom if no exact match is found, GOLFTeeColorUnknown if no teeColor given.
//
//NSString * _Nonnull GOLFTeeColorNameFromTeeColorIndex(GOLFTeeColorIndex proposedColorIndex);
////	Returns the localized name of the tee whose colorIndex matches proposedColorIndex, like "Blue", "Rouge et Blanc", etc.
////	Can also return "Custom", "Unknown", "Combo", "Add" and "All" for special cases
//
//NSRange GOLFLongestRangeOfAnyTeeColorNameInTeeName(NSString * _Nonnull teeName);
////	Returns the longest occurrance of any standard tee color name within the provided teeName string.
////	Returns NSNotFound in range.location if no tee color name is found in the string.
//
