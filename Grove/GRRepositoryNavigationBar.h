//
//  GRRepositoryNavigationBar.h
//  Grove
//
//  Created by Rocco Del Priore on 12/3/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRNavigationBar.h"

extern const CGFloat GRRepositoryNavigationBarExpansionHeight;

typedef NS_ENUM(NSInteger, GRRepositoryNavigationBarState) {
    GRRepositoryNavigationBarStateCollapsed,
    GRRepositoryNavigationBarStateExpanded
};

@interface GRRepositoryNavigationBar : GRNavigationBar

- (void)setState:(GRRepositoryNavigationBarState)state animated:(BOOL)animated;

@end
