//
//  GSRepository.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

@interface GSRepository : GSObject
@property (nonatomic, readonly) NSString *owner;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, assign, getter=isPrivate) BOOL private;
@property (nonatomic, readonly) NSURL *browserURL;
@property (nonatomic, readonly) NSString *stringDescription;
@property (nonatomic, readonly) BOOL fork;

@end
