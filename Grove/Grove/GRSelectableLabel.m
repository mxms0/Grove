//
//  GRSelectableLabel.m
//  Grove
//
//  Created by Max Shavrick on 3/1/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRSelectableLabel.h"

@implementation GRSelectableLabel

- (instancetype)init {
	if ((self = [super init])) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	
}

- (void)setFont:(UIFont *)font {
	[[self titleLabel] setFont:font];
}

- (void)setText:(NSString *)text {
	[self setTitle:text forState:UIControlStateNormal];
}

- (void)sizeToFit {
	const CGFloat fontSize = [[[self titleLabel] font] pointSize];
	
	const CGFloat padding = floorf((fontSize / 14) * 3.0);
	
	CGSize stringSize = [[[self titleLabel] text] boundingRectWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [[self titleLabel] font]} context:nil].size;
	
	[self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, stringSize.width + 2 * padding, stringSize.height + 2 * padding)];
}

@end
