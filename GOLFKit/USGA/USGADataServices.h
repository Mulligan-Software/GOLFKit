//
//  USGADataServices.h
//  GOLFKit
//
//  Created by John Bishop on 12/18/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GOLFKit/GOLFKit.h>

//	Misc constants
#define USGADataServicesIsAvailable 0	//	for testing
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

extern NSString * _Nonnull const GOLFKitForUSGADataServicesErrorDomain;	//	The error domain name

typedef NS_ENUM(NSInteger, GOLFKitForUSGADataServicesErrorDomainError) {
	GOLFKitForUSGADataServicesDataError					= 10000,	// generic error
	GOLFKitForUSGADataServicesNotAvailableError			= 10005,	// the flag USGADataServicesIsAvailable (above) is NOT set
	GOLFKitForUSGADataServicesMultipleErrorsError		= 10010,	// generic message for error containing multiple validation errors
	GOLFKitForUSGADataServicesTokenPostError			= 10150,	// something wrong with TokenPost access token retrieval
	GOLFKitForUSGADataServicesGetGolferError			= 10160,	// something wrong with GetGolfer retrieval
	GOLFKitForUSGADataServicesGetCountryCodesError		= 10170,	// something wrong with GetCountryCodes retrieval
	GOLFKitForUSGADataServicesGetStateCodesError		= 10180,	// something wrong with GetStateCodes retrieval
	GOLFKitForUSGADataServicesSearchCoursesError		= 10190,	// something wrong with SearchCourses retrieval
	GOLFKitForUSGADataServicesGetCourseDetailsError		= 10195,	// something wrong with GetCourseDetails retrieval
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
- (NSDictionary * _Nullable)USGADataServicesAppInfo;

@end


@interface USGADataServicesAgent : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong, nullable) NSString *USGADataServicesProductAppName;
@property (nonatomic, strong, nullable) NSString *USGADataServicesProductAppKey;
@property (nonatomic, strong, nullable) NSString *USGADataServicesProductAppSecret;

@property (nullable, retain) id <USGADataServicesAgentDelegate> delegate;
@property (nonatomic, strong, nullable) NSURLSession *USGAQuerySession;
@property (nonatomic, strong) NSString * _Nullable userAgent;

//	TokenPost
@property (nonatomic, strong, nullable) NSString *accessToken;
@property (nonatomic, strong, nullable) NSDate *accessTokenExpiresAt;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGATokenPostTask;
@property (nonatomic, strong, nullable) NSMutableData *USGATokenPostData;
@property (nonatomic, copy, nullable) void (^USGATokenPostTaskCompletionHandler)(NSString * _Nullable accessToken, NSDate * _Nullable expiresAt, NSError * _Nullable error);

//	GetGolfer
@property (nonatomic, weak, nullable) id golfer;
@property (nonatomic, weak, nullable) NSString *ghinNumber;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGAGetGolferTask;
@property (nonatomic, strong, nullable) NSMutableData *USGAGetGolferData;
@property (nonatomic, copy, nullable) void (^USGAGetGolferTaskCompletionHandler)(id _Nullable golferInfo, NSError * _Nullable error);

//	GetCountryCodes
@property (nonatomic, strong, nullable) NSURLSessionTask *USGAGetCountryCodesTask;
@property (nonatomic, strong, nullable) NSMutableData *USGAGetCountryCodesData;
@property (nonatomic, copy, nullable) void (^USGAGetCountryCodesTaskCompletionHandler)(NSDictionary * _Nullable countryCodes, NSError * _Nullable error);

//	GetStateCodes
@property (nonatomic, strong, nullable) NSURLSessionTask *USGAGetStateCodesTask;
@property (nonatomic, strong, nullable) NSMutableData *USGAGetStateCodesData;
@property (nonatomic, copy, nullable) void (^USGAGetStateCodesTaskCompletionHandler)(NSDictionary * _Nullable stateCodes, NSError * _Nullable error);

//	SearchCourses
@property (nonatomic, weak, nullable) NSString *courseName;
@property (nonatomic, weak, nullable) NSString *countryCode;
@property (nonatomic, weak, nullable) NSString *stateCode;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGASearchCoursesTask;
@property (nonatomic, strong, nullable) NSMutableData *USGASearchCoursesData;
@property (nonatomic, copy, nullable) void (^USGASearchCoursesTaskCompletionHandler)(NSArray * _Nullable foundCourses, NSError * _Nullable error);

//	GetCourseDetails
@property (nonatomic, assign) NSUInteger courseID;

@property (nonatomic, strong, nullable) NSURLSessionTask *USGAGetCourseDetailsTask;
@property (nonatomic, strong, nullable) NSMutableData *USGAGetCourseDetailsData;
@property (nonatomic, copy, nullable) void (^USGAGetCourseDetailsTaskCompletionHandler)(NSDictionary * _Nullable detailsDict, NSError * _Nullable error);

@property (nullable, strong) NSString *progressString;
@property (nullable, strong) NSTimer *startupTimer;

@property (nonatomic, assign) BOOL needCancel;

+ (USGADataServicesAgent * _Nonnull)agentForDelegate:(id<USGADataServicesAgentDelegate> _Nonnull)delegate appInfo:(NSDictionary * _Nullable)appInfo;

- (USGADataServicesAgent * _Nonnull)initWithDelegate:(id<USGADataServicesAgentDelegate> _Nonnull)delegate appInfo:(NSDictionary * _Nullable)appInfo;
- (void)invalidateAndClose;

- (void)requestAccessTokenWithTimer:(NSTimer * _Nonnull)timer;

//	Call:
//		[(USGADataServicesAgent *)agent TokenPostWithCompletionHandler:^(NSString *accessToken, NSDate *expiresAt, NSError *error) {
//			parameters:		none
//			accessToken:	nil or NSString expiring access token delivered in data requests
//			expiresAt:		nil or future NSDate representing the expiration or invalidation of the access token
//			error:			nil or POSIX/USGA/GOLFKit error domain NSError resulting from TokenPost request
//		}];
//
- (void)TokenPostWithCompletionHandler:(void (^ _Nonnull)(NSString * _Nullable accessToken, NSDate * _Nullable expiresAt, NSError * _Nullable error))completionHandler;

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
- (void)GetGolfer:(id _Nullable)golfer withID:(NSString * _Nonnull)GHINString completionHandler:(void (^ _Nonnull)(id _Nullable golferInfo, NSError * _Nullable error))completionHandler;

//	Call:
//		[(USGADataServicesAgent *)agent GetCountryCodesWithCompletionHandler:^(NSDictionary *countryCodes, NSError *error) {
//			parameters:		none
//			countryCodes:	nil or NSDictionary containing valid country coded (as keys) NSDictionarys (ie: "240" = U.S.A.)
//								key				type		description
//								--------------	----------	----------------------------------------
//								Description		NSString *	Full country name (ie: United States of America)
//								ISOCountryCode	NSString *	ISO-standard alphabetic country identifier (ie: "USA")
//								StringValue		NSString *	String-equivalent country identifier (ie: "USA")
//			error:			nil or POSIX/USGA/GOLFKit error domain NSError resulting from GetCountryCodes request
//		}];
//
//	{
//		"14": {
//			"ISOCountryCode": "AUS",
//			"Description": "Australia",
//			"StringValue": "AUS"
//		},
//		...
//		"68": {
//			"ISOCountryCode": "GBR",
//			"Description": "England (UK)",
//			"StringValue": "ENG"
//		},
//		...
//		"240": {
//			"ISOCountryCode": "USA",
//			"Description": "United States of America",
//			"StringValue": "USA"
//		},
//		...
//	}
//
- (void)GetCountryCodesWithCompletionHandler:(void (^ _Nonnull)(NSDictionary * _Nullable countryCodes, NSError * _Nullable error))completionHandler;

//	Call:
//		[(USGADataServicesAgent *)agent GetStateCodesWithCompletionHandler:^(NSDictionary *stateCodes, NSError *error) {
//			parameters:		none
//			stateCodes:		nil or NSDictionary containing valid country coded (as keys) NSDictionarys (ie: "240" = Texas)
//								key				type		description
//								--------------	----------	----------------------------------------
//								Description		NSString *	Full country name (ie: United States of America)
//								ISOCountryCode	NSString *	ISO-standard alphabetic country identifier (ie: "USA")
//								StringValue		NSString *	String-equivalent country identifier (ie: "USA")
//			error:			nil or POSIX/USGA/GOLFKit error domain NSError resulting from GetCountryCodes request
//		}];
//
//	{
//		"200001": {
//			"CountryCode": "240",
//			"ISOStateCode": "US-AL",
//			"Description": "Alabama",
//			"StringValue": "US_AL"
//		},
//		"200002": {
//			"CountryCode": "240",
//			"ISOStateCode": "US-AK",
//			"Description": "Alaska",
//			"StringValue": "US_AK"
//		},
//		...
//		"200044": {
//			"CountryCode": "240",
//			"ISOStateCode": "US-TX",
//			"Description": "Texas",
//			"StringValue": "US_TX"
//		},
//		...
//		"200077": {
//			"CountryCode": "14",
//			"ISOStateCode": "",
//			"Description": "Jervis Bay Territory",
//			"StringValue": "AU_JB"
//		},
//		"200078": {
//			"CountryCode": "14",
//			"ISOStateCode": "AU-NSW",
//			"Description": "New South Wales",
//			"StringValue": "AU_NS"
// 		 },
// 		 ...
//		"200099": {
//			 "CountryCode": "32",
//			"ISOStateCode": "BR-AP",
//			"Description": "Amazonas",
//			"StringValue": "BR_AM"
//		},
//		...
//		"200238": {
//			"CountryCode": "68",
//			"ISOStateCode": "GB-DBY",
//			"Description": "Derbyshire",
//			"StringValue": "EN_DB"
//  		},
//  		...
//		"204158": {
//			"CountryCode": "159",
//			"ISOStateCode": "NL-SX",
//			"Description": "Sint Maarten",
//			"StringValue": "NL_SX"
//		},
//		...
//		"204164": {
//			"CountryCode": "240",
//			"ISOStateCode": "US-VI",
//			"Description": "Virgin Islands, U.S.",
//			"StringValue": "US_VI"
//		}
//	}
//
- (void)GetStateCodesWithCompletionHandler:(void (^ _Nonnull)(NSDictionary * _Nullable stateCodes, NSError * _Nullable error))completionHandler;

//	Call:
//		[(USGADataServicesAgent *)agent SearchCourses:courseName country:country state:state completionHandler:^(NSArray *foundCourses, NSError *error) {
//			parameters:		courseName - name (or partial name) of the course we're searching for
//							country - a USGA Data Services country code - 'USA' by default
//							state - a USGA Data Services state code (like US_TX) or a US Postal code that will be formatted
//			foundCourses:	nil or NSArray of returned course data (NSDictionary) matching search requirements
//			error:			nil or POSIX/USGA/GOLFKit error domain NSError resulting from SearchCourses request
//		}];
//
//	[
//		{
//			"CourseID": 11057,
//			"CourseName": "Grande Oaks Golf Club",
//			"FacilityID": 10176,
//			"FacilityName": "Grande Oaks Golf Club",
//			"FullName": "Grande Oaks Golf Club",
//			"City": "Fort Lauderdale",
//			"State": "US-FL",
//			"Country": "USA",
//			"EntCountryCode": 240,
//			"EntStateCode": 200010,
//			"LegacyCRPCourseId": 27292
//		},
//		{
//			"CourseID": 23816,
//			"CourseName": "Grande Oaks Golf Club",
//			"FacilityID": 21104,
//			"FacilityName": "Grande Oaks Golf Club",
//			"FullName": "Grande Oaks Golf Club",
//			"City": "Davie",
//			"State": "US-FL",
//			"Country": "USA",
//			"EntCountryCode": 240,
//			"EntStateCode": 200010,
//			"LegacyCRPCourseId": 45138
//		}
//	]
//
- (void)SearchCourses:(NSString * _Nonnull)courseName country:(NSString * _Nonnull)country state:(NSString * _Nonnull)state completionHandler:(void (^ _Nonnull)(NSArray * _Nullable foundCourses, NSError * _Nullable error))completionHandler;

//	Call:
//		[(USGADataServicesAgent *)agent GetCourseDetails:courseID completionHandler:^(NSDictionary *courseDetails, NSError *error) {
//			parameter:		courseID - NSUInteger course identifier within USGA Data Services database ("CourseID" from SearchCourses)
//			courseDetails:	nil or NSDictionary of returned course data, including ratings, hole info, etc.
//			error:			nil or POSIX/USGA/GOLFKit error domain NSError resulting from GetCourseDetails request
//		}];
//
//	{
//	  "CourseStatus": "Active",
//	  "Facility": {
//		"FacilityId": 4131,
//		"FacilityName": "Eagle's Bluff Country Club",
//		"FacilityNumber": "57037"
//	  },
//	  "Season": {
//		"SeasonName": "Year Round",
//		"SeasonStartDate": "12/15",
//		"SeasonEndDate": "12/14",
//		"IsAllYear": true
//	  },
//	  "TeeSets": [
//		{
//		  "Ratings": [
//			{
//			  "RatingType": "Total",
//			  "CourseRating": 71.7,
//			  "SlopeRating": 136,
//			  "BogeyRating": 96.9
//			},
//			{
//			  "RatingType": "Front",
//			  "CourseRating": 36.1,
//			  "SlopeRating": 139,
//			  "BogeyRating": 49
//			},
//			{
//			  "RatingType": "Back",
//			  "CourseRating": 35.6,
//			  "SlopeRating": 132,
//			  "BogeyRating": 47.9
//			}
//		  ],
//		  "Holes": [
//			{
//			  "Number": 1,
//			  "HoleId": 429743,
//			  "Length": 494,
//			  "Par": 5
//			},
//				...
//			{
//			  "Number": 18,
//			  "HoleId": 429777,
//			  "Length": 405,
//			  "Par": 4
//			}
//		  ],
//		  "TeeSetRatingId": 283919,
//		  "TeeSetRatingName": "Blue",
//		  "Gender": "Male",
//		  "HolesNumber": 18,
//		  "TotalYardage": 6336
//		}
//	  ],
//	  "CourseId": 4422,
//	  "CourseName": "Eagle's Bluff Country Club",
//	  "CourseCity": "Bullard",
//	  "CourseState": "US-TX"
//	}
//
- (void)GetCourseDetails:(NSUInteger)courseID completionHandler:(void (^ _Nonnull)(NSDictionary * _Nullable courseDetails, NSError * _Nullable error))completionHandler;


//- (void)GetHandicapProfileforGolfer:(NSString *)GolferId completionHandler:(void (^)(NSDictionary *profileDictionary, NSError *error))completionHandler;
//- (void)GetScoresCurrentRevisionByGolfer:(NSString *)GolferId forClub:(NSString *)ClubId completionHandler:(void (^)(NSArray *scoresArray, NSError *error))completionHandler;

@end
