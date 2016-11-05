//
//  GSRepository.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSRepository.h"
#import "GroveSupportInternal.h"

@implementation GSRepository

static NSMutableDictionary *cachedRepos = nil;

+ (GSRepository *)cachedRepositoryWithPath:(NSString *)path {
	static dispatch_once_t token;
	
	dispatch_once(&token, ^ {
		cachedRepos = [[NSMutableDictionary alloc] init];
	});
	
	GSRepository *repo = nil;
	@synchronized(cachedRepos) {
		repo = cachedRepos[path];
	}
	
	return repo;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {
		GSRepository *cachedSelf = [GSRepository cachedRepositoryWithPath:[self pathString]];
		if (cachedSelf) {
			return cachedSelf;
		}
		
		@synchronized(cachedRepos) {
			cachedRepos[self.pathString] = self;
		}
	}
	return self;
}

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	[super _configureWithDictionary:dictionary];
	
#if 0
	NSLog(@"Repo %@", dictionary);
#endif
	
	GSObjectAssign(dictionary, @"owner", _owner, GSUser);
	
	GSAssign(dictionary, @"name", _name);
	
	// API is inconsistent here
	// sometimes "name" represents User/RepoName
	// sometimes "name" just represents RepoName
	// full_name variable also exists, sometimes.
	
	if (!_name) {
		NSLog(@"%@", dictionary);
	}
	
	NSRange inconsistencyFix = [_name rangeOfString:@"/"];
	
	if (!_owner) {
		if (inconsistencyFix.location != NSNotFound) {
			NSString *username = [_name substringToIndex:inconsistencyFix.location];
			// may have to be an organization in the future, BEWARE MAX
			GSUser *user = [[GSUser alloc] initWithDictionary:@{@"login": username }];
			[user updateSynchronouslyWithError:nil];
			_owner = user;
		}
		else {
			NSLog(@"Repo with no owner???");
			GSAssert();
		}
	}
	
	if (inconsistencyFix.location != NSNotFound) {
		_name = [_name substringFromIndex:inconsistencyFix.location + 1];
	}
							  
	GSURLAssign(dictionary, @"html_url", _browserURL);
	GSURLAssign(dictionary, @"homepage", _browserHomepageURL);
	GSURLAssign(dictionary, @"ssh_url", _sshURL);
	GSURLAssign(dictionary, @"git_url", _gitURL);
    GSURLAssign(dictionary, @"branches_url", _branchesAPIURL);
	GSAssign(dictionary, @"language", _language);
	GSAssign(dictionary, @"description", _userDescription);
	GSAssign(dictionary, @"open_issues_count", _numberOfOpenIssues);
	GSAssign(dictionary, @"watchers_count", _numberOfWatchers);
	GSAssign(dictionary, @"stargazers_count", _numberOfStargazers);
	GSAssign(dictionary, @"size", _repositorySize);
	GSAssign(dictionary, @"forks_count", _numberOfForks);
	GSAssign(dictionary, @"default_branch", _defaultBranch);
    
    //TODO: Come up with a better way of handling this
    if (dictionary[@"branches_url"]) {
        _branchesAPIURL = [NSURL URLWithString:[dictionary[@"branches_url"] stringByReplacingOccurrencesOfString:@"{/branch}" withString:@""]];
    }
	
	NSDictionary *permissions = nil;
	GSAssign(dictionary, @"permissions", permissions);
	BOOL admin = [permissions[@"admin"] boolValue];
	BOOL pull = [permissions[@"pull"] boolValue];
	BOOL push = [permissions[@"push"] boolValue];
	
	GSRepositoryPermissions perms = GSRepositoryPermissionsNone;
	
	if (admin) perms |= GSRepositoryPermissionsAdmin;
	if (pull)  perms |= GSRepositoryPermissionsPull;
	if (push)  perms |= GSRepositoryPermissionsPush;
	_permissions = perms;
	
	NSNumber *hasDownloads = nil, *hasIssues = nil, *hasPages = nil, *hasWiki = nil;
	GSAssign(dictionary, @"has_downloads", hasDownloads);
	GSAssign(dictionary, @"has_issues", hasIssues);
	GSAssign(dictionary, @"has_pages", hasPages);
	GSAssign(dictionary, @"has_wiki", hasWiki);
	
	_downloadsAvailable	= [hasDownloads boolValue];
	_issuesAvailable	= [hasIssues boolValue];
	_pagesAvailable		= [hasPages boolValue];
	_wikiAvailable		= [hasWiki boolValue];
	
	NSNumber *isFork = nil;
	GSAssign(dictionary, @"fork", isFork);
	_fork = [isFork boolValue];
}

- (NSString *)pathString {
#if API_TRUST_LEVEL >= 1
	// return name retrieved from github
#endif
	return [NSString stringWithFormat:@"%@/%@", _owner.username, _name];
}

- (NSString *)defaultBranchOrMaster {
	if (!_defaultBranch)
		return @"master";
	return _defaultBranch;
}

- (BOOL)isFull {
	// need to establish criteriae for this.
	// If we have the full packet on the first go,
	// then an update can be backgrounded and not waited on
	// I've never seen archive_url as null. This'll improve in time.
	return !!(self.archiveAPIURL);
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; name = %@;>", NSStringFromClass([self class]), (void *)self, [self pathString]];
}

@end
