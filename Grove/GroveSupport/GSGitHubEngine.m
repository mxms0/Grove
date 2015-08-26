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
#import "GSUserInternal.h"

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

- (void)authenticateUserWithUsername:(NSString *__nonnull)username password:(NSString *__nonnull)password completionHandler:(void (^ __nullable)(GSUser *__nullable, NSError *__nullable))handler {
	
	GSUser *_user = nil;
	
	__block NSError *error = nil;
	__block NSString *token = nil;
	__block NSDictionary *userData = nil;
	
	dispatch_semaphore_t wait = dispatch_semaphore_create(0);
	
	[[GSNetworkManager sharedInstance] requestOAuth2TokenWithUsername:username password:password handler:^(NSString * __nullable tokenParam, NSError * __nullable errorParam) {
		token = tokenParam;
		error = errorParam;
		
		dispatch_semaphore_signal(wait);
	}];
	
	dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
	
	if (error) {
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

- (void)eventsForUser:(GSUser *)user completionHandler:(void (^)(NSArray *events, NSError *error))handler {
	[[GSNetworkManager sharedInstance] requestEventsForUser:user.username token:user.token completionHandler:^(id events, NSError *error) {
		if ([events isKindOfClass:[NSArray class]]) {
			NSMutableArray *serializedEvents = [[NSMutableArray alloc] init];
			for (NSDictionary *eventPacket in events) {
				if (![eventPacket isKindOfClass:[NSDictionary class]]) {
					GSAssert();
				}
			
				GSEvent *event = [[GSEvent alloc] initWithDictionary:eventPacket];
				[serializedEvents addObject:event];
			}
		
			handler(serializedEvents, error);
		}
		else {
			if (events) {
				handler(nil, [NSError errorWithDomain:GSErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: events[@"message"]}]);
			}
			else {
				handler(nil, error);
			}
		}
	}];
}

- (void)userInformationWithToken:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(id __nullable information, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestUserInformationForToken:token completionHandler:^(id info, NSError *error) {
		if ([info isKindOfClass:[NSDictionary class]]) {
			handler(info, NULL);
		}
		else {
			// create NSError here
			GSAssert();
		}
	}];
}

- (void)userForUsername:(NSString *__nonnull)username completionHandler:(void (^__nonnull)(GSUser *__nullable user, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestUserInformationForUsername:username token:nil completionHandler:^(NSDictionary *__nullable dictionary, NSError *__nullable error) {
		if (error) {
			handler(nil, error);
			return;
		}
		GSUser *user = [[GSUser alloc] initWithDictionary:dictionary];
		handler(user, nil);
	}];
}

#pragma mark Starring

- (void)starRepository:(GSRepository *__nonnull)repo forUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSError *__nullable error))handler {
	// PUT
	GSAssert();
}
- (void)unstarRepository:(GSRepository *__nonnull)repo forUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSError *__nullable error))handler {
	// DELETE
	GSAssert();
}

- (void)repositoriesStarredByUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler {
	if (user.token) {
		// use /user/starred
	}
	else {
		// use users/{user.username}/starred
	}
	GSAssert();
}

#pragma mark Repositories

- (void)repositoriesForUser:(GSUser *__nonnull)user completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	GSAssert();
}

- (void)repositoriesForUsername:(NSString *__nonnull)username completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	GSAssert();
}

- (void)collaboratorsForRepository:(GSRepository *__nonnull)repo completionHandler:(void (^__nonnull)(NSArray *__nullable collabs, NSError *__nullable error))error {
	GSAssert();
}

- (void)collaboratorsForRepositoryName:(NSString *__nonnull)repoName owner:(NSString *__nonnull)owner completionHandler:(void (^__nonnull)(NSArray *__nullable collabs, NSError *__nullable error))error {
	GSAssert();
}

@end
