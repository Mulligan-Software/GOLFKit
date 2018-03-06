//
//  GOLFKit.m
//  GOLFKit
//
//  Created by John Bishop on 3/3/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "GOLFKit.h"

//	Private Prototypes
static NSBundle *cachedGolfKitBundle = nil;

//=================================================================
//	GOLFKitBundle
//=================================================================
NSBundle * GOLFKitBundle(void) {
	if (cachedGolfKitBundle == nil) {
		cachedGolfKitBundle = [NSBundle bundleWithIdentifier:GOLFKIT_BUNDLE_ID];
	}
	return cachedGolfKitBundle;
}

//=================================================================
//	GOLFKitBundleShortVersionString
//	The string version of CFBundleShortVersionString from Info.plist for GOLFKit
//=================================================================
NSString * GOLFKitBundleShortVersionString(void) {
	NSBundle *ourBundle = GOLFKitBundle();
	return [[ourBundle localizedInfoDictionary] objectForKey:@"CFBundleShortVersionString"] ? : [[ourBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//=================================================================
//	GOLFKitBundleVersion
//	The string version of CFBundleVersion from Info.plist for GOLFKit
//=================================================================
NSString * GOLFKitBundleVersion(void) {
	NSBundle *ourBundle = GOLFKitBundle();
	return [[ourBundle localizedInfoDictionary] objectForKey:@"CFBundleVersion"] ? : [[ourBundle infoDictionary] objectForKey:@"CFBundleVersion"];
}

