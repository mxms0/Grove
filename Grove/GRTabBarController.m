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
		self.delegate = self;
    }
    return self;
}

#pragma mark - Setters

- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    [super setViewControllers:viewControllers animated:animated];
    
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[GRNavigationController class]]) {
            [(GRNavigationController *)viewController setTabBarController:self];
        }
    }
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
	[navigationController showBackButtonAnimated:YES];
}

- (void)didPopViewController:(GRNavigationController *)navigationController {
    if (navigationController.viewControllers.count == 1) {
		[navigationController hideBackButtonAnimated:YES];
    }
}

@end
