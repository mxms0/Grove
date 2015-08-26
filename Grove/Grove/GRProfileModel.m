//
//  GRProfileModel.m
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileModel.h"
#import "GRSessionManager.h"

#import "GSGitHubEngine.h"

@implementation GRProfileModel

- (instancetype)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)requestNewData {
//	GRApplicationUser *appUser = [[GRSessionManager sharedInstance] currentUser];
//	[[GSGitHubEngine sharedInstance] userForUsername:appUser.user.username completionHandler:^(GSUser *user, NSError *error) {
		// reload data here
		// use If-Modified-Since ETAG to request profile picture, that way we dont waste resources
//	}];
}

- (NSInteger)numberOfSections {
	return 3;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	int rowCount = 0;
	switch (section) {
		case 0:
			rowCount = 1;
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

- (CGFloat)cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat cellHeight = 0;
	switch (indexPath.section) {
		case 0:
			cellHeight = 88.0;
			break;
		case 1:
			cellHeight = 44.0;
			break;
		case 2:
			cellHeight = 44.0;
			break;
		default:
			cellHeight = 22.0;
			break;
	}
	return cellHeight;
}

@end
