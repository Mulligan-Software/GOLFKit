//
//  USGADataServices.m
//  GOLFKit
//
//  Created by John Bishop on 12/18/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "USGADataServices.h"

//	Globals
NSString * const USGADataServicesGOLFKitAppName		= @"GOLFKit for USGA Data Services";
NSString * const USGADataServicesGOLFKitAppKey		= @"BOBegvneUAUD6GeVAEHievXPw1C8vUoq";
NSString * const USGADataServicesGOLFKitAppSecret	= @"aScrZs9kX8r4wPgi";
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
NSString * const USGADataServicesiOSIdentifier		= @"iOS";
#endif

//=================================================================
//	USGADataServicesGOLFKitInfo()
//=================================================================
NSDictionary * USGADataServicesGOLFKitInfo(void) {
	return [NSDictionary dictionaryWithObjectsAndKeys:USGADataServicesGOLFKitAppName, @"appName",
			USGADataServicesGOLFKitAppKey, @"appKey",
			USGADataServicesGOLFKitAppSecret, @"appSecret",
			nil];
}

