//
//  GRRepositoryViewSelector.m
//  Grove
//
//  Created by Max Shavrick on 1/15/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryViewSelector.h"

@implementation GRRepositoryViewSelector {
	UILabel *currentViewLabel;
	GRRepositoryViewSelectorType currentViewType;
}

- (instancetype)init {
	if ((self = [super init])) {
		currentViewType = GRRepositoryViewSelectorTypeCodeView;
		currentViewLabel = [[UILabel alloc] init];
		[currentViewLabel setTextAlignment:NSTextAlignmentCenter];
		[currentViewLabel setText:[self _stringForViewType:currentViewType]];

		for (UIView *v in @[currentViewLabel]) {
			[self addSubview:v];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[currentViewLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (NSString *)_stringForViewType:(GRRepositoryViewSelectorType)type {
	NSString *ret = nil;
	switch (type) {
		case GRRepositoryViewSelectorTypeCodeView:
			ret = @"Code";
			break;
		case GRRepositoryViewSelectorTypeIssuesView:
			ret = @"Issues";
			break;
		case GRRepositoryViewSelectorTypePullRequestsView:
			ret = @"Pull Request";
			break;
		default:
			ret = @"Unknown";
			break;

	}
	return ret;
}

@end
