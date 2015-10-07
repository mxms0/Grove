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
}

- (NSString *)pathString {
	return [NSString stringWithFormat:@"%@/%@", _owner.username, _name];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; name = %@;>", NSStringFromClass([self class]), self, [self pathString]];
}

@end
