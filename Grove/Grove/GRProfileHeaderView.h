//
//  GRProfileHeaderView.h
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRApplicationUser;
@interface GRProfileHeaderView : UIView
- (void)configureWithUser:(GRApplicationUser *)user;
@end
