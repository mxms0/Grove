//
//  GRNotificationViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationViewController.h"
#import <GroveSupport/GroveSupport.h>
#import "GRSessionManager.h"
#import "GRNotificationTableViewCell.h"
#import "GRSmallCapsLabel.h"
#import "GRNotificationHeaderTableViewCell.h"
#import "GRNotificationTitleView.h"
#import "GRNotificationModel.h"
#import "GRSectionHeaderFooterView.h"
#import "GREmptySectionHeaderFooterView.h"

@implementation GRNotificationViewController {
	GRNotificationModel *model;
}

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:GRLocalizedString(@"Notifications", nil, nil) image:[UIImage imageNamed:@"tb@2x"] tag:0];
		
	}
	return self;
}

- (instancetype)init {
	if ((self = [super init])) {
        GRNotificationTitleView *headerView = [[GRNotificationTitleView alloc] init];
        [headerView setFrame:CGRectWithContentSize(headerView.intrinsicContentSize)];
        [self.tableView setTableHeaderView:headerView];
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	model = [[GRNotificationModel alloc] init];
	[model setDelegate:self];
	[model requestNewData];
}

- (void)reloadData {
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	Class headerClass = [GRSectionHeaderFooterView class];
	if ([model numberOfRowsInSection:section] == 0) {
		headerClass = [GREmptySectionHeaderFooterView class];
	}
	
	return [[headerClass alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [model heightForSectionHeader:section]) mode:GRSectionModeHeader text:[model titleForSection:section]];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	Class footerClass = [GRSectionHeaderFooterView class];
	
	if ([model numberOfRowsInSection:section] == 0) {
		footerClass = [GREmptySectionHeaderFooterView class];
	}
	
	return [[footerClass alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [model heightForSectionFooter:section]) mode:GRSectionModeFooter text:@""];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return [model heightForSectionHeader:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return [model heightForSectionFooter:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [model numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [model numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [model heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier       = @"notificationCell";
    static NSString *headerReuseIdentifier = @"notificationHeaderCell";
    NSString *activeIdentifier             = reuseIdentifier;
    BOOL isHeaderCell                      = (indexPath.row == 0);
    Class cellClass                        = [GRNotificationTableViewCell class];
    
	if (isHeaderCell) {
        activeIdentifier = headerReuseIdentifier;
        cellClass        = [GRNotificationHeaderTableViewCell class];
	}
	
	GRNotificationTableViewCell *cell = (GRNotificationTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:activeIdentifier];
	if (!cell) cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activeIdentifier];
	

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	GSNotification *notification = [model notificationAtIndexPath:indexPath];
        
	[cell setNotification:notification];
    
	[cell setNeedsLayout];
	
	return cell;
}

#pragma mark - GRTableViewController

- (BOOL)isDismissable {
	return NO;
}

@end
