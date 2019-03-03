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
@property (nonatomic, copy) void (^USGAGetGolferTaskCompletionHandler)(id golferInfo, NSError *error);

@property (nullable, strong) NSString *progressString;
@property (nullable, strong) NSTimer *startupTimer;

@property (nonatomic, assign) BOOL needCancel;

+ (USGADataServicesAgent *)agentForDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo;

- (USGADataServicesAgent *)initWithDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo;
- (void)invalidateAndClose;

- (void)requestAccessTokenWithTimer:(NSTimer *)timer;

//	Call:
//		[(USGADataServicesAgent *)agent TokenPostWithCompletionHandler:^(NSString *accessToken, NSDate *expiresAt, NSError *error) {
//			parameters:		none
//			accessToken:	nil or NSString expiring access token delivered in data requests
//			expiresAt:		nil or future NSDate representing the expiration or invalidation of the access token
//			error:			nil or POSIX/USGA/GOLFKit error domain NSError resulting from TokenPost request
//		}];
//
- (void)TokenPostWithCompletionHandler:(void (^)(NSString *accessToken, NSDate *expiresAt, NSError *error))completionHandler;

//	Call:
//		[(USGADataServicesAgent *)agent GetGolfer:golfer withID:GHINString completionHandler:^(id golferInfo, NSError *error) {
//			parameters:	(id)golfer - optional local object representing the golfer of interest
//						(NSString *)GHINString - required unique GHIN or handicapping identifier for the golfer
//			golferInfo:	nil or NSDictionary equivalent of returned JSON request data (Top keys "Golfer", "HandicapProfile", "LowestHiValues")
//			error:		nil or POSIX/USGA/GOLFKit error domain NSError resulting from GetGolfer request
//		}];
//
//	GolferInfo	[
//		"Golfer" = [
//			"AccountSource" = Portal
//			"ActiveClubMemberships" = 1
//			"Admin" = 0
//			"Age" = 0
//			"BasicName" = "Judge Smails"
//			"BasicName_LN" = "Smails , Judge"
//			"ClubAffiliations" = {
//				[
//					"AccountId" = 001m000000oMsEMAA0
//					"ActiveStatus" = 0
//					"AssociationId" = 1000080
//					"AssociationName" = 001m000000oMsEC
//					"ClubId" = 1000130
//					"ClubName" = "Bushwood Country Club"
//					"ClubTimezoneOffset" = "-05:00"
//					"ClubType" = "Type 1"
//					"ContactId" = 003m0000016sqBUAAY
//					"ContactName" = "Judge Smails"
//					"CountryCode" = USA
//					"CountryText" = "United States"
//					"EndDate" = "2019-12-19T00:00:00Z"
//					"ENewsLetterFlag" = 1
//					"FirstName" = "Judge"
//					"Gender" = Male
//					"GolferEmail" = "support@mulligansoftware.com"
//					"GolferId" = 3000000314
//					"GHINNumber" = 3000000314
//					"HcsUpdated" = "0001-01-01T00:00:00Z"
//					"Id" = a0Hm000000GZ85UEAT
//					"IsDeleted" = 0
//					"LastName" = "Smails"
//					"MembershipType" = [
//						"AssocOrClubId" = 001m000000oMsEMAA0
//						"BillRate" = 1
//						"MembershipCode" = Q
//						"MembershipTypeDescription" = "Test Data Membership"
//						"OriginatorID" = ""
//						"ParentId" = 001m000000oMsEMAA0
//						"ParentType" = Club
//						"RecordTypeID" = 01241000001INDwAAO
//						"SystemId" = "USGA Data Services"
//						"USGAMembershipType" = Standard
//					]
//					"MembershipTypeId" = a0sm0000001o01iAAA
//					"Name" = "AF-7515149"
//					"OriginatorID" = ""
//					"ParentId" = 003m0000016sqBUAAY
//					"ParentType" = Golfer
//					"PlayerHandicapIndexType" = "18H and 9H Handicap Index"
//					"RecordTypeId" = 01241000001INDyAAO
//					"RelationshipStatus" = Active
//					"RevisionSchedule" = "1,15"
//					"StartDate" = "2018-12-20T00:00:00Z"
//					"StateText" = "New Jersey"
//					"StatusDate" = "2018-12-20T00:00:00Z"
//					"SystemId" = "USGA Data Services"
//				]
//			}	("ClubAffiliations")
//			"CreatedDate" = "2018-12-20T16:15:48Z"
//			"Deceased" = 0
//			"Email" = "fredthebishop@mulligansoftware.com"
//			"ExternalID" = "Judge Elihu Smails"
//			"FirstName" = "Judge"
//			"FullName" = "Judge Smails"
//			"FullName_LN" = "Smails , Judge"
//			"Gender" = Male
//			"GhinID" = 3000000314
//			"GhinNumber" = 3000000314
//			"GolferId" = 3000000314
//			"HandicapIndexType" = "18H and 9H Handicap Index"
//			"HandicapIndexTypeInt" = (9,18)
//			"Id" = 003m0000016sqBUAAY
//			"InactiveClubMemberships" = 0
//			"IsGolfer" = 1
//			"IsGuardian" = 0
//			"isMinorTurned13" = 0
//			"LastModifiedDate" = "2018-12-20T16:15:51Z"
//			"LastName" = "Smails"
//			"OriginatorID" = ""
//			"PrimaryEmail" = "fredthebishop@mulligansoftware.com"
//			"PublicName" = "Judge Smails"
//			"PublicName_LN" = "Smails , Judge"
//			"RecordTypeID" = 01241000001INDtAAO
//			"StandardName" = "Judge Smails"
//			"StandardName_LN" = "Smails , Judge"
//			"SystemId" = "USGA Data Services"
//			"TitleName" = "Judge Smails"
//			"UseSecondaryEmail" = 0
//			"UsgaID" = 8523762904510050479
//		]	("Golfer")
//		"HandicapProfile" = [
//			"ClubAffiliations" = {
//				[
//					"AR" = 0
//					"ClubId" = 1000130
//					"ClubAffiliationID" = "5b09db84-7204-e911-a947-000d3a0e37af"
//					"CurrentRevisions" = {
//						[
//							"ClubId" = 1000130
//							"CurrentHandicapValue" = "7.6N"
//							"DateOfRevision" = "2019-03-01T05:00:00Z"
//							"Flags" = None
//							"Id" = "c409db84-7204-e911-a947-000d3a0e37af"
//							"TrendId" = "00000000-0000-0000-0000-000000000000"
//							"TrendUsed" = [
//								"Value" = [
//									"DateOfChange" = "2018-12-20T00:00:00Z"
//									"TotalDiff" = "47.5"
//									"Value" = "7.6"
//								]
//								"Gender" = M
//								"GolferIdentifier" = 3000000314
//								"Holes" = 9
//								"EligibleTscoresCount" = 0
//								"Suffix" = NL
//								"TrendId" = "5d09db84-7204-e911-a947-000d3a0e37af"
//							]
//							"Value" = "7.6"
//						]
//						[
//							"ClubId" = 1000130
//							"CurrentHandicapValue" = "16.8"
//							"DateOfRevision" = "2019-03-01T05:00:00Z"
//							"Flags" = None
//							"Id" = "c409db84-7204-e911-a947-000d3a0e37af"
//							"TrendId" = "00000000-0000-0000-0000-000000000000"
//							"TrendUsed" = [
//								"EligibleTscoresCount" = 0
//								"Gender" = M
//								"GolferIdentifier" = 3000000314
//								"Holes" = 18
//								"Suffix" = L
//								"TrendId" = "5e09db84-7204-e911-a947-000d3a0e37af"
//								"Value" = [
//									"DateOfChange" = "2018-12-20T00:00:00Z"
//									"TotalDiff" = "35.2"
//									"Value" = "16.8"
//								]
//							]
//							"Value = "16.8";
//						]
//					}	("CurrentRevisions")
//					"NH" = 0
//					"Override" = 0
//					"RevisionSchedule" = (1, 15)
//					"TimeZone" = "-300"
//					"Withdrawal" = 0
//				]
//			}	("ClubAffiliations")
//			"Gender" = M
//			"GlobalTrends" = {
//				[
//					"EligibleTscoresCount" = 0
//					"Gender" = M
//					"Holes" = 9
//					"Suffix" = NL
//					"TrendId" = "5d09db84-7204-e911-a947-000d3a0e37af"
//					"Value" = [
//						"CalculatedTotalDiff" = "79.2"
//						"DateOfChange" = "2018-12-20T00:00:00Z"
//						"TotalDiff" = "47.5"
//						"Value" = "7.6"
//					]
//				]
//			}	("GlobalTrends")
//			"HandicapIndexType" = (9, 18)
//			"PlayerId" = 3000000314
//			"Status" = Active
//			"TestFlag" = 0
//		]	("HandicapProfile")
//		"LowestHiValues" = [
//			"18" = [
//				"LowHI" = "16.8"
//				"RevisionDate" = "2019-03-01T05:00:00Z"
//				"TotalDiff" = "35.2"
//			]
//			"9" = [
//				"LowHI" = "7.6N"
//				"RevisionDate" = "2019-03-01T05:00:00Z"
//				"TotalDiff" = "47.5"
//			]
//		]	("LowestHiValues")
//	]	(GolferInfo)
//
- (void)GetGolfer:(id)golfer withID:(NSString *)GHINString completionHandler:(void (^)(id golferInfo, NSError *error))completionHandler;

//- (void)GetHandicapProfileforGolfer:(NSString *)GolferId completionHandler:(void (^)(NSDictionary *profileDictionary, NSError *error))completionHandler;
//- (void)GetScoresCurrentRevisionByGolfer:(NSString *)GolferId forClub:(NSString *)ClubId completionHandler:(void (^)(NSArray *scoresArray, NSError *error))completionHandler;

@end
