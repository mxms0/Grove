//
//  GSIssue.m
//  Grove
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSIssue.h"
#import "GroveSupportInternal.h"

@implementation GSIssue

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super initWithDictionary:dictionary])) {
        GSAssign(dictionary, @"title", _title);
        GSAssign(dictionary, @"body", _body);
        GSAssign(dictionary, @"state", _state);
    }
    return self;
}

@end
