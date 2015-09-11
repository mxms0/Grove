//
//  GSURLRequest.m
//  GroveSupport
//
//  Created by Max Shavrick on 9/4/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSURLRequest.h"

@implementation GSURLRequest

- (void)addAuthToken:(NSString *)token {
    [self setValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
}

@end
