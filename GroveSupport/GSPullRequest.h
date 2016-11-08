//
//  GSPullRequest.h
//  Grove
//
//  Created by Jim Boulter on 11/7/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

@interface GSPullRequest : GSObject

@property (nonatomic, readonly) NSNumber* number;
@property (nonatomic, assign, readonly) BOOL isOpen;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* body;
@property (nonatomic, readonly) GSUser* assignee;
@property (nonatomic, readonly) NSString* milestone;
@property (nonatomic, assign, readonly) BOOL locked;
@property (nonatomic, readonly) NSDate* createdAt;
@property (nonatomic, readonly) NSDate* updatedAt;
@property (nonatomic, readonly) NSDate* closedAt;
@property (nonatomic, readonly) NSDate* mergedAt;
@property (nonatomic, readonly) NSString* head;
@property (nonatomic, readonly) GSRepository* repo;
@property (nonatomic, readonly) NSString* base;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
