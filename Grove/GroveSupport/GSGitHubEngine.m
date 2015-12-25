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

static NSString *const GSAPIURLComponentStarred = @"starred";

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

- (void)eventsForUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable events, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestEventsForUser:user.username token:user.token completionHandler:^(id events, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else if (!events) {
			GSAssert();
		}
		else if (![events isKindOfClass:[NSArray class]]) {
			handler(nil, [NSError errorWithDomain:GSErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: events[@"message"]}]);
		}
		else {
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
	}];
}

- (void)userInformationWithToken:(NSString *)token completionHandler:(void (^)(id __nullable information, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestUserInformationForToken:token completionHandler:^(NSDictionary *info, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else if (!info) {
			GSAssert();
		}
		else if (![info isKindOfClass:[NSDictionary class]]) {
			// craft new error here.
			GSAssert();
			handler(nil, error);
		}
		else {
			handler(info, nil);
		}
	}];
}

- (void)_userInformationForUsername:(NSString *)username completionHandler:(void (^)(NSDictionary *__nullable info, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestUserInformationForUsername:username token:nil completionHandler:^(NSDictionary *__nullable response, NSError * _Nullable error) {
		if (error) {
			handler(nil, error);
		}
		else if (!response) {
			GSAssert();
		}
		else if (!response || ![response isKindOfClass:[NSDictionary class]]) {
			GSAssert();
		}
		else {
			handler(response, nil);
		}
	}];
}


- (void)userForUsername:(NSString *)username completionHandler:(void (^)(GSUser *__nullable user, NSError *__nullable error))handler {
	GSUser *cached = [GSUser cachedUserWithUsername:username];
	if (cached) {
		handler(cached, nil);
		return;
	}
	
	[self _userInformationForUsername:username completionHandler:^(NSDictionary * _Nullable info, NSError * _Nullable error) {
		GSUser *user = [[GSUser alloc] initWithDictionary:info];
		
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

- (void)notificationsForUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable notifications, NSError *__nullable error))handler {
	if (!user.token) {
		GSAssert();
	}
	
	[[GSNetworkManager sharedInstance] requestUserNotificationsWithToken:user.token completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
		
		if (error) {
			handler(nil, error);
		}
		else if (!notifs || ![notifs isKindOfClass:[NSArray class]]) {
			GSAssert();
		}
		else {
			NSMutableArray *ret = [[NSMutableArray alloc] init];
		
			for (NSDictionary *dict in notifs) {
				GSNotification *notification = [[GSNotification alloc] initWithDictionary:dict];
				[ret addObject:notification];
			}
		
			handler(ret, nil);
		}
	}];
}

- (void)_dirtyRequestWithObject:(GSObject *)obj completionHandler:(void (^)(NSDictionary *__nullable ret, NSError *__nullable error))handler {
	if (!obj || !obj.directAPIURL) {
		GSAssert();
		return;
	}
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:obj.directAPIURL];
	[request addAuthToken:self.activeUser.token];
	[request addValue:GSRFC2616DTimestampFromDate(obj.updatedDate) forHTTPHeaderField:@"If-Modified-Since"];
	// this may or may not work, but it's worth a shot. :- )
	
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable * _Nullable serializeable, NSError * _Nullable error) {
		if (error) {
			handler(nil, error);
		}
		else if (!serializeable || ![serializeable isKindOfClass:[NSDictionary class]]) {
			GSAssert();
		}
		else {
			handler((NSDictionary *)serializeable, nil);
		}
	}];
}

#pragma mark Starring

- (void)starRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler {
	// PUT
	GSAssert();
}

- (void)unstarRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler {
	// DELETE
	GSAssert();
}

- (void)repositoriesStarredByUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	NSURL *destination = GSAPIURLComplex(GSAPIEndpointUsers, user.username, GSAPIComponentStarred);
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:destination];
	[request addAuthToken:user.token];
	
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable *serializeable, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else if (!serializeable || ![serializeable isKindOfClass:[NSArray class]]) {
			GSAssert();
		}
		else {
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

- (void)repositoriesForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSRepository *> *__nullable repos, NSError *__nullable error))handler {
	[[GSNetworkManager sharedInstance] requestRepositoriesForUsername:user.username token:_activeUser.token completionHandler:^(NSArray<NSDictionary *>* _Nullable repos, NSError * _Nullable error) {
		if (error) {
			handler(nil, error);
		}
		else if (!repos || ![repos isKindOfClass:[NSArray class]]) {
			GSAssert();
		}
		else {
			NSMutableArray *serializedRepos = [[NSMutableArray alloc] init];
			for (NSDictionary *dict in repos) {
				GSRepository *repository = [[GSRepository alloc] initWithDictionary:dict];
				[serializedRepos addObject:repository];
			}
			handler(serializedRepos, nil);
		}
	}];
}

- (void)repositoriesForUsername:(NSString *)username completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	GSAssert();
}

- (void)collaboratorsForRepository:(GSRepository *)repo completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error {
	GSAssert();
}

- (void)collaboratorsForRepositoryNamed:(NSString *)repoName owner:(NSString *)owner completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error {
	GSAssert();
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
