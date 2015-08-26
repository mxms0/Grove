//
//  GRProfileHeaderCell.m
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRProfileHeaderCell.h"
#import "GSUser.h"
#import "GRApplicationUser.h"

@implementation GRProfileHeaderCell {
	UIImageView *profileImageView;
	UILabel *nameLabel;
	UILabel *usernameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		profileImageView = [[UIImageView alloc] init];
		[profileImageView setBackgroundColor:[UIColor greenColor]];
		[self.contentView addSubview:profileImageView];
		
		usernameLabel = [[UILabel alloc] init];
		[usernameLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[self.contentView addSubview:usernameLabel];
		
		nameLabel = [[UILabel alloc] init];
		[nameLabel setFont:[UIFont systemFontOfSize:18]];
		[self.contentView addSubview:nameLabel];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[profileImageView setFrame:CGRectMake(8, 8, 72, 72)];
	[usernameLabel setFrame:CGRectMake(72 + 8 + 8, 8, (320 - (72 + 8 + 8)), 22)];
	[nameLabel setFrame:CGRectMake(72 + 8 + 8, 8 + 24 + 2, (320 - (72 + 8 + 8)), 20)];
}

- (void)configureWithUser:(GRApplicationUser *)appUser {
	[usernameLabel setText:[[appUser user] username]];
	[nameLabel setText:[[appUser user] fullName]];
	
}

@end
