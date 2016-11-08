//
//  GRNavigationController.m
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNavigationController.h"

@implementation GRNavigationController

- (instancetype)init {
	if ((self = [super init])) {
		[self setNavigationBarHidden:YES];
    }
    return self;
}

- (void)popViewController {
	[self popViewControllerAnimated:YES];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
	if ((self = [super initWithRootViewController:rootViewController])) {
        [self setNavigationBarHidden:YES];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
	if ((self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass])) {
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
