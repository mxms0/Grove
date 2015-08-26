//
//  GREventCommitCommentViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GREventIssueViewController.h"
#import "GRIssueCommentCell.h"

@interface GREventIssueViewController () <UITableViewDataSource, UITableViewDelegate>
@end

static NSString *reuseIdetentifier = @"reuseIdentifier";

@implementation GREventIssueViewController {
    UIImageView *imageView;
    UILabel *infoLabel;
    UITextView *messageView;
    UITableView *tableView;
}

#pragma mark - Initializers

- (instancetype)initWithEvent:(GSEvent *)event {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        //Initialize Views
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
        messageView = [[UITextView alloc] initWithFrame:CGRectZero];
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        messageView = [[UITextView alloc] initWithFrame:CGRectZero];
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        //Set Attributes
        [tableView registerClass:[GRIssueCommentCell class] forCellReuseIdentifier:reuseIdetentifier];
        [tableView setDataSource:self];
        [titleView setBackgroundColor:[UIColor whiteColor]];
        [imageView setBackgroundColor:[UIColor orangeColor]];
        [infoLabel setBackgroundColor:[UIColor redColor]];
        [tableView setBackgroundColor:[UIColor clearColor]];
        
        //Add Subviews
        for (UIView *view in @[imageView, messageView, infoLabel]) {
            [titleView addSubview:view];
        }
        for (UIView *view in @[titleView, tableView]) {
            [self.view addSubview:view];
        }
        
        //Set Constraints
        [titleView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@80);
        }];
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView).offset(25);
            make.left.equalTo(titleView).offset(10);
            make.size.equalTo(@40);
        }];
        [infoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView);
            make.bottom.equalTo(imageView);
            make.left.equalTo(imageView.right).offset(5);
            make.right.equalTo(titleView).offset(-10);
        }];
        [tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView.bottom);
            make.right.equalTo(self.view);
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-49);
        }];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [imageView.layer setCornerRadius:3];
    [imageView.layer masksToBounds];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GRIssueCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetentifier];
    if (!cell) {
        cell = [[GRIssueCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetentifier];
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
