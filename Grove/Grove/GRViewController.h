//
//  GRViewController.h
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRViewController : UIViewController
- (void)presentErrorAndDismissIfPossible:(NSError *)error;
- (BOOL)isDismissable;
@end

