//
//  GSGitHubEngine.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSGitHubEngine.h"
#import "GSNetworkManager.h"
#import "GSEvent.h"
#import "GroveSupportInternal.h"
#import "GSURLRequest.h"

/*
 Some comments, flow should go like this:
 Request data from GSNetworkManager, if error, pass error up
 If no error in GSGitHubEngine, check type, make new error or pass data on
 Checking should always be:
 If (!error) {}
 Else If (!correct type) {}
 Else { this is success }
 handler(x,y) where x (xor) y should always be 1 (1 for object, 0 for nil)
 */

NS_ASSUME_NONNULL_BEGIN

@implementation GSGitHubEngine

+ (instancetype)sharedInstance {
	static id _instance = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^ {
		_instance = [[self alloc] init];
	});
	
	return _instance;
}

- (instancetype)init {
	if ((self = [super init])) {
		
	}
	return self;
}

- (void)authenticateUserWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void (^__nullable)(GSUser *__nullable, NSError *__nullable))handler {
	[self authenticateUserWithUsername:username password:password twoFactorToken:nil completionHandler:handler];
}

- (void)authenticateUserWithUsername:(NSString *)username password:(NSString *)password twoFactorToken:(NSString *__nullable)twoFa completionHandler:(void (^ __nullable)(GSUser *__nullable user, NSError *__nullable error))handler {
	
	// this API is blocking. Not sure if I'm okay with this
	// since it has an async design
	
	GSUser *_user = nil;
	
	__block NSError *error = nil;
	__block NSString *token = nil;
	__block NSDictionary *userData = nil;
	
	dispatch_semaphore_t wait = dispatch_semaphore_create(0);
	
	[[GSNetworkManager sharedInstance] requestOAuth2TokenWithUsername:username password:password twoFactorToken:twoFa handler:^(NSString * __nullable tokenParam, NSError * __nullable errorParam) {
		token = tokenParam;
		error = errorParam;
		
		dispatch_semaphore_signal(wait);
	}];
	
	dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
	
	if (error) {
		NSString *authAttempt = [[error userInfo] objectForKey:GSAuthCriteria];
		if (authAttempt) {
			// Wouldn't be in this place if X-GitHub-OTP key wasn't present
			// can't find a reason where it would be sent and not be requiring 2fa
			BOOL required = NO;
			GSTwoFactorAuthMethod method = GSTwoFactorAuthMethodUnknown;
			NSArray *words = [authAttempt componentsSeparatedByString:@" "];
			for (NSString *word in words) {
				if ([word hasPrefix:@"required"]) {
					required = YES;
					continue;
				}
				else if ([word hasPrefix:@"app"]) {
					method = GSTwoFactorAuthMethodApp;
					continue;
				}
				else if ([word hasPrefix:@"sms"]) {
					method = GSTwoFactorAuthMethodSMS;
					continue;
				}
			}
			NSDictionary *newInfo = @{
									  GSRequires2FAErrorKey:	@(YES), // assumption
									  GSAuthCriteria:			@(method)
									  };
			error = [NSError errorWithDomain:GSErrorDomain code:GSErrorReasonTwoFactorAuthRequired userInfo:newInfo];
		}
		
		handler(nil, error);
		return;
	}
	
	wait = dispatch_semaphore_create(0);
	
	[[GSNetworkManager sharedInstance] requestUserInformationForToken:token completionHandler:^(NSDictionary *__nullable information, NSError *__nullable errorParam) {
		error = errorParam;
		userData = information;
		
		dispatch_semaphore_signal(wait);
	}];
	
	dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
	
	if (error) {
		handler(nil, error);
		return;
	}
	
	_user = [[GSUser alloc] initWithDictionary:userData];
	[_user setToken:token];
	
	handler(_user, nil);
}

- (void)eventsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSEvent *> *__nullable events, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestEventsForUser:user.username token:user.token completionHandler:^(id events, NSError *error) {
		
		GSInsuranceBegin(events, NSArray, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
			handler(nil, [NSError errorWithDomain:GSErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: events[@"message"]}]);
		}
		GSInsuranceGoodData {
			NSMutableArray *serializedEvents = [[NSMutableArray alloc] init];
			
			[events enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
				NSDictionary *eventPacket = (NSDictionary *)obj;
				GSEvent *evt = [[GSEvent alloc] initWithDictionary:eventPacket];
				[serializedEvents addObject:evt];
			}];
			
			handler(serializedEvents, nil);
		}
		
		GSInsuranceEnd();
	}];
}

- (void)notificationsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSNotification *> *__nullable notifications, NSError *__nullable error))handler {
	if (!user.token) {
		GSAssert();
	}
	
	[[GSNetworkManager sharedInstance] requestUserNotificationsWithToken:user.token completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
		
		GSInsuranceBegin(notifs, NSArray, error)
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			NSMutableArray *ret = [[NSMutableArray alloc] init];
			
			for (NSDictionary *dict in notifs) {
				GSNotification *notification = [[GSNotification alloc] initWithDictionary:dict];
				[ret addObject:notification];
			}
			
			handler(ret, nil);
		}
		
		GSInsuranceEnd()
	}];
}

- (void)_dirtyRequestWithObject:(GSObject *)obj completionHandler:(void (^)(NSDictionary *__nullable ret, NSError *__nullable error))handler {
	if (!obj || !obj.directAPIURL) {
		GSAssert();
		return;
	}
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:obj.directAPIURL];
	[request setAuthToken:self.activeUser.token];
	[request setLastModifiedDate:obj.updatedDate];
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable * _Nullable serializeable, NSError * _Nullable error) {

		
		if (error) {
			handler(nil, error);
		}
		else if (!serializeable) {
			// This is *likely* because the data hasn't changed
			// Thanks to If-Modified-Since
			handler(nil, nil);
		}
		else if (![serializeable isKindOfClass:[NSDictionary class]] && ![serializeable isKindOfClass:[NSArray class]]) {
			GSAssert();
		}
		else {
			handler((NSDictionary *)serializeable, nil);
		}
	}];
}

#pragma mark Gists

- (void)gistsForUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable gists, NSError *__nullable))handler {
	if (user.token) {
		
	}
	else {
		
	}
}

- (void)commentsForGist:(GSGist *)gist completionHandler:(void (^)(NSArray *__nullable comments, NSError *__nullable))handler {
	GSAssert();
}

- (void)commentOnGist:(GSGist *)gist withMessage:(NSString *)message attachments:(NSArray<id> *__nullable)attachments completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler {
	GSAssert();
}

- (void)editComent:(id)comment gist:(GSGist *)gist newMessage:(NSString *)message completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler {
	GSAssert();
}

- (void)deleteComment:(id)comment gist:(GSGist *)gist completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler {
	GSAssert();
}

@end

NS_ASSUME_NONNULL_END

NSString *const GSDomain = @"com.RickSupport.morty";
NSString *const GSErrorDomain = @"MortiestMorty";
NSString *const GSUpdatedDateKey = @"updatedDate";
NSString *const GSRequires2FAErrorKey = @"Requires2FA";
NSString *const GSAuthCriteria = @"AuthCriteria";
