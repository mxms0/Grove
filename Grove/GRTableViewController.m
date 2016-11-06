//
//  GRTableViewController.m
//  Grove
//
//  Created by Max Shavrick on 1/15/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRTableViewController.h"
#import "GRAppNotificationManager.h"

@implementation GRTableViewController 

- (void)viewDidLoad {
	[super viewDidLoad];
	
		[[GRAppNotificationManager sharedInstance] postNotificationFromError:[NSError errorWithDomain:@"" code:44 userInfo:nil]];
}

@end
