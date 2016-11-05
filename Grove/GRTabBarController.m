//
//  GRTabBarController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/23/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRTabBarController.h"
#import "GRNavigationController.h"
#import "GRTableViewController.h"

@implementation GRTabBarController {
    GRNavigationController *currentNavigationController;
    UIButton *backButton;
}

#pragma mark - Initializer

- (instancetype)init {
    if ((self = [super init])) {
        backButton = [[UIButton alloc] init];
        
        self.delegate = self;
        backButton.backgroundColor = self.tabBar.backgroundColor;
        backButton.titleLabel.text = @"Back";
        
        [backButton addTarget:self action:@selector(popViewcontroller) forControlEvents:UIControlEventTouchUpInside];
            
        [self.view addSubview:backButton];
        [backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.view);
            make.top.equalTo(self.tabBar);
            make.width.equalTo(@100);
        }];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateFrames];
}

- (void)updateFrames {
    //Variables
    CGFloat itemWidth = 0;
    CGFloat itemOffset = -self.view.frame.size.width/(self.tabBar.items.count+1);
    
    if (currentNavigationController.viewControllers.count > 1) {
        itemWidth = self.view.frame.size.width/(self.tabBar.items.count+1);
        itemOffset = 0;
    }
    
    //TabBar
    [self.tabBar setFrame:CGRectMake(itemWidth, self.tabBar.frame.origin.y, self.view.frame.size.width-itemWidth, self.tabBar.frame.size.height)];
    for (UIView *subview in self.tabBar.subviews) {
        if (![subview isKindOfClass:[UITabBarItem class]]) {
            [subview setFrame:CGRectMake(-itemWidth, subview.frame.origin.y, self.view.frame.size.width+itemWidth, subview.frame.size.height)];
        }
    }
    
    //Button
    [backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.tabBar);
        make.width.equalTo(self.view).dividedBy(self.tabBar.items.count+1);
        make.left.equalTo(self.view).offset(itemOffset);
    }];
}

#pragma mark - Setters

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[GRNavigationController class]]) {
            [(GRNavigationController *)viewController setTabBarController:self];
        }
    }
    
    [self updateFrames];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    [self setViewControllers:viewControllers animated:NO];
}

#pragma mark - Actions

- (void)popViewcontroller {
    [currentNavigationController popViewControllerAnimated:YES];
}

- (void)didPushViewController:(GRNavigationController *)navigationController {
    currentNavigationController = navigationController;
    [self updateFrames];
}

- (void)didPopViewController:(GRNavigationController *)navigationController {
    [self updateFrames];
}

@end
