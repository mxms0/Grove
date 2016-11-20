//
//  GRRepositoryPullRequestsModel.h
//  Grove
//
//  Created by Max Shavrick on 1/27/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryGenericSectionModel.h"
#import "GSPullRequest.h"

@interface GRRepositoryPullRequestsModel : GRRepositoryGenericSectionModel

-(GSPullRequest*)pullRequestForRow:(NSInteger)row;

@end
