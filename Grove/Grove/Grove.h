//
//  Grove.h
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef Grove_Grove_h
#define Grove_Grove_h

#import <Masonry/Masonry.h>

static inline UIColor *GRColorFromRGB(unsigned long long rgb) {
	return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

static inline CGFloat GRStatusBarHeight(void) {
	return [[UIApplication sharedApplication] statusBarFrame].size.height;
}


static inline UIColor *GSRandomUIColor() {
	CGFloat hue = (arc4random() % 256 / 256.0);
	CGFloat saturation = (arc4random() % 128 / 256.0) + 0.5;
	CGFloat brightness = (arc4random() % 128 / 256.0) + 0.5;
	CGFloat alpha = ((arc4random() % 128) / 256.0) + 0.5;
	
	UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
	return color;
}

#endif
