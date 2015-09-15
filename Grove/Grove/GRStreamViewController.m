//
//  GRStreamViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "GRStreamViewController.h"
#import "GREventViewController.h"
#import "GREventCellModel.h"
#import "GRStreamEventCell.h"
#import "GRStreamModel.h"

static NSString *reuseIdentifier = @"reuseIdentifier";

@implementation GRStreamViewController {
    UITableView *tableView;
    GRStreamModel *model;
}

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    if (self) {
        //Initialze Variables
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        model = [[GRStreamModel alloc] init];
        
        //Set Properties
        [model setDelegate:self];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [tableView registerClass:[GRStreamEventCell class] forCellReuseIdentifier:reuseIdentifier];
        
        //Add Subviews
        for (UIView *view in @[tableView]) {
            [self.view addSubview:view];
        }

        //Set Constraints
        [tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
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
    [cell configureWithEventModel:[model eventCellModelForIndexPath:indexPath]];
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GREventViewController *viewController = [[GREventViewController alloc] initWithEvent:[model eventCellModelForIndexPath:indexPath].event];
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - GRStreamModel Delegate

- (void)reloadData {
	// this is a temporary solution
	// perhaps make GSGitHubEngine function only on one thread
	dispatch_async(dispatch_get_main_queue(), ^ {
		[tableView reloadData];
	});
}

@end