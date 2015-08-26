//
//  GSIssue.h
//  Grove
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
@property (nonatomic, readonly) BOOL state;
@property (nonatomic, readonly) NSURL *comments_url;
@property (nonatomic, readonly) NSInteger *number;

@end
