//
//  GRNotificationTableViewCell.h
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSNotification;
@interface GRNotificationTableViewCell : UITableViewCell {
	CAShapeLayer *boundingLayer;
	CGRect adjustedFrame;
}
- (void)setNotification:(GSNotification *)notif;
@end
