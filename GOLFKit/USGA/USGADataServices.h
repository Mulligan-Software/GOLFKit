//
//  USGADataServices.h
//  GOLFKit
//
//  Created by John Bishop on 12/18/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

@import Foundation;
#import "GOLFKit.h"

//	Misc constants
#define	kUSGADataServicesConstant		999			//	Dummy

typedef NS_OPTIONS(NSUInteger, USGADataServicesOption) {
	USGADataServicesOptionNone			= 0,			//	(0)
	USGADataServicesOptionsNone			= USGADataServicesOptionNone,
	USGADataServicesOptionSpare0		= 1 << 0,		//	(1)
	USGADataServicesOptionSpare1		= 1 << 1		//	(2)
};

typedef NS_ENUM(NSUInteger, USGADataServicesMethod) {
	USGADataServicesMethodNone = 0,					//	none (0)
	USGADataServicesMethodUSGA,						//	USGA Handicap System (1)
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
	USGADataServicesMethodMulligan = 20,			//	Mulligan Handicap System (20)
#endif
	USGADataServicesMethodUnknown = 999				//	Unknown handicapping type
};

extern NSString * const USGADataServicesGOLFKitAppName;
extern NSString * const USGADataServicesGOLFKitAppKey;
extern NSString * const USGADataServicesGOLFKitAppSecret;
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
extern NSString * const USGADataServicesiOSIdentifier;		//	"iOS"
#endif

NSDictionary * USGADataServicesGOLFKitInfo(void);
//	Returns an NSDictionary with information about "GOLFKit for USGA Data Services" app:
//
//	Key						Type			Description
//	----------------------	--------------	---------------------------------
//	appName					NSString *		Complete name of the Scoring Data Services Product
//	appKey					NSString *		The appKey required as credential for the app
//	appSecret				NSString *		The credentialling confidential appKey for the app

