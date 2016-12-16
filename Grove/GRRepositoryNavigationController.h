//
//  GRRepositoryNavigationController.h
//  Grove
//
//  Created by Rocco Del Priore on 11/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRNavigationController.h"
#import "GRRepositoryNavigationBar.h"

@interface GRRepositoryNavigationController : GRNavigationController

@property (nonatomic) GRNavigationController *parentNavigationController;

- (NSString *)path;

- (void)setPath:(NSArray *)array;

- (void)pushViewController:(UIViewController *)viewController withComponent:(NSString *)component animated:(BOOL)animated;

- (void)pushProjectViewController:(UIViewController *)viewController withComponent:(NSString *)component animated:(BOOL)animated;

@end
