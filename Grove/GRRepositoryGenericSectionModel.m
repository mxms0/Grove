//
//  GRRepositoryGenericSectionModel.m
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryGenericSectionModel.h"

@implementation GRRepositoryGenericSectionModel

- (instancetype)initWithRepository:(GSRepository *)repo {
	if (!repo) return nil;
	if ((self = [super init])) {
        self.repository = repo;
	}
	return self;
}

- (void)update {
	
}

- (NSString *)sectionLabelForSection:(NSUInteger)section {
	return nil;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
	return 0;
}

- (NSUInteger)numberOfSections {
	return 0;
}

@end
