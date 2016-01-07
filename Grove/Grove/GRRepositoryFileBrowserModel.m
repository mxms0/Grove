//
//  GRRepositoryFileBrowserModel.m
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryFileBrowserModel.h"

#import <GroveSupport/GroveSupport.h>

@implementation GRRepositoryFileBrowserModel {
	__weak GSRepository *repository;
	__block NSArray<GSRepositoryEntry *> *contents;
}

- (instancetype)initWithRepository:(GSRepository *)repo {
	if ((self = [super init])) {
		repository = repo;
	}
	return self;
}

- (void)update {
	[self requestNewData];
}

- (void)requestNewData {
	[[GSGitHubEngine sharedInstance] repositoryContentsForRepository:repository completionHandler:^(NSArray<GSRepositoryEntry *> * _Nullable items, NSError * _Nullable error) {
		if (error) {
			GSAssert();
		}
		else {
			contents = items;
			[self updateViewWithNewData];
		}
	}];
}

- (void)updateViewWithNewData {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.delegate prepareForLayout];
	});
}

@end
