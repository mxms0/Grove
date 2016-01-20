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
#import "UIImage+GRExtensions.h"

@implementation GRApplicationUser

- (instancetype)initWithCoder:(NSCoder *)coder {
	if ((self = [super init])) {
		GSDecodeAssign(coder, @"user", _user);
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	GSEncode(coder, @"user", _user);
}

- (void)prepareUnprocessedProfileImage:(UIImage *)image {
	self.profilePicture = [image imageByResizingToSize:CGSizeMake(200, 200) roundingCornerRadius:7];
}

@end
