//
//  GRBranchesTableViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryBranchesTableViewController.h"

@implementation GRRepositoryBranchesTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithModel:(id<GRDataSource>)model {
    self = [super initWithModel:model];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.title = @"Project";
}

@end
