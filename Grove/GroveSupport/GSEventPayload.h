//
//  GSEventPayload.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

typedef NS_ENUM(NSInteger, GSEventAction) {
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

@class GSComment, GSIssue;
@interface GSEventPayload : GSObject
@property (nonatomic, readonly) GSEventAction action;
@property (nonatomic, readonly) NSString *ref;
@property (nonatomic, readonly) NSString *refType;
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
@end
