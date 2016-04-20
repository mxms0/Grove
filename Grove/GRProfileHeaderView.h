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
@property (nonatomic, weak, setter=setUser:) GRApplicationUser *user;
@property (nonatomic, weak, setter=setProfileImage:) UIImage *profileImage;
@end
