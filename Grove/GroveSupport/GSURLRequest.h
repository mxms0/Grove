//
//  GSURLRequest.m
//  GroveSupport
//
//  Created by Max Shavrick on 9/4/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSURLRequest : NSMutableURLRequest
- (void)addAuthToken:(NSString *)token;
@end
