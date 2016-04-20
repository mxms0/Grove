//
//  GRTabBarController.h
//  Grove
//
//  Created by Rocco Del Priore on 8/23/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRTabBarController : UITabBarController <UITabBarControllerDelegate>

- (void)didPushViewController:(UINavigationController *)navigationController;
- (void)didPopViewController:(UINavigationController *)navigationController;

@end
