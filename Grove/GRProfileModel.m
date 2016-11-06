//
//  GRProfileModel.m
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileModel.h"
#import "GRSessionManager.h"

#import <GroveSupport/GroveSupport.h>

@implementation GRProfileModel {
	__strong GRApplicationUser *visibleUser;
	__block NSArray *repositories;
    __block NSArray *organizations;
    __block NSMutableDictionary *organizationAvatars;
	NSNumber *numberOfStarredRepositories;
}

- (instancetype)initWithUser:(GRApplicationUser *)user {
	if (!user) return nil;
	if ((self = [super init])) {
		visibleUser = user;
        organizationAvatars = [NSMutableDictionary dictionary];
		
		[self requestNewData];
	}
	return self;
}

- (void)requestNewData {
	[[GSCacheManager sharedInstance] findImageAssetWithURL:[visibleUser.user avatarURL] loggedInUser:nil downloadIfNecessary:YES completionHandler:^(UIImage * __nullable image, NSError *__nullable error) {
		if (image) {
			GRApplicationUser *appUser = [[GRSessionManager sharedInstance] currentUser];
			[appUser prepareUnprocessedProfileImage:image];
			_profileImage = [appUser profilePicture];
			
			[self reloadDelegate];
		}
	}];
	
	[[GSGitHubEngine sharedInstance] repositoriesStarredByUser:visibleUser.user completionHandler:^(NSArray * _Nullable repos, NSError * _Nullable error) {
		if (error) {
			_GSAssert(NO, [error localizedDescription]);
		}
		else {
			[visibleUser setNumberOfStarredRepositories:@([repos count])];
			[self reloadDelegate];
		}
	}];
	
	[visibleUser.user updateWithCompletionHandler:^(NSError *error) {
		if (error) {
			_GSAssert(NO, [error localizedDescription]);
			return;
		}
		[self reloadDelegate];
	}];
	
	[[GSGitHubEngine sharedInstance] repositoriesForUser:visibleUser.user completionHandler:^(NSArray *repos, NSError *error) {
		if (error) {
			_GSAssert(NO, [error localizedDescription]);
			return;
		}
		repositories = repos;
		[self reloadDelegate];
	}];
    
    [[GSGitHubEngine sharedInstance] organizationsForUser:visibleUser.user completionHandler:^(NSArray * _Nullable localOrganizations, NSError * _Nullable error) {
        if (error) {
            _GSAssert(NO, [error localizedDescription]);
            return;
        }
        
        organizations = localOrganizations;
        [self reloadDelegate];
    }];
}

- (void)reloadDelegate {
	__weak GRViewModel *weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^ {
		[weakSelf.delegate reloadData];
	});
}

- (UIImage *)avatarForOrganization:(GSOrganization *)organization {
    if (organizationAvatars[organization.orgId]) {
        return organizationAvatars[organization.orgId];
    }
    else {
        [[GSCacheManager sharedInstance] findImageAssetWithURL:organization.avatarURL loggedInUser:visibleUser.user downloadIfNecessary:YES completionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            organizationAvatars[organization.orgId] = image;
            [self reloadDelegate];
        }];
    }
    return nil;
}

- (GSRepository *)repositoryForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == GRProfileModelSectionIndexRepositories && indexPath.row < repositories.count) {
        return [repositories objectAtIndex:indexPath.row];
    }
    else {
        return nil;
    }
}

- (GSOrganization *)organizationForIndexPath:(NSIndexPath *)indexPath {
	// do we really need to check the section here?
	
    if (indexPath.section == GRProfileModelSectionIndexOrganizations && indexPath.row < organizations.count) {
        return [organizations objectAtIndex:indexPath.row];
    }
    else {
        return nil;
    }
}

- (GRApplicationUser *)visibleUser {
	return visibleUser;
}

- (NSInteger)numberOfSections {
	return 3;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	NSInteger rowCount = 0;
	switch (section) {
		case GRProfileModelSectionIndexRepositories:
			rowCount = [repositories count];
			break;
		case GRProfileModelSectionIndexOrganizations:
			rowCount = [organizations count];
            break;;
		case GRProfileModelSectionIndexContributions:
			rowCount = 3;
			break;
		default:
			rowCount = 0;
			break;
	}
	return rowCount;
}

- (NSString *)titleForSection:(NSInteger)section {
	NSString *ret = nil;
    switch (section) {
        case GRProfileModelSectionIndexRepositories:
            ret = @"repositories";
            break;
		case GRProfileModelSectionIndexOrganizations:
            ret = @"organizations";
            break;
        case GRProfileModelSectionIndexContributions:
            ret = @"contributions";
            break;
        default:
            break;
    }
	
	// assert(ret == nil)
	
    return ret.uppercaseString;
}

- (CGFloat)heightForProfileHeader {
	return 160.0f;
}

- (CGFloat)heightForSectionHeader:(NSInteger)section {
	return 60.0f;
}

- (CGFloat)heightForSectionFooter:(NSInteger)section {
    if ([self numberOfRowsInSection:section] == 0) {
        return 0.0;
    }
	return 30.0f;
}

- (CGFloat)cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat cellHeight = 0;
	
	switch (indexPath.section) {
		case GRProfileModelSectionIndexRepositories:
			cellHeight = 60.0;
			break;
        case GRProfileModelSectionIndexOrganizations:
            cellHeight = 60.0;
            break;
		case GRProfileModelSectionIndexContributions:
			cellHeight = 44.0;
			break;
		default:
			cellHeight = 10.0;
			break;
	}
	
	return cellHeight;
}

@end
