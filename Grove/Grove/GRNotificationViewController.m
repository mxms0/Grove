//
//  GRNotificationViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationViewController.h"

@implementation GRNotificationViewController

- (instancetype)init {
	if ((self = [super init])) {
        self.view.backgroundColor = [UIColor orangeColor];
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
		[indicator startAnimating];
		[self.view addSubview:indicator];
		[indicator makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(indicator.superview);
		}];
    }
    return self;
}

@end
