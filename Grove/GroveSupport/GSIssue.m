//
//  GSIssue.m
//  GroveSupport
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSIssue.h"
#import "GroveSupportInternal.h"

@implementation GSIssue

- (void)configureWithDictionary:(NSDictionary *)dictionary {
	[super configureWithDictionary:dictionary];
	GSAssign(dictionary, @"title", _title);
	GSAssign(dictionary, @"body", _body);
	//        GSAssign(dictionary, @"state", _state);
	GSAssign(dictionary, @"number", _number);
	GSAssign(dictionary, @"milestone", _milestone);
	GSAssign(dictionary, @"comments", _comments);
	
	GSURLAssign(dictionary, @"labels_url", _labelsAPIURL);
	GSURLAssign(dictionary, @"comments_url", _commentsAPIURL);
	GSURLAssign(dictionary, @"events_url", _eventsAPIURL);
	GSURLAssign(dictionary, @"html_url", _browserAPIURL);
}

@end
