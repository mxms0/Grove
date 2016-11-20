//
//  GRRepositoryPullRequestsView.m
//  Grove
//
//  Created by Max Shavrick on 1/27/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPullRequestsView.h"
#import "GRRepositoryPullRequestsModel.h"
#import "GRRepositoryPullRequestTableViewCell.h"

@interface GRRepositoryPullRequestsView ()
@property (nonatomic, strong, nonnull) UITableView* tableView;
@end

@implementation GRRepositoryPullRequestsView

-(void)commonInit {
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(Class)designatedModelClass {
    return [GRRepositoryPullRequestsModel class];
}

#pragma mark - Model Delegate

-(void)reloadView {
    [_tableView reloadData];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_model numberOfSections];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_model numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GRRepositoryPullRequestTableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GRRepositoryPullRequestTableViewCell class])];
    if(!cell) {
        cell = [[GRRepositoryPullRequestTableViewCell alloc] init];
    }
    
    GRRepositoryPullRequestsModel* model = (GRRepositoryPullRequestsModel*)_model;
    
    [cell configureWithPullRequest:[model pullRequestForRow:indexPath.row]];
    
    return cell;
}

@end
