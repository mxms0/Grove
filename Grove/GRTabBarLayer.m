//
//  GRTabBarLayer.m
//  Grove
//
//  Created by Max Shavrick on 4/20/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRTabBarLayer.h"

@implementation GRTabBarLayer

- (void)drawInContext:(CGContextRef)ctx {
	[[UIColor blueColor] setFill];
	CGContextFillRect(ctx, CGRectMake(0, 0, 500, 500));
}

@end
