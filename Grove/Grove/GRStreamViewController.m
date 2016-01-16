//
//  GRStreamViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "GRStreamViewController.h"
#import "GREventViewControllerProxy.h"
#import "GREventCellModel.h"
#import "GRStreamEventCell.h"
#import "GRStreamModel.h"

static NSString *reuseIdentifier = @"reuseIdentifier";

@implementation GRStreamViewController {
    GRStreamModel *model;
	UIRefreshControl *refreshControl;
}

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        model = [[GRStreamModel alloc] init];
		
        [model setDelegate:self];
		
		[self.tableView registerClass:[GRStreamEventCell class] forCellReuseIdentifier:reuseIdentifier];
		
		refreshControl = [[UIRefreshControl alloc] init];
		[refreshControl addTarget:self action:@selector(refreshTableView:) forControlEvents:UIControlEventValueChanged];
		[self.tableView addSubview:refreshControl];
		
		REGISTER_RELOAD_VIEW(GRStreamViewControllerNotificationKey);
    }
    return self;
}

- (void)refreshTableView:(UIRefreshControl *)control {
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
	GREventCellModel *cellModel = [model eventCellModelForIndexPath:indexPath];
	[cellModel setTableCell:cell];
    [cell configureWithEventModel:[model eventCellModelForIndexPath:indexPath]];
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GREventViewControllerProxy *viewController = [[GREventViewControllerProxy alloc] initWithEvent:[model eventCellModelForIndexPath:indexPath].event];
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - GRStreamModel Delegate

- (void)reloadData {
	// this is a temporary solution
	// perhaps make GSGitHubEngine function only on one thread
	dispatch_async(dispatch_get_main_queue(), ^ {
		[refreshControl endRefreshing];
		[self.tableView reloadData];
	});
}

@end