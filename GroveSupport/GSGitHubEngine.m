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

- (void)_isUser:(GSUser *__nonnull)user followingUser:(GSUser *__nonnull)followee completionHandler:(void (^__nonnull)(BOOL isFollowing, NSError *__nullable error))handler {
	// 404 if not following; 204 if following
	// why github?
	
	NSURL *requestURL = nil;
	
	if (self.activeUser && (self.activeUser == user)) {
		// /user/following/:username
		requestURL = GSAPIURLComplex(GSAPIEndpointUser, @"following", followee.username, nil);
	}
	else {
		// /users/:username/following/:target
		requestURL = GSAPIURLComplex(GSAPIEndpointUsers, user.username, @"following", followee.username, nil);
	}
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:requestURL];
	[request setAuthToken:self.activeUser.token];

	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable * _Nullable serializeable, NSError * _Nullable error) {
		NSLog(@"%@:%@", serializeable, error);
	}];
	
}

#pragma mark Gists

@end

NS_ASSUME_NONNULL_END

NSString *const GSDomain = @"com.RickSupport.morty";
NSString *const GSErrorDomain = @"MortiestMorty";
NSString *const GSUpdatedDateKey = @"updatedDate";
NSString *const GSRequires2FAErrorKey = @"Requires2FA";
NSString *const GSAuthCriteria = @"AuthCriteria";
