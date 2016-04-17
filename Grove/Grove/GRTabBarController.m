//
//  GRTabBarController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/23/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "GRTabBarController.h"
#import "GRNavigationController.h"

static const NSTimeInterval GRTabBarMenuDrawerAnimationDuration = 0.45f;
static const CGFloat GRTabBarMenuDrawerHeight = 200.0f;

@implementation GRTabBarController {
    GRNavigationController *currentNavigationController;
    UIButton *backButton;
	UIButton *touchCover;
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

- (BOOL)tabBarController:(nonnull UITabBarController *)tab shouldSelectViewController:(nonnull UIViewController *)viewController {
	[self optionalPresentMenuDrawerForViewController:viewController];
	return YES;
}

- (void)optionalPresentMenuDrawerForViewController:(UIViewController *)vc {
	if (self.selectedViewController == vc) {
		NSLog(@"SHOULD PRESENT");
		[self forcefullyPresentMenuDrawerForViewController:vc];
	}
}

- (void)forcefullyPresentMenuDrawerForViewController:(UIViewController *)vcc {
	@synchronized(self) {
		// XXX: put better lock in place so its not possible to call this during animation etc
		[self presentTouchBlockingView];
		[self placeMenuDrawerView];
		[self makeMenuDrawerVisible];
		// populate list here
	}
}

- (void)placeMenuDrawerView {
	UIView *v = [[UIView alloc] init];
	[v setBackgroundColor:[UIColor blueColor]];
	[self.view addSubview:v];
	[self.view sendSubviewToBack:v];
	[v setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.height, GRTabBarMenuDrawerHeight)];
}

- (void)forcefullyDismissMenuDrawer:(UIButton *)bt {
	[touchCover removeFromSuperview];
	[self dismissMenuDrawer];
}

- (void)makeMenuDrawerVisible {
	[UIView animateWithDuration:GRTabBarMenuDrawerAnimationDuration delay:0.0f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
				[self.view setFrame:CGRectMake(self.selectedViewController.view.frame.origin.x, -GRTabBarMenuDrawerHeight, self.selectedViewController.view.frame.size.width, self.selectedViewController.view.frame.size.height)];
	} completion:^(BOOL finished) {
		
	}];
}

- (void)dismissMenuDrawer {
	[UIView animateWithDuration:GRTabBarMenuDrawerAnimationDuration delay:0.0f options:(UIViewAnimationOptionCurveEaseOut) animations:^{
		[self.view setFrame:CGRectMake(self.selectedViewController.view.frame.origin.x, 0, self.selectedViewController.view.frame.size.width, self.selectedViewController.view.frame.size.height)];
	} completion:^(BOOL finished) {
		
	}];
}

- (void)presentTouchBlockingView {

	if (!touchCover) {
		touchCover = [[UIButton alloc] init];
		[touchCover setBackgroundColor:[UIColor clearColor]];
		[touchCover addTarget:self action:@selector(forcefullyDismissMenuDrawer:) forControlEvents:UIControlEventTouchUpInside];
		[touchCover setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	}
	
	[self.view addSubview:touchCover];
	[self.view bringSubviewToFront:touchCover];
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
