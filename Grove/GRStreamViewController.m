//
//  GRStreamViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRStreamViewController.h"
#import "GRStreamViewControllerProxy.h"
#import "GRStreamCellModel.h"
#import "GRStreamEventCell.h"
#import "GRStreamModel.h"
#import "GRStreamTitleView.h"

static NSString *const reuseIdentifier      = @"reuseIdentifier";
static const CGFloat GRStreamViewAvatarSize = 38.0f;

@implementation GRStreamViewController {
    GRStreamModel *model;
	UIRefreshControl *refreshControl;
	BOOL attemptingRefresh;
}

#pragma mark - Initializers

- (instancetype)init {
	if ((self = [super init])) {
		
        self.tabBarItem               = [[UITabBarItem alloc] initWithTitle:GRLocalizedString(@"Home", nil, nil) image:[UIImage imageNamed:@"tb@2x"] tag:0];
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		[self.tableView registerClass:[GRStreamEventCell class] forCellReuseIdentifier:reuseIdentifier];
		
		refreshControl = [[UIRefreshControl alloc] init];
		[refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
		
		[self setRefreshControl:refreshControl];
		
		GR_RELOAD_VIEW_REGISTER(self, @selector(_reloadNotification));
		
		model = [[GRStreamModel alloc] initWithDelegate:self];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if (!attemptingRefresh) {
		[refreshControl endRefreshing];
	}
	else {
		[refreshControl endRefreshing];
		[refreshControl beginRefreshing];
		[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
		// UIRefreshControl is actually broken.
	}
}

- (void)refreshTableView:(UIRefreshControl *)control {
	attemptingRefresh = YES;
	[model requestNewData];
}

- (void)_reloadNotification {
	[self.tableView reloadData];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	GRStreamTitleView *headerView = [[GRStreamTitleView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 45)];
	
	[self.tableView setTableHeaderView:headerView];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return model.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [model numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GRStreamEventCell *cell = [aTableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
	
    if (!cell) {
        cell = [[GRStreamEventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
		// Cell is never actually null... ?_?
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	GRStreamCellModel *cellModel = [model eventCellModelForIndexPath:indexPath];
	[cellModel setFontSize:13];
	[cellModel setCellSize:CGSizeMake(aTableView.frame.size.width, 0)];
	[cellModel setAvatarSize:CGSizeMake(GRStreamViewAvatarSize, GRStreamViewAvatarSize)];
	[cellModel setTableCell:cell];
    [cell configureWithEventModel:[model eventCellModelForIndexPath:indexPath]];
	
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	GRStreamCellModel *cellModel = [model eventCellModelForIndexPath:indexPath];
    return [cellModel requiredTableCellHeight];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GRStreamViewControllerProxy *viewController = [[GRStreamViewControllerProxy alloc] initWithEvent:[model eventCellModelForIndexPath:indexPath].event];
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - GRStreamModel Delegate

- (void)reloadData {
	// this is a temporary solution
	// perhaps make GSGitHubEngine function only on one thread
	dispatch_async(dispatch_get_main_queue(), ^ {
		attemptingRefresh = NO;
		[refreshControl endRefreshing];
		[self.tableView reloadData];
	});
}

- (BOOL)isDismissable {
	return NO;
}

@end
