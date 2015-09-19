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
		textView = [[GRSyntaxHighlightedTextView alloc] initWithFrame:CGRectZero textContainer:nil];

		NSMutableString *string = [[NSMutableString alloc] init];
		[string appendString:@"/*"];
		[string appendString:@"\t dsfdsfds\r\n "];
		[string appendString:@"\t fdsfdsfds\r\n"];
		[string appendString:@"//fdsf dsfsdfsd\r\n\r\n"];
		[string appendString:@"*/"];
		for(int i = 0; i < 500; i++) {
			[string appendString:@"// fffd testing\r\nnot testing "];
		}

		[textView setText:string];
		[textView setSyntaxLanguage:GRSyntaxLanguageObjectiveC];
		NSLog(@"dfds %@", textView);
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor orangeColor];
	[self.view addSubview:textView];
	[textView setFrame:CGRectMake(0, 44, 320, 568)];
	[textView asynchronouslyHighlightSyntax];
	NSLog(@"Fff %@", textView);
}

@end
