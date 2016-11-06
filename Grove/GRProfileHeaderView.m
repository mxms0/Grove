//
//  GRProfileHeaderView.m
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

#import "GRProfileHeaderView.h"
#import "GSUser.h"
#import "Grove.h"
#import "GRApplicationUser.h"
#import "GRProfileStatisticButton.h"
#import "GRBlurryImageView.h"
#import <GroveSupport/GroveSupport.h>

@implementation GRProfileHeaderView {
	UIView *contentView;
	UIImageView *profileImageView;
    
    UIStackView *statisticsView;
    UIStackView *titlesView;
    
	UILabel *nameLabel;
	UILabel *usernameLabel;
	UILabel *locationLabel;
	
	GRProfileStatisticButton *followersButton;
	GRProfileStatisticButton *starredButton;
	GRProfileStatisticButton *followingButton;
}

- (instancetype)init {
	if ((self = [super init])) {
		contentView = [[UIView alloc] init];
		
		[self addSubview:contentView];
		
		[self setBackgroundColor:[UIColor clearColor]];
		[contentView setBackgroundColor:[UIColor whiteColor]];
		[contentView.layer setCornerRadius:10];
        
        statisticsView      = [[UIStackView alloc] init];
        titlesView          = [[UIStackView alloc] init];
        profileImageView    = [[UIImageView alloc] init];
        usernameLabel       = [[UILabel alloc] init];
        nameLabel           = [[UILabel alloc] init];
        locationLabel       = [[UILabel alloc] init];
        followersButton     = [[GRProfileStatisticButton alloc] init];
        starredButton       = [[GRProfileStatisticButton alloc] init];
        followingButton     = [[GRProfileStatisticButton alloc] init];
        
		[profileImageView setBackgroundColor:[UIColor whiteColor]];
		[self addSubview:profileImageView];
		

		[usernameLabel setFont:[UIFont systemFontOfSize:14]];
		[usernameLabel setTextAlignment:NSTextAlignmentCenter];
		[nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[nameLabel setTextAlignment:NSTextAlignmentCenter];
		[locationLabel setTextAlignment:NSTextAlignmentCenter];
		[followersButton setSubText:@"Followers"];
		[starredButton setSubText:@"Starred"];
		[followingButton setSubText:@"Following"];
        [titlesView setDistribution:UIStackViewDistributionFillEqually];
        [titlesView setBackgroundColor:[UIColor clearColor]];
        [titlesView setAxis:UILayoutConstraintAxisVertical];
        [titlesView setSpacing:4];
        [statisticsView setDistribution:UIStackViewDistributionFillEqually];
        [statisticsView setBackgroundColor:[UIColor clearColor]];
        [statisticsView setAxis:UILayoutConstraintAxisHorizontal];
        
        for (GRProfileStatisticButton *button in @[followersButton, starredButton, followingButton]) {
            [button setBackgroundColor:[UIColor whiteColor]];
        }
        
        [titlesView addArrangedSubviews:@[nameLabel, usernameLabel, locationLabel]];
        [statisticsView addArrangedSubviews:@[followersButton, starredButton, followingButton]];
        [contentView addSubviews:@[profileImageView, titlesView, statisticsView]];
        
        [profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(4*GRGenericVerticalPadding);
            make.height.width.equalTo(@(64));
			make.centerY.equalTo(titlesView);
        }];
		
        [titlesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(65));
            make.left.equalTo(profileImageView.mas_right).offset(GRGenericHorizontalPadding);
            make.bottom.equalTo(statisticsView.mas_top).offset(-GRGenericVerticalPadding);
            make.right.equalTo(contentView).offset(-GRGenericHorizontalPadding);
        }];
		
        [statisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(contentView).offset(-GRGenericVerticalPadding);
            make.centerX.equalTo(contentView);
            make.height.equalTo(@(50));
            make.width.equalTo(@(300));
        }];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[contentView setFrame:CGRectMake(GRProfileTableHorizontalPadding, 0, self.frame.size.width - 2 * GRProfileTableHorizontalPadding, self.frame.size.height)];
	
	[self setUser:self.user];
}

- (void)setUser:(GRApplicationUser *)user {
	_user = user;
	if (!user) return;
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
