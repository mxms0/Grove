//
//  GRAppDelegate.h
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRNavigationController.h"

@interface GRAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

- (void)presentLogin;
- (void)presentTabBar;

@end

