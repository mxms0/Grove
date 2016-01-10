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
	NSMutableArray *currentDirectoryComponents;
	__block NSArray<GSRepositoryEntry *> *contents;
	__strong GSRepositoryTree *directoryTree;
	BOOL hasCompleteTree;
	BOOL requestedCompleteTree;
}

- (instancetype)initWithRepository:(GSRepository *)repo {
	if ((self = [super init])) {
		repository = repo;
		currentDirectoryComponents = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)update {
	[self requestNewData];
	
	if (!requestedCompleteTree) {
		return;
		requestedCompleteTree = YES;
		[self requestFullTree];
	}
}

- (void)requestFullTree {
	[[GSGitHubEngine sharedInstance] repositoryContentsForRepository:repository atPath:[self _currentDirectoryAsString] recurse:YES completionHandler:^(GSRepositoryTree* _Nullable tree, NSError * _Nullable error) {
		hasCompleteTree = YES;
		directoryTree = tree;
	}];
}

- (NSString *)_currentDirectoryAsString {
	NSString *directory = nil;
	@synchronized(currentDirectoryComponents) {
		directory = [currentDirectoryComponents componentsJoinedByString:@"/"];
	}
	NSLog(@"fds %@", directory);
	return directory;
}

- (void)pushItemFromIndexPath:(NSIndexPath *)path {
	GSRepositoryEntry *entry = [contents objectAtIndex:path.row];
	switch ([entry type]) {
		case GSRepositoryEntryTypeDirectory: {
			[self _pushNewDirectoryWithEntry:entry];
			break;
		}
		case GSRepositoryEntryTypeFile:
		case GSRepositoryEntryTypeSubmodule:
		case GSRepositoryEntryTypeSymlink:
		case GSRepositoryEntryTypeUnknown:
		default:
			break;
	}
}

- (void)_pushNewDirectoryWithEntry:(GSRepositoryEntry *)entry {
	[currentDirectoryComponents addObject:entry.name];
	if (hasCompleteTree) {
		contents = [directoryTree entriesForPath:[self _currentDirectoryAsString]];
		[self.delegate pushToNewDirectory];
	}
	else {
		[self.delegate pushToNewDirectory];
		[self.delegate presentLoadingIndicator];
		[self requestNewData];
	}
}

- (void)requestNewData {
	[[GSGitHubEngine sharedInstance] repositoryContentsForRepository:repository atPath:[self _currentDirectoryAsString] recurse:NO completionHandler:^(GSRepositoryTree *_Nullable items, NSError * _Nullable error) {
		if (error) {
			GSAssert();
		}
		else {
			NSLog(@"Ff %@", items);
			contents = [items rootEntries];
			[self updateViewWithNewData];
		}
	}];
}

- (void)updateViewWithNewData {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.delegate prepareForLayout];
		[self.delegate reloadData];
	});
}

- (GSRepositoryEntry *)repositoryEntryForIndex:(NSUInteger)index {
	return [contents objectAtIndex:index];
}

- (NSUInteger)numberOfItemsInCurrentDirectory {
	return [contents count];
}

@end
