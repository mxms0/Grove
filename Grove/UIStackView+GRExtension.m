//
//  UIStackView+GRExtension.m
//  Grove
//
//  Created by Rocco Del Priore on 9/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "UIStackView+GRExtension.h"

@implementation UIStackView (GRExtensions)

- (void)addArrangedSubviews:(NSArray <UIView *> *)views {
    for (UIView *view in views) {
        [self addArrangedSubview:view];
    }
}

@end
