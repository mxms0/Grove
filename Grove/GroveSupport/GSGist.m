//
//  GSGist.m
//  GroveSupport
//
//  Created by Max Shavrick on 9/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSGist.h"
#import "GroveSupportInternal.h"

@implementation GSGist

- (void)configureWithDictionary:(NSDictionary *)dictionary {
	[super configureWithDictionary:dictionary];
	NSString *_publiclyAccessibleFlag = nil;
	GSAssign(dictionary, @"public", _publiclyAccessibleFlag);
	GSAssign(dictionary, @"description", _stringDescription);
	
	_publiclyAccessible = [_publiclyAccessibleFlag boolValue];
}

@end
