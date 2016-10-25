//
//  GSComment.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSComment : GSObject
@property (nonatomic, readonly, strong) NSString *diffHunk;
@property (nonatomic, readonly, strong) NSString *path;
@property (nonatomic, readonly, strong) NSNumber *position;
@property (nonatomic, readonly, strong) NSNumber *line;
@property (nonatomic, readonly, strong) NSNumber *originalPosition;
@property (nonatomic, readonly, strong) NSString *commitIdentifier;
@property (nonatomic, readonly, strong) NSString *originalCommitIdentifier;
@property (nonatomic, readonly, strong) GSUser *user;
@property (nonatomic, readonly, strong) NSString *body;
@property (nonatomic, readonly, strong) NSURL *browserURL;
@end

NS_ASSUME_NONNULL_END
