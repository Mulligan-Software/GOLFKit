//
//  GOLFHandicapLookup.h
//  GOLFKit
//
//  Created by John Bishop on 7/7/21.
//  Copyright © 2021 Mulligan Software. All rights reserved.
//

@import Foundation;
#import <GOLFKit/GOLFKit.h>

typedef NS_ENUM(NSUInteger, GOLFHandicapLookupService) {
	GOLFHandicapLookupServiceGHIN = 0,		//	Golf Handicap Information Network (GHIN)	(0)
	GOLFHandicapLookupServiceGOLFLink,		//	GOLFLink Australia							(1)
	GOLFHandicapLookupServiceGolfNetwork,	//	GOLF Network Canada							(2)
	GOLFHandicapLookupServiceUnknown = 99	//	Unknown handicap lookup technique
};

//	GOLFLink
extern NSString * _Nonnull const GOLFLinkLoggedInGAUserCookieValue;
extern NSString * _Nonnull const GOLFLink_gaCookieValue;
extern NSString * _Nonnull const GOLFLink_gidCookieValue;

NSString * _Nonnull GOLFHandicapLookupServiceTitle(GOLFHandicapLookupService lookupService);
//	Returns a localized title for the specified handicap data service ("GHIN", "GOLFLink", "Network de Golf", etc.)


//	Misc constants
#define GOLFHandicapLookupDidCompleteNotification @"GOLFHandicapLookupDidComplete"	//	for Notification
#define GOLFHandicapLookupDidFailNotification @"GOLFHandicapLookupDidFail"			//	for Notification

extern NSString * _Nonnull const GOLFHandicapLookupServiceErrorDomain;	//	The error domain name

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


@protocol GOLFHandicapLookupAgentDelegate <NSObject>

@optional

//	Returns an NSDictionary with information about the GOLFHandicapLookupService to be used for a query
//	May return nil if there is no service or the service is disabled
//
//	Key						Type			Description
//	----------------------	--------------	---------------------------------
//	serviceName				NSString *		Complete name of the handicapping service
//	lookupService			NSNumber *		A GOLFHandicapLookupService identifying the service
- (NSDictionary * _Nullable)GOLFHandicapLookupServiceInfo;

@end


@interface GOLFHandicapLookupAgent : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nullable, retain) id <GOLFHandicapLookupAgentDelegate> delegate;
@property (nonatomic, strong, nullable) NSURLSession *handicapLookupSession;
@property (nonatomic, strong) NSString * _Nullable userAgent;

//	Lookup Handicap
@property (nonatomic, weak, nullable) NSDictionary *queryInfo;

@property (nonatomic, strong, nullable) NSURLSessionTask *getHandicapTask;
@property (nonatomic, strong, nullable) NSMutableData *getHandicapData;
@property (nonatomic, strong, nullable) NSString * getHandicapResponseString;
@property (nonatomic, strong, nullable) NSDate * getHandicapTaskStart;
@property (nonatomic, copy, nullable) void (^GetHandicapTaskCompletionHandler)(NSDictionary * _Nullable queryResponse, NSError * _Nullable error);

@property (nullable, strong) NSString *progressNotice;
@property (nullable, strong) NSTimer *startupTimer;
@property (nonatomic, assign) BOOL needCancel;

+ (GOLFHandicapLookupAgent * _Nonnull)agentForDelegate:(id<GOLFHandicapLookupAgentDelegate> _Nonnull)delegate;
- (GOLFHandicapLookupAgent * _Nonnull)initWithDelegate:(id<GOLFHandicapLookupAgentDelegate> _Nonnull)delegate;

- (void)invalidateAndClose;

- (void)GetHandicapWithQueryInfo:(NSDictionary *_Nonnull)queryInfo completionHandler:(void (^ _Nonnull)(NSDictionary * _Nullable queryResponse, NSError * _Nullable error))completionHandler;

@end
