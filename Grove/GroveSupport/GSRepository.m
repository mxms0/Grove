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

- (void)configureWithDictionary:(NSDictionary *)dictionary {
	[super configureWithDictionary:dictionary];
	GSObjectAssign(dictionary, @"owner", _owner, GSUser);
	GSURLAssign(dictionary, @"html_url", _browserURL);
	GSAssign(dictionary, @"name", _name);
	// API is inconsistent here
	// sometimes "name" represents User/RepoName
	// sometimes "name" just represents RepoName
	if ([_name containsString:@"/"]) {
		
	}
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
