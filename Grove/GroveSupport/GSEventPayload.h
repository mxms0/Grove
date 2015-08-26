//
//  GSEventPayload.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

@class GSComment, GSIssue;
@interface GSEventPayload : GSObject
@property (nonatomic, readonly) NSString *action;
@property (nonatomic, readonly) NSNumber *pushIdentifier;
@property (nonatomic, readonly) NSNumber *size;
@property (nonatomic, readonly) NSNumber *distinctSize;
@property (nonatomic, readonly) NSString *branch;
@property (nonatomic, readonly) NSString *head;
@property (nonatomic, readonly) NSString *previousHead;
@property (nonatomic, readonly) NSArray  *commits;
@property (nonatomic, readonly) NSString *commitMessage;
@property (nonatomic, readonly) GSComment *comment;
@property (nonatomic, readonly) GSIssue *issue;
@end
