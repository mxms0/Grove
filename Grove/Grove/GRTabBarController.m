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

static float animationDuration = 0.4f;

@implementation GRTabBarController {
    GRNavigationController *currentNavigationController;
    UIButton *backButton;
}

#pragma mark - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        //Initializers
        backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        //Attributes
        [backButton setBackgroundColor:[UIColor colorWithRed:50/255.0 green:60/255.0 blue:61/255.0 alpha:1.0]];
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popViewcontroller) forControlEvents:UIControlEventTouchUpInside];
        
        //Add Subview
        [self.view addSubview:backButton];
        
        //Set Constraints
        [backButton makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(self.tabBar);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.lessThanOrEqualTo(self.view.bottom).offset(0);
            make.top.greaterThanOrEqualTo(self.view.bottom).offset(-49);
        }];
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
    [UIView animateWithDuration:animationDuration animations:^{
        [backButton setFrame:CGRectMake(0, self.view.frame.size.height-49, backButton.frame.size.width, backButton.frame.size.height)];
    }];
}

- (void)didPopViewController:(GRNavigationController *)navigationController {
    if (navigationController.viewControllers.count == 1) {
        [UIView animateWithDuration:animationDuration animations:^{
            [backButton setFrame:CGRectMake(0, self.view.frame.size.height, backButton.frame.size.width, backButton.frame.size.height)];
        }];
    }
}

@end
