//
//  GRNotificationHeaderTableViewCell.m
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationHeaderTableViewCell.h"
#import "GRNotificationHeaderLabel.h"

@implementation GRNotificationHeaderTableViewCell {
	GRNotificationHeaderLabel *textLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		textLabel = [[GRNotificationHeaderLabel alloc] init];
        
		[textLabel setFont:[UIFont systemFontOfSize:12]];
		[textLabel setTextColor:[UIColor darkGrayColor]];
        
		[self addSubview:textLabel];
		[self.textLabel removeFromSuperview];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.left.equalTo(self).offset(15);
            make.top.bottom.equalTo(self);
        }];
	}
	return self;
}

- (void)setText:(NSString *)text {
	[textLabel setText:text];
}

@end
