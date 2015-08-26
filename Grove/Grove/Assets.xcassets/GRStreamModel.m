//
//  GRStreamModel.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRStreamModel.h"
#import "GSGitHubEngine.h"
#import "GRSessionManager.h"

@interface GRStreamModel ()
@property (nonatomic) NSArray *events;
@end

@implementation GRStreamModel

- (instancetype)init {
	if ((self = [super init])) {
		self.events = [NSMutableArray array];
	}
	return self;
}

- (void)requestNewData {
	[[GSGitHubEngine sharedInstance] eventsForUser:[[[GRSessionManager sharedInstance] currentUser] user] completionHandler:^(NSArray *events, NSError * error) {
		self.events = events;
		[self.delegate reloadData];
	}];
}

- (NSInteger)numberOfSections {
	return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	return self.events.count;
}

- (GSEvent *)eventForIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < self.events.count) {
		return self.events[indexPath.row];
	}
	return nil;
}

@end
