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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {

	}
	return self;
}

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	[super _configureWithDictionary:dictionary];
	
	GSObjectAssign(dictionary, @"owner", _owner, GSUser);
	
	GSAssign(dictionary, @"name", _name);
	
	// API is inconsistent here
	// sometimes "name" represents User/RepoName
	// sometimes "name" just represents RepoName
	
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
}

- (NSString *)pathString {
#if API_TRUST_LEVEL >= 1
	// return name retrieved from github
#endif
	return [NSString stringWithFormat:@"%@/%@", _owner.username, _name];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; name = %@;>", NSStringFromClass([self class]), self, [self pathString]];
}

@end
