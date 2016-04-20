//
//  GRTabBarController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/23/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRTabBarController.h"
#import "GRDrawerView.h"
#import "GRNavigationController.h"
#import "GRTableViewController.h"

static const NSTimeInterval GRTabBarMenuDrawerAnimationDuration = 0.28f;
static const CGFloat GRTabBarMenuDrawerHeight = 200.0f;

@implementation GRTabBarController {
    GRNavigationController *currentNavigationController;
    UIButton *backButton;
	UIButton *touchCover;
	GRDrawerView *drawer;
}

#pragma mark - Initializer

- (instancetype)init {
	if ((self = [super init])) {
		self.delegate = self;
		drawer = [[GRDrawerView alloc] init];
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

#pragma mark - Menu Drawer

- (void)optionalPresentMenuDrawerForViewController:(UIViewController *)vc {
	if (self.selectedViewController == vc) {
		[self presentMenuDrawerForViewController:vc];
	}
}

- (void)presentMenuDrawerForViewController:(UIViewController *)vcc {
	@synchronized(self) {
		// XXX: put better lock in place so its not possible to call this during animation etc
		[self presentTouchBlockingView];
		[self placeMenuDrawerView];
		[self populateMenuDrawerFromViewController:vcc];
		[self makeMenuDrawerVisible];
		// populate list here
	}
}

- (void)populateMenuDrawerFromViewController:(UIViewController *)viewController {
	NSArray *items = nil;
	
	UIViewController *targetViewController = nil;
	
	if ([viewController respondsToSelector:@selector(drawerMenuItems)]) {
		targetViewController = viewController;

	}
	else if ([viewController isKindOfClass:[UINavigationController class]]) {
		UINavigationController *nav = (UINavigationController *)viewController;
		UIViewController *hopefullyActiveController = [nav topViewController];
		if ([hopefullyActiveController respondsToSelector:@selector(drawerMenuItems)]) {
			targetViewController = hopefullyActiveController;
		}
	}
	
	items = [(id <GRDrawerMenuViewDataSource>)targetViewController drawerMenuItems];

	[drawer setMenuItems:items];
}

- (UIView *)designatedDrawerParentView {
	return [[UIApplication sharedApplication] keyWindow];
}

- (void)placeMenuDrawerView {
	UIView *drawerParent = [self designatedDrawerParentView];
	[drawerParent addSubview:drawer];
	[drawerParent sendSubviewToBack:drawer];
	[drawer setFrame:CGRectMake(0, drawerParent.frame.size.height - GRTabBarMenuDrawerHeight, self.view.frame.size.height, GRTabBarMenuDrawerHeight)];
}

- (void)forcefullyDismissMenuDrawer:(UIButton *)bt {
	[touchCover removeFromSuperview];
	[self dismissMenuDrawer];
}

- (void)makeMenuDrawerVisible {
	[UIView animateWithDuration:GRTabBarMenuDrawerAnimationDuration delay:0.0f options:(0) animations:^{
		[self.view setFrame:CGRectMake(self.selectedViewController.view.frame.origin.x, -GRTabBarMenuDrawerHeight, self.selectedViewController.view.frame.size.width, self.selectedViewController.view.frame.size.height)];
	} completion:^(BOOL finished) {
		
	}];
}

- (void)dismissMenuDrawer {
	[UIView animateWithDuration:GRTabBarMenuDrawerAnimationDuration delay:0.0f options:(0) animations:^{
		[self.view setFrame:CGRectMake(self.selectedViewController.view.frame.origin.x, 0, self.selectedViewController.view.frame.size.width, self.selectedViewController.view.frame.size.height)];
	} completion:^(BOOL finished) {
		[drawer removeFromSuperview];
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


@end
