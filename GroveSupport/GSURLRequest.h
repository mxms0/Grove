//
//  GSURLRequest.m
//  GroveSupport
//
//  Created by Max Shavrick on 9/4/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroveSupportInternal.h"

@interface GSURLRequest : NSMutableURLRequest
- (void)setAuthToken:(NSString *__nullable)token;
- (void)setTwoFactorAuthToken:(NSString *__nullable)token;
- (void)setLastModifiedDate:(NSDate *__nullable)date;
@end
