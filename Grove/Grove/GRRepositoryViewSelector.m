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

		infoButton = [self _selectorButtonForViewType:GRRepositoryViewSelectorTypeInfoView];
		codeButton = [self _selectorButtonForViewType:GRRepositoryViewSelectorTypeCodeView];
		issuesButton = [self _selectorButtonForViewType:GRRepositoryViewSelectorTypeIssuesView];
		pullRequestsButton = [self _selectorButtonForViewType:GRRepositoryViewSelectorTypePullRequestsView];
		
		for (UIButton *v in @[infoButton, codeButton, issuesButton, pullRequestsButton]) {
			[self addSubview:v];
		}
	}
	return self;
}

- (UIButton *)_selectorButtonForViewType:(GRRepositoryViewSelectorType)tp {
	UIButton *btn = [[UIButton alloc] init];
	[btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btn addTarget:self action:@selector(genericButtonPress:) forControlEvents:UIControlEventTouchUpInside];
	[btn setTag:tp];
	NSString *titleString = nil;
	switch (tp) {
		case GRRepositoryViewSelectorTypeCodeView:
			titleString = @"code";
			break;
		case GRRepositoryViewSelectorTypeInfoView:
			titleString = @"info";
			break;
		case GRRepositoryViewSelectorTypeIssuesView:
			titleString = @"issues";
			break;
		case GRRepositoryViewSelectorTypePullRequestsView:
			titleString = @"pr";
			break;
		default:
			GSAssert();
			break;
	}
	[btn setTitle:titleString forState:UIControlStateNormal];
	return btn;
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
