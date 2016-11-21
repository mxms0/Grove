//
//  GRRepositoryInfoView.m
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryInfoView.h"
#import "GRRepositoryInfoViewHeaderView.h"
#import "GRRepositoryInfoModel.h"
#import "GRRepositoryReadMeCell.h"

static NSString *const GRRepositoryInfoReadMeCellIdentifier = @"readMeCell";
static NSString *const GRRepositoryInfoRegularCellIdentifier = @"infoCell";

@implementation GRRepositoryInfoView {
	UITableView *tableView;
	BOOL hasDescription;
	CGFloat readMeCellHeight;
	UILabel* emptyLabel;
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

-(Class)designatedModelClass {
	return [GRRepositoryInfoModel class];
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
	[super setRepository:repository];
	hasDescription = !!([(GRRepositoryInfoModel*)_model repositoryDescription]);
}

- (void)reloadView {
	hasDescription = !!([(GRRepositoryInfoModel*)_model repositoryDescription]);
	[tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [(GRRepositoryInfoModel *)_model numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [(GRRepositoryInfoModel *)_model numberOfSections];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (!hasDescription || section != 0) return nil;
	
	UIView *base = [[UIView alloc] init];
	
	UILabel *label = [[UILabel alloc] init];
	[label setText:[(GRRepositoryInfoModel*)_model repositoryDescription]];
	
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
	
	GRRepositoryInfoModel* model = (GRRepositoryInfoModel*)_model;
	
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
