//
//  GRNotificationTitleView.m
//  Grove
//
//  Created by Max Shavrick on 2/22/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRNotificationTitleView.h"
#import "GRSmallCapsLabel.h"

@implementation GRNotificationTitleView {
	GRSmallCapsLabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setBackgroundColor:[UIColor clearColor]];
		label = [[GRSmallCapsLabel alloc] init];
		[label setText:GRLocalizedString(@"notifications", nil, nil)];
		[self addSubview:label];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[label setFrame:CGRectMake(0, 10, self.frame.size.width, 15)];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	UIRectFill(CGRectMake(rect.size.width/2 - 15, label.frame.size.height + label.frame.origin.y + 5, 30, 1));
}

@end
