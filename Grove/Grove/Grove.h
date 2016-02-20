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

static CGFloat GRGenericHorizontalPadding = 10.0f;
static CGFloat GRGenericVerticalPadding = 10.0f;

#define GSLocalizedString(x,y,z) x
#define GSLocalizedStringFromTable(x,y,z) NSLocalizedStringFromTable(x,y,z)
#define GSLocalizedStringWithDefault(key,table,bundle,value,comment) NSLocalizedStringWithDefaultValue(key,table,bundle,value,comment)
// will replace these later on to find which strings arent localized yet.

extern void _GSAssert(BOOL, NSString *, ...);
#define GSAssert() _GSAssert(NO, @"(%s) in [%s:%d]", __PRETTY_FUNCTION__, __FILE__, __LINE__)

static NSString *const GRStreamViewControllerNotificationKey = @"GRStreamViewControllerNotificationKey";

#define GR_REGISTER_RELOAD_VIEW(x) \
	do { \
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_reloadNotification) name:x object:nil]; \
	} while (0); 

#define GR_RELOAD_VIEW(x) \
	do { \
		[[NSNotificationCenter defaultCenter] postNotificationName:x object:nil]; \
	} while (0);

#endif
