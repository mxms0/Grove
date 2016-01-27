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
		[infoButton setTag:GRRepositoryViewSelectorTypeInfoView];
		[codeButton setTitle:@"code" forState:UIControlStateNormal];
		[codeButton setTag:GRRepositoryViewSelectorTypeCodeView];
		[issuesButton setTitle:@"issues" forState:UIControlStateNormal];
		[issuesButton setTag:GRRepositoryViewSelectorTypeIssuesView];
		[pullRequestsButton setTitle:@"pr" forState:UIControlStateNormal];
		[pullRequestsButton setTag:GRRepositoryViewSelectorTypePullRequestsView];
		
		for (UIButton *v in @[infoButton, codeButton, issuesButton, pullRequestsButton]) {
			[v setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			[v addTarget:self action:@selector(genericButtonPress:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:v];
		}
	}
	return self;
}

- (void)genericButtonPress:(UIButton *)button {
	GRRepositoryViewSelectorType typ = (GRRepositoryViewSelectorType)[button tag];
	[self.delegate viewSelector:self didChangeToViewType:typ];
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
		case GRRepositoryViewSelectorTypeInfoView:
			ret = @"Info";
		default:
			ret = @"Unknown";
			break;

	}
	return ret;
}

@end
