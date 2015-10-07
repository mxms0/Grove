//
//  GSUser.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSUser.h"
#import "GroveSupportInternal.h"

@implementation GSUser

static NSMutableDictionary *cachedUsers = nil;

+ (GSUser *)cachedUserWithUsername:(NSString *)username {
	static dispatch_once_t token;
	
	dispatch_once(&token, ^ {
		cachedUsers = [[NSMutableDictionary alloc] init];
	});
	
	GSUser *user = nil;
	@synchronized(cachedUsers) {
		user = cachedUsers[username];
	}
	
	return user;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {
		GSUser *cachedSelf = [GSUser cachedUserWithUsername:self.username];
		// should perhaps move this stage to before calling super init
		// will be faster, not a priority unless it becomes an issue.
		// the only reason why it's not is because then i don't have to check the dictionary in two places
		// for the same key. Incase it changes, etc.
		// Also will probably make a list of constants for each key defined in the API later.
		if (cachedSelf) {
			NSLog(@"GSUser cached. Reusing.");
			return cachedSelf;
		}
		
		@synchronized(cachedUsers) {
			cachedUsers[self.username] = self;
		}
	}
	return self;
}

- (void)configureWithDictionary:(NSDictionary *)dictionary {
	[super configureWithDictionary:dictionary];
	
	GSAssign(dictionary, @"name", _fullName);
	GSAssign(dictionary, @"company", _company);
	GSAssign(dictionary, @"blog", _blog);
	GSAssign(dictionary, @"location", _location);
	GSAssign(dictionary, @"email", _email);
	GSAssign(dictionary, @"hireable", _hireable);
	GSAssign(dictionary, @"bio", _biography);
	GSAssign(dictionary, @"public_repos", _publicRepoCount);
	GSAssign(dictionary, @"public_gists", _publicGistCount);
	GSAssign(dictionary, @"followers", _followersCount);
	GSAssign(dictionary, @"following", _followingCount);
	GSAssign(dictionary, @"private_gists", _privateGistsCount);
	GSAssign(dictionary, @"total_private_repos", _totalPrivateRepoCount);
	GSAssign(dictionary, @"owned_private_repos", _ownedPrivateRepoCount);
	GSAssign(dictionary, @"disk_usage", _diskUsage);
	GSAssign(dictionary, @"collaborators", _collaboratorCount);
	
	GSURLAssign(dictionary, @"html_url", _browserURL);
	GSURLAssign(dictionary, @"followers_url", _followersAPIURL);
	GSURLAssign(dictionary, @"following_url", _followingAPIURL);
	GSURLAssign(dictionary, @"gists_url", _gistsAPIURL);
	GSURLAssign(dictionary, @"starred_url", _starredAPIURL);
	GSURLAssign(dictionary, @"subscriptions_url", _subscriptionsAPIURL);
	GSURLAssign(dictionary, @"organizations_url", _organizationsAPIURL);
	GSURLAssign(dictionary, @"repos_url", _repositoriesAPIURL);
	GSURLAssign(dictionary, @"events_url", _eventsAPIURL);
	GSURLAssign(dictionary, @"received_events_url", _receivedEventsAPIURL);
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	GSEncode(coder, @"__token", _token);
	GSEncode(coder, @"name", _fullName);
	GSEncode(coder, @"company", _company);
	GSEncode(coder, @"blog", _blog);
	GSEncode(coder, @"location", _location);
	GSEncode(coder, @"email", _email);
	GSEncode(coder, @"hireable", _hireable);
	GSEncode(coder, @"bio", _biography);
	GSEncode(coder, @"public_repos", _publicRepoCount);
	GSEncode(coder, @"public_gists", _publicGistCount);
	GSEncode(coder, @"followers", _followersCount);
	GSEncode(coder, @"following", _followingCount);
	GSEncode(coder, @"private_gists", _privateGistsCount);
	GSEncode(coder, @"total_private_repos", _totalPrivateRepoCount);
	GSEncode(coder, @"owned_private_repos", _ownedPrivateRepoCount);
	GSEncode(coder, @"disk_usage", _diskUsage);
	GSEncode(coder, @"collaborators", _collaboratorCount);
	GSEncode(coder, @"starredRepositoryCount", _starredRepositoryCount);
	
	GSEncode(coder, @"html_url", _browserURL);
	GSEncode(coder, @"followers_url", _followersAPIURL);
	GSEncode(coder, @"following_url", _followingAPIURL);
	GSEncode(coder, @"gists_url", _gistsAPIURL);
	GSEncode(coder, @"starred_url", _starredAPIURL);
	GSEncode(coder, @"subscriptions_url", _subscriptionsAPIURL);
	GSEncode(coder, @"organizations_url", _organizationsAPIURL);
	GSEncode(coder, @"repos_url", _repositoriesAPIURL);
	GSEncode(coder, @"events_url", _eventsAPIURL);
	GSEncode(coder, @"received_events_url", _receivedEventsAPIURL);
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	if ((self = [super initWithCoder:coder])) {
		GSDecodeAssign(coder, @"__token", _token);
		GSDecodeAssign(coder, @"name", _fullName);
		GSDecodeAssign(coder, @"company", _company);
		GSDecodeAssign(coder, @"blog", _blog);
		GSDecodeAssign(coder, @"location", _location);
		GSDecodeAssign(coder, @"email", _email);
		GSDecodeAssign(coder, @"hireable", _hireable);
		GSDecodeAssign(coder, @"bio", _biography);
		GSDecodeAssign(coder, @"public_repos", _publicRepoCount);
		GSDecodeAssign(coder, @"public_gists", _publicGistCount);
		GSDecodeAssign(coder, @"followers", _followersCount);
		GSDecodeAssign(coder, @"following", _followingCount);
		GSDecodeAssign(coder, @"private_gists", _privateGistsCount);
		GSDecodeAssign(coder, @"total_private_repos", _totalPrivateRepoCount);
		GSDecodeAssign(coder, @"owned_private_repos", _ownedPrivateRepoCount);
		GSDecodeAssign(coder, @"disk_usage", _diskUsage);
		GSDecodeAssign(coder, @"collaborators", _collaboratorCount);
		GSDecodeAssign(coder, @"starredRepositoryCount", _starredRepositoryCount);
		
		GSDecodeAssign(coder, @"html_url", _browserURL);
		GSDecodeAssign(coder, @"followers_url", _followersAPIURL);
		GSDecodeAssign(coder, @"following_url", _followingAPIURL);
		GSDecodeAssign(coder, @"gists_url", _gistsAPIURL);
		GSDecodeAssign(coder, @"starred_url", _starredAPIURL);
		GSDecodeAssign(coder, @"subscriptions_url", _subscriptionsAPIURL);
		GSDecodeAssign(coder, @"organizations_url", _organizationsAPIURL);
		GSDecodeAssign(coder, @"repos_url", _repositoriesAPIURL);
		GSDecodeAssign(coder, @"events_url", _eventsAPIURL);
		GSDecodeAssign(coder, @"received_events_url", _receivedEventsAPIURL);
	}
	return self;
}

@end
