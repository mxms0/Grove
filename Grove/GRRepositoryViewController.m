//
//  GRRepositoryViewController.m
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRRepositoryViewController.h"
#import "GRRepositoryHeaderView.h"
#import "GRRepositoryFileBrowserView.h"
#import "GRRepositoryInfoView.h"
#import "GRRepositoryIssuesView.h"
#import "GRRepositoryPullRequestView.h"
#import "GRRepositoryCommitsView.h"

#import <GroveSupport/GroveSupport.h>

static const CGFloat GRHeaderHeight = 36.0f;

@implementation GRRepositoryViewController {
	GRRepositoryHeaderView *header;
	GRRepositoryViewSelector *viewSelector;
	GRRepositoryFileBrowserView *fileBrowser;
	GRRepositoryInfoView *infoView;
	GRRepositoryCommitsView *commitsView;
	GRRepositoryPullRequestView *pullRequestView;
	GRRepositoryIssuesView *issuesView;
	GRRepositoryGenericSectionView *currentSectionView;
	GRRepositoryViewSelectorType currentViewType;
}

- (instancetype)init {
	if ((self = [super init])) {
		header = [[GRRepositoryHeaderView alloc] init];
		[header setBackgroundColor:GSRandomUIColor()];
		
		self.edgesForExtendedLayout = UIRectEdgeNone;
		
		viewSelector = [[GRRepositoryViewSelector alloc] init];
		[viewSelector setDelegate:self];
		
		infoView = [[GRRepositoryInfoView alloc] init];
		
		currentSectionView = infoView;
	}
	return self;
}

- (instancetype)initWithRepositoryName:(NSString *)name owner:(NSString *)owner {
	if ((self = [self init])) {
		NSLog(@"%s NOT IMPLEMENTED.", __PRETTY_FUNCTION__);
	}
	
	return self;
}

- (void)setRepository:(GSRepository *)newRepository {
	[_repository removeObserver:self forKeyPath:GSUpdatedDateKey];
	
	_repository = newRepository;
	[_repository addObserver:self forKeyPath:GSUpdatedDateKey options:0 context:NULL];
	[_repository updateWithCompletionHandler:^(NSError * _Nullable error) {
		if (error) {
			[self presentErrorAndDismissIfPossible:error];
		}
	}];
	
	[infoView setRepository:newRepository];
	[fileBrowser setRepository:newRepository];
	[header setRepositoryName:_repository.name];
	[header setRepositoryOwner:_repository.owner.username];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// only case right now should be to dismiss, so let's just dismiss... .-.
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewSelector:(GRRepositoryViewSelector *)selector didChangeToViewType:(GRRepositoryViewSelectorType)viewType {
	if (currentViewType == viewType) return;
	currentViewType = viewType;
	
	[currentSectionView removeFromSuperview];
	
	GRRepositoryGenericSectionView *viewToSwitch = nil;
	
	switch (viewType) {
		case GRRepositoryViewSelectorTypeCodeView:
			viewToSwitch = [self _presentCodeView];
			break;
		case GRRepositoryViewSelectorTypeInfoView:
			viewToSwitch = [self _presentInfoView];
			break;
		case GRRepositoryViewSelectorTypeIssuesView:
			viewToSwitch = [self _presentIssuesView];
			break;
		case GRRepositoryViewSelectorTypeCommitsView:
			viewToSwitch = [self _presentCommitsView];
			break;
		case GRRepositoryViewSelectorTypePullRequestsView:
			viewToSwitch = [self _presentPullRequestsView];
			break;
		default:
			break;
	}
	
	currentSectionView = viewToSwitch;
	
	[self.view addSubview:currentSectionView];
	
	[self properLayoutSubviews];
}

- (GRRepositoryGenericSectionView *)_presentIssuesView {
	if (!issuesView) {
		issuesView = [[GRRepositoryIssuesView alloc] init];
		[issuesView setRepository:_repository];
	}
	
	return issuesView;
}

- (GRRepositoryGenericSectionView *)_presentCommitsView {
	if (!commitsView) {
		commitsView = [[GRRepositoryCommitsView alloc] init];
		[commitsView setRepository:_repository];
	}
	return commitsView;
}

- (GRRepositoryGenericSectionView *)_presentPullRequestsView {
	if (!pullRequestView) {
		pullRequestView = [[GRRepositoryPullRequestView alloc] init];
		[pullRequestView setRepository:_repository];
	}

	return pullRequestView;
}

- (GRRepositoryGenericSectionView *)_presentInfoView {
	if (!infoView) {
		infoView = [[GRRepositoryInfoView alloc] init];
		[infoView setRepository:_repository];
	}
	
	return infoView;
}

- (GRRepositoryGenericSectionView *)_presentCodeView {
	if (!fileBrowser) {
		fileBrowser = [[GRRepositoryFileBrowserView alloc] init];
		[fileBrowser setRepository:_repository];
	}
	
	return fileBrowser;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	NSLog(@"Repository has new data %@:%@:%@", object, keyPath, change);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	for (UIView *v in @[header, currentSectionView, viewSelector]) {
		[self.view addSubview:v];
	}
}

- (void)properLayoutSubviews {
	
	CGFloat verticalOffsetUsed = GRStatusBarHeight();
	
	[header setFrame:CGRectMake(0, verticalOffsetUsed, self.view.frame.size.width, GRHeaderHeight)];
	
	verticalOffsetUsed += header.frame.size.height;
	
	[viewSelector setFrame:CGRectMake(0, verticalOffsetUsed, self.view.frame.size.width, 44.0f)];
	
	verticalOffsetUsed += viewSelector.frame.size.height;
	
	[currentSectionView setFrame:CGRectMake(0, verticalOffsetUsed, self.view.frame.size.width, self.view.frame.size.height - verticalOffsetUsed)];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self properLayoutSubviews];
}

- (void)dealloc {
	[self setRepository:nil];
}

@end
