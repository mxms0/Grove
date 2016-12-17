//
//  GRGroupedTableViewCellContentView.m
//  Grove
//
//  Created by Max Shavrick on 11/15/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRGroupedTableViewCellContentView.h"

@implementation GRGroupedTableViewCellContentView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[GRColorFromRGB(0xF0F0F0) set];
	UIRectFill(CGRectMake(20, rect.size.height - .5, rect.size.width - 2 * 20, .5));
}

@end
