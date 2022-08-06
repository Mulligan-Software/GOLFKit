//
//  GOLFHandicapLookup.m
//  GOLFKit
//
//  Created by John Bishop on 7/7/21.
//  Copyright © 2021 Mulligan Software. All rights reserved.
//

#import "GOLFUtilities.h"
#import "GOLFExtensions.h"
#import "GOLFHandicapLookup.h"
#import <WebKit/WKWebView.h>

//	Globals
NSString * const GOLFHandicapLookupServiceErrorDomain = @"com.mulligansoftware.GOLFHandicapLookupService.ErrorDomain";

//	GOLFLink (www.golf.org.au) constants for Lou Loomis login
NSString * const GOLFLinkLoggedInGAUserCookieValue = @"212251";
NSString * const GOLFLink_gaCookieValue = @"GA1.3.1660873617.1546283221";
NSString * const GOLFLink_gidCookieValue = @"GA1.3.1902797135.1547657519";


//=================================================================
//	GOLFHandicapServiceForAuthority(authority)
//=================================================================
GOLFHandicapLookupService GOLFHandicapServiceForAuthority(GOLFHandicapAuthority *authority) {
//	Returns the GOLFHandicapLookupService identifier of the calculation service for the specified authority
	if (authority) {
		if ([authority isEqualToString:GOLFHandicapAuthorityWHS] || [authority isEqualToString:GOLFHandicapAuthorityUSGA]) {
			return GOLFHandicapLookupServiceGHIN;
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityRCGA]) {
			return GOLFHandicapLookupServiceGolfNetwork;
		}
		else if ([authority isEqualToString:GOLFHandicapAuthorityAGU]) {
			return GOLFHandicapLookupServiceGOLFLink;
		}
	}
	return GOLFHandicapLookupServiceUnknown;
}

//=================================================================
//	GOLFHandicapLookupServiceTitle(lookupService)
//=================================================================
NSString * GOLFHandicapLookupServiceTitle(GOLFHandicapLookupService lookupService) {
	if (lookupService == GOLFHandicapLookupServiceGHIN) {
		return GOLFLocalizedString(@"TITLE_GHIN_ABBR");	//	"GHIN"
	} else if (lookupService == GOLFHandicapLookupServiceGOLFLink) {
		return GOLFLocalizedString(@"TITLE_GOLFLINK_ABBR");	//	"GOLFLink"
	} else if (lookupService == GOLFHandicapLookupServiceGolfNetwork) {
		return GOLFLocalizedString(@"TITLE_GOLF_NETWORK_ABBR");	//	"Golf Network"
	}
	//	Anything else
	return GOLFLocalizedString(@"TITLE_UNKNOWN_SERVICE");	//	???
}

@interface GOLFHandicapLookupAgent ()

- (NSURLSessionConfiguration *)lookupSessionConfiguration;

- (void)GetHandicap:(NSDictionary *)queryInfo;

@end


@implementation GOLFHandicapLookupAgent

+ (GOLFHandicapLookupAgent *)agentForDelegate:(id<GOLFHandicapLookupAgentDelegate>)delegate {
	GOLFHandicapLookupAgent *newAgent = (GOLFHandicapLookupAgent *)[[GOLFHandicapLookupAgent alloc] initWithDelegate:delegate];
	
	return newAgent;
}

- (GOLFHandicapLookupAgent *)initWithDelegate:(id<GOLFHandicapLookupAgentDelegate>)delegate {
    if (self = [super init]) {
    	self.delegate = delegate;
    	self.sendProgressNotifications = NO;
    	NSDictionary *info = nil;
    	if (delegate) {
			if ([delegate respondsToSelector:@selector(GOLFHandicapLookupServiceInfo)]) {
				info = [delegate GOLFHandicapLookupServiceInfo];
			}

			self.canReportProgressToDelegate = [delegate respondsToSelector:@selector(GOLFHandicapLookupAgent:reportingProgress:)];
    	}
    	self.serviceInfo = info;
	}
	return self;
}

- (void)dealloc {
}

- (void)setProgressNotice:(NSString *)progressNotice {
	_progressNotice = progressNotice;
	
	if (self.sendProgressNotifications) {
		dispatch_async(dispatch_get_main_queue(), ^{
			NSDictionary *info = (progressNotice ? [NSDictionary dictionaryWithObject:progressNotice forKey:@"notice"] : nil);
			[[NSNotificationCenter defaultCenter] postNotificationName:GOLFHandicapLookupProgressNotification object:self.delegate userInfo:info];
		});
	}
	
	if (progressNotice && self.canReportProgressToDelegate) {
		[self.delegate GOLFHandicapLookupAgent:self reportingProgress:progressNotice];
	}
}

- (void)setNeedCancel:(BOOL)wantCancel {
	if (_needCancel != wantCancel) {
		if (wantCancel && self.handicapLookupSession) {
			[self.handicapLookupSession invalidateAndCancel];
		}
		_needCancel = wantCancel;
	}
}

- (NSString *)userAgent {
	if (_userAgent == nil) {
		NSOperatingSystemVersion systemVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
		NSString *appName = ([self.serviceInfo objectForKey:@"appName"]
				?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]);	//	"Application Name"
		NSString *build = ([self.serviceInfo objectForKey:@"build"]
				?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);	//	build number
		NSString *appVersion = ([self.serviceInfo objectForKey:@"appVersion"]
				?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);	//	version number
		NSString *osVersionString = @"";
		if (systemVersion.patchVersion > 0) {
			osVersionString = [NSString stringWithFormat:@"_%ld", (long)systemVersion.patchVersion];
		}
		if (([osVersionString length] > 0) || (systemVersion.minorVersion > 0)) {
			osVersionString = [NSString stringWithFormat:@"_%ld%@", (long)systemVersion.minorVersion, osVersionString];
		}
		osVersionString = [NSString stringWithFormat:@"%ld%@", (long)systemVersion.majorVersion, osVersionString];

		NSString *appPart = [NSString stringWithFormat:@"%@/%@(%@)", [[appName componentsSeparatedByString:@" "] componentsJoinedByString:@""], appVersion, build];
		NSString *GOLFKitPart = [NSString stringWithFormat:@"GOLFKit/%@(%@)", GOLFKitBundleShortVersionString(), GOLFKitBundleVersion()];
		NSString *WebKitPart = [NSString stringWithFormat:@"AppleWebKit/%@ (KHTML, like Gecko)", [[[NSBundle bundleForClass:[WKWebView class]] infoDictionary] objectForKey:@"CFBundleVersion"]];
		NSString *MozillaPart = @"Mozilla/5.0 ";

#if TARGET_OS_IOS

		if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
			//	User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1
			_userAgent = [MozillaPart stringByAppendingFormat:@"(iPhone; CPU iPhone OS %@ like Mac OS X) %@ %@ %@", osVersionString, WebKitPart, GOLFKitPart, appPart];
		} else {
			//	User-Agent: Mozilla/5.0 (iPad; CPU OS 12_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Mobile/15E148 Safari/604.1
			_userAgent = [MozillaPart stringByAppendingFormat:@"(iPad; CPU OS %@ like Mac OS X) %@ %@ %@", osVersionString, WebKitPart, GOLFKitPart, appPart];
		}
		
#endif

#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)

		//	User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15
		if (@available (macOS 10.14, *)) {
			_userAgent = [MozillaPart stringByAppendingFormat:@"(Macintosh; Intel Mac OS X %@) %@ %@ %@", osVersionString, WebKitPart, GOLFKitPart, appPart];
		} else {
			//	User-Agent: Mozilla/5.0 (Macintosh; U; Mac OS X 10_13_2; en-us) Eagle/2.9.9
			_userAgent = [MozillaPart stringByAppendingFormat:@"(Macintosh; U; Mac OS X %@; en-us) Eagle/%@", osVersionString, appVersion];
		}
	
#endif
	}
	return _userAgent;
}

- (NSURLSessionConfiguration *)lookupSessionConfiguration {
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	
	if (@available (macOS 10.13, iOS 11.0, *)) {
		configuration.waitsForConnectivity = YES;
	}
	configuration.networkServiceType = NSURLNetworkServiceTypeDefault;
	configuration.timeoutIntervalForRequest = 10.0;	//	10 second timeouts
	configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;	//	Accept cookies using default service
	configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;	//	Don't cache incoming data - reload it

	return configuration;
}

- (NSURLSession *)handicapLookupSession {
	if (_handicapLookupSession == nil) {
		_handicapLookupSession = [NSURLSession sessionWithConfiguration:self.lookupSessionConfiguration delegate:self delegateQueue:nil];
		//	Important - The session object keeps a strong reference to the delegate until your app exits or explicitly invalidates the session. If you do not invalidate the session by calling the invalidateAndCancel or finishTasksAndInvalidate method, your app leaks memory until it exits.
	}
	return _handicapLookupSession;
}

- (NSMutableData *)getHandicapData {
	if (_getHandicapData == nil) {
		_getHandicapData = [[NSMutableData alloc] init];	//	Retained
	}
	return _getHandicapData;
}

- (void)invalidateAndClose {
	if (self.handicapLookupSession != nil) {
		[self.handicapLookupSession finishTasksAndInvalidate];
	}
}

- (void)endLookupSession {
	if (self.handicapLookupSession) {
		[self.handicapLookupSession invalidateAndCancel];
	}
}

- (void)GetHandicapWithQueryInfo:(NSDictionary *)queryInfo completionHandler:(void (^)(NSDictionary *queryResponse, NSError *error))completionHandler {
	//	Data to perform a lookup query is contained in a queryInfo NSDictionary
	//	which is returned in queryResponse at completion (with additions) that may contain…
	//
	//	Key					Type						Description
	//	------------------	--------------------------	-------------------------------------------------
	//	alphabeticName		NSString *					The player's name alphabetically ("Czervick, Al")
	//	canLookup			NSNumber *					BOOL - whether pre-query data appears OK
	//	competitorName		NSString *					The player's name ("Al Czervik")
	//	done				NSNumber *					BOOL - set when query completes (any status)
	//	effectiveDate		NSDate *					The effective date for the on-file Handicap Index
	//	firstName			NSString *					The player's first (given) name
	//	gHIN				NSString *					The player's GHIN service account number - required
	//	goal				NSNumber *					GOLFHandicapLookupGoal - intent of query
	//	guest				NSNumber *					BOOL - set if the player is a "guest"
	//	handicapAuthority	GOLFHandicapAuthority *		The player's handicap authority ("WHS")
	//	handicapIndex		NSString *					The player's on-file Handicap Index, formatted
	//	is9HoleIndex		NSNumber *					BOOL - set if numericIndex is for 9 holes
	//	itemIndex			NSNumber *					For bulk lookup, an index for the competitor
	//	lastName			NSString *					The player's last name (surname) - required
	//	limited				NSNumber *					BOOL - whether handicapIndex is a limited value
	//	lookupService		NSNumber *					GOLFHandicapLookupService - identifying the service
	//	memberships			NSArray*					The player's team GOLFMembership(s) from Scorecard or Event
	//	notes				NSString *					Status, comments, progress, etc.
	//	numericIndex		NSNumber *					GOLFHandicapIndex - the player's on-file Handicap Index
	//	overridden			NSNumber *					BOOL - whether handicapIndex is an override
	//	player				GOLFCompetitor *			The player whose handicap is being looked up
	//	round				GOLFRound *					The player's round from a Scorecard or Event
	//	shouldLookup		NSNumber *					BOOL - whether player is approved for query
	//	status				NSNumber *					GOLFHandicapLookupStatus - status of query
	
	self.GetHandicapTaskCompletionHandler = completionHandler;
	if (self.getHandicapTask == nil) {
		self.queryInfo = queryInfo;
		self.lookupService = ([queryInfo objectForKey:@"lookupService"]
				? [[queryInfo objectForKey:@"lookupService"] unsignedIntegerValue]
				: GOLFHandicapLookupServiceGHIN);
		[self GetHandicap:queryInfo];
	}
}

- (void)GetHandicap:(NSDictionary *)queryInfo {
	if (self.getHandicapTask == nil) {
		NSString *canonicalGHINNumber = [queryInfo objectForKey:@"gHIN"];
		while ([[canonicalGHINNumber substringToIndex:1] isEqualToString:@"0"]) {
			canonicalGHINNumber = [canonicalGHINNumber substringFromIndex:1];
		}
		NSURLComponents *components = [NSURLComponents componentsWithString:@"https://api2.ghin.com/api/v1/public/login.json"];
		components.queryItems = [NSArray arrayWithObjects:
				[NSURLQueryItem queryItemWithName:@"ghinNumber" value:canonicalGHINNumber],
				[NSURLQueryItem queryItemWithName:@"lastName" value:[queryInfo objectForKey:@"lastName"]],
				nil];
		NSURL *url = components.URL;
		
		NSMutableURLRequest *lookupRequest = [[NSMutableURLRequest alloc] initWithURL:url];
		lookupRequest.HTTPMethod = @"GET";
		lookupRequest.HTTPBody = [NSData data];
		lookupRequest.networkServiceType = NSURLNetworkServiceTypeDefault;
		lookupRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
		lookupRequest.timeoutInterval = 10.0;
		lookupRequest.HTTPShouldHandleCookies = YES;
		
		[lookupRequest setValue:@"https://www.ghin.com" forHTTPHeaderField:@"Origin"];
		[lookupRequest setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
		[lookupRequest setValue:@"https://www.ghin.com/login?returnUrl=/profile" forHTTPHeaderField:@"Referer"];
		[lookupRequest setValue:@"br, gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
		[lookupRequest setValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
		[lookupRequest setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
		
//		[lookupRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
//		[lookupRequest setValue:[NSString stringWithFormat:@"W/\"%@\"", [NSString randomETagStringOfLength:32]] forHTTPHeaderField:@"If-None-Match"];

		if (@available (macOS 10.14, *)) {
			[lookupRequest setValue:@"*/*" forHTTPHeaderField:@"Accept"];
			[lookupRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
			[lookupRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
		} else {
			[lookupRequest setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
		}

		self.getHandicapTask = [self.handicapLookupSession dataTaskWithRequest:lookupRequest];
		self.getHandicapData = nil;	//	Start with no data
		self.needCancel = NO;

		self.getHandicapTaskStart = [NSDate date];	//	Now
		[self.getHandicapTask resume];	//	Get the download going…
		
		self.progressNotice = GOLFLocalizedString(@"NOTICE_SERVICE_CONNECTING");
	}	//	if (self.getHandicapTask == nil)
}

#pragma mark <NSURLSessionDelegate>

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {

	//	session - The session object that was invalidated.
	//	error - The error that caused invalidation, or nil if the invalidation was explicit.
	//
	//	If you invalidate a session by calling its finishTasksAndInvalidate method, the session waits
	//	until after the final task in the session finishes or fails before calling this delegate method.
	//	If you call the invalidateAndCancel method, the session calls this delegate method immediately.

	if (session == self.handicapLookupSession) {
		//	Report any invalidation error…
		if (error != nil) {
			self.progressNotice = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_SERVICE_CODE_%ld_DESC_%@"), [error code], [error localizedFailureReason]];	//	???
//#ifdef DEBUG
//			NSLog(@"%@ -%@\nnotice: %@\nerror: %@", [self className], NSStringFromSelector(_cmd), self.progressNotice, error);
//#endif
		}

		//	Final stuff
		self.GetHandicapTaskCompletionHandler = nil;
		
		// Remove our references…
		self.handicapLookupSession = nil;	//	Retained
	}
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {

	//	session - The session containing the task that requested authentication.
	//	challenge - An object that contains the request for authentication.
	//	completionHandler - A handler that your delegate method must call. This completion handler takes the following parameters::
	//		disposition — One of several constants that describes how the challenge should be handled.
	//		credential — The credential that should be used for authentication if disposition is NSURLSessionAuthChallengeUseCredential, otherwise NULL.

	//	Discussion - This method is called in two situations:
	//	•	When a remote server asks for client certificates or Windows NT LAN Manager (NTLM) authentication, to allow your app to provide appropriate credentials
	//	•	When a session first establishes a connection to a remote server that uses SSL or TLS, to allow your app to verify the server’s certificate chain

	//	If you do not implement this method, the session calls its delegate’s URLSession:task:didReceiveChallenge:completionHandler: method instead.

	NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
	if ([authMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
		completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
	} else {
		NSURLCredential *credential = [NSURLCredential credentialWithUser:@"UserName" password:@"Password" persistence:NSURLCredentialPersistenceNone];
		completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
	}
}

#pragma mark <NSURLSessionTaskDelegate>

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
	//	session - The session containing the task whose request finished transferring data.
	//	task - The task whose request finished transferring data.
	//	error - If an error occurred, an error object indicating how the transfer failed, otherwise NULL.

	//	Discussion - Server errors are not reported through the error parameter. The only errors your delegate receives through the error parameter are client-side errors, such as being unable to resolve the hostname or connect to the host.

	if (session == self.handicapLookupSession) {
		if (task == self.getHandicapTask) {
			NSMutableDictionary *queryResponse = [NSMutableDictionary dictionaryWithDictionary:self.queryInfo];
			if (error != nil) {
				if (error.code == NSUserCancelledError) {
					self.progressNotice = GOLFLocalizedString(@"NOTICE_SERVICE_CANCELLED");
				} else {
					self.progressNotice = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_SERVICE_CODE_%ld_DESC_%@"), [error code], [error localizedFailureReason]];
				}
//#ifdef DEBUG
//				NSLog(@"%@ -%@\nnotice: %@\nerror: %@", [self className], NSStringFromSelector(_cmd), self.progressNotice, error);
//#endif
				self.getHandicapTask = nil;	//	We don't need the reference
				self.getHandicapData = nil;	//	Nor any data we've accumulated
				if (self.GetHandicapTaskCompletionHandler) {
					[queryResponse setObject:self.progressNotice forKey:@"notice"];
					[queryResponse setObject:[NSNumber numberWithInteger:[error code]] forKey:@"errorCode"];
					[queryResponse setObject:[error localizedFailureReason] forKey:@"errorDescription"];
					self.GetHandicapTaskCompletionHandler([NSDictionary dictionaryWithDictionary:queryResponse], error);
				}
				return;
			}	//	if (error != nil)

			NSURLResponse *lastResponse = [task response];
			if ((lastResponse == nil)
					|| ![lastResponse isKindOfClass:[NSHTTPURLResponse class]]
					|| ([(NSHTTPURLResponse *)lastResponse statusCode] < 200)
					|| ([(NSHTTPURLResponse *)lastResponse statusCode] > 299)) {
				NSInteger code = [(NSHTTPURLResponse *)lastResponse statusCode];
				self.progressNotice = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_SERVICE_CODE_%ld_DESC_%@"), code, [NSHTTPURLResponse localizedStringForStatusCode:code]];
//#ifdef DEBUG
//				NSLog(@"%@ -%@\nnotice: %@", [self className], NSStringFromSelector(_cmd), self.progressNotice);
//#endif

				NSInteger responseCode = GOLFHandicapLookupServiceGetHandicapError;
				NSString *responseDescription = GOLFLocalizedString(@"SERVICE_GETHANDICAP_FAIL");
				if (code > 0) {
					responseDescription = [responseDescription stringByAppendingFormat:@" - %@ (%ld)", [NSHTTPURLResponse localizedStringForStatusCode:code], (long)code];
				}
				NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:responseCode], @"statusCode",
								responseDescription, @"localizedDescription",
								nil];
				NSError *responseError = [NSError errorWithDomain:GOLFHandicapLookupServiceErrorDomain code:responseCode userInfo:info];
				self.getHandicapTask = nil;	//	We don't need the reference
				self.getHandicapData = nil;	//	Nor any data we've accumulated
				if (self.GetHandicapTaskCompletionHandler) {
					[queryResponse setObject:self.progressNotice forKey:@"notice"];
					[queryResponse setObject:[NSNumber numberWithInteger:code] forKey:@"errorCode"];
					[queryResponse setObject:[NSHTTPURLResponse localizedStringForStatusCode:code] forKey:@"errorDescription"];
					[queryResponse setObject:[NSNumber numberWithInteger:responseCode] forKey:@"responseCode"];
					[queryResponse setObject:responseDescription forKey:@"responseDescription"];
					self.GetHandicapTaskCompletionHandler([NSDictionary dictionaryWithDictionary:queryResponse], responseError);
				}
				return;
			}	//	if ((lastResponse == nil)
			
			NSError *JSONError = nil;
			if ((self.getHandicapData != nil) && ([self.getHandicapData length] > 0)) {

//	{
//		golfers =     (
//					{
//				Active = true;
//				Assoc = 57;
//				AssocName = "Texas Golf Association";
//				Club = 37;
//				ClubId = 22696;
//				ClubName = "Eagle's Bluff Country Club";
//				ClubType = Private;
//				DateOfBirth = "0001-01-01T00:00:00";
//				Display = "15.1";
//				FirstName = Bobby;
//				GHINNumber = 1684227;
//				Gender = M;
//				HardCap = false;
//				HiDisplay = "15.1";
//				HiValue = "15.1";
//				Holes = 18;
//				IndexType = 0;
//				LastName = Brewer;
//				LegacyPass = GHIN2020;
//				LegacyUser = GHIN2020;
//				Local = 0;
//				LowHI = "15.1";
//				LowHIDisplay = "15.1";
//				LowHiValue = 999;
//				MembershipPaidTime = "0001-01-01T00:00:00";
//				MiddleName = "";
//				NewUserToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyIiwic2NwIjoidXNlciIsImF1ZCI6bnVsbCwiaWF0IjoxNTgwNDE1NDM0LCJleHAiOjE1ODA0NTg2MzQsImp0aSI6IjU2ZWJkNTAzLThmMGQtNDBiOS04MmQ3LWQ3MWJlNGQwNTc3ZSJ9.n0s0YW6oLiPiPcQ3C5D3xXfY1VZuICMM7gjcV1WvtXA";
//				PlayerName = "Bobby Brewer";
//				Prefix = "";
//				PrimaryClubCountry = "United States";
//				PrimaryClubState = TX;
//				RevDate = "2020-01-15T00:00:00";
//				SearchValue = "Bobby Brewer 1684227 84";
//				Service = 0;
//				ServiceName = "";
//				SoftCap = false;
//				StatusDate = "0001-01-01T00:00:00";
//				Suffix = "";
//				TScoreCount = 0;
//				TechnologyProvider = GHIN;
//				TotalDiff = "120.8";
//				TrendDisplay = "";
//				TrendIndexType = "";
//				TrendRevDate = "0001-01-01T00:00:00";
//				TrendTScoreCount = 0;
//				TrendTotalDiff = "";
//				TrendValue = "";
//				Type3 = 0;
//				Value = "15.1";
//			}
//		);
//	}

				self.getHandicapResponseString = [[NSString alloc] initWithData:self.getHandicapData encoding:NSUTF8StringEncoding];
				NSString *theGHINNumber = nil;
				NSString *thePlayerName = nil;
				NSDate *theRevisionDate = nil;
				NSString *theEffectiveDate = nil;
				NSString *theHandicapIndex = nil;
				NSString *theUserToken = nil;
				
				id searchDict = [NSJSONSerialization JSONObjectWithData:self.getHandicapData options:0 error:&JSONError];
				if ((JSONError == nil) && [searchDict isKindOfClass:[NSDictionary class]]) {
					//	JSON return data…
					NSArray *golfersArray = [((NSDictionary *)searchDict) objectForKey:@"golfers"];
					NSString *canonicalGHINNumber = [self.queryInfo objectForKey:@"gHIN"];
					while ([[canonicalGHINNumber substringToIndex:1] isEqualToString:@"0"]) {
						canonicalGHINNumber = [canonicalGHINNumber substringFromIndex:1];
					}
					if (golfersArray != nil) {
						for (NSDictionary *golferDict in golfersArray) {
							NSString *workingString = [golferDict objectForKey:@"GHINNumber"];
							if ([workingString isEqualToString:canonicalGHINNumber]) {
								theGHINNumber = workingString;
							} else {
								continue;
							}
							
							workingString = [golferDict objectForKey:@"LastName"];
							if (workingString && [workingString isEqualToString:[self.queryInfo objectForKey:@"lastName"]]) {
								thePlayerName = [golferDict objectForKey:@"PlayerName"];
							} else {
								thePlayerName = workingString;
							}
							if ((thePlayerName == nil) || ([thePlayerName length] < 2)) {
								workingString = [golferDict objectForKey:@"FirstName"];
								NSString *firstName = [self.queryInfo objectForKey:@"firstName"];
								if (workingString && firstName && [workingString isEqualToString:firstName]) {
									thePlayerName = [golferDict objectForKey:@"PlayerName"];
								} else {
									thePlayerName = workingString;
								}
							}
							
							workingString = [golferDict objectForKey:@"RevDate"];
							if (workingString) {
								//		RevDate = "2020-01-15T00:00:00";
								NSDateFormatter *RFC3339DateFormatter = [[NSDateFormatter alloc] init];
								RFC3339DateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
								RFC3339DateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
//								RFC3339DateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
								RFC3339DateFormatter.timeZone = [NSTimeZone localTimeZone];
								 
								NSDate *revDate = [RFC3339DateFormatter dateFromString:workingString];
								theRevisionDate = revDate;
								theEffectiveDate = [[workingString componentsSeparatedByString:@"T"] objectAtIndex:0];
							}
							
							workingString = [golferDict objectForKey:@"HiDisplay"];
							if (workingString) {
								theHandicapIndex = workingString;
							}

							workingString = [golferDict objectForKey:@"NewUserToken"];
							if (workingString) {
								theUserToken = workingString;
							}
							break;
						}	//	for (NSDictionary *golferDict in golfersArray)

						if (theGHINNumber != nil) {
							NSInteger pad = [[self.queryInfo objectForKey:@"gHIN"] length] - [theGHINNumber length];
							if (pad > 0) {
								//	Pad the front of theGHINNumber until it's the same length as in the Player's record
								theGHINNumber = [[@"000000000000" substringToIndex:pad] stringByAppendingString:theGHINNumber];
							}
							if (theGHINNumber) {
								[queryResponse setObject:theGHINNumber forKey:@"foundGHINNumber"];
							}
							if (thePlayerName) {
								[queryResponse setObject:thePlayerName forKey:@"foundPlayerName"];
							}
							if (theRevisionDate) {
								[queryResponse setObject:theRevisionDate forKey:@"foundRevisionDate"];
							}
							if (theEffectiveDate) {
								[queryResponse setObject:theEffectiveDate forKey:@"foundEffectiveDate"];
							}
							if (theHandicapIndex) {
								[queryResponse setObject:theHandicapIndex forKey:@"foundHandicapIndex"];
							}
							if (theUserToken) {
								[queryResponse setObject:theUserToken forKey:@"foundUserToken"];
							}

							self.progressNotice = [GOLFLocalizedString(@"TERM_COMPLETE") capitalizedString];
							[queryResponse setObject:self.progressNotice forKey:@"notice"];
							
							self.getHandicapTask = nil;	//	We don't need the reference
							self.getHandicapData = nil;	//	Nor any data we've accumulated
							if (self.GetHandicapTaskCompletionHandler) {
								self.GetHandicapTaskCompletionHandler([NSDictionary dictionaryWithDictionary:queryResponse], nil);
							}
							return;
						}	//	if (self.foundGHINNumber != nil)
					}	//	if (golfersArray != nil)
				}	//	if ((JSONError == nil) && [searchDict isKindOfClass:[NSDictionary class]])
			}	//	if ((self.getHandicapData != nil) && ([self.getHandicapData length] > 0))

			NSInteger errorCode = GOLFHandicapLookupServiceGetHandicapError;
			NSString *errorDescription = GOLFLocalizedString(@"SERVICE_GETHANDICAP_JSON_FAIL");
			if (JSONError) {
				errorDescription = [errorDescription stringByAppendingFormat:@" - %@ (%ld)", [JSONError localizedDescription], (long)[JSONError code]];
			}
			NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:errorCode], @"statusCode",
							errorDescription, @"localizedDescription",
							nil];
			NSError *dataError = [NSError errorWithDomain:GOLFHandicapLookupServiceErrorDomain code:errorCode userInfo:info];
			self.progressNotice = GOLFLocalizedString(@"NOTICE_SERVICE_FAILED");

			self.getHandicapTask = nil;	//	We don't need the reference
			self.getHandicapData = nil;	//	Nor any data we've accumulated
			[queryResponse setObject:[NSNumber numberWithInteger:errorCode] forKey:@"errorCode"];
			[queryResponse setObject:errorDescription forKey:@"errorDescription"];
			[queryResponse setObject:self.progressNotice forKey:@"notice"];
			if (self.GetHandicapTaskCompletionHandler) {
				self.GetHandicapTaskCompletionHandler([NSDictionary dictionaryWithDictionary:queryResponse], dataError);
			}
		}	//	if (task == self.getHandicapTask)
	}	//	if (session == self.handicapLookupSession)
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {

	//	session - The session containing the task whose request resulted in a redirect.
	//	task - The task whose request resulted in a redirect.
	//	response - An object containing the server’s response to the original request.
	//	request - A URL request object filled out with the new location.
	//	completionHandler - A block that your handler should call with either the value of the request parameter, a modified URL request object, or NULL to refuse the redirect and return the body of the redirect response.

	//	Discussion - This method is called only for tasks in default and ephemeral sessions.  Tasks in background sessions automatically follow redirects.

	if (session == self.handicapLookupSession) {
		//	For all tasks…
		completionHandler(request);
	}
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
//
//	//	session - The session containing the data task.
//	//	task - The data task.
//	//	bytesSent - The number of bytes sent since the last time this delegate method was called.
//	//	totalBytesSent - The total number of bytes sent so far.
//	//	totalBytesExpectedToSend - The expected length of the body data. The URL loading system can determine the length of the upload data in three ways:
//	//		From the length of the NSData object provided as the upload body.
//	//		From the length of the file on disk provided as the upload body of an upload task (not a download task).
//	//		From the Content-Length in the request object, if you explicitly set it.
//	//		Otherwise, the value is NSURLSessionTransferSizeUnknown (-1) if you provided a stream or body data object, or zero (0) if you did not.
//
//	//	Discussion - The totalBytesSent and totalBytesExpectedToSend parameters are also available as NSURLSessionTask properties countOfBytesSent and countOfBytesExpectedToSend. Or, since NSURLSessionTask supports NSProgressReporting, you can use the task’s progress property instead, which may be more convenient.
//
//	if (session == self.lookupHandicapSession) {
//	}
//}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {

	//	session - The session containing the task whose request requires authentication.
	//	task - The task whose request requires authentication.
	//	challenge - An object that contains the request for authentication.
	//	completionHandler - A handler that your delegate method must call. Its parameters are:
	//		disposition — One of several constants that describes how the challenge should be handled.
	//		credential — The credential that should be used for authentication if disposition is NSURLSessionAuthChallengeUseCredential; otherwise, NULL.

	//	Discussion
	//	This method handles task-level authentication challenges. The NSURLSessionDelegate protocol also provides a session-level authentication delegate method. The method called depends on the type of authentication challenge:
	//	•	For session-level challenges—NSURLAuthenticationMethodNTLM, NSURLAuthenticationMethodNegotiate, NSURLAuthenticationMethodClientCertificate, or NSURLAuthenticationMethodServerTrust—the NSURLSession object calls the session delegate’s URLSession:didReceiveChallenge:completionHandler: method. If your app does not provide a session delegate method, the NSURLSession object calls the task delegate’s URLSession:task:didReceiveChallenge:completionHandler: method to handle the challenge.
	//	•	For non-session-level challenges (all others), the NSURLSession object calls the session delegate’s URLSession:task:didReceiveChallenge:completionHandler: method to handle the challenge. If your app provides a session delegate and you need to handle authentication, then you must either handle the authentication at the task level or provide a task-level handler that calls the per-session handler explicitly. The session delegate’s URLSession:didReceiveChallenge:completionHandler: method is not called for non-session-level challenges.

	if (session == self.handicapLookupSession) {
		NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
		if ([authMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
			NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
		} else {
			NSURLCredential *credential = [NSURLCredential credentialWithUser:@"UserName" password:@"Password" persistence:NSURLCredentialPersistenceNone];
			completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
		}
	}
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willBeginDelayedRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest *newRequest))completionHandler API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) {
	//	session - The session containing the delayed request.
	//	task - The task handling the delayed request.
	//	request - The request that was delayed.
	//	completionHandler - A completion handler to perform the request. The completion handler takes two parameters: a disposition that tells the task how to proceed, and a new request object that is only used if the disposition is NSURLSessionDelayedRequestUseNewRequest.

	//	Discussion - This method is called when a background session task with a delayed start time (as set with the earliestBeginDate property) is ready to start. This delegate method should only be implemented if the request might become stale while waiting for the network load and needs to be replaced by a new request.

	//	For loading to continue, the delegate must call the completion handler, passing in a disposition that indicates how the task should proceed. Passing the NSURLSessionDelayedRequestCancel disposition is equivalent to calling cancel on the task directly.

	if (@available (macOS 10.13, iOS 11.0, *)) {
		if (session == self.handicapLookupSession) {
			NSURLSessionDelayedRequestDisposition disposition = (self.needCancel ? NSURLSessionDelayedRequestCancel : NSURLSessionDelayedRequestContinueLoading);
			completionHandler(disposition, nil);
		}
	}
}

- (void)URLSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task API_AVAILABLE(macos(10.13), ios(11.0), watchos(4.0), tvos(11.0)) {
	//	session - The session that contains the waiting task.
	//	task - The task that is waiting for a change in connectivity.

	//	Discussion - This method is called if the waitsForConnectivity property of NSURLSessionConfiguration is true, and sufficient connectivity is unavailable. The delegate can use this opportunity to update the user interface; for example, by presenting an offline mode or a cellular-only mode.

	//	This method is called, at most, once per task, and only if connectivity is initially unavailable.  It is never called for background sessions because waitsForConnectivity is ignored for those sessions.
	
	if (@available (macOS 10.13, iOS 11.0, *)) {
		if (session == self.handicapLookupSession) {
			if (task == self.getHandicapTask) {
				if (self.needCancel) {
					self.progressNotice = GOLFLocalizedString(@"NOTICE_SERVICE_CANCELLING");
					[self.getHandicapTask cancel];
				} else {
					NSTimeInterval fiveSecondsAgo = -5.0;
					if ([self.getHandicapTaskStart timeIntervalSinceNow] < fiveSecondsAgo) {
						self.progressNotice = GOLFLocalizedString(@"NOTICE_SERVICE_NO_CONNECTION");
						[self.getHandicapTask cancel];	//	Cancel and report an error
					}
				}
			}
		}
	}
}

#pragma mark <NSURLSessionDataDelegate>

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {

	//	session - The session containing the data task that received an initial reply.
	//	dataTask - The data task that received an initial reply.
	//	response - A URL response object populated with headers.
	//	completionHandler - A completion handler that your code calls to continue a transfer, passing a NSURLSessionResponseDisposition constant to indicate whether the transfer should continue as a data task or should become a download task.
	//		If you pass NSURLSessionResponseAllow, the task continues as a data task.
	//		If you pass NSURLSessionResponseCancel, the task is canceled.
	//		If you pass NSURLSessionResponseBecomeDownload, your delegate’s URLSession:dataTask:didBecomeDownloadTask: method is called to provide the new download task that supersedes the current task.

	//	Discussion - Implementing this method is optional unless you need to cancel the transfer or convert it to a download task when the response headers are first received. If you don’t provide this delegate method, the session always allows the task to continue.

	//	You also implement this method if you need to support the fairly obscure multipart/x-mixed-replace content type. With that content type, the server sends a series of parts, each of which is intended to replace the previous part. The session calls this method at the beginning of each part, followed by one or more calls to URLSession:dataTask:didReceiveData: with the contents of that part.

	//	Each time the URLSession:dataTask:didReceiveResponse:completionHandler: method is called for a part, collect the data received for the previous part (if any) and process the data as needed for your application. This processing can include storing the data to the filesystem, parsing it into custom types, or displaying it to the user. Next, begin receiving the next part by calling the completion handler with the NSURLSessionResponseAllow constant. Finally, if you have also implemented URLSession:task:didCompleteWithError:, the session will call it after sending all the data for the last part.

	if (session == self.handicapLookupSession) {
		NSURLSessionResponseDisposition disposition = (self.needCancel ? NSURLSessionResponseCancel : NSURLSessionResponseAllow);
		if (dataTask == self.getHandicapTask) {
			self.progressNotice = (self.needCancel ? GOLFLocalizedString(@"NOTICE_SERVICE_CANCELLING") : GOLFLocalizedString(@"NOTICE_SERVICE_CONNECTED"));
			completionHandler(disposition);
		}
	}
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {

	//	session - The session containing the data task that provided data.
	//	dataTask - The data task that provided data.
	//	data - A data object containing the transferred data.

	//	Discussion - Because the data object parameter is often pieced together from a number of
	//	different data objects, whenever possible, use the enumerateByteRangesUsingBlock: method
	//	to iterate through the data rather than using the bytes method (which flattens the data
	//	object into a single memory block).

	//	This delegate method may be called more than once, and each call provides only data received
	//	since the previous call. The app is responsible for accumulating this data if needed.

	if (session == self.handicapLookupSession) {
		if (dataTask == self.getHandicapTask) {
			[self.getHandicapData appendData:data];
		}
		
		self.progressNotice = GOLFLocalizedString(@"NOTICE_SERVICE_RECEIVING");
	}
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
//
//	//	session - The session containing the data (or upload) task.
//	//	dataTask - The data (or upload) task.
//	//	proposedResponse - The default caching behavior. This behavior is determined based on the current caching policy and the values of certain received headers, such as the Pragma and Cache-Control headers.
//	//	completionHandler - A block that your handler must call, providing either the original proposed response, a modified version of that response, or NULL to prevent caching the response. If your delegate implements this method, it must call this completion handler; otherwise, your app leaks memory.
//
//	//	Discussion - The session calls this delegate method after the task finishes receiving all of the expected data. If you don’t implement this method, the default behavior is to use the caching policy specified in the session’s configuration object. The primary purpose of this method is to prevent caching of specific URLs or to modify the userInfo dictionary associated with the URL response.
//
//	//	This method is called only if the NSURLProtocol handling the request decides to cache the response. As a rule, responses are cached only when all of the following are true:
//	//		The request is for an HTTP or HTTPS URL (or your own custom networking protocol that supports caching).
//	//		The request was successful (with a status code in the 200–299 range).
//	//		The provided response came from the server, rather than out of the cache.
//	//		The session configuration’s cache policy allows caching.
//	//		The provided URLRequest object's cache policy (if applicable) allows caching.
//	//		The cache-related headers in the server’s response (if present) allow caching.
//	//		The response size is small enough to reasonably fit within the cache. (For example, if you provide a disk cache, the response must be no larger than about 5% of the disk cache size.)
//
//	if (session == self.handicapLookupSession) {
//		completionHandler(nil);	//	Don't cache the response
//	}
//}

@end
