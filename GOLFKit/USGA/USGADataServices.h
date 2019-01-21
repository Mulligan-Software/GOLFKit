//
//  USGADataServices.h
//  GOLFKit
//
//  Created by John Bishop on 12/18/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GOLFKit.h"

//	Misc constants
#define	kDefaultUSGAAccessTokenExpiration		9000			//	NSTimeInterval (seconds)

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

extern NSString * const GOLFKitForUSGADataServicesErrorDomain;	//	The error domain name

typedef NS_ENUM(NSInteger, GOLFKitForUSGADataServicesErrorDomainError) {
	GOLFKitForUSGADataServicesDataError					= 10000,	// generic error
	GOLFKitForUSGADataServicesMultipleErrorsError		= 10010,	// generic message for error containing multiple validation errors
	GOLFKitForUSGADataServicesDataBaseAccessError		= 10050,	// something wrong with retrieval from or export to USGA Data Services
	GOLFKitForUSGADataServicesRemoteDataAccessError		= 10100,	// something wrong with reading or writing remote (sync) data to USGA Data Services
	GOLFKitForUSGADataServicesAccessTokenError			= 10150,	// something wrong with retrieving access token credentials
};

NSDictionary * USGADataServicesGOLFKitInfo(void);
//	Returns an NSDictionary with information about "GOLFKit for USGA Data Services" app:
//
//	Key						Type			Description
//	----------------------	--------------	---------------------------------
//	appName					NSString *		Complete name of the Scoring Data Services Product
//	appKey					NSString *		The appKey required as credential for the app
//	appSecret				NSString *		The credentialling confidential appKey for the app


@protocol USGADataServicesAgentDelegate <NSObject>

@optional

//	Returns an NSDictionary with information about the  USGA Scoring Data Services Product registration for the client app.
//	May return nil if the app is not registered
//
//	Key						Type			Description
//	----------------------	--------------	---------------------------------
//	appName					NSString *		Complete name of the Scoring Data Services Product
//	appKey					NSString *		The appKey required as credential for the app
//	appSecret				NSString *		The credentialling confidential appKey for the app
- (NSDictionary *)USGADataServicesAppInfo;

@end


@interface USGADataServicesAgent : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong, nullable) NSString *USGADataServicesProductAppName;
@property (nonatomic, strong, nullable) NSString *USGADataServicesProductAppKey;
@property (nonatomic, strong, nullable) NSString *USGADataServicesProductAppSecret;

@property (nullable, retain) id <USGADataServicesAgentDelegate> delegate;
@property (nonatomic, strong, nullable) NSURLSession *USGAQuerySession;

//	Access Token
@property (nonatomic, strong, nullable) NSString *accessToken;
@property (nonatomic, strong, nullable) NSDate *accessTokenExpiresAt;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGAAccessTokenTask;
@property (nonatomic, strong, nullable) NSMutableData *USGAAccessTokenData;
@property (nonatomic, copy) void (^accessTokenTaskCompletionHandler)(NSString *accessToken, NSDate *expiresAt, NSError *error);
//@property (nonatomic, strong, nullable) NSDate *USGAAccessTokenTaskStart;

//	Golfer
@property (nonatomic, weak, nullable) id golfer;
@property (nonatomic, weak, nullable) NSString *ghinNumber;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGAGetGolferTask;
@property (nonatomic, strong, nullable) NSMutableData *USGAGetGolferData;
@property (nonatomic, copy) void (^getGolferTaskCompletionHandler)(NSDictionary *golferData, NSError *error);

@property (nullable, strong) NSString *progressString;
@property (nullable, strong) NSTimer *startupTimer;

@property (nonatomic, assign) BOOL needCancel;

+ (USGADataServicesAgent *)agentForDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo;

- (USGADataServicesAgent *)initWithDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo;
- (void)invalidateAndClose;

- (void)requestAccessTokenWithTimer:(NSTimer *)timer;
- (void)getAccessTokenWithCompletionHandler:(void (^)(NSString *accessToken, NSDate *expiresAt, NSError *error))completionHandler;
- (void)getGolfer:(id)golfer withGHINNumber:(NSString *)ghinText completionHandler:(void (^)(NSDictionary *golferData, NSError *error))completionHandler;


@end
