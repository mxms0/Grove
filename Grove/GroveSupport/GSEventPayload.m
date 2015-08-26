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
		GSAssign(dictionary, @"description", _descriptionMessage);
		GSAssign(dictionary, @"ref", _ref);
		GSAssign(dictionary, @"ref_type", _refType);
		GSAssign(dictionary, @"master_branch", _masterBranch);
		GSAssign(dictionary, @"pusher_type", _pusherType);
		
		
		GSObjectAssign(dictionary, @"comment", _comment, GSComment);
		GSObjectAssign(dictionary, @"issue", _issue, GSIssue);
		
		NSString *action = nil;
		GSAssign(dictionary, @"action", action);
		_action = [self actionForString:action];
		
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

- (GSEventAction)actionForString:(NSString *)actionString {
	NSDictionary *const actionMapping = @{
										  @"started" : @(GSEventActionStarted),
										  @"created": @(GSEventActionCreated),
										  @"create": @(GSEventActionCreated),
										  @"updated": @(GSEventActionUpdated),
										  @"update": @(GSEventActionUpdated),
										  @"edited": @(GSEventActionEdited),
										  @"opened": @(GSEventActionOpened),
										  @"reopened": @(GSEventActionReopened),
										  @"assigned":@(GSEventActionAssigned),
										  @"unassigned": @(GSEventActionUnassigned),
										  @"labeled": @(GSEventActionLabeled),
										  @"unlabeled": @(GSEventActionUnlabeled),
										  @"published": @(GSEventActionPublished),
										  @"added": @(GSEventActionAdded),
										  @"removed": @(GSEventActionRemoved),
										  @"synchronize": @(GSEventActionSynchronized),
										  @"synchronized": @(GSEventActionSynchronized),
										  };
	return actionMapping[actionString] ? (GSEventAction)[actionMapping[actionString] intValue] : GSEventActionNone;
}

@end
