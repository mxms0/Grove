//
//  GRApplicationUser.m
//  Grove
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRApplicationUser.h"
#import "GSObject.h"
#import "GroveSupportInternal.h"

@implementation GRApplicationUser

- (instancetype)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
		GSDecodeAssign(coder, @"users", _user);
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:_user forKey:@"users"];
}

@end
