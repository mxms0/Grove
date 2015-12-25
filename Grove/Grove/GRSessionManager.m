//
//  GRSessionManager.m
//  Grove
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRSessionManager.h"
#import "GroveSupport.h"
#import "GSGithubEngine.h"

@implementation GRSessionManager

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
		_users = [[NSMutableOrderedSet alloc] init];
	}
	return self;
}

- (GRApplicationUser *)createApplicationUserWithUser:(GSUser *)user becomeCurrentUser:(BOOL)becomeCurrentUser {
	if (!user) {
		GSAssert();
	}
	
	GRApplicationUser *appUser = [[GRApplicationUser alloc] init];
	
	appUser.user = user;
	
	@synchronized(self.users) {
		[self.users addObject:appUser];
	}
	
	if (becomeCurrentUser) {
		self.currentUser = appUser;
	}
	
	return appUser;
}

- (void)save {
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_users];
	
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"users"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)unpack {
	NSData *input = [[NSUserDefaults standardUserDefaults] objectForKey:@"users"];
	if (!input) {
		return;
	}
	NSMutableOrderedSet *usersTmp = [[NSKeyedUnarchiver unarchiveObjectWithData:input] mutableCopy];
	if (usersTmp)
		_users = usersTmp;
	
	if ([_users count] > 0) {
		[[GSGitHubEngine sharedInstance] setActiveUser:self.currentUser.user];
		self.currentUser = _users[0];
		// bad hack for now
	}
	// ASK GSGitHubEngine for new data on these now.
}

@end
