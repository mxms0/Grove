//
//  GRViewController.m
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"
#import "GRAppNotificationManager.h"

@implementation GRViewController 

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)presentErrorAndDismissIfPossible:(NSError *)error {
	// Will improve error handling here.
	
	NSLog(@"Local Error: [%@]", error);
	
	[[GRAppNotificationManager sharedInstance] postNotificationFromError:[NSError errorWithDomain:@"" code:44 userInfo:nil]];
	
	if ([self isDismissable]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (BOOL)isDismissable {
	return YES;
}

@end
