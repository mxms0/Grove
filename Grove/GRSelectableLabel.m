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
	self.lineBreakMode = NSLineBreakByTruncatingTail;
	
	[[self titleLabel] setTextAlignment:NSTextAlignmentLeft];
	// literally nothing anywhere about what to use instead
	// except NSAttributedString with paragraph styles
	self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	// what is this API...
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self setNeedsDisplay];
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self setNeedsDisplay];
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self setNeedsDisplay];
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self setNeedsDisplay];
	[super touchesCancelled:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	if (self.state & (UIControlStateHighlighted | UIControlStateSelected)) {
		[[UIColor blackColor] setFill];
		UIRectFill(rect);
	}
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
