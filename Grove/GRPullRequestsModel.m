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
    NSArray *pullRequests;
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
    [[GSGitHubEngine sharedInstance] issuesForRepository:self.repository completionHandler:^(NSArray * _Nonnull localIssues, NSError * _Nonnull error) {
        pullRequests = localIssues;
        [self.delegate reloadData];
    }];
    
    //[[GSGitHubEngine sharedInstance]
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 0;
}

//- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
//    GSIssue *issue = issues[indexPath.row];
//    return issue.title;
//}

@end
