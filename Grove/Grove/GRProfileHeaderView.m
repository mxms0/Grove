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
		[usernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[usernameLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:usernameLabel];
		
		nameLabel = [[UILabel alloc] init];
		[nameLabel setFont:[UIFont systemFontOfSize:18]];
		[nameLabel setTextAlignment:NSTextAlignmentCenter];
		[self addSubview:nameLabel];
		
		locationLabel = [[UILabel alloc] init];
		[self addSubview:locationLabel];
		
		followersButton = [[GRProfileStatisticButton alloc] init];
		starredButton = [[GRProfileStatisticButton alloc] init];
		followingButton = [[GRProfileStatisticButton alloc] init];
		
		[followersButton setSubText:@"Followers"];
		
		[starredButton setSubText:@"Starred"];
		
		[followingButton setSubText:@"Following"];
		
		NSArray *statsButtons = @[followersButton, starredButton, followingButton];
		
		for (int i = 0; i < 3; i++) {
			GRProfileStatisticButton *button = statsButtons[i];
			[button setBackgroundColor:[UIColor whiteColor]];
			[self addSubview:button];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat genericHorizontalPadding = 10.0f;
	const CGFloat profilePictureSize = 64.0f;
	const CGFloat genericVerticalPadding = 5.0f;
	
	CGFloat verticalOffsetUsed = 5.0f;
	
	[usernameLabel setFrame:CGRectMake(genericHorizontalPadding, verticalOffsetUsed, self.frame.size.width - 2 * genericHorizontalPadding, 30.0f)];
	
	verticalOffsetUsed += usernameLabel.frame.origin.x + usernameLabel.frame.size.height;
	
	[profileImageView setFrame:CGRectMake((self.frame.size.width/2 - profilePictureSize/2), verticalOffsetUsed + genericVerticalPadding, profilePictureSize, profilePictureSize)];
	
	verticalOffsetUsed = profileImageView.frame.origin.y + profileImageView.frame.size.height;
	
	[nameLabel setFrame:CGRectMake(genericHorizontalPadding, verticalOffsetUsed + genericVerticalPadding, self.frame.size.width - genericHorizontalPadding * 2, 25)];

	[locationLabel setFrame:CGRectMake(72 + 8 + 8, 8 + 24 + 22 + 2 + 2, (320 - (72 + 8 + 8)), 20)];
	
	NSArray *statsButtons = @[followersButton, starredButton, followingButton];
	
	for (int i = 0; i < 3; i++) {
		GRProfileStatisticButton *button = statsButtons[i];
		[button setFrame:CGRectMake(floorf(i * self.frame.size.width / 3), (profileImageView.frame.size.height + profileImageView.frame.origin.y * 2), floorf(self.frame.size.width/3), 64)];
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
