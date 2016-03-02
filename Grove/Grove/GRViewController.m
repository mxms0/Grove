//
//  GRViewController.m
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"

@interface GRViewController ()

@end

@implementation GRViewController 

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithWhite:.98 alpha:1];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)presentErrorAndDismissIfPossible:(NSError *)error {
	// Will improve error handling here.
	
	__weak GRViewController *weakSelf = self;
	
	dispatch_async(dispatch_get_main_queue(), ^ {
		
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
	
		UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			if ([weakSelf isDismissable])
				[weakSelf.navigationController popViewControllerAnimated:YES];
		}];
		[alertController addAction:dismiss];
	
		[self presentViewController:alertController animated:YES completion:nil];
	});
}

- (BOOL)isDismissable {
	return YES;
}

@end
