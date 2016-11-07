//
//  GRBranchesModel.m
//  Grove
//
//  Created by Rocco Del Priore on 11/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>
#import "GRSessionManager.h"

#import "GRBranchesModel.h"

@interface GRBranchesModel ()
@property (nonatomic) GSRepository *repository;
@end

@implementation GRBranchesModel {
    NSArray <NSString *> *branches;
}
@synthesize delegate;

- (instancetype)initWithRepository:(GSRepository *)localRepository {
    self = [super init];
    if (self) {
        self.repository = localRepository;
        
        branches = @[];
        
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    [[GSGitHubEngine sharedInstance] branchesForRepository:self.repository completionHandler:^(NSArray * _Nullable localBranches, NSError * _Nullable error) {
        branches = localBranches;
        [self.delegate reloadData];
    }];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return branches.count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    return branches[indexPath.row];
}

@end
