//
//  GRActiveUserProfileViewController.m
//  Grove
//
//  Created by Max Shavrick on 9/29/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRActiveUserProfileViewController.h"
#import "GRSessionManager.h"

@implementation GRActiveUserProfileViewController

- (instancetype)init {
	if ((self = [super init])) {
		[self setUser:[[[GRSessionManager sharedInstance] currentUser] user]];
	}
	return self;
}

- (BOOL)isDismissable {
	return NO;
}

@end
