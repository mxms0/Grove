//
//  GRRepositoryInfoView.m
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryInfoView.h"
#import "GRRepositoryInfoViewHeaderView.h"
#import "GRRepositoryReadMeCell.h"

static NSString *const GRRepositoryInfoReadMeCellIdentifier = @"readMeCell";
static NSString *const GRRepositoryInfoRegularCellIdentifier = @"infoCell";

@implementation GRRepositoryInfoView {
	UITableView *tableView;
	GRRepositoryInfoModel *model;
	BOOL hasDescription;
	CGFloat readMeCellHeight;
}

- (void)commonInit {
	[super commonInit];
	tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	
	[tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:GRRepositoryInfoRegularCellIdentifier];
	[tableView registerClass:[GRRepositoryReadMeCell class] forCellReuseIdentifier:GRRepositoryInfoReadMeCellIdentifier];
	
	[tableView setDelegate:self];
	[tableView setDataSource:self];
	[self addSubview:tableView];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[tableView setFrame:self.bounds];
}

- (CGFloat)allottedWidthForReadMeLabel {
	return self.frame.size.width - 2 * GRGenericHorizontalPadding;
}

- (void)setReadmeCellHeight:(CGFloat)height {
	readMeCellHeight = height;
	[tableView reloadData];
}

- (void)setRepository:(GSRepository *)repository {
	if (!repository) {
		model = nil;
	}
	else {
		model = [[GRRepositoryInfoModel alloc] initWithRepository:repository];
	}
	[model setDelegate:self];
	hasDescription = !!([model repositoryDescription]);
}

- (void)reloadView {
	hasDescription = !!([model repositoryDescription]);
	[tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [(GRRepositoryInfoModel *)model numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [(GRRepositoryInfoModel *)model numberOfSections];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (!hasDescription || section != 0) return nil;
	
	UIView *base = [[UIView alloc] init];
	
	UILabel *label = [[UILabel alloc] init];
	[label setText:[model repositoryDescription]];
	
	[label setFrame:CGRectMake(GRGenericHorizontalPadding, GRGenericVerticalPadding, self.frame.size.width - 2 * GRGenericHorizontalPadding, 45 - 2 * GRGenericVerticalPadding)];
	
	[base addSubview:label];
	
	return base;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (hasDescription)
		return 45.0;
	return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		return (readMeCellHeight == 0.0 ? 45.0f : readMeCellHeight + GRGenericVerticalPadding * 2 + 5); // readmeString height + header label
	}
	return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BOOL isReadMeCell = (indexPath.section == 1);
	
	NSString *reuseIdentifier = GRRepositoryInfoRegularCellIdentifier;
	
	if (isReadMeCell) {
		reuseIdentifier = GRRepositoryInfoReadMeCellIdentifier;
	}
	
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	}
	
	if (isReadMeCell) {
		[model setReadMeCell:(GRRepositoryReadMeCell *)cell];
	}
	
	
	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
	// expand README cell
}

@end
