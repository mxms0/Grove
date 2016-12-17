//
//  GRProfileViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRRepositoryViewController.h"
#import "GRProfileViewController.h"
#import "GRProfileModel.h"
#import "GRProfileHeaderView.h"
#import "GRSessionManager.h"
#import "GRSectionHeaderFooterView.h"
#import "GREmptySectionHeaderFooterView.h"
#import "GRProfileRepositoryCell.h"
#import "GRProfileOrganizationCell.h"
#import "GRProfileContributionsCell.h"

#import <GroveSupport/GSGitHubEngine.h>
#import <GroveSupport/GroveSupport.h>

@implementation GRProfileViewController {
	GRProfileModel *model;
	GRProfileHeaderView *headerView;
}

- (instancetype)initWithUsername:(NSString *)username {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		
		__weak id weakSelf = self;
		[[GSGitHubEngine sharedInstance] userForUsername:username completionHandler:^(GSUser * _Nullable user, NSError * _Nullable error) {
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
    
    self.view.backgroundColor = [UIColor blackColor];
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	[self.tableView registerClass:[GRProfileRepositoryCell class] forCellReuseIdentifier:@"GRProfileRepositoryCell"];
	[self.tableView registerClass:[GRProfileOrganizationCell class] forCellReuseIdentifier:@"GRProfileOrganizationCell"];
    [self.tableView registerClass:[GRProfileContributionsCell class] forCellReuseIdentifier:@"GRProfileContributionsCell"];
    
	headerView = [[GRProfileHeaderView alloc] init];
	[headerView setFrame:CGRectMake(0, 0, self.view.frame.size.width, GRProfileHeaderViewHeight)];	
	
	[self.tableView setTableHeaderView:headerView];
	
	[self reloadData];
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
	
	GRApplicationUser *formalUser = [[GRApplicationUser alloc] init];
	[formalUser setUser:self.user];
	
	model = [[GRProfileModel alloc] initWithUser:formalUser];
	[model setDelegate:self];
	
	[headerView setUser:[model visibleUser]];
	[headerView setProfileImage:[model profileImage]];
}

- (void)reloadData {
	[self.tableView reloadData];
	
	[headerView setUser:[model visibleUser]];
	[headerView setProfileImage:[model profileImage]];
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	[view setNeedsDisplay];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseIdentifier = nil;
	NSString *textContent = nil;
    NSString *secondaryTextContent = nil;
	UIImage *image = nil;
	
	Class cellClass = [UITableViewCell class];
	
	switch (indexPath.section) {
        case GRProfileModelSectionIndexOrganizations: {
			cellClass = [GRProfileOrganizationCell class];
			
			reuseIdentifier = @"GRProfileOrganizationCell";
			
            GSOrganization *organization = [model organizationForIndexPath:indexPath];
			
            image = [model avatarForOrganization:organization];
            reuseIdentifier = @"organizationCell";
            textContent = organization.login;
            secondaryTextContent = organization.orgDescription;
			
            break;
        }
			
		case GRProfileModelSectionIndexRepositories: {
			cellClass = [GRProfileRepositoryCell class];
			
            reuseIdentifier = @"GRProfileRepositoryCell";
			
            GSRepository *repo = [model repositoryForIndexPath:indexPath];
            textContent = repo.name;
            secondaryTextContent = repo.userDescription;
			break;
		}
			
		case GRProfileModelSectionIndexContributions:
            cellClass = [GRProfileContributionsCell class];
            
            reuseIdentifier = @"GRProfileContributionsCell";
            
			break;
		default:
			break;
	}
	
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	
	if (!cell) {
		cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
	}
    
    // configure the cell
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = textContent;
    cell.detailTextLabel.text = secondaryTextContent;
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[cell.imageView setImage:image];
    
	return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case GRProfileModelSectionIndexRepositories: {
			GSRepository *repository = [model repositoryForIndexPath:indexPath];
			[self pushRepositoryViewControllerWithRepository:repository];
			break;
		}
		case GRProfileModelSectionIndexOrganizations:
			break;
		default:
			break;
	}
	
	[_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pushRepositoryViewControllerWithRepository:(GSRepository *)repo {
	//GRRepositoryViewController_alt *repoViewController = [[GRRepositoryViewController_alt alloc] init];
    //[self.navigationController pushViewController:repoViewController animated:YES];
    //[repoViewController setRepository:repo];
    GRRepositoryViewController *repoViewController = [[GRRepositoryViewController alloc] initWithRepository:repo];
    [self.navigationController presentViewController:repoViewController animated:YES completion:nil];
}

@end
