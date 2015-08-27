//
//  GRProfileStatisticButton.m
//  Grove
//
//  Created by Max Shavrick on 8/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileStatisticButton.h"

#import <GroveSupport/GroveSupport.h>

@implementation GRProfileStatisticButton {
	UILabel *text;
	UILabel *subText;
}

- (void)setText:(NSString *)_text {
	[text setText:_text];
}

- (void)setSubText:(NSString *)_text {
	[subText setText:_text];
}

- (void)_commonInit {
	text = [[UILabel alloc] init];
	subText = [[UILabel alloc] init];

	[text setFont:[UIFont systemFontOfSize:20]];
	[text setTextAlignment:NSTextAlignmentCenter];
	[text setMinimumScaleFactor:0.5];
	
	[subText setTextAlignment:NSTextAlignmentCenter];
	[subText setFont:[UIFont systemFontOfSize:14]];
	[subText setMinimumScaleFactor:0.8];
	
	[text setBackgroundColor:GSRandomUIColor()];
	[subText setBackgroundColor:GSRandomUIColor()];
	
	[self addSubview:text];
	[self addSubview:subText];
}

- (instancetype)init {
	if ((self = [super init])) {
		[self _commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self _commonInit];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGFloat divisionFactor = 0.60;
	[text setFrame:CGRectMake(0, 0, self.frame.size.width, floorf(divisionFactor * self.frame.size.height))];
	[subText setFrame:CGRectMake(0, floorf(divisionFactor * self.frame.size.height), self.frame.size.width, self.frame.size.height - (floorf(divisionFactor * self.frame.size.height)))];
}

@end
