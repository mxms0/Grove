//
//  GSNotification.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/20/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSNotification.h"
#import "GroveSupportInternal.h"

@implementation GSNotification

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {
		GSObjectAssign(dictionary, @"repository", _repository, GSRepository);
		
		GSURLAssign(dictionary, @"subscription_url", _subscriptionAPIURL);
	}
	return self;
}

@end
