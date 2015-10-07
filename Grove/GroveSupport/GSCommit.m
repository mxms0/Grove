//
//  GSCommit.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSCommit.h"
#import "GroveSupportInternal.h"

@implementation GSCommit

- (void)configureWithDictionary:(NSDictionary *)dictionary {
	[super configureWithDictionary:dictionary];
	GSAssign(dictionary, @"sha", _shaHash);
	GSAssign(dictionary, @"message", _message);
	
	NSString *distinctKey = nil;
	GSAssign(dictionary, @"distinct", distinctKey);
	_distinct = [distinctKey boolValue];
}

@end
