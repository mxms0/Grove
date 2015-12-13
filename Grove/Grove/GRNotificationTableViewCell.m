//
//  GRNotificationTableViewCell.m
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationTableViewCell.h"

@implementation GRNotificationTableViewCell

static CGFloat GRNotificationTableViewCellPadding = 15.0f;
static CGFloat GRNotificationTableViewCellCornerRadius = 4.0f;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		boundingLayer = [CAShapeLayer layer];
		boundingLayer.shouldRasterize = YES;
		
		[self setBackgroundColor:[UIColor clearColor]];
		[[self contentView] setBackgroundColor:[UIColor whiteColor]];
		self.separatorInset = UIEdgeInsetsMake(0, 20.0f, 0, 20.0f);
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[[[self contentView] layer] setBorderColor:GRColorFromRGB(0xd8d8d8).CGColor];
		[[[self contentView] layer] setBorderWidth:0.8f];
		
		[self.textLabel setFont:[UIFont systemFontOfSize:13]];
	}
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	adjustedFrame = CGRectMake(0, 0, frame.size.width - GRNotificationTableViewCellPadding * 2, frame.size.height);
}

- (void)setPosition:(GRNotificationTableViewCellPosition)position {
	
	if (position == GRNotificationTableViewCellMiddle) {
		self.contentView.layer.mask = nil;
		return;
	}

	UIRectCorner corners = 0;
	
	if (position & GRNotificationTableViewCellTop) {
		corners |= UIRectCornerTopLeft;
		corners |= UIRectCornerTopRight;
	}
	
	if (position & GRNotificationTableViewCellBottom) {
		corners |= UIRectCornerBottomLeft;
		corners |= UIRectCornerBottomRight;
	}
	
	CGSize cornerSize = CGSizeMake(GRNotificationTableViewCellCornerRadius, GRNotificationTableViewCellCornerRadius);
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:adjustedFrame byRoundingCorners:corners cornerRadii:cornerSize];
	
	boundingLayer.frame = adjustedFrame;
	boundingLayer.path = maskPath.CGPath;
	
	[[[self contentView] layer] setMask:boundingLayer];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.contentView setFrame:CGRectMake(10, self.contentView.frame.origin.y, self.contentView.frame.size.width - 20, self.contentView.frame.size.height)];
	
	[self.textLabel setFrame:CGRectMake(10, self.textLabel.frame.origin.y, self.contentView.frame.size.width - 20, self.textLabel.frame.size.height)];
	
	boundingLayer.frame = adjustedFrame;
}

@end
