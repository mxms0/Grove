//
//  GRProfileViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileViewController.h"
#import "GRProfileModel.h"
#import "GRProfileHeaderCell.h"
#import "GRSessionManager.h"

@implementation GRProfileViewController {
	GRProfileModel *model;
	UITableView *tableView;
}

- (instancetype)init {
	if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];
		model = [[GRProfileModel alloc] init];
		tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		[self.view addSubview:tableView];
		[tableView makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
		}];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
	return [model numberOfSections];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	return [model numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [model cellHeightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = @"stupidCell";
	BOOL isProfileCell = NO;
	Class tableCellClass = [UITableViewCell class];
	switch (indexPath.section) {
		case 0:
			reuseIdentifier = @"profileHeader";
			tableCellClass = [GRProfileHeaderCell class];
			isProfileCell = YES;
			break;
		case 1:
			break;
		case 2:
			break;
		default:
			break;
	}
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell) {
		cell = [[tableCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	}
	
	if (isProfileCell) {
		GRApplicationUser *user = [[GRSessionManager sharedInstance] currentUser];
		[(GRProfileHeaderCell *)cell configureWithUser:user];
	}
	
	

	return cell;
}

@end
