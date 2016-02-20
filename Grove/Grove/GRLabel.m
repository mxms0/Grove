//
//  GRLabel.m
//  Grove
//
//  Created by Max Shavrick on 2/20/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRLabel.h"

@implementation GRLabel

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[self.attributedString drawWithRect:rect options:(NSStringDrawingUsesLineFragmentOrigin) context:nil];
	
}

@end
