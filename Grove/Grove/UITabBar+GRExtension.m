//
//  UITabBar+GRExtension.m
//  Grove
//
//  Created by Rocco Del Priore on 8/21/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "UITabBar+GRExtension.h"

@implementation UITabBar (GRExtensions)

static BOOL addedShadowLayer = NO;

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    if (self.layer == layer) {
        if (!addedShadowLayer) {
			
			CALayer *fillLayer = [CALayer layer];
			[fillLayer setBackgroundColor:[UIColor colorWithRed:.1 green:.1 blue:.1 alpha:.05].CGColor];
			[fillLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
			[self.layer addSublayer:fillLayer];
			
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.colors = @[(id)[UIColor colorWithWhite:1 alpha:1].CGColor, (id)[UIColor colorWithWhite:1 alpha:.1].CGColor, (id)[[UIColor colorWithWhite:1 alpha:0] CGColor],  (id)[[UIColor whiteColor] CGColor], (id)[[UIColor whiteColor] CGColor]];
			gradient.locations = @[@(0), @(.1), @(.35), @(.8), @(1)];
			
			gradient.opacity = .8;
			
            [self.layer addSublayer:gradient];
			
			CALayer *borderLayer = [CALayer layer];
			[borderLayer setBackgroundColor:[UIColor colorWithWhite:.2 alpha:.4].CGColor];
			[borderLayer setFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
			[self.layer addSublayer:borderLayer];
			
			for (int i = 1; i < 3; i++) {
				CALayer *divider1 = [CALayer layer];
				[divider1 setBackgroundColor:[UIColor lightGrayColor].CGColor];
				[divider1 setFrame:CGRectMake(i * floorf(self.frame.size.width/3), 10, 1, self.frame.size.height - 10*2)];
				[self.layer addSublayer:divider1];
			}
			
			// I will come up with a much better way to do this or your money back – max
			
			addedShadowLayer = YES;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
