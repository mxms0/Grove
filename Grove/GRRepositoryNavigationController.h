//
//  GRRepositoryNavigationController.h
//  Grove
//
//  Created by Rocco Del Priore on 11/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRNavigationController.h"

@interface GRRepositoryNavigationController : GRNavigationController

- (void)setPath:(NSArray *)array;

- (void)pushViewController:(UIViewController *)viewController withComponent:(NSString *)component animated:(BOOL)animated;

@end
