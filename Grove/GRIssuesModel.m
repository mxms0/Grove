//
//  GRIssuesModel.m
//  Grove
//
//  Created by Rocco Del Priore on 12/3/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

#import "GRIssuesModel.h"

@interface GRIssuesModel ()
@property (nonatomic) GSRepository *repository;
@end

@implementation GRIssuesModel {
    NSArray<GSIssue *> *issues;
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
        issues = localIssues;
        [self.delegate reloadData];
    }];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return issues.count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    GSIssue *issue = issues[indexPath.row];
    return issue.title;
}

@end
