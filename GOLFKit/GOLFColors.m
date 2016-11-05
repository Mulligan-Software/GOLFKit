//
//  GOLFColors.m
//  GOLFKit
//
//  Created by John Bishop on 11/5/16.
//  Copyright © 2016 Mulligan Software. All rights reserved.
//

#import "GOLFColors.h"

#if TARGET_OS_IOS || TARGET_OS_WATCH

#define GOLFAppColor UIColor

#elif TARGET_OS_MAC

#define GOLFAppColor NSColor

#endif


//	#undef GOLFAppColor
