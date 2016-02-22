//
//  GRProfileHeaderView.m
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileHeaderView.h"
#import "GSUser.h"
#import "GRApplicationUser.h"
#import "GRProfileStatisticButton.h"
#import <GroveSupport/GroveSupport.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation GRProfileHeaderView {
	UIImageView *profileImageView;
	UILabel *nameLabel;
	UILabel *usernameLabel;
	UILabel *locationLabel;

	UIView *statisticsView;
	GRProfileStatisticButton *followersButton;
	GRProfileStatisticButton *starredButton;
	GRProfileStatisticButton *followingButton;
}

- (instancetype)init {
	if ((self = [super init])) {
		[self setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
		profileImageView = [[UIImageView alloc] init];
		[profileImageView setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:profileImageView];
		
		usernameLabel = [[UILabel alloc] init];
		[usernameLabel setFont:[UIFont systemFontOfSize:17]];
		[usernameLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:usernameLabel];
		
		nameLabel = [[UILabel alloc] init];
		[nameLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[nameLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:nameLabel];
		
		locationLabel = [[UILabel alloc] init];
		[locationLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:locationLabel];
		
		followersButton = [[GRProfileStatisticButton alloc] init];
		starredButton = [[GRProfileStatisticButton alloc] init];
		followingButton = [[GRProfileStatisticButton alloc] init];
		
		[followersButton setSubText:@"Followers"];
		
		[starredButton setSubText:@"Starred"];
		
		[followingButton setSubText:@"Following"];
		
		statisticsView = [[UIView alloc] init];
		[self addSubview:statisticsView];
		
		NSArray *statsButtons = @[followersButton, starredButton, followingButton];
		
		for (int i = 0; i < 3; i++) {
			GRProfileStatisticButton *button = statsButtons[i];
			[button setBackgroundColor:[UIColor whiteColor]];
			[statisticsView addSubview:button];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat genericHorizontalPadding = 10.0f;
	const CGFloat profilePictureSize = 64.0f;
	const CGFloat genericVerticalPadding = 5.0f;
	const CGFloat elementWidth = self.frame.size.width - 2 * genericHorizontalPadding;
	
	CGFloat verticalOffsetUsed = 10.0f;
	
	[profileImageView setFrame:CGRectMake((self.frame.size.width/2 - profilePictureSize/2), verticalOffsetUsed, profilePictureSize, profilePictureSize)];
	
	verticalOffsetUsed = profileImageView.frame.origin.y + profileImageView.frame.size.height;
	
	verticalOffsetUsed += genericVerticalPadding;
	
	[nameLabel setFrame:CGRectMake(genericHorizontalPadding, verticalOffsetUsed, elementWidth, 25)];
	
	verticalOffsetUsed += nameLabel.frame.size.height;
	verticalOffsetUsed += genericVerticalPadding;
	
	[usernameLabel setFrame:CGRectMake(genericHorizontalPadding, verticalOffsetUsed, elementWidth, 30.0f)];
	
	verticalOffsetUsed += usernameLabel.frame.size.height;
	
	verticalOffsetUsed += genericVerticalPadding;

	[locationLabel setFrame:CGRectMake(genericHorizontalPadding, verticalOffsetUsed, elementWidth, 20)];
	
	verticalOffsetUsed += locationLabel.frame.size.height;
	verticalOffsetUsed += genericVerticalPadding;
//	
	CGFloat buttonViewWidth = .80 * self.frame.size.width;
	
	CGFloat leftOffset = (self.frame.size.width - buttonViewWidth) / 2.0;
	[statisticsView setFrame:CGRectMake(leftOffset, verticalOffsetUsed, buttonViewWidth, 64)];
	
	NSArray *statsButtons = @[followersButton, starredButton, followingButton];
	
	CGFloat buttonWidth = buttonViewWidth / 3.0;
	
	for (int i = 0; i < 3; i++) {
		GRProfileStatisticButton *button = statsButtons[i];
		[button setFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, 64)];
	}
	
	[self setUser:self.user];
}

- (void)setUser:(GRApplicationUser *)user {
	_user = user;
	[usernameLabel setText:[user.user username]];
	[nameLabel setText:[user.user fullName]];
	[locationLabel setText:[user.user location]];

	[starredButton setText:[[user numberOfStarredRepositories] stringValue]];
	[followingButton setText:[[user.user followingCount] stringValue]];
	[followersButton setText:[[user.user followersCount] stringValue]];
}

- (void)setProfileImage:(UIImage *)profileImage {
	_profileImage = profileImage;
	[profileImageView setImage:profileImage];
}

@end
