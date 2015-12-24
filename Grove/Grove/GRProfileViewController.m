//
//  GRProfileViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileViewController.h"
#import "GRProfileModel.h"
#import "GRProfileHeaderView.h"
#import "GRSessionManager.h"
#import <GroveSupport/GSGitHubEngine.h>
#import <GroveSupport/GroveSupport.h>

@implementation GRProfileViewController {
	GRProfileModel *model;
	UITableView *tableView;
}

- (instancetype)init {
	if ((self = [super init])) {
        self.view.backgroundColor = [UIColor blackColor];

		tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		[self.view addSubview:tableView];
		[tableView makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.view);
		}];
		tableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:245/255.0 blue:243/255.0 alpha:1];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	NSLog(@"user has new data %@:%@:%@", object, keyPath, change);
}

- (void)setUser:(GSUser *)newUser {
	if (self.user) {
		[self.user removeObserver:self forKeyPath:GSUpdatedDateKey];
	}
	_user = newUser;
	[self.user addObserver:self forKeyPath:GSUpdatedDateKey options:0 context:NULL];
	[self.user update];
	
	model = [[GRProfileModel alloc] initWithUser:self.user];
	[model setDelegate:self];
}

- (void)reloadData {
	[tableView reloadData];
	[(GRProfileHeaderView *)[tableView headerViewForSection:0] setUser:[model activeUser]];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [model titleForSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		GRProfileHeaderView *header = [[GRProfileHeaderView alloc] init];
		[header setUser:[model activeUser]];
		[header setProfileImage:[model profileImage]];
		return header;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0)
		return [model heightForProfileHeader];
	return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	[view setNeedsDisplay];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = @"stupidCell";
	switch (indexPath.section) {
		case 0:
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	}

	return cell;
}

@end
