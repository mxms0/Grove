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

@implementation GRIssuesModel

- (instancetype)initWithRepository:(GSRepository *)repository {
    self = [super init];
    if (self) {
        self.repository = repository;
        [self reloadData];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)reloadData {
    [[GSGitHubEngine sharedInstance] issuesForRepository:self.repository completionHandler:^(NSArray * _Nonnull issues, NSError * _Nonnull error) {
        //NSLog(@"Issues: %@", issues);
    }];
}

@end
