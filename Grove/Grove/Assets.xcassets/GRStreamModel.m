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

@interface GRStreamModel ()
@property (nonatomic, strong) NSArray *eventModels;
@end

@implementation GRStreamModel

- (instancetype)init {
	if ((self = [super init])) {
		self.eventModels = [NSMutableArray array];
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
	NSMutableArray *eventModels = [[NSMutableArray alloc] init];
	for (GSEvent *evt in events) {
		GREventCellModel *model = [[GREventCellModel alloc] initWithEvent:evt];
		[eventModels addObject:model];
	}
	
	self.eventModels = eventModels;
	[self.delegate reloadData];
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
