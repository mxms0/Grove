//
//  GRStreamViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "GRStreamViewController.h"
#import "GRStreamViewControllerProxy.h"
#import "GRStreamCellModel.h"
#import "GRStreamEventCell.h"
#import "GRStreamModel.h"

static NSString *reuseIdentifier = @"reuseIdentifier";

static const CGFloat GRStreamViewAvatarSize = 38.0f;

@implementation GRStreamViewController {
    GRStreamModel *model;
	UIRefreshControl *refreshControl;
	BOOL attemptingRefresh;
}

#pragma mark - Initializers

- (instancetype)init {
	if ((self = [super init])) {
		self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
		
		[self.tableView registerClass:[GRStreamEventCell class] forCellReuseIdentifier:reuseIdentifier];
		
		refreshControl = [[UIRefreshControl alloc] init];
		[refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
		
		[self setRefreshControl:refreshControl];
		
		GR_REGISTER_RELOAD_VIEW(GRStreamViewControllerNotificationKey);
		
		model = [[GRStreamModel alloc] initWithDelegate:self];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	// Remove seperator inset
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	// Prevent the cell from inheriting the Table View's margin settings
	if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
		[cell setPreservesSuperviewLayoutMargins:NO];
	}
	
	// Explictly set your cell's layout margins
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
    }
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