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

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	[super _configureWithDictionary:dictionary];
	
	//NSLog(@"NOTIF: %@", dictionary);
	
	GSObjectAssign(dictionary, @"repository", _repository, GSRepository);
	GSURLAssign(dictionary, @"subscription_url", _subscriptionAPIURL);
	
	NSDictionary *subjectPacket = nil;
	GSAssign(dictionary, @"subject", subjectPacket);
	GSAssign(subjectPacket, @"title", _title);
}

@end
