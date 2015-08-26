//
//  GSEvent.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSActor.h"
#import "GSObject.h"
#import "GSRepository.h"
#import "GSEventPayload.h"
#import "GSOrganization.h"

typedef NS_ENUM(NSInteger, GSEventType) {
	GSEventTypeCommitComment,
	GSEventTypeCreate,
	GSEventTypeDelete,
	GSEventTypeDeployment,
	GSEventTypeDeploymentStatus,
	GSEventTypeDownload,
	GSEventTypeFollow,
	GSEventTypeFork,
	GSEventTypeForkApply,
	GSEventTypeGistEvent,
	GSEventTypeGollumEvent,
	GSEventTypeIssueComment,
	GSEventTypeIssues,
	GSEventTypeMember,
	GSEventTypeMembership,
	GSEventTypePageBuild,
	GSEventTypePublic,
	GSEventTypePullRequest,
	GSEventTypePullRequestReviewComment,
	GSEventTypePush,
	GSEventTypeRelease,
	GSEventTypeRepository,
	GSEventTypeStatus,
	GSEventTypeTeamAdd,
	GSEventTypeWatch,
	GSEventTypeUnknown
};

@interface GSEvent : GSObject
@property (nonatomic, readonly) GSActor *actor;
@property (nonatomic, readonly) GSRepository *repository;
@property (nonatomic, readonly) NSDate *createdDate;
@property (nonatomic, readonly) GSEventPayload *payload;
@property (nonatomic, readonly) GSEventType type;
@property (nonatomic, readonly) BOOL publicallyAvailable;
@property (nonatomic, readonly) GSOrganization *organization;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end