//
//  GRAppDelegate.m
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRAppDelegate.h"
#import "GRNavigationController.h"
#import "GRTabBarController.h"
#import "GRNavigationBar.h"

#import "GRLoginViewController.h"
#import "GRStreamViewController.h"
#import "GRNotificationViewController.h"
#import "GRActiveUserProfileViewController.h"
#import "GRSessionManager.h"
#import "GRRepositoryViewController.h"

@interface GRAppDelegate ()
@property (nonatomic) GRTabBarController *tabBarController;
@end

@implementation GRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	[[GRSessionManager sharedInstance] unpack];

	[self initializeApplicationInterface];
	
	return YES;
}

- (void)initializeViewForDebug {
	GRNavigationController *navigation = [[GRNavigationController alloc] init];
	
	UIViewController *viewController = nil;
	
	if (GRDebugTarget == GRDebugTargetProfileView) {
		viewController = [[GRProfileViewController alloc] initWithUsername:@"Maximus-"];
	}
	else if (GRDebugTarget == GRDebugTargetRepositoryView) {
		viewController = [[GRRepositoryViewController alloc] initWithRepositoryName:@"Grove" owner:@"Maximus-"];
	}
	else if (GRDebugTarget == GRDebugTargetNotificationsView) {
		viewController = [[GRNotificationViewController alloc] init];
	}
	else if (GRDebugTarget == GRDebugTargetLoginView) {
		viewController = [[GRLoginViewController alloc] init];
	}
	
	if (!viewController) {
		NSLog(@"Debug target specified to invalid selection. No view.");
		return;
	}
	
	navigation.viewControllers = @[viewController];
	
	self.window.rootViewController = navigation;
}

- (void)initializeApplicationInterface {
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window makeKeyAndVisible];
	
#if GRStaticDebugTarget != 0
	
	[self initializeViewForDebug];
	return;
	
#else
	
	[[UITabBar appearance] setBarTintColor:[UIColor clearColor]];
	[[UITabBar appearance] setBackgroundImage:[UIImage new]];
	
	if ([[[GRSessionManager sharedInstance] users] count] == 0) {
		
		GRLoginViewController *loginViewController = [[GRLoginViewController alloc] init];
		
		self.window.rootViewController = loginViewController;
		
		[[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
		[[UITabBar appearance] setBackgroundImage:[UIImage new]];
		[[UITabBar appearance] setShadowImage:[UIImage new]];
		
	}
	else {
		
		[self presentTabBar];
	}
	
	// this isn't the correct solution for this. only temporary.
	// Correct pattern should be as follows:
	// Application launches to loading screen everytimea
	// data present? - [ present login view controller
	//				   [ load data
	
#endif
}

- (void)presentLogin {
	GRLoginViewController *loginViewController = [[GRLoginViewController alloc] init];
	
	[UIView transitionWithView:self.window duration:0.5 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.window setRootViewController:loginViewController];
    } completion:nil];
}

- (void)presentTabBar {
    GRStreamViewController *streamViewController = [[GRStreamViewController alloc] init];
    GRNotificationViewController *notificationsViewController = [[GRNotificationViewController alloc] init];
    GRProfileViewController *profileViewController = [[GRActiveUserProfileViewController alloc] init];
    
    GRNavigationController *streamNavigationController = [[GRNavigationController alloc] initWithNavigationBarClass:[GRNavigationBar class] toolbarClass:[UIToolbar class]];

    GRNavigationController *notificationNavigationController = [[GRNavigationController alloc] initWithNavigationBarClass:[GRNavigationBar class] toolbarClass:[UIToolbar class]];
    GRNavigationController *profileNavigationController = [[GRNavigationController alloc] initWithNavigationBarClass:[GRNavigationBar class] toolbarClass:[UIToolbar class]];
    
    streamNavigationController.viewControllers = @[streamViewController];
    notificationNavigationController.viewControllers = @[notificationsViewController];
    profileNavigationController.viewControllers = @[profileViewController];
	
    self.tabBarController = [[GRTabBarController alloc] init];
    self.tabBarController.viewControllers = @[streamNavigationController, notificationNavigationController, profileNavigationController];
	
	self.window.rootViewController = self.tabBarController;
	
//    [UIView transitionWithView:self.window duration:0.5 options: UIViewAnimationOptionTransitionCrossDissolve animations:^{
//        [self.window setRootViewController:self.tabBarController];
//    } completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	/*
	NSArray *URLs = [[UIPasteboard generalPasteboard] URLs];
	NSArray *possibleURLS = [[UIPasteboard generalPasteboard] strings];
	 Check if these are valid GitHub related URLs. Also make this a setting, 
	 some users may not want me reading their clipboard.
	 */
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	GR_TEARDOWN_NOTIFY();
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
