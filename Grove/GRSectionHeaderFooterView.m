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
//	NSString* text;
	UILabel* label;
}

- (instancetype)initWithFrame:(CGRect)frame mode:(GRSectionHeaderFooterMode)_mode text:(NSString*)_text
{
	mode = _mode;
//	text = _text;
	
	label = [[UILabel alloc] init];
	[label setText:_text];
	[label setBackgroundColor:[UIColor whiteColor]];
	
	self = [super initWithFrame:frame];
	if (self) {
		[self setBackgroundColor:[UIColor whiteColor]];
		
		[self addSubview:label];
	}
	return self;
}

-(void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setClipsToBounds:YES];
	[self setBackgroundColor:[UIColor whiteColor]];
	
	[label setFrame:CGRectMake(0, self.bounds.size.height/2.0, self.bounds.size.width/2.0, self.bounds.size.height/2.0)];
	
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
