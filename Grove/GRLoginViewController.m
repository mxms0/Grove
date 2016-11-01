//
//  GRLoginViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSGitHubEngine.h"
#import "GroveSupport.h"

#import "GRAppDelegate.h"
#import "GRSessionManager.h"
#import "GRLoginViewController.h"

@interface GRLoginViewController () <UITextFieldDelegate>
@end

@implementation GRLoginViewController {
    UIActivityIndicatorView *activityIndicator;
    UIStackView *stackView;
	UITextField *username;
	UITextField *password;
    UIView* tfa_placeholder;
	UITextField *tfa;
	UIButton *login;
	UIImageView *applicationIcon;
}

#pragma mark - Initialzers

- (instancetype)init {
	if ((self = [super init])) {
        self.view.backgroundColor = [UIColor whiteColor];
		
		//Initialize Variables
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        applicationIcon   = [[UIImageView alloc] init];
        stackView         = [[UIStackView alloc] init];
        username          = [[UITextField alloc] initWithFrame:CGRectZero];
        password          = [[UITextField alloc] initWithFrame:CGRectZero];
        tfa_placeholder   = [[UIView alloc] initWithFrame:CGRectZero];
        tfa               = [[UITextField alloc] initWithFrame:CGRectZero];
        login             = [[UIButton alloc] initWithFrame:CGRectZero];
        
        //Set Attributes
        [applicationIcon setImage:[UIImage imageNamed:@"applicationIconLarge"]];
        [stackView setDistribution:UIStackViewDistributionFillEqually];
        [stackView setAxis:UILayoutConstraintAxisVertical];
        [stackView setSpacing:10];
        [username setPlaceholder:@"Username"];
        [password setPlaceholder:@"Password"];
        [password setSecureTextEntry:YES];
        [tfa setPlaceholder:@"Two Factor Authentication"];
        [tfa setHidden:YES];
        [login setBackgroundColor:[UIColor colorWithRed:0.2627 green:0.4784 blue:0.7451 alpha:1.0]];
        [login setTitle:@"Login" forState:UIControlStateNormal];
        [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [login addTarget:self action:@selector(attemptLogin) forControlEvents:UIControlEventTouchUpInside];
		
		for (UIView *rounding in @[username, password, tfa, tfa_placeholder, applicationIcon]) {
			[rounding.layer setCornerRadius:3.0];
		}
        for (UIView *view in @[applicationIcon, username, password, login, activityIndicator, tfa]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField *)view setTextAlignment:NSTextAlignmentCenter];
                [(UITextField *)view setDelegate:self];
                [(UITextField *)view setBackgroundColor:GRColorFromRGB(0xD9D9D9)];
            }
        }
        
        //Add Subviews
        [tfa_placeholder addSubview:tfa];
        [stackView addArrangedSubviews:@[username, password, tfa_placeholder]];
        [self.view addSubviews:@[applicationIcon, stackView, login, activityIndicator]];
        
        //Add Constraints
        [tfa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(tfa_placeholder);
        }];
        
        [applicationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(15);
            make.centerX.equalTo(self.view);
        }];
        [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(applicationIcon.mas_bottom).offset(10);
            make.right.equalTo(self.view).offset(-30);
            make.left.equalTo(self.view).offset(30);
            make.height.equalTo(@(180));
        }];
        [login mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@(50));
        }];
	}
	return self;
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
