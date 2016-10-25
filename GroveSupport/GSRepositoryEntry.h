//
//  GSRepositoryEntry.h
//  GroveSupport
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright (c) 2016 Milo. All rights reserved.
//

#import "GSObject.h"

typedef NS_ENUM(NSInteger, GSRepositoryEntryType) {
	GSRepositoryEntryTypeFile, // blob
	GSRepositoryEntryTypeDirectory, // tree
	GSRepositoryEntryTypeSymlink, //  ???
	GSRepositoryEntryTypeSubmodule, // commit ???
	GSRepositoryEntryTypeUnknown
};

@interface GSRepositoryEntry : GSObject
@property (nonatomic, strong, nullable) NSURL *downloadURL;
@property (nonatomic, strong, nullable) NSURL *gitURL;
@property (nonatomic, strong, nullable) NSURL *browserURL;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *path;
@property (nonatomic, strong, nullable) NSString *shaHash;
@property (nonatomic, strong, nullable) NSNumber *size;
@property (nonatomic, assign) GSRepositoryEntryType type;
@end
