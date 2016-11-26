//
//  GRPullToRefreshView.m
//  Grove
//
//  Created by Max Shavrick on 11/24/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRPullToRefreshView.h"

@implementation GRPullToRefreshView

- (instancetype)initWithTableView:(UITableView *)table {
	if ((self = [super init])) {
		[table addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
		[table addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionInitial context:nil];
	}
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
	// assume keyPath is the one we want... shouldn't be observing anything else anyways..
	if ([keyPath isEqualToString:@"contentOffset"]) {
		CGPoint newOfft = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
		[self scrollView:object offsetChanged:newOfft ];
	}
	NSLog(@"packet %@:%@", change, object);
//	else if ([keyPath isEqualToString:@"dragging"]) {
//		NSLog(@"packet: %@", change);
//	}
}

- (void)scrollView:(UIScrollView *)scroll offsetChanged:(CGPoint)offt {
	CGFloat absOfft = offt.y + scroll.contentInset.top;
	
	if (absOfft < -80) {
		// mark it as over the threshold to refresh upon release
	}
	
	NSLog(@"offt: %f", absOfft);
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	[[UIColor colorWithWhite:self.animationProgress alpha:1.0] set];
	UIRectFill(rect);
}

@end
