//
//  GRRepositoryPullRequestsModel.m
//  Grove
//
//  Created by Max Shavrick on 1/27/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPullRequestsModel.h"
#import "GSRepositoryGitHubEngine.h"

@interface GRRepositoryPullRequestsModel ()
@property (nonatomic, strong, nullable) NSArray<GSPullRequest*>* pullRequests;
@end

@implementation GRRepositoryPullRequestsModel

- (instancetype)initWithRepository:(GSRepository *)repo;
{
	self = [super initWithRepository:repo];
	if(self) {
		GSGitHubEngine* engine = [GSGitHubEngine sharedInstance];
		
		[engine pullRequestsForRepository:repo completionHandler:^(NSArray * _Nullable pullRequests, NSError * _Nullable error) {
			if(!error) {
				self.pullRequests = pullRequests;
				[self update];
			}
		}];
	}
	return self;
}

-(NSUInteger)numberOfRowsInSection:(NSUInteger)section {
    return self.pullRequests.count;
}

-(NSUInteger)numberOfSections {
    return 1;
}

-(GSPullRequest*)pullRequestForRow:(NSInteger)row {
    return self.pullRequests[row];
}

@end
