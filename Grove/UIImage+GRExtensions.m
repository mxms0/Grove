//
//  UIImage+GRExtensions.m
//  Grove
//
//  Created by Max Shavrick on 8/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "UIImage+GRExtensions.h"

@implementation UIImage (GRExtensions)

- (UIImage *)imageByResizingToSize:(CGSize)targetSize roundingCornerRadius:(CGFloat)radius {
	UIImage *image = nil;
	UIGraphicsBeginImageContextWithOptions(targetSize, NO, 1.0);
	
	[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, targetSize.width, targetSize.height) cornerRadius:radius] addClip];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0.0, targetSize.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, targetSize.width, targetSize.height), self.CGImage);
	image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return image;
}

@end
