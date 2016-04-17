//
//  GRLoginViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "GSGitHubEngine.h"
#import "GroveSupport.h"

#import "GRAppDelegate.h"
#import "GRSessionManager.h"
#import "GRLoginViewController.h"

@interface GRLoginViewController () <UITextFieldDelegate>
@end

@implementation GRLoginViewController {
    UIActivityIndicatorView *activityIndicator;
	UITextField *username;
	UITextField *password;
	UITextField *tfa;
	UIButton *login;
	UIImageView *applicationIcon;
}

#pragma mark - Initialzers

- (instancetype)init {
	if ((self = [super init])) {
		applicationIcon = [[UIImageView alloc] init];
		[applicationIcon setImage:[UIImage imageNamed:@"applicationIconLarge"]];
		
		//Initialize Variables
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		username = [[UITextField alloc] initWithFrame:CGRectZero];
		password = [[UITextField alloc] initWithFrame:CGRectZero];
		tfa		 = [[UITextField alloc] initWithFrame:CGRectZero];
		login    = [[UIButton alloc] initWithFrame:CGRectZero];
		
		for (UIView *rounding in @[username, password, tfa, applicationIcon]) {
			[rounding.layer setCornerRadius:3.0];
		}
		
		//Set Attributes
		[username setPlaceholder:@"Username"];
		[password setPlaceholder:@"Password"];
		[password setSecureTextEntry:YES];
		[tfa setPlaceholder:@"Two Factor Authentication"];
		[tfa setHidden:YES];
		[login setBackgroundColor:[UIColor colorWithRed:0.2627 green:0.4784 blue:0.7451 alpha:1.0]];
		[login setTitle:@"Login" forState:UIControlStateNormal];
		[login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[login addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];

	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	//Add Subviews
	for (UIView *view in @[applicationIcon, username, password, login, activityIndicator, tfa]) {
		if ([view isKindOfClass:[UITextField class]]) {
			[(UITextField *)view setTextAlignment:NSTextAlignmentCenter];
			[(UITextField *)view setDelegate:self];
			[(UITextField *)view setBackgroundColor:GRColorFromRGB(0xD9D9D9)];
		}
		[self.view addSubview:view];
	}
	
	CGFloat constraintPadding = 115.0f;
	CGFloat iconWidth = self.view.frame.size.width - constraintPadding * 2;
	
	[applicationIcon setFrame:CGRectMake((self.view.frame.size.width/2 - iconWidth/2), 30, iconWidth, iconWidth)];
	
	[username setFrame:CGRectMake(70, applicationIcon.frame.origin.y + applicationIcon.frame.size.height + 20, 250, 50)];
	
	[password setFrame:CGRectMake(70, username.frame.origin.y + username.frame.size.height + 15, 250, 50)];

	[tfa setFrame:CGRectMake(70, password.frame.origin.y + password.frame.size.height + 15, 250, 50)];
	
	[login setFrame:CGRectMake(0, self.view.frame.size.height - 90, self.view.frame.size.width, 90)];
}

#pragma mark - Actions

- (void)attemptLogin {
	if (username.text && username.text.length > 0) {
		[password resignFirstResponder];
		[username resignFirstResponder];
		[tfa resignFirstResponder];
		
		
        [activityIndicator startAnimating];
		// XXX: This is synchronous, and GroveSupport has a note about it.
		// Probably will change.
		[[GSGitHubEngine sharedInstance] authenticateUserWithUsername:username.text password:password.text twoFactorToken:tfa.text completionHandler:^(GSUser *__nullable user, NSError *__nullable error) {
            [activityIndicator stopAnimating];
			if (user) {
				[[GRSessionManager sharedInstance] createApplicationUserWithUser:user becomeCurrentUser:YES];
				
				GRAppDelegate *appDelegate = (GRAppDelegate *)[[UIApplication sharedApplication] delegate];
				
				// XXX: Don't dismiss this view until the stream data has been loaded.
				// This might be quite a bit of work to sort of properly.
				// Since a ton of requests are made at this time. 
				
				[appDelegate presentTabBar];
				
				[[GRSessionManager sharedInstance] save];
			}
			
			else {
				
				NSDictionary *errorInfo = [error userInfo];
				if (errorInfo[GSRequires2FAErrorKey]) {
					NSLog(@"REQUIRE OAUTH TYPE %@", errorInfo[GSAuthCriteria]);
					GSTwoFactorAuthMethod method = (GSTwoFactorAuthMethod)[errorInfo[GSAuthCriteria] integerValue];
					__weak id weakSelf = self;
					dispatch_async(dispatch_get_main_queue(), ^ {
						[weakSelf displayTwoFactorAuthFieldForMethod:method];
					});
					return;
				}
				_GSAssert(NO, @"%@", error);
			}
		}];
	}
}

- (void)displayTwoFactorAuthFieldForMethod:(GSTwoFactorAuthMethod)meth {
	[tfa setHidden:NO];
	[tfa becomeFirstResponder];
	switch (meth) {
		case GSTwoFactorAuthMethodSMS:
		case GSTwoFactorAuthMethodApp:
		case GSTwoFactorAuthMethodUnknown:
			break;
	}
	
}

- (void)shiftViewContents {
	
}

#pragma mark - UITextField Delegate

- (BOOL)becomeFirstResponder {
	[self shiftViewContents];
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	return [super resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == username) {
		[password becomeFirstResponder];
		return YES;
	}
	
	[self attemptLogin];
	return YES;
}

- (BOOL)isDismissable {
	return NO;
}

@end
