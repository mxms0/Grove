//
//  GSIssue.h
//  GroveSupport
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

@interface GSIssue : GSObject

@property (nonatomic, readonly) GSUser *assignee;
@property (nonatomic, readonly) GSUser *user;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) NSArray *comments;
@property (nonatomic, readonly) int state;
@property (nonatomic, readonly, getter=isLocked) BOOL locked;
@property (nonatomic, readonly) NSURL *comments_url;
@property (nonatomic, readonly) NSString *milestone;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, readonly) NSDate *closedDate;
@property (nonatomic, readonly) NSNumber *number;
@property (nonatomic, readonly) NSArray *labels;

@end
