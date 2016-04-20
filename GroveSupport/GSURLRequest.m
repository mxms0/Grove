//
//  GSURLRequest.m
//  GroveSupport
//
//  Created by Max Shavrick on 9/4/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSURLRequest.h"

@implementation GSURLRequest

- (void)setAuthToken:(NSString *__nullable)token {
	if (!token) return;
    [self setValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:GSHTTPAuthorizationHeaderKey];
}

- (void)setTwoFactorAuthToken:(NSString *__nullable)token {
	if (!token || [token isEqualToString:@""]) return;
	[self setValue:token forHTTPHeaderField:GSHTTPTwoFactorAuthHeaderKey];
}

- (void)setLastModifiedDate:(NSDate *__nullable)date {
	if (!date) return;
	[self addValue:GSRFC2616DTimestampFromDate(date) forHTTPHeaderField:GSHTTPIfModifiedSinceEtagHeaderKey];
	// this may or may not work, but it's worth a shot. :- )
}

@end
