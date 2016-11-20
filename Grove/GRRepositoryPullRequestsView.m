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

-(instancetype)init {
    self = [super init];
    if(self) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStyleGrouped];
        
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(Class)designatedModelClass {
    return [GRRepositoryPullRequestsModel class];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [model numberOfSections];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [model numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GRRepositoryPullRequestTableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GRRepositoryPullRequestTableViewCell class])];
    if(!cell) {
        cell = [[GRRepositoryPullRequestTableViewCell alloc] init];
    }
    
    [cell configureWithPullRequest:];
}

@end
