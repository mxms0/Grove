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
	UILabel* label;
}

- (instancetype)initWithFrame:(CGRect)frame mode:(GRSectionHeaderFooterMode)_mode text:(NSString*)_text
{
	mode = _mode;
	
	label = [[UILabel alloc] init];
	[label setText: [@"  " stringByAppendingString:_text]];
	[label setBackgroundColor:[UIColor whiteColor]];
	
	self = [super initWithFrame:frame];
	if (self) {
		[self addSubview:label];
	}
	return self;
}

-(void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setClipsToBounds:YES];
	
	CGFloat y = 0;
	CGFloat ratio = .8;
	
	if(mode == GRSectionHeaderMode) {
		y = self.bounds.size.height*(1.0-ratio);
	}
	
	[label setFrame:CGRectMake(0, y, self.bounds.size.width, self.bounds.size.height*ratio)];
	
	UIRectCorner rc = (mode == GRSectionHeaderMode ? UIRectCornerTopLeft | UIRectCornerTopRight : UIRectCornerBottomLeft | UIRectCornerBottomRight);
	
	UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:label.bounds
											   byRoundingCorners:rc
													 cornerRadii:CGSizeMake(10, 10)];
	
	CAShapeLayer* sl = [[CAShapeLayer alloc] init];
	sl.frame = self.bounds;
	sl.path = path.CGPath;
	label.layer.mask = sl;
}

@end
