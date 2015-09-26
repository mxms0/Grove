//
//  GRNotificationTableViewCell.m
//  
//
//  Created by Max Shavrick on 9/26/15.
//
//

#import "GRNotificationTableViewCell.h"

@implementation GRNotificationTableViewCell

static CGFloat GRNotificationTableViewCellPadding = 20.0f;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		[self setBackgroundColor:[UIColor clearColor]];
		[[self contentView] setBackgroundColor:[UIColor whiteColor]];
		self.separatorInset = UIEdgeInsetsMake(0, 20.0f, 0, 20.0f);
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	adjustedFrame = CGRectMake(0, 0, frame.size.width - GRNotificationTableViewCellPadding * 2, frame.size.height);
}

- (void)setPosition:(GRNotificationTableViewCellPosition)position {
	
	if (position == GRNotificationTableViewCellMiddle) {
		NSLog(@"middle");
		self.contentView.layer.mask = nil;
		return;
	}

	UIRectCorner corners = 0;
	
	if (position & GRNotificationTableViewCellTop) {
		NSLog(@"top");
		corners |= UIRectCornerTopLeft;
		corners |= UIRectCornerTopRight;
	}
	
	if (position & GRNotificationTableViewCellBottom) {
		NSLog(@"bottom");
		corners |= UIRectCornerBottomLeft;
		corners |= UIRectCornerBottomRight;
	}
	
	CGSize cornerSize = CGSizeMake(10.0, 10.0);
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:adjustedFrame byRoundingCorners:corners cornerRadii:cornerSize];
	
	boundingLayer = [CAShapeLayer layer];
	boundingLayer.frame = adjustedFrame;
	boundingLayer.path = maskPath.CGPath;
	
	[[[self contentView] layer] setMask:boundingLayer];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.contentView setFrame:CGRectMake(20, self.contentView.frame.origin.y, self.contentView.frame.size.width - 40, self.contentView.frame.size.height)];
	
	boundingLayer.frame = adjustedFrame;
}

@end
