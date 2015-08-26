//
//  GREventViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GREventViewController.h"

#import "GREventIssueViewController.h"

@implementation GREventViewController

- (instancetype)initWithEvent:(GSEvent *)event {
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
            self = [[GREventIssueViewController alloc] initWithEvent:event];
            break;
        }
        case GSEventTypeIssues: {
            self = [[GREventIssueViewController alloc] initWithEvent:event];
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
        case GSEventTypeWatch: {
            
            break;
        }
        case GSEventTypeUnknown: {
            
            break;
        }
        default: {
            self = [super init];
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
