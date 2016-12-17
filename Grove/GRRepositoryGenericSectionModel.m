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
	if(self.delegate && [self.delegate respondsToSelector:@selector(reloadView)]) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.delegate reloadView];
		});
	}
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
