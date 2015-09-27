//
//  GRNotificationTableViewCell.h
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, GRNotificationTableViewCellPosition) {
	GRNotificationTableViewCellTop = 1 << 0,
	GRNotificationTableViewCellMiddle = 1 << 1,
	GRNotificationTableViewCellBottom = 1 << 2
};


@interface GRNotificationTableViewCell : UITableViewCell {
	CAShapeLayer *boundingLayer;
	CGRect adjustedFrame;
}
@property (nonatomic, unsafe_unretained, setter=setPosition:) GRNotificationTableViewCellPosition position;
@end
