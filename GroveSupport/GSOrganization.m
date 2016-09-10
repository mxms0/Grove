//
//  GSOrganization.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSOrganization.h"
#import "GroveSupportInternal.h"

@implementation GSOrganization
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super initWithDictionary:dictionary])) {
        GSAssign(dictionary, @"login", _login);
        GSAssign(dictionary, @"id", _orgId);
        GSAssign(dictionary, @"description", _orgDescription);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    GSEncode(coder, @"login", _login);
    GSEncode(coder, @"id", _orgId);
    GSEncode(coder, @"description", _orgDescription);
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        GSDecodeAssign(coder, @"login", _login);
        GSDecodeAssign(coder, @"id", _orgId);
        GSDecodeAssign(coder, @"description", _orgDescription);
    }
    return self;
}
@end
