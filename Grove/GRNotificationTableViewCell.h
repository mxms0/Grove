//
//  GRNotificationTableViewCell.h
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRGroupedTableViewCell.h"

@class GSNotification;
@interface GRNotificationTableViewCell : GRGroupedTableViewCell {
	CAShapeLayer *boundingLayer;
	CGRect adjustedFrame;
}
- (void)setNotification:(GSNotification *)notif;
@end
