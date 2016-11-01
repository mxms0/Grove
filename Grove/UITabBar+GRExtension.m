//
//  UITabBar+GRExtension.m
//  Grove
//
//  Created by Rocco Del Priore on 8/21/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "UITabBar+GRExtension.h"

@implementation UITabBar (GRExtensions)

static UIView *gradientBackgroundView = nil;

//- (instancetype)initWithFrame:(CGRect)frame {
//	if ((self = [super initWithFrame:frame])) {
	
//		gradientBackgroundView = [[UIView alloc] init];
//		
//		CALayer *fillLayer = [CALayer layer];
//		[fillLayer setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0].CGColor];
//		[gradientBackgroundView.layer addSublayer:fillLayer];
//		
//		CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//		gradientLayer.colors = @[(id)[UIColor colorWithWhite:1 alpha:1].CGColor, (id)[UIColor colorWithRed:254/255.0 green:254/255.0 blue:254/255.0 alpha:1].CGColor];
//		gradientLayer.locations = @[@(0), @(.86)];
//		gradientLayer.name = @"GradientLayer";
//		
//		[gradientBackgroundView.layer addSublayer:gradientLayer];
//		
//		for (int i = 1; i < 3; i++) {
//			CALayer *divider = [CALayer layer];
//			[divider setName:@"DividerLayer"];
//			[divider setBackgroundColor:[UIColor colorWithWhite:.95 alpha:1].CGColor];
//			[gradientBackgroundView.layer addSublayer:divider];
//		}
//		
//		CALayer *borderLayer = [CALayer layer];
//		[borderLayer setFrame:CGRectMake(0, 0, 0, .5)];
//		[borderLayer setBackgroundColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0].CGColor];
//		[gradientBackgroundView.layer addSublayer:borderLayer];
//		
//		[self addSubview:gradientBackgroundView];
//	}
//	
//	return self;
//}

//- (CGSize)sizeThatFits:(CGSize)size {
//	CGSize sizeThatFits = [super sizeThatFits:size];
//	sizeThatFits.height = 64;
	
	//	return sizeThatFits;
	//}

//- (void)layoutSubviews {
//	[super layoutSubviews];
//	[gradientBackgroundView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//	int idx = 1;
//	for (CALayer *layer in [[gradientBackgroundView layer] sublayers]) {
//		if ([[layer name] isEqualToString:@"DividerLayer"]) {
//			[layer setFrame:CGRectMake(idx * floorf(self.frame.size.width/3), 0, 1, self.frame.size.height)];
//			idx++;
//		}
//		else if ([[layer name] isEqualToString:@"GradientLayer"]) {
//			[layer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//		}
//		else {
//			[layer setFrame:CGRectMake(0, 0, self.frame.size.width, layer.frame.size.height)];
//		}
//	}
//}

@end
