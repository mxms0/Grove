//
//  GSEvent.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//
//	Events are designated by those things you see on your feed
//	Notifications are analogous to alerts. You see them when you click the alert icon on github.com

#import <Foundation/Foundation.h>

#import "GSActor.h"

typedef NS_ENUM(NSInteger, GSEventType) {
	GSEventTypeUnknown,
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
	GSEventTypeStar,
};

typedef NS_ENUM(NSInteger, GSEventAction) {
	GSEventActionUnknown,
	GSEventActionStarted,
	GSEventActionCreated,
	GSEventActionUpdated,
	GSEventActionEdited,
	GSEventActionOpened,
	GSEventActionClosed,
	GSEventActionPublished,
	GSEventActionReopened,
	GSEventActionAdded,
	GSEventActionRemoved,
	GSEventActionSynchronized,
	GSEventActionAssigned,
	GSEventActionUnassigned,
	GSEventActionLabeled,
	GSEventActionUnlabeled,
	GSEventActionNone
};

typedef NS_ENUM(NSInteger, GSEventRefType) {
	GSEventRefTypeUnknown,
	GSEventRefTypeRepository,
	GSEventRefTypeBranch,
	GSEventRefTypeTag,
};

@class GSIssue, GSComment, GSOrganization, GSRepository;

@interface GSEvent : GSObject
@property (nonatomic, readonly, strong) GSActor *actor;
@property (nonatomic, readonly, strong) GSActor *member;
@property (nonatomic, readonly, strong) GSRepository *repository;
@property (nonatomic, readonly) GSEventType type;
@property (nonatomic, readonly) BOOL publicallyAvailable;
@property (nonatomic, readonly, strong) GSOrganization *organization;
@property (nonatomic, readonly) GSEventAction action;
@property (nonatomic, readonly) NSString *ref;
@property (nonatomic, readonly) GSEventRefType refType;
@property (nonatomic, readonly) NSString *masterBranch;
@property (nonatomic, readonly) NSString *pusherType;
@property (nonatomic, readonly) NSNumber *pushIdentifier;
@property (nonatomic, readonly) NSNumber *size;
@property (nonatomic, readonly) NSNumber *distinctSize;
@property (nonatomic, readonly) NSString *branch;
@property (nonatomic, readonly) NSString *head;
@property (nonatomic, readonly) NSString *previousHead;
@property (nonatomic, readonly) NSArray  *commits;
@property (nonatomic, readonly) NSString *commitMessage;
@property (nonatomic, readonly) NSString *descriptionMessage;
@property (nonatomic, readonly) GSComment *comment;
@property (nonatomic, readonly) GSIssue *issue;
@property (nonatomic, readonly) GSRepository *forkee;
/* refine these.. */
/* organization == actor??? */
@end
