//
//  GRRepositoryPullRequestsView.m
//  Grove
//
//  Created by Max Shavrick on 1/27/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPullRequestsView.h"
#import "GRRepositoryPullRequestsModel.h"

@interface GRRepositoryPullRequestsView ()
@property (nonatomic, strong, nonnull) UITableView* tableView;
@end

@implementation GRRepositoryPullRequestsView

-(instancetype)init {
    self = [super init];
    if(self) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        _tableView = 
    }
    return self;
}

-(Class)designatedModelClass {
    return [GRRepositoryPullRequestsModel class];
}



@end
