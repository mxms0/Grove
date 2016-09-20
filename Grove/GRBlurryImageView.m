//
//  GRBlurryImageView.m
//  Grove
//
//  Created by Jim Boulter on 9/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRBlurryImageView.h"

@import QuartzCore;
@import Accelerate;

@implementation GRBlurryImageView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	if (_blurRadius < 0.f || _blurRadius > 1.f) {
		_blurRadius = 0.5f;
	}
	int boxSize = (int)(_blurRadius * 40);
	boxSize = boxSize - (boxSize % 2) + 1;
	
	CGImageRef img = self.image.CGImage;
	vImage_Buffer inBuffer, outBuffer;
	vImage_Error error = 0;
	void *pixelBuffer = nil;
	
	//create vImage_Buffer with data from CGImageRef
	CGDataProviderRef inProvider = CGImageGetDataProvider(img);
	CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
	
	inBuffer.width = CGImageGetWidth(img);
	inBuffer.height = CGImageGetHeight(img);
	inBuffer.rowBytes = CGImageGetBytesPerRow(img);
	
	inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
	
	//create vImage_Buffer for output
	pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
	
	if(pixelBuffer == NULL)
		NSLog(@"No pixelbuffer");
	
	outBuffer.data = pixelBuffer;
	outBuffer.width = CGImageGetWidth(img);
	outBuffer.height = CGImageGetHeight(img);
	outBuffer.rowBytes = CGImageGetBytesPerRow(img);
	
	// Create a third buffer for intermediate processing
	void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
	vImage_Buffer outBuffer2;
	outBuffer2.data = pixelBuffer2;
	outBuffer2.width = CGImageGetWidth(img);
	outBuffer2.height = CGImageGetHeight(img);
	outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
	
	//perform convolution
	error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
	error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
	error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
	
	if (error) {
		NSLog(@"error from convolution %ld", error);
	}
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
											 outBuffer.width,
											 outBuffer.height,
											 8,
											 outBuffer.rowBytes,
											 colorSpace,
											 kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
	CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, imageRef);
	
	//clean up
	CGContextRelease(ctx);
	CGColorSpaceRelease(colorSpace);
	
	free(pixelBuffer);
	free(pixelBuffer2);
	
	CFRelease(inBitmapData);
	
	CGImageRelease(imageRef);
}

@end
