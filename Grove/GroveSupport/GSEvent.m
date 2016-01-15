//
//  GSEvent.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSEvent.h"
#import "GroveSupportInternal.h"

@implementation GSEvent

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	[super _configureWithDictionary:dictionary];
	
#if 1
	NSLog(@"Event information %@", dictionary);
#endif
	
	GSObjectAssign(dictionary, @"actor", _actor, GSActor);
	GSObjectAssign(dictionary, @"repo", _repository, GSRepository);
	
	_createdDate = [self dateFromISO8601String:dictionary[@"created_at"]];
	_publicallyAvailable = [dictionary[@"public"] boolValue];
	_type = [self notificationEventTypeFromString:dictionary[@"type"]];
	
	
	// Begin Event Payload
	
	NSDictionary *payload = nil;
	GSAssign(dictionary, @"payload", payload);
	
	NSString *refTypeString = nil;
	
	GSAssign(payload, @"push_id", _pushIdentifier);
	GSAssign(payload, @"size", _size);
	GSAssign(payload, @"description", _descriptionMessage);
	GSAssign(payload, @"ref", _ref);
	GSAssign(payload, @"ref_type", refTypeString);
	GSAssign(payload, @"master_branch", _masterBranch);
	GSAssign(payload, @"pusher_type", _pusherType);
	
	_refType = [self refTypeForString:refTypeString];
	
	GSObjectAssign(payload, @"comment", _comment, GSComment);
	GSObjectAssign(payload, @"issue", _issue, GSIssue);
	GSObjectAssign(payload, @"member", _member, GSUser);
	// this is an issue wherever member is an organization
	// organizations aren't handled properly, pretty much anywhere.
	
	GSObjectAssign(payload, @"forkee", _forkee, GSRepository);
	
	NSString *action = nil;
	GSAssign(payload, @"action", action);
	_action = [self actionForString:action];
	
	NSMutableArray *commitsSerialized = [NSMutableArray array];
	
	NSArray *commitsUnserialized = payload[@"commits"];
	if ([commitsUnserialized isKindOfClass:[NSArray class]]) {
		for (NSDictionary *commitPacket in commitsUnserialized) {
			GSCommit *commit = [[GSCommit alloc] initWithDictionary:commitPacket];
			[commitsSerialized addObject:commit];
		}
	}
	_commits = commitsSerialized;

}

- (GSEventRefType)refTypeForString:(NSString *)refs {
	NSDictionary *const refMapping = @{
									   @"branch":		@(GSEventRefTypeBranch),
									   @"repository":	@(GSEventRefTypeRepository),
									   @"tag":			@(GSEventRefTypeTag)
									   };
	return refMapping[refs] ? (GSEventRefType)[refMapping[refs] integerValue] : GSEventRefTypeUnknown;
	
}

- (GSEventAction)actionForString:(NSString *)actionString {
	NSDictionary *const actionMapping = @{
										  @"started"		: @(GSEventActionStarted),
										  @"created"		: @(GSEventActionCreated),
										  @"create"			: @(GSEventActionCreated),
										  @"updated"		: @(GSEventActionUpdated),
										  @"update"			: @(GSEventActionUpdated),
										  @"edited"			: @(GSEventActionEdited),
										  @"opened"			: @(GSEventActionOpened),
										  @"reopened"		: @(GSEventActionReopened),
										  @"assigned"		: @(GSEventActionAssigned),
										  @"unassigned"		: @(GSEventActionUnassigned),
										  @"labeled"		: @(GSEventActionLabeled),
										  @"unlabeled"		: @(GSEventActionUnlabeled),
										  @"published"		: @(GSEventActionPublished),
										  @"added"			: @(GSEventActionAdded),
										  @"removed"		: @(GSEventActionRemoved),
										  @"synchronize"	: @(GSEventActionSynchronized),
										  @"synchronized"	: @(GSEventActionSynchronized),
										  };
	return actionMapping[actionString] ? (GSEventAction)[actionMapping[actionString] integerValue] : GSEventActionNone;
}

- (GSEventType)notificationEventTypeFromString:(NSString *)string {
	NSDictionary *const mapping = @{
							   @"CommitCommentEvent"		:@(GSEventTypeCommitComment),
							   @"CreateEvent"				:@(GSEventTypeCreate),
							   @"DeleteEvent"				:@(GSEventTypeDelete),
							   @"DeploymentEvent"			:@(GSEventTypeDeployment),
							   @"DeploymentStatusEvent"		:@(GSEventTypeDeploymentStatus),
							   @"DownloadEvent"				:@(GSEventTypeDownload),
							   @"FollowEvent"				:@(GSEventTypeFollow),
							   @"ForkEvent"					:@(GSEventTypeFork),
							   @"ForkApplyEvent"			:@(GSEventTypeForkApply),
							   @"GistEvent"					:@(GSEventTypeGistEvent),
							   @"GollumEvent"				:@(GSEventTypeGollumEvent),
							   @"IssueCommentEvent"			:@(GSEventTypeIssueComment),
							   @"IssuesEvent"				:@(GSEventTypeIssues),
							   @"MemberEvent"				:@(GSEventTypeMember),
							   @"MembershipEvent"			:@(GSEventTypeMembership),
							   @"PageBuildEvent"			:@(GSEventTypePageBuild),
							   @"PublicEvent"				:@(GSEventTypePublic),
							   @"PullRequestEvent"			:@(GSEventTypePullRequest),
							   @"PullRequestReviewCommentEvent":@(GSEventTypePullRequestReviewComment),
							   @"PushEvent"					:@(GSEventTypePush),
							   @"ReleaseEvent"				:@(GSEventTypeRelease),
							   @"RepositoryEvent"			:@(GSEventTypeRepository),
							   @"StatusEvent"				:@(GSEventTypeStatus),
							   @"TeamAddEvent"				:@(GSEventTypeTeamAdd),
							   @"WatchEvent"				:@(GSEventTypeStar)
							};

	return mapping[string] ? [mapping[string] intValue] : GSEventTypeUnknown;
}

#if DEBUG
- (NSString *)stringForEventType:(GSEventType)type {
	NSDictionary *const mapping = @{
									@"CommitCommentEvent"			:@(GSEventTypeCommitComment),
									@"CreateEvent"					:@(GSEventTypeCreate),
									@"DeleteEvent"					:@(GSEventTypeDelete),
									@"DeploymentEvent"				:@(GSEventTypeDeployment),
									@"DeploymentStatusEvent"		:@(GSEventTypeDeploymentStatus),
									@"DownloadEvent"				:@(GSEventTypeDownload),
									@"FollowEvent"					:@(GSEventTypeFollow),
									@"ForkEvent"					:@(GSEventTypeFork),
									@"ForkApplyEvent"				:@(GSEventTypeForkApply),
									@"GistEvent"					:@(GSEventTypeGistEvent),
									@"GollumEvent"					:@(GSEventTypeGollumEvent),
									@"IssueCommentEvent"			:@(GSEventTypeIssueComment),
									@"IssuesEvent"					:@(GSEventTypeIssues),
									@"MemberEvent"					:@(GSEventTypeMember),
									@"MembershipEvent"				:@(GSEventTypeMembership),
									@"PageBuildEvent"				:@(GSEventTypePageBuild),
									@"PublicEvent"					:@(GSEventTypePublic),
									@"PullRequestEvent"				:@(GSEventTypePullRequest),
									@"PullRequestReviewCommentEvent":@(GSEventTypePullRequestReviewComment),
									@"PushEvent"					:@(GSEventTypePush),
									@"ReleaseEvent"					:@(GSEventTypeRelease),
									@"RepositoryEvent"				:@(GSEventTypeRepository),
									@"StatusEvent"					:@(GSEventTypeStatus),
									@"TeamAddEvent"					:@(GSEventTypeTeamAdd),
									@"WatchEvent"					:@(GSEventTypeStar)
									};
	return [[mapping allKeysForObject:@(type)] firstObject];
}
#endif

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; id = %@; type = %@;>", NSStringFromClass([self class]), self, self.identifier, [self stringForEventType:self.type]];
}

@end
