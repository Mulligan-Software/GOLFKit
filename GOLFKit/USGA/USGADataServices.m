//
//  USGADataServices.m
//  GOLFKit
//
//  Created by John Bishop on 12/18/18.
//  Copyright © 2018 Mulligan Software. All rights reserved.
//

#import "USGADataServices.h"
#import <WebKit/WKWebView.h>

//	Globals
NSString * const GOLFKitForUSGADataServicesErrorDomain = @"com.mulligansoftware.GOLFKitForUSGADataServices.ErrorDomain";

//	Private definitions
#define	kDefaultUSGADataServicesAccessTokenExpiration	9000			//	(seconds) 2 1/2 hours

NSString * const USGADataServicesDeveloperUserName	= @"jb@mulligansoftware.com";
NSString * const USGADataServicesDeveloperPassword	= @"CqdMM77CUG";

NSString * const USGADataServicesGOLFKitAppName		= @"GOLFKit for USGA Data Services";
NSString * const USGADataServicesGOLFKitAppKey		= @"BOBegvneUAUD6GeVAEHievXPw1C8vUoq";
NSString * const USGADataServicesGOLFKitAppSecret	= @"aScrZs9kX8r4wPgi";
#if TARGET_OS_MAC && !(TARGET_OS_EMBEDDED || TARGET_OS_IOS || TARGET_OS_WATCH)
NSString * const USGADataServicesiOSIdentifier		= @"iOS";
#endif

//	Private functions

//=================================================================
//	USGADataServicesGOLFKitInfo()
//=================================================================
NSDictionary * USGADataServicesGOLFKitInfo(void) {
	return [NSDictionary dictionaryWithObjectsAndKeys:USGADataServicesGOLFKitAppName, @"appName",
			USGADataServicesGOLFKitAppKey, @"appKey",
			USGADataServicesGOLFKitAppSecret, @"appSecret",
			nil];
}


@interface USGADataServicesAgent ()

- (NSURLSessionConfiguration *)USGAQuerySessionConfiguration;
- (NSString *)USGAAppAuthenticationString;

- (void)TokenPost:(NSInteger)expiresIn;
- (void)GetGolfer:(NSString *)GolferId token:(NSString *)token;

@end


@implementation USGADataServicesAgent

+ (USGADataServicesAgent *)agentForDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo {
	USGADataServicesAgent *newAgent = (USGADataServicesAgent *)[[USGADataServicesAgent alloc] initWithDelegate:delegate appInfo:appInfo];
	
	return newAgent;
}

- (USGADataServicesAgent *)initWithDelegate:(id<USGADataServicesAgentDelegate>)delegate appInfo:(NSDictionary *)appInfo {
    if (self = [super init]) {
    	self.delegate = delegate;
    	NSDictionary *info = appInfo;
    	if ((info == nil) && (self.delegate != nil) && [self.delegate respondsToSelector:@selector(USGADataServicesAppInfo)]) {
    		info = [self.delegate USGADataServicesAppInfo];
    	}
    	if (info == nil) {
    		self.USGADataServicesProductAppName = USGADataServicesGOLFKitAppName;
    		self.USGADataServicesProductAppKey = USGADataServicesGOLFKitAppKey;
    		self.USGADataServicesProductAppSecret = USGADataServicesGOLFKitAppSecret;
    	} else {
    		//	All or nothing
    		self.USGADataServicesProductAppName = [info objectForKey:@"appName"];
    		self.USGADataServicesProductAppKey = [info objectForKey:@"appKey"];
    		self.USGADataServicesProductAppSecret = [info objectForKey:@"appSecret"];
    	}
	}
	return self;
}

- (void)dealloc {
	[self invalidateAndClose];
#ifdef DEBUG
	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
}

- (NSString *)userAgent {
	if (_userAgent == nil) {
		NSOperatingSystemVersion systemVersion = [[NSProcessInfo processInfo] operatingSystemVersion];
		NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
		NSString *bundleName = [info objectForKey:@"CFBundleName"];	//	"The Scoring Machine"
		NSString *bundleVersion = [info objectForKey:@"CFBundleVersion"];	//	96
		NSString *bundleShortVersion = [info objectForKey:@"CFBundleShortVersionString"];	//	"1.5"
		NSString *osVersionString = @"";
		if (systemVersion.patchVersion > 0) {
			osVersionString = [NSString stringWithFormat:@"_%ld", (long)systemVersion.patchVersion];
		}
		if (([osVersionString length] > 0) || (systemVersion.minorVersion > 0)) {
			osVersionString = [NSString stringWithFormat:@"_%ld%@", (long)systemVersion.minorVersion, osVersionString];
		}
		osVersionString = [NSString stringWithFormat:@"%ld%@", (long)systemVersion.majorVersion, osVersionString];

		NSString *appPart = [NSString stringWithFormat:@"%@/%@(%@)", [[bundleName componentsSeparatedByString:@" "] componentsJoinedByString:@""], bundleShortVersion, bundleVersion];
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
		_userAgent = [MozillaPart stringByAppendingFormat:@"(Macintosh; Intel Mac OS X %@) %@ %@ %@", osVersionString, WebKitPart, GOLFKitPart, appPart];
	
#ifdef DEBUG
	NSLog(@"%@ -%@ returns…\n%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), _userAgent);
#endif

#endif
	}
	return _userAgent;
}

- (NSURLSessionConfiguration *)USGAQuerySessionConfiguration {
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	
	if (@available (macOS 10.13, iOS 11.0, *)) {
		configuration.waitsForConnectivity = YES;
	}
	configuration.networkServiceType = NSURLNetworkServiceTypeDefault;
	configuration.timeoutIntervalForRequest = 30.0;	//	30 second timeouts
	configuration.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;	//	Accept cookies using default service
	configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;	//	Don't cache incoming data - reload it

//#ifdef DEBUG
//	NSLog(@"%@ -%@ returns: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), configuration);
//#endif
	return configuration;
}

- (NSString *)USGAAppAuthenticationString {
	NSString *workingString = [NSString stringWithFormat:@"%@:%@", self.USGADataServicesProductAppKey, self.USGADataServicesProductAppSecret];
	NSData *workingData = [workingString dataUsingEncoding:NSUTF8StringEncoding];
	return [NSString stringWithFormat:@"Basic %@", [workingData base64EncodedStringWithOptions:0]];
}

- (NSURLSession *)USGAQuerySession {
	if (_USGAQuerySession == nil) {
		_USGAQuerySession = [NSURLSession sessionWithConfiguration:self.USGAQuerySessionConfiguration delegate:self delegateQueue:nil];
		//	Important - The session object keeps a strong reference to the delegate until your app exits or explicitly invalidates the session. If you do not invalidate the session by calling the invalidateAndCancel or finishTasksAndInvalidate method, your app leaks memory until it exits.
	}
	return _USGAQuerySession;
}

- (NSMutableData *)USGATokenPostData {
	if (_USGATokenPostData == nil) {
		_USGATokenPostData = [[NSMutableData alloc] init];	//	Retained
	}
	return _USGATokenPostData;
}

- (NSMutableData *)USGAGetGolferData {
	if (_USGAGetGolferData == nil) {
		_USGAGetGolferData = [[NSMutableData alloc] init];	//	Retained
	}
	return _USGAGetGolferData;
}

- (void)invalidateAndClose {
#ifdef DEBUG
	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
	if (self.USGAQuerySession != nil) {
		[self.USGAQuerySession invalidateAndCancel];
	}
}

- (void)requestAccessTokenWithTimer:(NSTimer *)timer {
	[self TokenPostWithCompletionHandler:^(NSString *accessToken, NSDate *expiresAt, NSError *error) {
		if (error) {
#ifdef DEBUG
	NSLog(@"%@ -%@ failed to load accessToken - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error userInfo]);
#endif
		} else if (accessToken) {
#ifdef DEBUG
	NSLog(@"%@ -%@ accessToken: %@  expiresAt: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), accessToken, [NSDateFormatter localizedStringFromDate:expiresAt dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]);
#endif
			self.accessToken = accessToken;
			self.accessTokenExpiresAt = expiresAt;
		}
		self.USGATokenPostTaskCompletionHandler = nil;
	}];
}

- (void)TokenPostWithCompletionHandler:(void (^)(NSString *accessToken, NSDate *expiresAt, NSError *error))completionHandler {
	NSString *token = self.accessToken;
	NSDate *expiresAt = ((self.accessTokenExpiresAt == nil) ? [NSDate date] : self.accessTokenExpiresAt);
	NSDate *needNewTokenDate = [NSDate dateWithTimeInterval:-10 sinceDate:expiresAt];	//	10 seconds before now or expiration
	if ((self.USGATokenPostTask == nil) && (token != nil) && (expiresAt != nil) && ([needNewTokenDate timeIntervalSinceNow] > 0)) {
		//	The current token hasn't (isn't soon to be) expired…
		self.USGATokenPostTaskCompletionHandler = nil;
		if (completionHandler) {
			completionHandler(token, expiresAt, nil);
		}
	} else {
		self.USGATokenPostTaskCompletionHandler = completionHandler;
		if (self.USGATokenPostTask == nil) {
			[self TokenPost:(NSInteger)kDefaultUSGADataServicesAccessTokenExpiration];
		}
	}
}

- (void)GetGolfer:(NSString *)GolferId completionHandler:(void (^)(NSArray *golferArray, NSError *error))completionHandler {
//#ifdef DEBUG
//	NSLog(@"%@ -%@ GolferId: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), GolferId);
//#endif

	[self TokenPostWithCompletionHandler:^(NSString *accessToken, NSDate *expiresAt, NSError *tokenError) {
		if (tokenError != nil) {
			self.USGATokenPostTaskCompletionHandler = nil;
			completionHandler(nil, tokenError);
		} else {
			self.accessToken = accessToken;
			self.accessTokenExpiresAt = expiresAt;
			self.USGAGetGolferTaskCompletionHandler = completionHandler;
			if (self.USGAGetGolferTask == nil) {
				[self GetGolfer:GolferId token:accessToken];
			}
		}
	}];
}

- (void)TokenPost:(NSInteger)expiresIn {
	if (self.USGATokenPostTask == nil) {
		NSString *bodyString = [NSString stringWithFormat:@"grant_type=client_credentials&expires_in=%ld", (long)expiresIn];
		NSURL *url = [NSURL URLWithString:@"https://apis.usga.org/api/v1/oauth/token"];
		
		NSMutableURLRequest *lookupRequest = [[NSMutableURLRequest alloc] initWithURL:url];
		lookupRequest.HTTPMethod = @"POST";
		lookupRequest.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
		lookupRequest.networkServiceType = NSURLNetworkServiceTypeDefault;
		lookupRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
		lookupRequest.timeoutInterval = 30.0;
		lookupRequest.HTTPShouldHandleCookies = YES;
		
		[lookupRequest setValue:self.USGAAppAuthenticationString forHTTPHeaderField:@"Authorization"];
		[lookupRequest setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
		[lookupRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[lookupRequest setValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
		[lookupRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
		[lookupRequest setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
		[lookupRequest setValue:@"*/*" forHTTPHeaderField:@"Accept"];
		[lookupRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

		self.USGATokenPostTask = [self.USGAQuerySession dataTaskWithRequest:lookupRequest];
		self.USGATokenPostData = nil;	//	Start with no data
		self.needCancel = NO;

		[self.USGATokenPostTask resume];	//	Get the download going…
		
		self.progressString = GOLFLocalizedString(@"NOTICE_USGA_CONNECTING");
	}	//	if (self.USGATokenPostTask == nil)
}

- (void)GetGolfer:(NSString *)GolferId token:(NSString *)token {
	if (self.USGAGetGolferTask == nil) {
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://apis.usga.org/api/v1/golfers/%@", GolferId]];
		
		NSMutableURLRequest *lookupRequest = [[NSMutableURLRequest alloc] initWithURL:url];
		lookupRequest.HTTPMethod = @"GET";
		lookupRequest.HTTPBody = [NSData data];
		lookupRequest.networkServiceType = NSURLNetworkServiceTypeDefault;
		lookupRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
		lookupRequest.timeoutInterval = 30.0;
		lookupRequest.HTTPShouldHandleCookies = YES;
		
		[lookupRequest setValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
		[lookupRequest setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
		[lookupRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[lookupRequest setValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
		[lookupRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
		[lookupRequest setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
		[lookupRequest setValue:@"*/*" forHTTPHeaderField:@"Accept"];
		[lookupRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

		self.USGAGetGolferTask = [self.USGAQuerySession dataTaskWithRequest:lookupRequest];
		self.USGAGetGolferData = nil;	//	Start with no data
		self.needCancel = NO;

		[self.USGAGetGolferTask resume];	//	Get the download going…
		
		self.progressString = GOLFLocalizedString(@"NOTICE_USGA_CONNECTING");
	}	//	if (self.USGAGetGolferTask == nil)
}

#pragma mark <NSURLSessionDelegate>

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error {

	//	session - The session object that was invalidated.
	//	error - The error that caused invalidation, or nil if the invalidation was explicit.
	//
	//	If you invalidate a session by calling its finishTasksAndInvalidate method, the session waits
	//	until after the final task in the session finishes or fails before calling this delegate method.
	//	If you call the invalidateAndCancel method, the session calls this delegate method immediately.

	if (session == self.USGAQuerySession) {
//		dispatch_async(dispatch_get_main_queue(), ^{
//			//	Final stuff
			self.USGATokenPostTaskCompletionHandler = nil;
			self.USGAGetGolferTaskCompletionHandler = nil;
			
			// Remove our references…
			self.USGAQuerySession = nil;	//	Retained
		 
			//	Report any invalidation error…
			if (error != nil) {
				self.progressString = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_USGA_CODE_%ld_DESC_%@"), [error code], [error localizedFailureReason]];
#ifdef DEBUG
	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.progressString);
#endif
			} else {
#ifdef DEBUG
	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
			}
//		});
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
//		NSURLCredential *credential = [NSURLCredential credentialWithUser:kUSGADataServicesDeveloperUserName password:kUSGADataServicesDeveloperPassword persistence:NSURLCredentialPersistenceNone];
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

	if (session == self.USGAQuerySession) {
		if (task == self.USGATokenPostTask) {
			if (error != nil) {
				[self.USGAQuerySession finishTasksAndInvalidate];
				if (error.code == NSUserCancelledError) {
					self.progressString = GOLFLocalizedString(@"NOTICE_USGA_CANCELLED");
				} else {
					self.progressString = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_USGA_CODE_%ld_DESC_%@"), [error code], [error localizedFailureReason]];
				}
#ifdef DEBUG
	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.progressString);
#endif
				self.USGATokenPostTask = nil;	//	We don't need the reference
				self.USGATokenPostData = nil;	//	Nor any data we've accumulated
				if (self.USGATokenPostTaskCompletionHandler) {
					self.USGATokenPostTaskCompletionHandler(nil, nil, error);
				}
				return;
			}
			
			NSURLResponse *lastResponse = [task response];
			if ((lastResponse == nil)
					|| ![lastResponse isKindOfClass:[NSHTTPURLResponse class]]
					|| ([(NSHTTPURLResponse *)lastResponse statusCode] < 200)
					|| ([(NSHTTPURLResponse *)lastResponse statusCode] > 299)) {
				[self.USGAQuerySession finishTasksAndInvalidate];
				NSInteger code = [(NSHTTPURLResponse *)lastResponse statusCode];
				self.progressString = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_USGA_CODE_%ld_DESC_%@"), code, [NSHTTPURLResponse localizedStringForStatusCode:code]];
#ifdef DEBUG
	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.progressString);
#endif
				NSDictionary *info = ((code > 0)
						? [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:code], @"statusCode",
								[NSHTTPURLResponse localizedStringForStatusCode:code], @"localizedDescription",
								nil]
						: nil);
				NSError *responseError = [NSError errorWithDomain:GOLFKitForUSGADataServicesErrorDomain code:GOLFKitForUSGADataServicesTokenPostError userInfo:info];
				self.USGATokenPostTask = nil;	//	We don't need the reference
				self.USGATokenPostData = nil;	//	Nor any data we've accumulated
				if (self.USGATokenPostTaskCompletionHandler) {
					self.USGATokenPostTaskCompletionHandler(nil, nil, responseError);
				}
				return;
			}
			
			NSError *JSONError = nil;
			if ((self.USGATokenPostData != nil) && ([self.USGATokenPostData length] > 0)) {
				id searchDict = [NSJSONSerialization JSONObjectWithData:self.USGATokenPostData options:0 error:&JSONError];
				if ((JSONError == nil) && [searchDict isKindOfClass:[NSDictionary class]]) {
					//	JSON return data…
					NSString *workingAccessToken = [(NSDictionary *)searchDict objectForKey:@"access_token"];
					NSTimeInterval expiresInSeconds = [[(NSDictionary *)searchDict objectForKey:@"expires_in"] floatValue];
					NSDate *expiresAt = [[NSDate date] dateByAddingTimeInterval:expiresInSeconds];
					
					self.accessToken = workingAccessToken;
					self.accessTokenExpiresAt = expiresAt;

					self.USGATokenPostTask = nil;	//	We don't need the reference
					self.USGATokenPostData = nil;	//	Nor any data we've accumulated
					if (self.USGATokenPostTaskCompletionHandler) {
						self.USGATokenPostTaskCompletionHandler(workingAccessToken, expiresAt, nil);
					}
					
					self.progressString = @"";
					return;
				}
			}
			NSError *dataError = ((JSONError != nil)
					? JSONError
					: [NSError errorWithDomain:GOLFKitForUSGADataServicesErrorDomain code:GOLFKitForUSGADataServicesTokenPostError userInfo:nil]);
			self.progressString = GOLFLocalizedString(@"NOTICE_USGA_FAILED");
#ifdef DEBUG
	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.progressString);
#endif
			self.USGATokenPostTask = nil;	//	We don't need the reference
			self.USGATokenPostData = nil;	//	Nor any data we've accumulated
			if (self.USGATokenPostTaskCompletionHandler) {
				self.USGATokenPostTaskCompletionHandler(nil, nil, dataError);
			}
		} else if (task == self.USGAGetGolferTask) {
			if (error != nil) {
				[self.USGAQuerySession finishTasksAndInvalidate];
				if (error.code == NSUserCancelledError) {
					self.progressString = GOLFLocalizedString(@"NOTICE_USGA_CANCELLED");
				} else {
					self.progressString = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_USGA_CODE_%ld_DESC_%@"), [error code], [error localizedFailureReason]];
				}
#ifdef DEBUG
	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.progressString);
#endif
				self.USGAGetGolferTask = nil;	//	We don't need the reference
				self.USGAGetGolferData = nil;	//	Nor any data we've accumulated
				if (self.USGAGetGolferTaskCompletionHandler) {
					self.USGAGetGolferTaskCompletionHandler(nil, error);
				}
				return;
			}	//	if (error != nil)
			
			NSURLResponse *lastResponse = [task response];
			if ((lastResponse == nil)
					|| ![lastResponse isKindOfClass:[NSHTTPURLResponse class]]
					|| ([(NSHTTPURLResponse *)lastResponse statusCode] < 200)
					|| ([(NSHTTPURLResponse *)lastResponse statusCode] > 299)) {
				[self.USGAQuerySession finishTasksAndInvalidate];
				NSInteger code = [(NSHTTPURLResponse *)lastResponse statusCode];
				self.progressString = [NSString stringWithFormat:GOLFLocalizedString(@"NOTICE_USGA_CODE_%ld_DESC_%@"), code, [NSHTTPURLResponse localizedStringForStatusCode:code]];
#ifdef DEBUG
	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.progressString);
#endif
				NSDictionary *info = ((code > 0)
						? [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:code], @"statusCode",
								[NSHTTPURLResponse localizedStringForStatusCode:code], @"localizedDescription",
								nil]
						: nil);
				NSError *responseError = [NSError errorWithDomain:GOLFKitForUSGADataServicesErrorDomain code:GOLFKitForUSGADataServicesGetGolferError userInfo:info];
				self.USGAGetGolferTask = nil;	//	We don't need the reference
				self.USGAGetGolferData = nil;	//	Nor any data we've accumulated
				if (self.USGAGetGolferTaskCompletionHandler) {
					self.USGAGetGolferTaskCompletionHandler(nil, responseError);
				}
				return;
			}	//	if ((lastResponse == nil)
			
			NSError *JSONError = nil;
			if ((self.USGAGetGolferData != nil) && ([self.USGAGetGolferData length] > 0)) {
				id golferArray = [NSJSONSerialization JSONObjectWithData:self.USGAGetGolferData options:0 error:&JSONError];
//#ifdef DEBUG
//	NSLog(@"%@ -%@ %@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), NSStringFromClass([golferArray class]), golferArray);
//#endif
				if ((JSONError == nil) && [golferArray isKindOfClass:[NSArray class]]) {
					//	JSON return data…
					
					self.USGAGetGolferTask = nil;	//	We don't need the reference
					self.USGAGetGolferData = nil;	//	Nor any data we've accumulated
					if (self.USGAGetGolferTaskCompletionHandler) {
						self.USGAGetGolferTaskCompletionHandler(golferArray, nil);
					}
					
					self.progressString = @"";
					return;
				}
			}
			NSError *dataError = ((JSONError != nil)
					? JSONError
					: [NSError errorWithDomain:GOLFKitForUSGADataServicesErrorDomain code:GOLFKitForUSGADataServicesGetGolferError userInfo:nil]);
			self.progressString = GOLFLocalizedString(@"NOTICE_USGA_FAILED");
#ifdef DEBUG
	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.progressString);
#endif
			self.USGAGetGolferTask = nil;	//	We don't need the reference
			self.USGAGetGolferData = nil;	//	Nor any data we've accumulated
			if (self.USGAGetGolferTaskCompletionHandler) {
				self.USGAGetGolferTaskCompletionHandler(nil, dataError);
			}
		}
	}	//	if (session == USGAQuerySession)
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest *))completionHandler {

	//	session - The session containing the task whose request resulted in a redirect.
	//	task - The task whose request resulted in a redirect.
	//	response - An object containing the server’s response to the original request.
	//	request - A URL request object filled out with the new location.
	//	completionHandler - A block that your handler should call with either the value of the request parameter, a modified URL request object, or NULL to refuse the redirect and return the body of the redirect response.

	//	Discussion - This method is called only for tasks in default and ephemeral sessions.  Tasks in background sessions automatically follow redirects.

	if (session == self.USGAQuerySession) {
#ifdef DEBUG
	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
		//	For all tasks…
		completionHandler(request);
	}
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {

	//	session - The session containing the data task.
	//	task - The data task.
	//	bytesSent - The number of bytes sent since the last time this delegate method was called.
	//	totalBytesSent - The total number of bytes sent so far.
	//	totalBytesExpectedToSend - The expected length of the body data. The URL loading system can determine the length of the upload data in three ways:
	//		From the length of the NSData object provided as the upload body.
	//		From the length of the file on disk provided as the upload body of an upload task (not a download task).
	//		From the Content-Length in the request object, if you explicitly set it.
	//		Otherwise, the value is NSURLSessionTransferSizeUnknown (-1) if you provided a stream or body data object, or zero (0) if you did not.

	//	Discussion - The totalBytesSent and totalBytesExpectedToSend parameters are also available as NSURLSessionTask properties countOfBytesSent and countOfBytesExpectedToSend. Or, since NSURLSessionTask supports NSProgressReporting, you can use the task’s progress property instead, which may be more convenient.

//	if (session == self.USGAQuerySession) {
//#ifdef DEBUG
//	NSLog(@"%@ -%@ %lld of %lld", NSStringFromClass([self class]), NSStringFromSelector(_cmd), totalBytesSent, totalBytesExpectedToSend);
//#endif
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

	if (session == self.USGAQuerySession) {
		NSString *authMethod = [[challenge protectionSpace] authenticationMethod];
		if ([authMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
			NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
			completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
		} else {
//			NSURLCredential *credential = [NSURLCredential credentialWithUser:kUSGADataServicesDeveloperUserName password:kUSGADataServicesDeveloperPassword persistence:NSURLCredentialPersistenceNone];
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
		if (session == self.USGAQuerySession) {
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
		if (session == self.USGAQuerySession) {
			if (self.needCancel) {
#ifdef DEBUG
	NSLog(@"%@ -%@ task cancelled", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
#endif
				[task cancel];	//	Cancel the task (and report a "User cancelled" error)
//			} else if (task == self.USGATokenPostTask) {
//				NSTimeInterval twoMinutesAgo = -120.0;
//				if ([self.USGATokenPostTaskStart timeIntervalSinceNow] < twoMinutesAgo) {
//					[self.USGATokenPostTask cancel];	//	Cancel and report an error
//				}
			}
		}
	}
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0)) {
//	//	session - The session collecting the metrics.
//	//	task - The task whose metrics have been collected.
//	//	metrics - The collected metrics.
//	
//	if (@available (macOS 10.12, iOS 10.0, *)) {
//#ifdef DEBUG
//	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//#endif
//	}
//}

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

	if (session == self.USGAQuerySession) {
//#ifdef DEBUG
//	NSLog(@"%@ -%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), (self.needCancel ? @"(needCancel)" : @""));
//#endif
		NSURLSessionResponseDisposition disposition = (self.needCancel ? NSURLSessionResponseCancel : NSURLSessionResponseAllow);
		if (dataTask == self.USGATokenPostTask) {
			self.progressString = GOLFLocalizedString(@"NOTICE_USGA_CONNECTED");
			completionHandler(disposition);
		} else if (dataTask == self.USGAGetGolferTask) {
			self.progressString = GOLFLocalizedString(@"NOTICE_USGA_CONNECTED");
			completionHandler(disposition);
		}
	}
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {

	//	session - The session containing the task that was replaced by a download task.
	//	dataTask - The data task that was replaced by a download task.
	//	downloadTask - The new download task that replaced the data task.

	//	Discussion - When your URLSession:dataTask:didReceiveResponse:completionHandler: delegate method uses the NSURLSessionResponseBecomeDownload disposition to convert the request to use a download, the session calls this delegate method to provide you with the new download task. After this call, the session delegate receives no further delegate method calls related to the original data task.

//	if (session == self.USGAQuerySession) {
//#ifdef DEBUG
//	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//#endif
//	}
//}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {

	//	session - The session containing the task that was replaced by a stream task.
	//	dataTask - The data task that was replaced by a stream task.
	//	streamTask - The new stream task that replaced the data task.

	//	Discussion - When your URLSession:dataTask:didReceiveResponse:completionHandler: delegate method uses the NSURLSessionResponseBecomeStream disposition to convert the request to use a stream, the session calls this delegate method to provide you with the new stream task.  After this call, the session delegate receives no further delegate method calls related to the original data task.

	//	For requests that were pipelined, the stream task allows only reading, and the object immediately sends the delegate message URLSession:writeClosedForStreamTask:. You can disable pipelining for all requests in a session by setting the HTTPShouldUsePipelining property on its NSURLSessionConfiguration object, or for individual requests by setting the HTTPShouldUsePipelining property on an NSURLRequest object.

//	if (session == self.USGAQuerySession) {
//#ifdef DEBUG
//	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//#endif
//	}
//}

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

	if (session == self.USGAQuerySession) {
		if (dataTask == self.USGATokenPostTask) {
			[self.USGATokenPostData appendData:data];
		} else if (dataTask == self.USGAGetGolferTask) {
			[self.USGAGetGolferData appendData:data];
		}
		
//		dispatch_async(dispatch_get_main_queue(), ^{
			self.progressString = GOLFLocalizedString(@"NOTICE_USGA_RECEIVING");
//		});
	}
}

//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {

	//	session - The session containing the data (or upload) task.
	//	dataTask - The data (or upload) task.
	//	proposedResponse - The default caching behavior. This behavior is determined based on the current caching policy and the values of certain received headers, such as the Pragma and Cache-Control headers.
	//	completionHandler - A block that your handler must call, providing either the original proposed response, a modified version of that response, or NULL to prevent caching the response. If your delegate implements this method, it must call this completion handler; otherwise, your app leaks memory.

	//	Discussion - The session calls this delegate method after the task finishes receiving all of the expected data. If you don’t implement this method, the default behavior is to use the caching policy specified in the session’s configuration object. The primary purpose of this method is to prevent caching of specific URLs or to modify the userInfo dictionary associated with the URL response.

	//	This method is called only if the NSURLProtocol handling the request decides to cache the response. As a rule, responses are cached only when all of the following are true:
	//		The request is for an HTTP or HTTPS URL (or your own custom networking protocol that supports caching).
	//		The request was successful (with a status code in the 200–299 range).
	//		The provided response came from the server, rather than out of the cache.
	//		The session configuration’s cache policy allows caching.
	//		The provided URLRequest object's cache policy (if applicable) allows caching.
	//		The cache-related headers in the server’s response (if present) allow caching.
	//		The response size is small enough to reasonably fit within the cache. (For example, if you provide a disk cache, the response must be no larger than about 5% of the disk cache size.)

//	if (session == self.USGAQuerySession) {
//#ifdef DEBUG
//	NSLog(@"%@ -%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
//#endif
//		completionHandler(nil);	//	Don't cache the response
//	}
//}

@end
