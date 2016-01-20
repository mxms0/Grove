//
//  GRRepositoryGenericSectionView.m
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryGenericSectionView.h"

@implementation GRRepositoryGenericSectionView

- (instancetype)init {
	if ((self = [super init])) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	
}

- (Class)designatedModelClass {
	return [GRRepositoryGenericSectionModel class];
}

- (void)setRepository:(GSRepository *)repo {
	if (!repo) {
		model = nil;
		return;
	}
	model = [[[self designatedModelClass] alloc] initWithRepository:repo];
	[model setDelegate:self];
	[model update];
}

@end
