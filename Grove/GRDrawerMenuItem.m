//
//  GRDrawerMenuItem.m
//  Grove
//
//  Created by Max Shavrick on 4/17/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRDrawerMenuItem.h"

@implementation GRDrawerMenuItem 

+ (instancetype)drawerMenuItemWithText:(NSString *)text icon:(UIImage *)img target:(id)ta selector:(SEL)selector {
	return [[self alloc] initWithText:text icon:img target:ta selector:selector];
}

- (instancetype)initWithText:(NSString *)text icon:(UIImage *)img target:(id)target selector:(SEL)selector {
	if ((self = [super init])) {
		_selector = selector;
		_target = target;
		_text = text;
		_icon = img;
	}
	return self;
}

@end
