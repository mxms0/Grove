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
	GSUser *currentUser;
	NSArray *repositories;
}

- (instancetype)initWithUser:(GSUser *)user {
	if ((self = [super init])) {
		currentUser = user;
		
		[[GSCacheManager sharedInstance] findImageAssetWithURL:[currentUser avatarURL] loggedInUser:currentUser downloadIfNecessary:YES completionHandler:^(UIImage * __nullable image, NSError *__nullable error) {
			if (image) {
				GRApplicationUser *appUser = [[GRSessionManager sharedInstance] currentUser];
				[appUser prepareUnprocessedProfileImage:image];
				_profileImage = [appUser profilePicture];
				dispatch_async(dispatch_get_main_queue(), ^ {
					[self.delegate reloadData];
				});
			}
		}];
	}
	return self;
}

- (void)requestNewData {
//	[[GSGitHubEngine sharedInstance] repositoriesForUser:currentUser.user completionHandler:^(NSArray * __nullable repos, NSError * __nullable error) {
//		if (!error) {
//			repositories = repos;
//			dispatch_async(dispatch_get_main_queue(), ^	{
//			});
//		}
//	}];
//
//	[[GSGitHubEngine sharedInstance] userForUsername:appUser.user.username completionHandler:^(GSUser *user, NSError *error) {
		// reload data here
		// use If-Modified-Since ETAG to request profile picture, that way we dont waste resources
//	}];
}

- (GSRepository *)repositoryForIndex:(NSUInteger)index {
	if (index >= [repositories count])
		return [repositories objectAtIndex:index];
	else
		return nil;
}

- (GSUser *)activeUser {
	return currentUser;
}

- (NSInteger)numberOfSections {
	return 3;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	int rowCount = 0;
	switch (section) {
		case 0:
			rowCount = 0;
			break;
		case 1:
			rowCount = 1;
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
    NSString *ret = @"undef";
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
    return ret;
}

- (CGFloat)heightForProfileHeader {
	return 154;
}

- (CGFloat)cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat cellHeight = 0;
	switch (indexPath.section) {
		case 0:
			cellHeight = 44.0;
			break;
		case 1:
			cellHeight = 44.0;
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
