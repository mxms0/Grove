//
//  GRRepositoryViewSelector.m
//  Grove
//
//  Created by Max Shavrick on 1/15/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryViewSelector.h"

@implementation GRRepositoryViewSelector {
	GRRepositoryViewSelectorType currentViewType;
	UIButton *infoButton;
	UIButton *codeButton;
	UIButton *issuesButton;
	UIButton *pullRequestsButton;
}

- (instancetype)init {
	if ((self = [super init])) {
		currentViewType = GRRepositoryViewSelectorTypeInfoView;

		infoButton = [[UIButton alloc] init];
		codeButton = [[UIButton alloc] init];
		issuesButton = [[UIButton alloc] init];
		pullRequestsButton = [[UIButton alloc] init];
		
		[infoButton setTitle:@"info" forState:UIControlStateNormal];
		[codeButton setTitle:@"code" forState:UIControlStateNormal];
		[issuesButton setTitle:@"issues" forState:UIControlStateNormal];
		[pullRequestsButton setTitle:@"pr" forState:UIControlStateNormal];
		
		for (UIButton *v in @[infoButton, codeButton, issuesButton, pullRequestsButton]) {
			[v setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[self addSubview:v];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	int idx = 0;
	NSArray *buttons = @[infoButton, codeButton, issuesButton, pullRequestsButton];
	CGFloat buttonWidth = floorf(self.frame.size.width / [buttons count]);
	for (UIView *btn in buttons) {
		[btn setFrame:CGRectMake(buttonWidth * idx, 0, buttonWidth, self.frame.size.height)];
		idx++;
	}
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
