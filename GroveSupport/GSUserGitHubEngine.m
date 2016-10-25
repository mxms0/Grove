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
