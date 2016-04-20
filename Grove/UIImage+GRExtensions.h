//
//  UIImage+GRExtensions.h
//  Grove
//
//  Created by Max Shavrick on 8/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GRExtensions)
- (UIImage *)imageByResizingToSize:(CGSize)targetSize roundingCornerRadius:(CGFloat)radius;
@end
