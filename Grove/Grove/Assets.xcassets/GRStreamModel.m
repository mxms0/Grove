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
#import "GRStreamCellModel.h"

static NSString *const GRStreamModelStorageKey = @"stream_data"; // i will move away from NSUserDefaults soon. promise.

@interface GRStreamModel ()
@property (nonatomic, strong) NSMutableOrderedSet *eventModels;
@end

@implementation GRStreamModel

- (instancetype)initWithDelegate:(id <GRViewModelDelegate>)del {
	if ((self = [super init])) {
		self.delegate = del;
		self.eventModels = [[NSMutableOrderedSet alloc] init];
		NSData *cachedEventData = [[NSUserDefaults standardUserDefaults] objectForKey:GRStreamModelStorageKey];
		if (cachedEventData) {
			NSArray *ret = [NSKeyedUnarchiver unarchiveObjectWithData:cachedEventData];
			if ([ret isKindOfClass:[NSOrderedSet class]]) {
				self.eventModels = [ret mutableCopy];
				[del reloadData];
			}
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
		GRStreamCellModel *model = [[GRStreamCellModel alloc] initWithEvent:evt];
		[eventModels addObject:model];
		(void)[model eventString];
		(void)[model requiredTableCellHeight];
	}
	
	self.eventModels = eventModels;
	[self.delegate reloadData];
	
	NSData *root = [NSKeyedArchiver archivedDataWithRootObject:self.eventModels];
	
	[[NSUserDefaults standardUserDefaults] setObject:root forKey:GRStreamModelStorageKey];
}

- (NSInteger)numberOfSections {
	return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	return self.eventModels.count;
}

- (GRStreamCellModel *)eventCellModelForIndexPath:(NSIndexPath *)indexPath {
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
