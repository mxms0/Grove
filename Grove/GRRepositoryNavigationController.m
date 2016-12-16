//
//  GRRepositoryNavigationController.m
//  Grove
//
//  Created by Rocco Del Priore on 11/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryNavigationController.h"

@implementation GRRepositoryNavigationController {
    NSInteger initialPathLength;
    NSMutableArray *path;
    NSMutableDictionary *navigationBarStateMap;
}

- (instancetype)initWithNavigationBarClass:(Class)navigationBarClass toolbarClass:(Class)toolbarClass {
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        initialPathLength = 0;
        path = [NSMutableArray array];
        navigationBarStateMap = [NSMutableDictionary dictionary];
        self.navigationBarHidden = FALSE;
    }
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        initialPathLength = 0;
        path = [NSMutableArray array];
        navigationBarStateMap = [NSMutableDictionary dictionary];
        self.navigationBarHidden = FALSE;
    }
    return self;
}

#pragma mark - Helpers

- (NSString *)stringFromPath {
    NSString *string = @"";
    for (NSString *component in path) {
        if (string.length == 0) {
            string = component;
        }
        else {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"/%@", component]];
        }
    }
    return string;
}

#pragma mark - Modifiers

- (void)setPath:(NSArray *)array {
    path = [array mutableCopy];
    initialPathLength = path.count;
    [self.viewControllers.firstObject setTitle:[self stringFromPath]];
    [self popToRootViewControllerAnimated:NO];
}

#pragma mark - Accessors

- (NSString *)path {
    NSString *string = @"";
    for (NSString *component in path) {
        if ([path indexOfObject:component] == 0) {
            continue;
        }
        if (string.length == 0) {
            string = component;
        }
        else {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"/%@", component]];
        }
    }
    return string;
}

#pragma mark - Actions

- (void)pushViewController:(UIViewController *)viewController withComponent:(NSString *)component animated:(BOOL)animated {
    [path addObject:component];
    
    viewController.title                            = [self stringFromPath];
    viewController.navigationItem.leftBarButtonItem = self.viewControllers.lastObject.navigationItem.leftBarButtonItem;
    viewController.navigationItem.hidesBackButton   = YES;
    
    [super pushViewController:viewController animated:YES];
    
    navigationBarStateMap[@(self.viewControllers.count)] = @(GRRepositoryNavigationBarStateExpanded);
}

- (void)pushProjectViewController:(UIViewController *)viewController withComponent:(NSString *)component animated:(BOOL)animated {
    if ([self.navigationBar isKindOfClass:[GRRepositoryNavigationBar class]]) {
        [(GRRepositoryNavigationBar *)self.navigationBar setState:GRRepositoryNavigationBarStateExpanded animated:animated];
    }
    [self pushViewController:viewController withComponent:component animated:animated];
    navigationBarStateMap[@(self.viewControllers.count)] = @(GRRepositoryNavigationBarStateExpanded);
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *viewController = [super popViewControllerAnimated:animated];

    GRRepositoryNavigationBarState state = [navigationBarStateMap[@(self.viewControllers.count)] integerValue];
    [navigationBarStateMap removeObjectForKey:@(self.viewControllers.count+1)];
    
    if ([self.navigationBar isKindOfClass:[GRRepositoryNavigationBar class]]) {
        [(GRRepositoryNavigationBar *)self.navigationBar setState:state animated:animated];
    }
    
    if (path.count > initialPathLength) {
        [path removeLastObject];
        viewController.title = [self stringFromPath];
    }
    
    return viewController;
}

@end
