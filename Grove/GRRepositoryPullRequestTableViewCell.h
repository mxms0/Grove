//
//  GRRepositoryPullRequestTableViewCell.h
//  Grove
//
//  Created by Jim Boulter on 11/19/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSPullRequest.h" 

@interface GRRepositoryPullRequestTableViewCell : UITableViewCell

-(void)configureWithPullRequest:(GSPullRequest*)pullRequest;

@end
