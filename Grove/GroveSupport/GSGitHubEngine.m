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

static NSString *const GSAPIURLComponentStarred = @"starred";

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

- (void)authenticateUserWithUsername:(NSString *__nonnull)username password:(NSString *__nonnull)password completionHandler:(void (^__nullable)(GSUser *__nullable, NSError *__nullable))handler {
	
	// this API is blocking. Not sure if I'm okay with this
	// since it has an async design
	
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
	
	wait = dispatch_semaphore_create(0);
	
	__block NSArray *starredRepoData = nil;
	
	[self repositoriesStarredByUser:_user completionHandler:^(NSArray *repos, NSError *errorParam) {
		error = errorParam;
		starredRepoData = repos;
		
		dispatch_semaphore_signal(wait);
		
	}];
	
	dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
	
	if (error) {
		handler(nil, error);
		return;
	}
	
	[_user setStarredRepositoryCount:@([starredRepoData count])];

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
	GSUser *cached = [GSUser cachedUserWithUsername:username];
	if (cached) {
		handler(cached, nil);
		return;
	}
	
	[[GSNetworkManager sharedInstance] requestUserInformationForUsername:username token:nil completionHandler:^(NSDictionary *__nullable dictionary, NSError *__nullable error) {
		if (error) {
			handler(nil, error);
			return;
		}
		
		GSUser *user = [[GSUser alloc] initWithDictionary:dictionary];
		
		[self repositoriesStarredByUser:user completionHandler:^(NSArray * _Nullable repos, NSError * _Nullable error) {
			if (error) {
				handler(nil, error);
				return;
			}
			
			[user setStarredRepositoryCount:@([repos count])];
			NSLog(@"USER FOUD BEING USED %@", user);
			handler(user, nil);
		}];
	}];
}

- (void)notificationsForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable notifications, NSError *__nullable error))handler {
	if (!user.token) {
		GSAssert();
	}
	
	[[GSNetworkManager sharedInstance] requestUserNotificationsWithToken:user.token completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
		
		if (error) {
			handler(nil, error);
			return;
		}
		
		NSMutableArray *ret = [[NSMutableArray alloc] init];
		
		for (NSDictionary *dict in notifs) {
			GSNotification *notification = [[GSNotification alloc] initWithDictionary:dict];
			[ret addObject:notification];
		}
		
		handler(ret, nil);
	}];
}

#pragma mark Starring

- (void)starRepository:(GSRepository *__nonnull)repo completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler {
	// PUT
	GSAssert();
}
- (void)unstarRepository:(GSRepository *__nonnull)repo completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler {
	// DELETE
	GSAssert();
}

- (void)repositoriesStarredByUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler {
	NSURL *destination = GSAPIURLComplex(GSAPIEndpointUsers, user.username, GSAPIComponentStarred);
	
#if API_TRUST_LEVEL >= 3
	if (user.starredAPIURL) {
		destination = user.starredAPIURL;
	}
#endif
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:destination];
	[request addAuthToken:user.token];
	
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable *serializeable, NSError *error) {
		if (error) {
			handler(nil, error);
			return;
		}
		if ([serializeable isKindOfClass:[NSArray class]]) {
			NSMutableArray *ret = [[NSMutableArray alloc] init];
			for (NSDictionary *dict in (NSArray *)serializeable) {
				GSRepository *repo = [[GSRepository alloc] initWithDictionary:dict];
				[ret addObject:repo];
			}
			
			handler((NSArray *)ret, nil);
		}
	}];
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

- (void)collaboratorsForRepositoryNamed:(NSString *__nonnull)repoName owner:(NSString *__nonnull)owner completionHandler:(void (^__nonnull)(NSArray *__nullable collabs, NSError *__nullable error))error {
	GSAssert();
}

#pragma mark Gists

- (void)gistsForUser:(GSUser *)user completionHandler:(void (^__nonnull)(NSArray *__nullable gists, NSError *__nullable))handler {
	if (user.token) {
		
	}
	else {
		
	}
}

- (void)commentsForGist:(GSGist *__nonnull)gist completionHandler:(void (^__nonnull)(NSArray *__nullable comments, NSError *__nullable))handler {
	GSAssert();
}

- (void)commentOnGist:(GSGist *__nonnull)gist withMessage:(NSString *__nonnull)message attachments:(NSArray<id> *__nullable)attachments completionHandler:(void (^__nonnull)(__nullable id comment, NSError *__nullable error))handler {
	GSAssert();
}

- (void)editComent:(__nonnull id)comment gist:(GSGist *__nonnull)gist newMessage:(NSString *__nonnull)message completionHandler:(void (^__nonnull)(__nullable id comment, NSError *__nullable error))handler {
	GSAssert();
}

- (void)deleteComment:(__nonnull id)comment gist:(GSGist *__nonnull)gist completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler {
	GSAssert();
}

@end
