//
//  GSUserGitHubEngine.m
//  GroveSupport
//
//  Created by Max Shavrick on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSUserGitHubEngine.h"
#import "GSNetworkManager.h"
#import "GSEvent.h"
#import "GroveSupportInternal.h"
#import "GSURLRequest.h"

@implementation GSGitHubEngine (GSUserGitHubEngine)

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

- (void)userInformationWithToken:(NSString *)token completionHandler:(void (^)(id __nullable information, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestUserInformationForToken:token completionHandler:^(NSDictionary *info, NSError *error) {
		
		GSInsuranceBegin(info, NSDictionary, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
			handler(nil, error);
		}
		
		GSInsuranceGoodData {
			handler(info, nil);
		}
		
		GSInsuranceEnd();
	}];
}

- (void)_userInformationForUsername:(NSString *)username completionHandler:(void (^)(NSDictionary *__nullable info, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestUserInformationForUsername:username token:self.activeUser.token completionHandler:^(NSDictionary *__nullable response, NSError * _Nullable error) {
		
		GSInsuranceBegin(response, NSDictionary, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			handler(response, nil);
		}
		
		GSInsuranceEnd();
	}];
}

- (void)userForUsername:(NSString *)username completionHandler:(void (^)(GSUser *__nullable user, NSError *__nullable error))handler {
	GSUser *cached = [GSUser cachedUserWithUsername:username];
	if (cached) {
		handler(cached, nil);
		return;
	}
	
	[self _userInformationForUsername:username completionHandler:^(NSDictionary * _Nullable info, NSError * _Nullable error) {
		
		GSInsuranceBegin(info, NSDictionary, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			GSUser *user = [[GSUser alloc] initWithDictionary:info];
			handler(user, error);
		}
		
		GSInsuranceEnd();
	}];
}

@end
