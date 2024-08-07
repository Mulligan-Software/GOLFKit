//
//  GOLFHandicapLookup.h
//  GOLFKit
//
//  Created by John Bishop on 7/7/21.
//  Copyright © 2021 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GOLFKit/GOLFKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GOLFHandicapLookupService) {
	GOLFHandicapLookupServiceGHIN = 0,		//	Golf Handicap Information Network (GHIN)	(0)
	GOLFHandicapLookupServiceGOLFLink,		//	GOLFLink Australia							(1)
	GOLFHandicapLookupServiceGolfNetwork,	//	GOLF Network Canada							(2)
	GOLFHandicapLookupServiceUnknown = 99	//	Unknown handicap lookup technique
};

typedef NS_ENUM(NSUInteger, GOLFHandicapLookupStatus) {
	GOLFHandicapLookupStatusNone = 0,		//	none (0) - no indicator
	GOLFHandicapLookupStatusSuccess,		//	Lookup succeeded - green indicator
	GOLFHandicapLookupStatusFailure,		//	Lookup failed - red indicator
	GOLFHandicapLookupStatusWarning,		//	Lookup succeeded or caution - yellow indicator
	GOLFHandicapLookupStatusUnknown = 999	//	Unknown status - gray indicator
};

typedef NS_ENUM(NSUInteger, GOLFHandicapLookupGoal) {
	GOLFHandicapLookupGoalQueryOnly = 0,	//	Lookup only - no data updates
	GOLFHandicapLookupGoalHandicapRecords,	//	Successful lookup creates GOLFHandicapRecord
	GOLFHandicapLookupGoalIndexOverrides,	//	Successful lookup sets Scorecard or Event index override
	GOLFHandicapLookupGoalUnknown = 999		//	Unknown goal
};

//	GOLFLink
extern NSString * const GOLFLinkLoggedInGAUserCookieValue;
extern NSString * const GOLFLink_gaCookieValue;
extern NSString * const GOLFLink_gidCookieValue;

//	Lookup functions…

GOLFHandicapLookupService GOLFHandicapServiceForAuthority(GOLFHandicapAuthority *authority);
//	Returns handicapping service appropriate for the specified authority (GOLFHandicapLookupServiceGHIN for example)

NSString * _Nonnull GOLFHandicapLookupServiceTitle(GOLFHandicapLookupService lookupService);
//	Returns a localized title for the specified handicap data service ("GHIN", "GOLFLink", "Network de Golf", etc.)

//=================================================================
//	Utilities:
//
//	NSStringFromGOLFHandicapLookupStatus(status)
//
//=================================================================
NSString * NSStringFromGOLFHandicapLookupStatus(GOLFHandicapLookupStatus status);

//	Misc constants
#define GOLFHandicapLookupProgressNotification @"GOLFHandicapLookupProgress"	//	for Notification
#define GOLFHandicapLookupDidCompleteNotification @"GOLFHandicapLookupDidComplete"	//	for Notification
#define GOLFHandicapLookupDidFailNotification @"GOLFHandicapLookupDidFail"			//	for Notification

extern NSString * const GOLFHandicapLookupServiceErrorDomain;	//	The error domain name

typedef NS_ENUM(NSInteger, GOLFHandicapLookupServiceErrorDomainError) {
	GOLFHandicapLookupServiceDataError				= 17000,	// generic error
	GOLFHandicapLookupServiceNotAvailableError		= 17005,	// the flag GOLFHandicapLookupServiceIsAvailable (above?) is NOT set
	GOLFHandicapLookupServiceMultipleErrorsError	= 17010,	// generic message for error containing multiple validation errors
	GOLFHandicapLookupServiceTokenPostError			= 17150,	// something wrong with TokenPost access token retrieval
	GOLFHandicapLookupServiceGetHandicapError		= 17160,	// something wrong with GetHandicap retrieval
	GOLFHandicapLookupServiceGetCountryCodesError	= 17170,	// something wrong with GetCountryCodes retrieval
	GOLFHandicapLookupServiceGetStateCodesError		= 17180,	// something wrong with GetStateCodes retrieval
	GOLFHandicapLookupServiceSearchCoursesError		= 17190,	// something wrong with SearchCourses retrieval
	GOLFHandicapLookupServiceGetCourseDetailsError	= 17195,	// something wrong with GetCourseDetails retrieval
};

//	Forward declarations
@class GOLFHandicapLookupAgent;

@protocol GOLFHandicapLookupAgentDelegate <NSObject>

//	Returns an NSDictionary with information about the GOLFHandicapLookupService to be used for a query
//	May return nil if there is no service or the service is disabled
//
//	Key						Type			Description
//	------------------	----------	---------------------------------
//	serviceName			NSString *		Complete name of the handicapping service
//	lookupService		NSNumber *		A GOLFHandicapLookupService identifying the service
//	appName				NSString *		From the delegate's [NSBundle mainBundle] - the app(lication) name
//	appVersion			NSString *		From the delegate's [NSBundle mainBundle] - the app(lication) version number
//	build				NSString *		From the delegate's [NSBundle mainBundle] - the app(lication) build number

- (NSDictionary * _Nullable)GOLFHandicapLookupServiceInfo;

@optional

//	Allows the GOLFHandicapLookupAgent to report its progress with a localized
//	NSString indicating its status.  There is no return from the delegate
- (void)GOLFHandicapLookupAgent:(GOLFHandicapLookupAgent *)lookupAgent reportingProgress:(NSString *)progressNotice;

@end


@interface GOLFHandicapLookupAgent : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, weak, nullable) id <GOLFHandicapLookupAgentDelegate> delegate;

@property (nonatomic, weak, nullable) NSURLSession *handicapLookupSession;
@property (nonatomic, weak, nullable) NSURLSessionTask *getHandicapTask;
@property (nonatomic, strong, nullable) NSMutableData *getHandicapData;
@property (nonatomic, strong, nullable) NSString * getHandicapResponseString;
@property (nonatomic, strong, nullable) NSDate * getHandicapTaskStart;

@property (nonatomic, strong) NSString * _Nullable userAgent;
@property (nonatomic, strong) NSString * _Nullable webKitVersionString;
@property (nonatomic, strong) NSDictionary * _Nullable serviceInfo;	//	Setup data from the delegate

//	Lookup Handicap
@property (nonatomic, weak, nullable) NSDictionary *queryInfo;

@property (nonatomic, assign) GOLFHandicapLookupService lookupService;
@property (nonatomic, copy, nullable) void (^GetHandicapTaskCompletionHandler)(NSDictionary * _Nullable queryResponse, NSError * _Nullable error);

@property (nonatomic, nullable, strong) NSString *progressNotice;
@property (nonatomic, assign) BOOL canReportProgressToDelegate;
@property (nonatomic, assign) BOOL sendProgressNotifications;	//	Always sent on main thread
@property (nonatomic, assign) BOOL needCancel;

+ (GOLFHandicapLookupAgent *)agentForDelegate:(id<GOLFHandicapLookupAgentDelegate>)delegate;
- (GOLFHandicapLookupAgent *)initWithDelegate:(id<GOLFHandicapLookupAgentDelegate>)delegate;

- (void)invalidateAndClose;
- (void)endLookupSession;

- (void)GetHandicapWithQueryInfo:(NSDictionary *)queryInfo completionHandler:(void (^)(NSDictionary * _Nullable queryResponse, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
