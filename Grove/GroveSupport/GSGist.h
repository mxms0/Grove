//
//  GSGist.h
//  GroveSupport
//
//  Created by Max Shavrick on 9/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

@interface GSGist : GSObject
@property (nonatomic, strong) NSString *stringDescription;
@property (nonatomic, assign, getter=isPublic) BOOL publiclyAccessible;
@property (nonatomic, weak) GSUser *owner;
@property (nonatomic, strong) NSArray *files;

@end
