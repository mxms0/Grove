//
//  GRNavigationController.m
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNavigationController.h"

static float animationDuration = 0.4f;

@implementation GRNavigationController {
	UIButton *backButton;
}

- (instancetype)init {
	if ((self = [super init])) {
        self.tabBarController = [[GRTabBarController alloc] init];
        [self setNavigationBarHidden:YES];
		
		[self commonInit];
    }
    return self;
}

- (void)commonInit {
	backButton = [[UIButton alloc] initWithFrame:CGRectZero];
	
	[backButton setBackgroundColor:[UIColor colorWithRed:50/255.0 green:60/255.0 blue:61/255.0 alpha:1.0]];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
	
	[backButton setFrame:CGRectMake(0, 800, 50, 34)];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:backButton];
	[self.view bringSubviewToFront:backButton];
}

- (void)popViewController {
	[self popViewControllerAnimated:YES];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
	if ((self = [super initWithRootViewController:rootViewController])) {
		self.tabBarController = [[GRTabBarController alloc] init];
        [self setNavigationBarHidden:YES];
		[self commonInit];
    }
    return self;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
	if ((self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass])) {
		self.tabBarController = [[GRTabBarController alloc] init];
		[self setNavigationBarHidden:YES];
		[self commonInit];
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

- (void)showBackButtonAnimated:(BOOL)anim {
	[UIView animateWithDuration:animationDuration animations:^{
		[backButton setFrame:CGRectMake(0, self.view.frame.size.height - 100.0, 50, 35)];
	}];
}

- (void)hideBackButtonAnimated:(BOOL)anim {
	[UIView animateWithDuration:animationDuration animations:^{
		[backButton setFrame:CGRectMake(0, self.view.frame.size.height, 50, 35)];
	}];
}

@end
