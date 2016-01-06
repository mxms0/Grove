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
	[self.delegate prepareForLayout];
//	[[GSGitHubEngine sharedInstance] request]/
}


@end
