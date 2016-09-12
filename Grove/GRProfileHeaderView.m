//
//  GRProfileHeaderView.m
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileHeaderView.h"
#import "GSUser.h"
#import "Grove.h"
#import "GRApplicationUser.h"
#import "GRProfileStatisticButton.h"
#import <GroveSupport/GroveSupport.h>

@implementation GRProfileHeaderView {
	UIImageView *profileImageView;
	UIImageView *backgroundImageView;
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
		[self setBackgroundColor:[UIColor whiteColor]];
		
		profileImageView = [[UIImageView alloc] init];
		[profileImageView setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:profileImageView];
		
		backgroundImageView = [[UIImageView alloc] init];
		[backgroundImageView setBackgroundColor:[UIColor whiteColor]];
		[self insertSubview:backgroundImageView belowSubview:profileImageView];
		
		usernameLabel = [[UILabel alloc] init];
		[usernameLabel setFont:[UIFont systemFontOfSize:14]];
		[usernameLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:usernameLabel];
		
		nameLabel = [[UILabel alloc] init];
		[nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
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
		[statisticsView setBackgroundColor:[UIColor clearColor]];
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
	
	const CGFloat profilePictureSize = 64.0f;
	const CGFloat elementWidth = self.frame.size.width - 2 * GRGenericHorizontalPadding;
	
	CGFloat verticalOffsetUsed = 10.0f;
	const CGFloat realNameHeight = 18.0f;
	const CGFloat userNameHeight = 17.0f;
	const CGFloat locationHeight = 17.0f;
	
	[profileImageView setFrame:CGRectMake((self.frame.size.width/2 - profilePictureSize/2), verticalOffsetUsed, profilePictureSize, profilePictureSize)];
	
	[backgroundImageView setFrame:self.bounds];
	
	verticalOffsetUsed = profileImageView.frame.origin.y + profileImageView.frame.size.height;
	
	verticalOffsetUsed += GRGenericVerticalPadding / 2;
	
	[nameLabel setFrame:CGRectMake(GRGenericHorizontalPadding, verticalOffsetUsed, elementWidth, realNameHeight)];
	
	verticalOffsetUsed += nameLabel.frame.size.height;
	verticalOffsetUsed += GRGenericVerticalPadding / 2;
	
	[usernameLabel setFrame:CGRectMake(GRGenericHorizontalPadding, verticalOffsetUsed, elementWidth, userNameHeight)];
	
	verticalOffsetUsed += usernameLabel.frame.size.height;
	
	verticalOffsetUsed += GRGenericVerticalPadding;
	
	[locationLabel setFrame:CGRectMake(GRGenericHorizontalPadding, verticalOffsetUsed, elementWidth, locationHeight)];
	
	verticalOffsetUsed += locationLabel.frame.size.height;
	verticalOffsetUsed += GRGenericVerticalPadding / 2;
	
	CGFloat buttonViewWidth = .80 * self.frame.size.width;
	
	CGFloat leftOffset = (self.frame.size.width - buttonViewWidth) / 2.0;
	[statisticsView setFrame:CGRectMake(leftOffset, verticalOffsetUsed, buttonViewWidth, 50)];
	
	NSArray *statsButtons = @[followersButton, starredButton, followingButton];
	
	CGFloat buttonWidth = buttonViewWidth / 3.0;
	
	for (int i = 0; i < 3; i++) {
		GRProfileStatisticButton *button = statsButtons[i];
		[button setFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, 50)];
	}
	
	[self setUser:self.user];
}

- (void)setUser:(GRApplicationUser *)user {
	_user = user;
	[usernameLabel setText:[@"@" stringByAppendingString:[user.user username]]];
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
