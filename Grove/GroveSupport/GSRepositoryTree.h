//
//  GSRepositoryTree.h
//  GroveSupport
//
//  Created by Max Shavrick on 1/9/16.
//  Copyright (c) 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

@interface GSRepositoryTree : GSObject
@property (nonatomic, assign, readonly, getter=isRecursive) BOOL recursive;
@property (nonatomic, assign, readonly, getter=isTruncated) BOOL truncated;
- (NSArray *)rootEntries;
- (NSArray *)entriesForPath:(NSString *)path;
@end
