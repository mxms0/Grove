//
//  GRNotificationTableViewCell.m
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationTableViewCell.h"

@implementation GRNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		[self setBackgroundColor:[UIColor whiteColor]];
		self.separatorInset = UIEdgeInsetsMake(0, 20.0f, 0, 20.0f);
		self.selectionStyle = UITableViewCellSelectionStyleNone;

	}
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
}

- (void)setText:(NSString *)text {
	
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.contentView setFrame:CGRectMake(10, self.contentView.frame.origin.y, self.contentView.frame.size.width - 20, self.contentView.frame.size.height)];
	
	[self.textLabel setFrame:CGRectMake(10, self.textLabel.frame.origin.y, self.contentView.frame.size.width - 20, self.textLabel.frame.size.height)];
}

@end
