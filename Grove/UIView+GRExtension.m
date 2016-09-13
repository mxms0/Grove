//
//  UIView+GRExtension.m
//  Grove
//
//  Created by Rocco Del Priore on 9/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "UIView+GRExtension.h"

@implementation UIView (GRExtension)

- (void)addSubviews:(NSArray <UIView *> *)subviews {
    for (UIView *view in subviews) {
        [self addSubview:view];
    }
}

@end
