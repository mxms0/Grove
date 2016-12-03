//
//  GRRepositoryViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 11/12/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <GroveSupport/GroveSupport.h>

#import "GRRepositoryViewController.h"
#import "GRRepositoryNavigationController.h"
#import "GRTabBarController.h"

//View Controllers
#import "GRRespositoryInformationViewController.h"
#import "GRRepositoryBranchesTableViewController.h"
#import "GRRepositoryIssuesViewController.h"
#import "GRRepositoryPullRequestViewController.h"

//Models
#import "GRBranchesModel.h"

@interface GRRepositoryViewController ()
@property (nonatomic) GRTabBarController *tabBarController;
@end

@implementation GRRepositoryViewController

- (instancetype)initWithRepositoryName:(NSString *)name owner:(NSString *)owner {
    self = [self init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithRepository:(GSRepository *)repository {
    self = [super init];
    if (self) {
        self.tabBarController = [[GRTabBarController alloc] init];
        
        GRBranchesModel *branchModel = [[GRBranchesModel alloc] initWithRepository:repository];
        
        GRRespositoryInformationViewController *infomationViewController = [[GRRespositoryInformationViewController alloc] init];
        GRRepositoryBranchesTableViewController *branchesViewController  = [[GRRepositoryBranchesTableViewController alloc] initWithModel:branchModel];
        GRRepositoryIssuesViewController *issuesViewController           = [[GRRepositoryIssuesViewController alloc] init];
        GRRepositoryPullRequestViewController *pullRequestViewController = [[GRRepositoryPullRequestViewController alloc] init];
        
        NSMutableArray *navigationControllers = [NSMutableArray array];
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
        for (GRViewController *viewController in @[infomationViewController, branchesViewController, issuesViewController, pullRequestViewController]) {
            GRRepositoryNavigationController *navigationController = [[GRRepositoryNavigationController alloc] initWithRootViewController:viewController];
            UITabBarItem *item                                     = [[UITabBarItem alloc] initWithTitle:GRLocalizedString(viewController.title, nil, nil) image:[UIImage imageNamed:@"tb@2x"] tag:0];
            
            [navigationController setTabBarController:self.tabBarController];
            [navigationController setPath:@[repository.owner.username, repository.name]];
            
            viewController.navigationItem.leftBarButtonItem = close;
            viewController.navigationItem.hidesBackButton   = YES;
            viewController.view.backgroundColor             = GSRandomUIColor();
            viewController.tabBarItem                       = item;
            
            [navigationControllers addObject:navigationController];
        }
        
        self.tabBarController.viewControllers = navigationControllers;
        
        [self.view addSubview:self.tabBarController.view];
        [self.tabBarController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [self setRepository:repository];
    }
    return self;
}

- (void)setRepository:(GSRepository *)newRepository {
    _repository = newRepository;
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
