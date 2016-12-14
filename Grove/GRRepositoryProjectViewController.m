//
//  GRProjectViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 12/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryNavigationController.h"

#import "GRRepositoryProjectViewController.h"

#import "GRRepositoryCodeTableViewController.h"

#import "GRCodeModel.h"

@interface GRRepositoryProjectViewController ()
@property (nonatomic) GRRepositoryCodeTableViewController *codeViewController;
@end

@implementation GRRepositoryProjectViewController

- (instancetype)initWithRepository:(GSRepository *)repository {
    self = [super init];
    if (self) {
        GRCodeModel *codeModel = [[GRCodeModel alloc] initWithRepository:repository];
        
        self.codeViewController = [[GRRepositoryCodeTableViewController alloc] initWithModel:codeModel];
        
        [self.view addSubview:self.codeViewController.view];
        [self addChildViewController:self.codeViewController];
        [self.codeViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(GRRepositoryNavigationBarExpansionHeight);
        }];
        
        [codeModel reloadDataAtPath:[(GRRepositoryNavigationController *)self.navigationController path]];
    }
    return self;
}

@end
