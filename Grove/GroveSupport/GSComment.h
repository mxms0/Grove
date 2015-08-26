//
//  GSComment.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

@interface GSComment : GSObject
@property (nonatomic, readonly) NSString *diffHunk;
@property (nonatomic, readonly) NSString *path;
@property (nonatomic, readonly) NSNumber *position;
@property (nonatomic, readonly) NSNumber *line;
@property (nonatomic, readonly) NSNumber *originalPosition;
@property (nonatomic, readonly) NSString *commitIdentifier;
@property (nonatomic, readonly) NSString *originalCommitIdentifier;
@property (nonatomic, readonly) GSUser *user;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSDate *updatedDate;
@property (nonatomic, readonly) NSURL *browserURL;
@end
