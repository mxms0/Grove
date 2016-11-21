//
//  GRCommitsModel.m
//  Grove
//
//  Created by Rocco Del Priore on 11/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>
#import "GRSessionManager.h"

#import "GRCommitsModel.h"

@interface GRCommitsModel ()
@property (nonatomic) GSRepository *repository;
@property (nonatomic) NSString *branch;
@end

@implementation GRCommitsModel {
    NSArray *commits;
}
@synthesize delegate;

- (instancetype)initWithRepository:(GSRepository *)repository branch:(NSString *)branch {
    self = [super init];
    if (self) {
        self.repository = repository;
        self.branch = branch;
        
        commits = [NSArray array];
        
        [self reloadData];
    }
    return self;
}

- (void)reloadData {
    [[GSGitHubEngine sharedInstance] commitsForRepository:self.repository branch:self.branch completionHandler:^(NSArray * _Nonnull commits, NSError * _Nonnull error) {
        //NSLog(@"Tits Up m9: %@", commits);
    }];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return commits.count;
}

@end
