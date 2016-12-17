//
//  GRPullRequestsModel.m
//  Grove
//
//  Created by Rocco Del Priore on 12/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

#import "GRPullRequestsModel.h"

@interface GRPullRequestsModel ()
@property (nonatomic) GSRepository *repository;
@end

@implementation GRPullRequestsModel {
    NSArray <GSPullRequest *> *pullRequests;
}
@synthesize delegate;

- (instancetype)initWithRepository:(GSRepository *)repository {
    self = [super init];
    if (self) {
        self.repository = repository;
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    [[GSGitHubEngine sharedInstance] pullRequestsForRepository:self.repository completionHandler:^(NSArray * _Nullable localPullRequests, NSError * _Nullable error) {
        pullRequests = localPullRequests;
        [self.delegate reloadData];
    }];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return pullRequests.count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    GSPullRequest *pullRequest = pullRequests[indexPath.row];
    return pullRequest.title;
}

@end
