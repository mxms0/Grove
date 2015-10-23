//
//  GRActiveUserProfileViewController.m
//  Grove
//
//  Created by Max Shavrick on 9/29/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRActiveUserProfileViewController.h"
#import "GRSessionManager.h"
#import <GroveSupport/GroveSupport.h>

@implementation GRActiveUserProfileViewController {
	GSUser *user;
}

- (instancetype)init {
	if ((self = [super init])) {
		[self setUser:[[[GRSessionManager sharedInstance] currentUser] user]];
	}
	return self;
}

- (void)setUser:(GSUser *)newUser {
	if (user) {
		[user removeObserver:self forKeyPath:GSUpdatedDataKey];
	}
	user = newUser;
	[user addObserver:self forKeyPath:GSUpdatedDataKey options:0 context:NULL];
	[user update];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	NSLog(@"user has new data %@:%@:%@", object, keyPath, change);
}


@end
