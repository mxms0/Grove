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
	NSMutableDictionary *directoryContentCache;
	BOOL hasCompleteTree;
	BOOL requestedCompleteTree;
}
@dynamic delegate;

- (instancetype)initWithRepository:(GSRepository *)repo {
	if ((self = [super init])) {
		repository = repo;
		currentDirectoryComponents = [[NSMutableArray alloc] init];
		directoryContentCache = [[NSMutableDictionary alloc] init];
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

- (BOOL)isAtRootDirectory {
	return ([[self _currentDirectoryAsString] length] == 0);
}

- (NSString *)currentDirectory {
	return [self _currentDirectoryAsString];
}

- (NSString *)_currentDirectoryAsString {
	NSString *directory = nil;
	@synchronized(currentDirectoryComponents) {
		directory = [currentDirectoryComponents componentsJoinedByString:@"/"];
	}
	
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
			NSLog(@"Not prepared to handle file %@", entry);
			break;
	}
}

- (void)_pushNewDirectoryWithEntry:(GSRepositoryEntry *)entry {
	[currentDirectoryComponents addObject:entry.name];
	[self.pathBar pushPath:entry.name];
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

- (void)_popCurrentDirectoryItem {
	[currentDirectoryComponents removeLastObject];
	if (hasCompleteTree) {
		contents = [directoryTree entriesForPath:[self _currentDirectoryAsString]];
	}
	else {
		contents = [directoryContentCache objectForKey:[self _currentDirectoryAsString]];
	}
	
	[self.delegate pushToPreviousDirectory];
}

- (void)requestNewData {
	[[GSGitHubEngine sharedInstance] repositoryContentsForRepository:repository atPath:[self _currentDirectoryAsString] recurse:NO completionHandler:^(GSRepositoryTree *_Nullable tree, NSError * _Nullable error) {
		if (error) {
			GSAssert();
		}
		else {
			contents = [tree rootEntries];
			[directoryContentCache setObject:contents forKey:[self _currentDirectoryAsString]];
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

- (BOOL)isAtRootForPathBar:(GRRepositoryPathBar *)bar {
	return [self isAtRootDirectory];
}

- (void)popPathForPathBar:(GRRepositoryPathBar *)bar {
	[self _popCurrentDirectoryItem];
}

- (void)popToRootForPathBar:(GRRepositoryPathBar *)bar {

}

@end
