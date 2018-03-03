//
//  GOLFKit.m
//  GOLFKit
//
//  Created by John Bishop on 3/3/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"

//=================================================================
//	GOLFKitBundleShortVersionString
//	The string version of CFBundleShortVersionString from Info.plist for GOLFKit
//=================================================================
NSString * GOLFKitBundleShortVersionString(void) {
	NSBundle *ourBundle = [NSBundle bundleWithIdentifier:@"com.mulligansoftware.GOLFKit"];
	return [[ourBundle localizedInfoDictionary] objectForKey:@"CFBundleShortVersionString"] ? : [[ourBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//=================================================================
//	GOLFKitBundleVersion
//	The string version of CFBundleVersion from Info.plist for GOLFKit
//=================================================================
NSString * GOLFKitBundleVersion(void) {
	NSBundle *ourBundle = [NSBundle bundleWithIdentifier:@"com.mulligansoftware.GOLFKit"];
	return [[ourBundle localizedInfoDictionary] objectForKey:@"CFBundleVersion"] ? : [[ourBundle infoDictionary] objectForKey:@"CFBundleVersion"];
}

