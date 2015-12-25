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
			[fillLayer setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0].CGColor];
			[fillLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
			[self.layer addSublayer:fillLayer];
			
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
			gradient.colors = @[(id)[UIColor colorWithWhite:1 alpha:1].CGColor, (id)[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1].CGColor];
			gradient.locations = @[@(0), @(.86)];
			
            [self.layer addSublayer:gradient];
			
			for (int i = 1; i < 3; i++) {
				CALayer *divider1 = [CALayer layer];
				[divider1 setBackgroundColor:[UIColor colorWithWhite:.95 alpha:1].CGColor];
				[divider1 setFrame:CGRectMake(i * floorf(self.frame.size.width/3), 0, 1, self.frame.size.height)];
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
