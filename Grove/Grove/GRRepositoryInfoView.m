//
//  GRRepositoryInfoView.m
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryInfoView.h"
#import "GRRepositoryInfoModel.h"
#import "GRRepositoryInfoViewHeaderView.h"

@implementation GRRepositoryInfoView {
	UITableView *tableView;
	GRRepositoryInfoModel *model;
}

- (void)commonInit {
	[super commonInit];
	tableView = [[UITableView alloc] init];
	[tableView setDelegate:self];
	[tableView setDataSource:self];
	[self addSubview:tableView];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[tableView setFrame:self.bounds];
}

- (void)setRepository:(GSRepository *)repository {
	model = [[GRRepositoryInfoModel alloc] initWithRepository:repository];
}

- (void)reloadView {
	[tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [(GRRepositoryInfoModel *)model numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [(GRRepositoryInfoModel *)model numberOfSections];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	GRRepositoryInfoViewHeaderView *header = [[GRRepositoryInfoViewHeaderView alloc] init];
	NSString *sectionLabel = [model sectionLabelForSection:section];
	[header setText:sectionLabel];
	return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"infoCell"];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
	}
	
	switch (indexPath.row) {
		case 0: {

		}
		default:
			break;
	}
	
	return cell;
}

@end
