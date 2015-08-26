//
//  GRNavigationController.m
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNavigationController.h"

@interface GRNavigationController ()

@end

@implementation GRNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarController = [[GRTabBarController alloc] init];
        [self setNavigationBarHidden:YES];
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.tabBarController = [[GRTabBarController alloc] init];
        [self setNavigationBarHidden:YES];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        self.tabBarController = [[GRTabBarController alloc] init];
        [self setNavigationBarHidden:YES];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self.tabBarController didPushViewController:self];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    [self.tabBarController didPopViewController:self];
    return viewController;
}

@end
