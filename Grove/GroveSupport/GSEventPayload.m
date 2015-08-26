//
//  GSEventPayload.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSEventPayload.h"
#import "GSCommit.h"
#import "GroveSupportInternal.h"
#import "GSIssue.h"

@implementation GSEventPayload

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {
		GSAssign(dictionary, @"push_id", _pushIdentifier);
		GSAssign(dictionary, @"size", _size);
		GSObjectAssign(dictionary, @"comment", _comment, GSComment);
		GSObjectAssign(dictionary, @"issue", _issue, GSIssue);
		
		NSString *ref = dictionary[@"ref"];
		if (ref && (NSNull *)ref != [NSNull null]) {
			if ([ref hasPrefix:@"refs/heads/"])
				_branch = [ref substringFromIndex:[@"refs/heads/" length]];
			else
				_branch = ref;
		}
		
		NSMutableArray *commitsSerialized = [NSMutableArray array];
		
		NSArray *commitsUnserialized = dictionary[@"commits"];
		if ([commitsUnserialized isKindOfClass:[NSArray class]]) {
			for (NSDictionary *commitPacket in commitsUnserialized) {
				GSCommit *commit = [[GSCommit alloc] initWithDictionary:commitPacket];
				[commitsSerialized addObject:commit];
			}
		}
		_commits = commitsSerialized;
		
	}
	
	return self;
}

@end
