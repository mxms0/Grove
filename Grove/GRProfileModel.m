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
	NSNumber *numberOfStarredRepositories;
}

- (instancetype)initWithUser:(GRApplicationUser *)user {
	if (!user) return nil;
	if ((self = [super init])) {
		visibleUser = user;
		
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
}

- (void)reloadDelegate {
	__weak GRViewModel *weakSelf = self;
	dispatch_async(dispatch_get_main_queue(), ^ {
		[weakSelf.delegate reloadData];
	});
}

- (GSRepository *)repositoryForIndex:(NSUInteger)index {
	if (index <= [repositories count])
		return [repositories objectAtIndex:index];
	else
		return nil;
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
		case 0:
			rowCount = 0;
			break;
		case 1:
			//rowCount = [repositories count];
			break;
		case 2:
			rowCount = 3;
			break;
		default:
			rowCount = 0;
			break;
	}
	return rowCount;
}

- (NSString *)titleForSection:(NSInteger)section {
    NSString *ret = @"UNDEF";
    switch (section) {
        case 0:
            break;
        case 1:
            ret = @"repositories";
            break;
        case 2:
            ret = @"contributions";
            break;
        case 3:
            ret = @"activity";
            break;
        default:
            break;
    }
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
		case 0:
			cellHeight = 44.0;
			break;
		case 1:
			cellHeight = 60.0;
			break;
		case 2:
			cellHeight = 22.0;
			break;
		default:
			cellHeight = 400.0;
			break;
	}
	return cellHeight;
}

@end
