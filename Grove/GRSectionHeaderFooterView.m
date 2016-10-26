//
//  GRSectionHeaderFooterView.m
//  Grove
//
//  Created by Jim Boulter on 10/25/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRSectionHeaderFooterView.h"

@implementation GRSectionHeaderFooterView {
	GRSectionHeaderFooterMode mode;
}

- (instancetype)initWithFrame:(CGRect)frame mode:(GRSectionHeaderFooterMode)_mode
{
	mode = _mode;
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor whiteColor]];
	}
	return self;
}

-(void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setClipsToBounds:YES];
	[self setBackgroundColor:[UIColor whiteColor]];
	
	UIRectCorner rc = (mode == GRSectionHeaderMode ? UIRectCornerTopLeft | UIRectCornerTopRight : UIRectCornerBottomLeft | UIRectCornerBottomRight);
	
	UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
											   byRoundingCorners:rc
													 cornerRadii:CGSizeMake(10, 10)];
	
	CAShapeLayer* sl = [[CAShapeLayer alloc] init];
	sl.frame = self.bounds;
	sl.path = path.CGPath;
	self.layer.mask = sl;
}

@end
