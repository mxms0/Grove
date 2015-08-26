//
//  GRNavigationController.h
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRTabBarController.h"

@interface GRNavigationController : UINavigationController
@property (nonatomic) GRTabBarController *tabBarController;
@end
