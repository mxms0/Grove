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
#import "GRRepositoryViewController.h"
#import "GRSectionHeaderFooterView.h"
#import "GREmptySectionHeaderFooterView.h"

#import <GroveSupport/GSGitHubEngine.h>
#import <GroveSupport/GroveSupport.h>

@implementation GRProfileViewController {
	GRProfileModel *model;
}

- (instancetype)initWithUsername:(NSString *)usernanme {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		
		__weak id weakSelf = self;
		[[GSGitHubEngine sharedInstance] userForUsername:usernanme completionHandler:^(GSUser * _Nullable user, NSError * _Nullable error) {
			dispatch_async(dispatch_get_main_queue(), ^ {
				[weakSelf setUser:user];
				[weakSelf reloadData];
			});
		}];
	}
	return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:GRLocalizedString(@"Profile", nil, nil) image:[UIImage imageNamed:@"tb@2x"] tag:0];
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	NSLog(@"user has new data %@:%@:%@", object, keyPath, change);
}

- (void)setUser:(GSUser *)newUser {
	NSLog(@"what is this %@", newUser);
	if (self.user) {
		[self.user removeObserver:self forKeyPath:GSUpdatedDateKey];
	}
	_user = newUser;
	[self.user addObserver:self forKeyPath:GSUpdatedDateKey options:0 context:NULL];
	[self.user update];
	
	GRApplicationUser *formalUser = [[GRApplicationUser alloc] init];
	[formalUser setUser:self.user];
	
	model = [[GRProfileModel alloc] initWithUser:formalUser];
	[model setDelegate:self];
}

- (void)reloadData {
	[self.tableView reloadData];
	[(GRProfileHeaderView *)[self.tableView headerViewForSection:0] setUser:[model visibleUser]];
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
		[header setUser:[model visibleUser]];
		[header setProfileImage:[model profileImage]];
		return header;
	} else {
        Class headerClass = [GRSectionHeaderFooterView class];
        if ([model numberOfRowsInSection:section] == 0) {
            headerClass = [GREmptySectionHeaderFooterView class];
        }
        return [[headerClass alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [model heightForSectionHeader:section])
                                             mode:GRSectionHeaderMode text:[model titleForSection:section]];
	}
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    Class footerClass = [GRSectionHeaderFooterView class];
    if ([model numberOfRowsInSection:section] == 0) {
        footerClass = [GREmptySectionHeaderFooterView class];
    }
    return [[footerClass alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, [model heightForSectionFooter:section])
                                         mode:GRSectionFooterMode text:@""];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0)
		return [model heightForProfileHeader];
    return [model heightForSectionHeader:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return [model heightForSectionFooter:section];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	[view setNeedsDisplay];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = @"stupidCell"; // Hey, Max! Don't do this.
	NSString *textContent = nil;
    NSString *secondaryTextContent = nil;
	switch (indexPath.section) {
		case 0:
			break;
        case 1: {
            reuseIdentifier = @"organizationCell";
            GSOrganization *organization = [model organizationForIndexPath:indexPath];
            textContent = organization.login;
            secondaryTextContent = organization.orgDescription;
            break;
        }
		case 2: {
			reuseIdentifier = @"repositoryCell";
			GSRepository *repo = [model repositoryForIndexPath:indexPath];
			textContent = repo.name;
            secondaryTextContent = repo.userDescription;
			break;
		}
		case 3:
			break;
		default:
			break;
	}
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	}
    
    //configure the cell
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.textLabel.text            = textContent;
    cell.detailTextLabel.text      = secondaryTextContent;
	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0:
			break;
		case 2: {
			GSRepository *repository = [model repositoryForIndexPath:indexPath];
			[self pushRepositoryViewControllerWithRepository:repository];
			break;
		}
		default:
			break;
	}
}

- (void)pushRepositoryViewControllerWithRepository:(GSRepository *)repo {
	GRRepositoryViewController *repoViewController = [[GRRepositoryViewController alloc] init];
	[repoViewController setRepository:repo];
	[self.navigationController pushViewController:repoViewController animated:YES];
}

@end
