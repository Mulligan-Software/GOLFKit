//
//  GOLFExtensions.h
//  GOLFKit
//
//  Created by John Bishop on 4/6/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef GOLFExtensions_h
#define GOLFExtensions_h
#endif /* GOLFExtensions_h */

// In this header, we import all the category extensions…

//	Common
#import <GOLFKit/NSNumber+GOLFExtensions.h>
#import <GOLFKit/NSDate+GOLFExtensions.h>
#import <GOLFKit/NSString+GOLFExtensions.h>

//	macOS only (not embedded, no iOS, no Watch)
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)

#import <GOLFKit/NSColor+GOLFExtensions.h>

#endif
