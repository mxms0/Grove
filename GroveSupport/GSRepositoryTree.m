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
	NSString *basePath;
}

static NSString *const GSRepositoryTreeRootItemPath = @"/";

- (instancetype)initWithRootEntries:(NSArray<NSDictionary *> *)entries basePath:(NSString *)base {
	NSDictionary *newMap = @{ @"tree" : entries };
	basePath = base;
	if ((self = [super initWithDictionary:newMap])) {
		
	}
	return self;
}

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	[super _configureWithDictionary:dictionary];
	
	treeMap = [[NSMutableDictionary alloc] init];
	
	NSArray *files = nil;
	GSAssign(dictionary, @"tree", files);
	
	// store truncate info and hash in here too!!!
	
	@synchronized(treeMap) {
		for (NSDictionary *dictionary in files) {
			NSString *path = dictionary[@"path"];
			NSString *storageLocation = [path stringByDeletingLastPathComponent];
			
			if (basePath && [storageLocation hasPrefix:basePath]) {
				storageLocation = [storageLocation substringFromIndex:[basePath length]];
				if ([storageLocation hasPrefix:@"/"]) {
					storageLocation = [storageLocation substringFromIndex:1];
				}
			}
			
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
	
//	NSLog(@"initial %@", dictionary);
//	NSLog(@"final %@", treeMap);
}

- (NSArray *)rootEntries {
	return [self entriesForPath:GSRepositoryTreeRootItemPath];
}

- (NSArray *)entriesForPath:(NSString *)path {
	NSArray *entries = nil;
	@synchronized(treeMap) {
		entries = treeMap[path];
	}
	return entries;
}

@end
