//
//  GREventViewControllerProxy.m
//  Grove
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GREventViewControllerProxy.h"

#import "GREventIssueViewController.h"
#import "GRRepositoryViewController.h"

@implementation GREventViewControllerProxy

- (instancetype)initWithEvent:(GSEvent *)event {
	// this whole thing is bad practice.
	// what is happening here Rocky?
	// Why do we have a view controller that actually isn't anything?
	// And why subclass it? That'll put us in a loop...
	// I corrected that issue, this thing should be removed however.
	// –Max
    switch (event.type) {
        case GSEventTypeCommitComment: {
            break;
        }
        case GSEventTypeCreate: {
            
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
			self = (GREventViewControllerProxy *)[[GRRepositoryViewController alloc] init];
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
            self = (GREventViewControllerProxy *)[[GREventIssueViewController alloc] initWithEvent:event];
            break;
        }
        case GSEventTypeIssues: {
            self = (GREventViewControllerProxy *)[[GREventIssueViewController alloc] initWithEvent:event];
            break;
        }
        case GSEventTypeMember: {
            
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
			self = (GREventViewControllerProxy *)[[GRRepositoryViewController alloc] init];
			GSRepository *repository = [event repository];
			[(GRRepositoryViewController *)self setRepository:repository];
			
			// contributing to murder
            break;
        }
        case GSEventTypeUnknown: {
            
            break;
        }
        default: {
            self = [super init];
			NSLog(@"Allocating bad vc. !");
            break;
        }
    }
    if (self) {
        
    }
    else {
        self = [super init];
    }
    return self;
}

@end
