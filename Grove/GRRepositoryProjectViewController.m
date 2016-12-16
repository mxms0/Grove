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
#import "GRRepositoryCommitsTableViewController.h"

#import "GRCodeModel.h"
#import "GRCommitsModel.h"

@interface GRRepositoryProjectViewController ()
@property (nonatomic) GRRepositoryCodeTableViewController *codeViewController;
@property (nonatomic) GRRepositoryCommitsTableViewController *commitsViewController;
@end

@implementation GRRepositoryProjectViewController {
    NSMutableArray *navigationControllers;
}

- (instancetype)initWithRepository:(GSRepository *)repository branch:(NSString *)branch {
    self = [super init];
    if (self) {
        GRCodeModel *codeModel       = [[GRCodeModel alloc] initWithRepository:repository];
        GRCommitsModel *commitsModel = [[GRCommitsModel alloc] initWithRepository:repository branch:branch];
        
        self.codeViewController    = [[GRRepositoryCodeTableViewController alloc] initWithModel:codeModel];
        self.commitsViewController = [[GRRepositoryCommitsTableViewController alloc] initWithModel:commitsModel];
        
        GRRepositoryNavigationController *codeNavigationController    = [[GRRepositoryNavigationController alloc] initWithRootViewController:self.codeViewController];
        GRRepositoryNavigationController *commitsNavigationController = [[GRRepositoryNavigationController alloc] initWithRootViewController:self.commitsViewController];
        
        navigationControllers = [NSMutableArray arrayWithArray:@[codeNavigationController, commitsNavigationController]];
        for (UINavigationController *navigationController in navigationControllers) {
            [navigationController setNavigationBarHidden:YES];
        }
        
        [self.view addSubviews:@[commitsNavigationController.view, codeNavigationController.view]];
        [codeNavigationController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(GRRepositoryNavigationBarExpansionHeight);
        }];
        [commitsNavigationController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(GRRepositoryNavigationBarExpansionHeight);
        }];
        
        [codeModel reloadDataAtPath:[(GRRepositoryNavigationController *)self.navigationController path]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UISegmentedControl *segmentedControl = [(GRRepositoryNavigationBar *)self.navigationController.navigationBar segmentedControl];
    [segmentedControl addTarget:self action:@selector(navigationBarSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    if (segmentedControl.selectedSegmentIndex < 0) {
        [segmentedControl insertSegmentWithTitle:@"Code" atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithTitle:@"Commits" atIndex:1 animated:NO];
        [segmentedControl setSelectedSegmentIndex:0];
    }
    
    for (GRRepositoryNavigationController *navigationController in navigationControllers) {
        [navigationController setParentNavigationController:(GRRepositoryNavigationController *)self.navigationController];
        [navigationController setTabBarController:(GRTabBarController *)self.navigationController.tabBarController];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UISegmentedControl *segmentedControl = [(GRRepositoryNavigationBar *)self.navigationController.navigationBar segmentedControl];
    [self navigationBarSegmentedControlAction:segmentedControl];
}

- (void)navigationBarSegmentedControlAction:(UISegmentedControl *)control {
    UINavigationController *navigationController = navigationControllers[control.selectedSegmentIndex];
    [self.view bringSubviewToFront:navigationController.view];
    
    if (navigationController.viewControllers.count > 1) {
        [(GRTabBarController *)self.navigationController.tabBarController setNavigationController:navigationController];
    }
    else {
        [(GRTabBarController *)self.navigationController.tabBarController setNavigationController:self.navigationController];
    }
}

@end
