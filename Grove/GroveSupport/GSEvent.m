//
//  GSEvent.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSEvent.h"
#import "GroveSupportInternal.h"
#import "GSEventPayload.h"

@implementation GSEvent

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {
		GSObjectAssign(dictionary, @"actor", _actor, GSActor);
		GSObjectAssign(dictionary, @"repo", _repository, GSRepository);
		GSObjectAssign(dictionary, @"payload", _payload, GSEventPayload);
		
		_createdDate = [self dateFromISO8601String:dictionary[@"created_at"]];
		_publicallyAvailable = [dictionary[@"public"] boolValue];
		_type = [self notificationEventTypeFromString:dictionary[@"type"]];
        
        
        if (_type == GSEventTypeIssueComment) {
        }
	}
	return self;
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
							   @"WatchEvent"				:@(GSEventTypeWatch)
							};

	return mapping[string] ? [mapping[string] intValue] : GSEventTypeUnknown;
}

- (NSString *)description {
#if DEBUG
	return [NSString stringWithFormat:@"<%@: %p; id = %@;>", NSStringFromClass([self class]), self, self.identifier];
#else
	return [super description];
#endif
}

@end
