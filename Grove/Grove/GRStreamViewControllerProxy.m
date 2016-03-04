//
//  GREventViewControllerProxy.m
//  Grove
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRStreamViewControllerProxy.h"

#import "GREventIssueViewController.h"
#import "GRRepositoryViewController.h"

@implementation GRStreamViewControllerProxy

- (instancetype)initWithEvent:(GSEvent *)event {
	// Why do we have a view controller that actually isn't anything?
	// And why subclass it? That'll put us in a loop...
	// I corrected that issue, this thing should be removed however.
	// –Max
    switch (event.type) {
        case GSEventTypeCommitComment: {
            break;
        }
        case GSEventTypeCreate: {
			self = (GRStreamViewControllerProxy *)[[GRRepositoryViewController alloc] init];
			GSRepository *repository = [event repository];
			[(GRRepositoryViewController *)self setRepository:repository];
			
			switch ([event refType]) {
				// push to specific location in here..
				case GSEventRefTypeBranch:
				case GSEventRefTypeRepository:
				case GSEventRefTypeTag:
				case GSEventRefTypeUnknown:
					break;
			}

            break;
        }
        case GSEventTypeDelete: {
            break;
        }
        case GSEventTypeDeployment: {
            break;
        }
        case GSEventTypeDeploymentStatus: {
            break;
        }
        case GSEventTypeDownload: {
            
            break;
        }
        case GSEventTypeFollow: {
            
            break;
        }
        case GSEventTypeFork: {
			self = (GRStreamViewControllerProxy *)[[GRRepositoryViewController alloc] init];
			GSRepository *repository = [event forkee];
			[(GRRepositoryViewController *)self setRepository:repository];
			
            break;
        }
        case GSEventTypeForkApply: {
            
            break;
        }
        case GSEventTypeGistEvent: {
            
            break;
        }
        case GSEventTypeGollumEvent: {
            
            break;
        }
        case GSEventTypeIssueComment: {
            self = (GRStreamViewControllerProxy *)[[GREventIssueViewController alloc] initWithEvent:event];
            break;
        }
        case GSEventTypeIssues: {
            self = (GRStreamViewControllerProxy *)[[GREventIssueViewController alloc] initWithEvent:event];
            break;
        }
        case GSEventTypeMember: {
			self = (GRStreamViewControllerProxy *)[[GRRepositoryViewController alloc] init];
			GSRepository *repository = [event repository];
			[(GRRepositoryViewController *)self setRepository:repository];
            break;
        }
        case GSEventTypeMembership: {
            
            break;
        }
        case GSEventTypePageBuild: {
        
            break;
        }
        case GSEventTypePublic: {
            
            break;
        }
        case GSEventTypePullRequest: {
            
            break;
        }
        case GSEventTypePullRequestReviewComment: {
            
            break;
        }
        case GSEventTypePush: {
            
            break;
        }
        case GSEventTypeRelease: {
            
            break;
        }
        case GSEventTypeRepository: {
            break;
        }
        case GSEventTypeStatus: {
            
            break;
        }
        case GSEventTypeTeamAdd: {
            
            break;
        }
        case GSEventTypeStar: {
			self = (GRStreamViewControllerProxy *)[[GRRepositoryViewController alloc] init];
			GSRepository *repository = [event repository];
			[(GRRepositoryViewController *)self setRepository:repository];
			
			// contributing to murder
            break;
        }
        case GSEventTypeUnknown: {
            
            break;
        }
        default: {
			GSAssert();
            break;
        }
    }
    if (!self) {
		self = [super init];
    }
    return self;
}

@end
