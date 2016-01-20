//
//  GRApplicationUser.h
//  Grove
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSUser;

@interface GRApplicationUser : NSObject <NSCoding>
@property (nonatomic, weak) GSUser *user;
@property (nonatomic, strong) UIImage *profilePicture;
@property (nonatomic, strong) NSNumber *numberOfStarredRepositories;
- (void)prepareUnprocessedProfileImage:(UIImage *)image;
@end
