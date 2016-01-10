//
//  GSRepositoryTree.m
//  GroveSupport
//
//  Created by Max Shavrick on 1/9/16.
//  Copyright (c) 2016 Milo. All rights reserved.
//

#import "GSRepositoryTree.h"
#import "GroveSupportInternal.h"

@implementation GSRepositoryTree {
	NSMutableDictionary *treeMap;
}

static NSString *const GSRepositoryTreeRootItemPath = @"/";

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	[super _configureWithDictionary:dictionary];
	
	treeMap = [[NSMutableDictionary alloc] init];
	
	NSArray *files = nil;
	GSAssign(dictionary, @"tree", files);
	
	// store truncate info and hash in here too!!!
	
	for (NSDictionary *dictionary in files) {
		
		NSString *path = dictionary[@"path"];
		NSString *storageLocation = [path stringByDeletingLastPathComponent];
		if (!storageLocation || ([storageLocation length] == 0)) {
			storageLocation = GSRepositoryTreeRootItemPath;
		}
		
		NSMutableArray *array = treeMap[storageLocation];
		
		if (!array) {
			array = [[NSMutableArray alloc] init];
			treeMap[storageLocation] = array;
		}
		
		GSRepositoryEntry *entry = [[GSRepositoryEntry alloc] initWithDictionary:dictionary];
		[array addObject:entry];
	}
}

- (NSArray *)rootEntries {
	return [self entriesForPath:GSRepositoryTreeRootItemPath];
}

- (NSArray *)entriesForPath:(NSString *)path {
	return [treeMap objectForKey:path];
}

@end
