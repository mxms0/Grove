//
//  GRRepositoryPullRequestsModel.m
//  Grove
//
//  Created by Max Shavrick on 1/27/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPullRequestsModel.h"

@implementation GRRepositoryPullRequestsModel

-(NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    return self.repository.pullRequests.count;
}

-(NSUInteger)numberOfSections {
    return 1;
}

-(GSPullRequest*)pullRequestForRow:(NSInteger)row {
    return self.repository.pullRequests[row];
}

@end
