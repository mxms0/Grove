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
#import "GREventCellModel.h"

static NSString *const GRStreamModelStorageKey = @"stream_data"; // i will move away from NSUserDefaults soon. promise.

@interface GRStreamModel ()
@property (nonatomic, strong) NSMutableOrderedSet *eventModels;
@end

@implementation GRStreamModel

- (instancetype)init {
	if ((self = [super init])) {
		self.eventModels = [[NSMutableOrderedSet alloc] init];
		NSArray *oldEventModels = [[NSUserDefaults standardUserDefaults] objectForKey:GRStreamModelStorageKey];
		if (oldEventModels) {
			self.eventModels = [oldEventModels mutableCopy];
		}
		[self requestNewData];
	}
	return self;
}

- (void)requestNewData {
	[[GSGitHubEngine sharedInstance] eventsForUser:[[[GRSessionManager sharedInstance] currentUser] user] completionHandler:^(NSArray *events, NSError *error) {
		[self handleNewleyArrivedEvents:events];
	}];
}

- (void)handleNewleyArrivedEvents:(NSArray *)events {
	NSMutableOrderedSet *eventModels = [[NSMutableOrderedSet alloc] init];
	for (GSEvent *evt in events) {
		GREventCellModel *model = [[GREventCellModel alloc] initWithEvent:evt];
		[eventModels addObject:model];
	}
	
	self.eventModels = eventModels;
	[self.delegate reloadData];
	//	[[NSUserDefaults standardUserDefaults] setObject:self.eventModels forKey:GRStreamModelStorageKey];
}

- (NSInteger)numberOfSections {
	return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	return self.eventModels.count;
}

- (GREventCellModel *)eventCellModelForIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < self.eventModels.count) {
		return self.eventModels[indexPath.row];
	}
	return nil;
}

- (GSEvent *)eventForIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < self.eventModels.count) {
		return self.eventModels[indexPath.row];
	}
	return nil;
}

@end
