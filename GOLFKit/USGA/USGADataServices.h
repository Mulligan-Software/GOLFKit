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
#define USGADataServicesDidCompleteHandicapRetrievalNotification @"DidCompleteUSGADataServicesHandicapRetrieval"	//	for Notification
#define USGADataServicesHandicapRetrievalDidFailNotification @"USGADataServicesHandicapRetrievalDidFail"			//	for Notification

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

extern NSString * const GOLFKitForUSGADataServicesErrorDomain;	//	The error domain name

typedef NS_ENUM(NSInteger, GOLFKitForUSGADataServicesErrorDomainError) {
	GOLFKitForUSGADataServicesDataError					= 10000,	// generic error
	GOLFKitForUSGADataServicesMultipleErrorsError		= 10010,	// generic message for error containing multiple validation errors
	GOLFKitForUSGADataServicesTokenPostError			= 10150,	// something wrong with TokenPost access token retrieval
	GOLFKitForUSGADataServicesGetGolferError			= 10160,	// something wrong with GetGolfer retrieval
};


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
@property (nonatomic, strong) NSString *userAgent;

//	TokenPost
@property (nonatomic, strong, nullable) NSString *accessToken;
@property (nonatomic, strong, nullable) NSDate *accessTokenExpiresAt;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGATokenPostTask;
@property (nonatomic, strong, nullable) NSMutableData *USGATokenPostData;
@property (nonatomic, copy) void (^USGATokenPostTaskCompletionHandler)(NSString *accessToken, NSDate *expiresAt, NSError *error);

//	GetGolfer
@property (nonatomic, weak, nullable) id golfer;
@property (nonatomic, weak, nullable) NSString *ghinNumber;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGAGetGolferTask;
@property (nonatomic, strong, nullable) NSMutableData *USGAGetGolferData;
@property (nonatomic, copy) void (^USGAGetGolferTaskCompletionHandler)(NSArray *golferArray, NSError *error);

@property (nullable, strong) NSString *progressString;
@property (nullable, strong) NSTimer *startupTimer;

@property (nonatomic, assign) BOOL needCancel;

+ (USGADataServicesAgent *)agentForDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo;

- (USGADataServicesAgent *)initWithDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo;
- (void)invalidateAndClose;

- (void)requestAccessTokenWithTimer:(NSTimer *)timer;
- (void)TokenPostWithCompletionHandler:(void (^)(NSString *accessToken, NSDate *expiresAt, NSError *error))completionHandler;
- (void)GetGolfer:(NSString *)GolferId completionHandler:(void (^)(NSArray *golferArray, NSError *error))completionHandler;
//- (void)GetHandicapProfileforGolfer:(NSString *)GolferId completionHandler:(void (^)(NSDictionary *profileDictionary, NSError *error))completionHandler;
//- (void)GetScoresCurrentRevisionByGolfer:(NSString *)GolferId forClub:(NSString *)ClubId completionHandler:(void (^)(NSArray *scoresArray, NSError *error))completionHandler;

@end
