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
		[self setBackgroundColor:GSRandomUIColor()];
		profileImageView = [[UIImageView alloc] init];
		[profileImageView setBackgroundColor:[UIColor greenColor]];
		[self addSubview:profileImageView];
		
		usernameLabel = [[UILabel alloc] init];
		[usernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[self addSubview:usernameLabel];
		
		nameLabel = [[UILabel alloc] init];
		[nameLabel setFont:[UIFont systemFontOfSize:18]];
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
			[button setBackgroundColor:GSRandomUIColor()];
			[self addSubview:button];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[profileImageView setFrame:CGRectMake(8, 8, 72, 72)];
	[usernameLabel setFrame:CGRectMake(72 + 8 + 8, 8, (320 - (72 + 8 + 8)), 22)];
	[nameLabel setFrame:CGRectMake(72 + 8 + 8, 8 + 24 + 2, (320 - (72 + 8 + 8)), 20)];
	[locationLabel setFrame:CGRectMake(72 + 8 + 8, 8 + 24 + 22 + 2 + 2, (320 - (72 + 8 + 8)), 20)];
	
	NSArray *statsButtons = @[followersButton, starredButton, followingButton];
	
	for (int i = 0; i < 3; i++) {
		GRProfileStatisticButton *button = statsButtons[i];
		[button setFrame:CGRectMake(floorf(i * self.frame.size.width / 3), (profileImageView.frame.size.height + profileImageView.frame.origin.y * 2), floorf(self.frame.size.width/3), 64)];
	}
}

- (void)configureWithUser:(GSUser *)user {
	[usernameLabel setText:[user username]];
	[nameLabel setText:[user fullName]];
	[locationLabel setText:[user location]];

	
	[followingButton setText:[[user followingCount] stringValue]];
	[followersButton setText:[[user followersCount] stringValue]];
}

@end
