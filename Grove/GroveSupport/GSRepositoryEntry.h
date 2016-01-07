//
//  GSRepositoryEntry.h
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

@interface GSRepositoryEntry : GSObject
@property (nonatomic, strong, nullable) NSURL *downloadURL;
@property (nonatomic, strong, nullable) NSURL *gitURL;
@property (nonatomic, strong, nullable) NSURL *browserURL;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSString *path;
@property (nonatomic, strong, nullable) NSString *shaHash;
@property (nonatomic, strong, nullable) NSNumber *size;
@property (nonatomic, assign) int type;
@end
