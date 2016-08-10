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
	UIActivityIndicatorView *activityIndicator;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[activityIndicator startAnimating];
		
		
		self.textLabel.text = @"README";
		self.textLabel.font = [UIFont boldSystemFontOfSize:14];
		
		readmeLabel = [[UILabel alloc] init];
		[readmeLabel setFont:[UIFont systemFontOfSize:13]];
		[readmeLabel setNumberOfLines:0];
		
		for (UIView *v in @[activityIndicator, readmeLabel]) {
			[self addSubview:v];
		}
		
		[self bringSubviewToFront:activityIndicator];
		
	}
	return self;
}

- (void)setReadMeString:(NSString *)readMeString {
	[activityIndicator removeFromSuperview];
	readmeLabel.text = readMeString;
	// ... post 
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat GRDefaultActivityIndicatorSize = 40.0f;
	
	[activityIndicator setFrame:CGRectMake(self.frame.size.width/2 - GRDefaultActivityIndicatorSize/2, self.frame.size.height/2 - GRDefaultActivityIndicatorSize/2, GRDefaultActivityIndicatorSize, GRDefaultActivityIndicatorSize)];
	
	[self.textLabel setFrame:CGRectMake(GRGenericVerticalPadding, GRGenericHorizontalPadding, self.frame.size.width - 2 * GRGenericHorizontalPadding, 15)];
	
	CGFloat verticalOffsetUsed = self.textLabel.frame.origin.y + self.textLabel.frame.size.height;
	
	[readmeLabel setFrame:CGRectMake(GRGenericHorizontalPadding, verticalOffsetUsed + GRGenericVerticalPadding/2, self.frame.size.width - GRGenericHorizontalPadding * 2, self.frame.size.height - (verticalOffsetUsed + GRGenericVerticalPadding))];
}

@end
