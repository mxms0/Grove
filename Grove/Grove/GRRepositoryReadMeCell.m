//
//  GRRepositoryReadMeCell.m
//  Grove
//
//  Created by Max Shavrick on 3/26/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryReadMeCell.h"

@implementation GRRepositoryReadMeCell {
	UILabel *readmeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		self.textLabel.text = @"README";
		self.textLabel.font = [UIFont boldSystemFontOfSize:14];
		
		readmeLabel = [[UILabel alloc] init];
		[readmeLabel setFont:[UIFont systemFontOfSize:13]];
		[readmeLabel setNumberOfLines:3];
		
		[self addSubview:readmeLabel];
	}
	return self;
}

- (void)setReadMeString:(NSString *)readMeString {
	readmeLabel.text = readMeString;
	// ... post 
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[self.textLabel setFrame:CGRectMake(GRGenericVerticalPadding, GRGenericHorizontalPadding, self.frame.size.width - 2 * GRGenericHorizontalPadding, 15)];
	
	CGFloat verticalOffsetUsed = self.textLabel.frame.origin.y + self.textLabel.frame.size.height;
	
	[readmeLabel setFrame:CGRectMake(GRGenericHorizontalPadding, verticalOffsetUsed + GRGenericVerticalPadding/2, self.frame.size.width - GRGenericHorizontalPadding * 2, self.frame.size.height - (verticalOffsetUsed + GRGenericVerticalPadding))];
}

@end
