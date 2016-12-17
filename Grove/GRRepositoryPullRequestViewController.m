//
//  GRRepositoryPullRequestViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 11/12/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPullRequestViewController.h"

@implementation GRRepositoryPullRequestViewController

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
    self.title = @"PR";
}


@end
