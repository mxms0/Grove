//
//  GRNotificationHeaderTableViewCell.m
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationHeaderTableViewCell.h"

@implementation GRNotificationHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		[[self contentView] setBackgroundColor:GRColorFromRGB(0xf5f5f5)];
		[self.textLabel setFont:[UIFont systemFontOfSize:15]];
	}
	return self;
}

@end
