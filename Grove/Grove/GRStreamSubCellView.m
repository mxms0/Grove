//
//  GRStreamSubCellView.m
//  Grove
//
//  Created by Max Shavrick on 3/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRStreamSubCellView.h"
#import "GRLabel.h"

@implementation GRStreamSubCellView {
	UIImageView *imageView;
	GRLabel *label;
	BOOL activeTouch;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self commonInit];
		// XXX: the accounting for the re-sizability of this view does not exist.
		// It will always be sized for the case where there is 3+ lines of text. 
	}
	return self;
}

- (void)commonInit {
	
	[self setBackgroundColor:GRColorFromRGB(0xF3F3F3)];
	
	label = [[GRLabel alloc] init];
	imageView = [[UIImageView alloc] init];
	
	for (UIView *v in @[label, imageView]) {
		[self addSubview:v];
	}
	
	self.layer.mask = [[CAShapeLayer alloc] init];
}

- (void)setImage:(UIImage *)image {
	[imageView setImage:image];
}

- (void)setText:(NSString *)text {
	if (!text) return;
	NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: [UIColor blackColor]}];
	[label setAttributedString:string];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer.mask;
	
	shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(3.0, 3.0)].CGPath;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[imageView setHidden:(!self.image)];

	CGFloat leftOffsetUsed = GRGenericHorizontalPadding;
	
	if (self.image) {
		[imageView setFrame:CGRectMake(leftOffsetUsed, GRGenericHorizontalPadding, 35, 35)];
		
		leftOffsetUsed += imageView.frame.size.width;
		leftOffsetUsed += GRGenericHorizontalPadding;
	}
	
	[label setFrame:CGRectMake(leftOffsetUsed, GRGenericVerticalPadding, self.frame.size.width - (leftOffsetUsed + GRGenericHorizontalPadding), self.frame.size.height - floorf(GRGenericVerticalPadding/2))];
}

- (void)setCurrentlyBeingTouched:(BOOL)touched {
	if (touched) {
		[self setBackgroundColor:GRColorFromRGB(0xDDDDDD)];
	}
	else {
		[self setBackgroundColor:GRColorFromRGB(0xF3F3F3)];
	}
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self setCurrentlyBeingTouched:YES];
	[super touchesCancelled:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	[self setCurrentlyBeingTouched:NO];
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self setCurrentlyBeingTouched:NO];
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[self setCurrentlyBeingTouched:NO];
	[super touchesCancelled:touches withEvent:event];
}

@end
