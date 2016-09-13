//
//  Grove.h
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef Grove_Grove_h
#define Grove_Grove_h

#import <UIKit/UIKit.h>
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

static inline NSString *GRRelativeDateStringFromDate(NSDate *date) {
	// XXX: this isn't perfect. I'll clean it up soon.
	unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
	NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:date toDate:[NSDate date] options:0];
	
	NSInteger months = [conversionInfo month];
	NSInteger days = [conversionInfo day];
	NSInteger hours = [conversionInfo hour];
	NSInteger minutes = [conversionInfo minute];
	
	NSString *dateString = nil;
	if (months > 0) {
		if (months == 1) {
			dateString = @"1 Month";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Months", (long)months];
		}
	}
	else if (days > 0) {
		if (days == 1) {
			dateString = @"1 Day";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Days", (long)days];
		}
	}
	else if (hours > 0) {
		if (hours == 1) {
			dateString = @"1 Hour";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Hours", (long)hours];
		}
	}
	else if (minutes > 0) {
		if (minutes == 1) {
			dateString = @"1 Minute";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Minutes", (long)minutes];
		}
	}
	
	return dateString;
}

static const CGFloat GRGenericHorizontalPadding = 10.0f;
static const CGFloat GRGenericVerticalPadding = 10.0f;

#define GRMaxf(x,y) ((x) > (y) ? (x) : (y))
#define GRMinf(x,y) ((x) < (y) ? (x) : (y))

#define GRLocalizedString(x,y,z) x
#define GRLocalizedStringFromTable(x,y,z) NSLocalizedStringFromTable(x,y,z)
#define GRLocalizedStringWithDefault(key,table,bundle,value,comment) NSLocalizedStringWithDefaultValue(key,table,bundle,value,comment)
// will replace these later on to find which strings arent localized yet.

extern void _GSAssert(BOOL, NSString *, ...);
#define GSAssert() _GSAssert(NO, @"(%s) in [%s:%d]", __PRETTY_FUNCTION__, __FILE__, __LINE__)

static NSString *const GRStreamViewControllerNotificationKey = @"GRStreamViewControllerNotificationKey";
static NSString *const GRApplicationStateNotificationTeardownKey = @"GRApplicationStateNotificationTeardownKey";
static NSString *const GRHighlightAttribute = @"GRHighlightAttribute";

#define GR_RELOAD_VIEW_REGISTER(x,sel) \
	do { \
		[[NSNotificationCenter defaultCenter] addObserver:x selector:sel name:GRStreamViewControllerNotificationKey object:nil]; \
	} while (0); 

#define GR_RELOAD_VIEW() \
	do { \
		[[NSNotificationCenter defaultCenter] postNotificationName:GRStreamViewControllerNotificationKey object:nil]; \
	} while (0);

#define GR_TEARDOWN_REGISTER(x,sel) \
	do { \
		[[NSNotificationCenter defaultCenter] addObserver:x selector:sel name:GRApplicationStateNotificationTeardownKey object:nil]; \
	} while (0);

#define GR_TEARDOWN_NOTIFY() \
	do { \
		[[NSNotificationCenter defaultCenter] postNotificationName:GRApplicationStateNotificationTeardownKey object:nil]; \
	} while (0);

#endif
