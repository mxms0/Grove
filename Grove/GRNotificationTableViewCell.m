//
//  GRNotificationTableViewCell.m
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationTableViewCell.h"
#import <GroveSupport/GSNotification.h>

@implementation GRNotificationTableViewCell

- (void)setNotification:(GSNotification *)notif {
	self.textLabel.text = [notif title];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
}

@end
