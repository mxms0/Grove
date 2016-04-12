//
//  GRStreamEventCell.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "NSAttributedString+GRExtensions.h"

#import "GRStreamEventCell.h"
#import "GRStreamCellModel.h"
#import "GRLabel.h"
#import "GSEvent.h"
#import "GRStreamSubCellView.h"

@implementation GRStreamEventCell {
    UIImageView *imageView;
    GRLabel *titleLabel;
    UILabel *timeLabel;
	UILabel *usernameLabel;
	
	GRStreamSubCellView *subCellView;
	
    GRStreamCellModel *eventModel;
	
	BOOL hasSubcell;
	CGFloat subCellHeight;
}

#pragma mark Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		imageView		= [[UIImageView alloc] initWithFrame:CGRectZero];
		titleLabel		= [[GRLabel alloc] initWithFrame:CGRectZero];
		timeLabel		= [[UILabel alloc] initWithFrame:CGRectZero];
		usernameLabel	= [[UILabel alloc] initWithFrame:CGRectZero];
		
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		[imageView setBackgroundColor:[UIColor whiteColor]];
		[imageView.layer setCornerRadius:2.0f];
		[imageView.layer setMasksToBounds:YES];
		
		[titleLabel setBackgroundColor:[UIColor whiteColor]];
		
		[timeLabel setFont:[UIFont systemFontOfSize:11]];
		[timeLabel setTextColor:[UIColor darkGrayColor]];
		[timeLabel setTextAlignment:NSTextAlignmentRight];
		
		[usernameLabel setFont:[UIFont boldSystemFontOfSize:13]];
		
		subCellView = [[GRStreamSubCellView alloc] init];
		
		[self setBackgroundColor:[UIColor clearColor]];
		
		for (UIView *view in @[imageView, titleLabel, usernameLabel, timeLabel]) {
			[self.contentView addSubview:view];
		}
	}
	return self;
}

- (void)setAvatar:(UIImage *)image {
	[imageView setImage:image];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGFloat leftOffsetUsed = 0.0f;
	CGFloat verticalOffsetUsed = 0.0f;
	
	leftOffsetUsed += GRGenericHorizontalPadding;
	
	const CGFloat avatarSize = eventModel.avatarSize.width;
	
	[imageView setFrame:CGRectMake(leftOffsetUsed, GRGenericVerticalPadding, avatarSize, avatarSize)];
	
	leftOffsetUsed += imageView.frame.size.width;
	
	leftOffsetUsed += GRGenericHorizontalPadding;
	
	verticalOffsetUsed += GRGenericVerticalPadding;
	
	[usernameLabel setFrame:CGRectMake(leftOffsetUsed, verticalOffsetUsed, self.frame.size.width - (leftOffsetUsed + GRGenericHorizontalPadding), 13)];
	
	verticalOffsetUsed += usernameLabel.frame.size.height;
	
	verticalOffsetUsed += 2;
	
	CGFloat textHeight = [eventModel safeTextHeight];
	
	[titleLabel setFrame:CGRectMake(leftOffsetUsed, verticalOffsetUsed, self.frame.size.width - (leftOffsetUsed + GRGenericHorizontalPadding), textHeight + 10)];
	
	[timeLabel setFrame:CGRectMake((self.frame.size.width - GRGenericHorizontalPadding - 75.0f), GRGenericVerticalPadding, 75.0f, 13)];
	
	verticalOffsetUsed += GRGenericVerticalPadding;
	
	verticalOffsetUsed += textHeight + 2;
	
	if (subCellView.superview) {
		[subCellView setFrame:CGRectMake(leftOffsetUsed, verticalOffsetUsed, self.frame.size.width - (leftOffsetUsed + GRGenericHorizontalPadding), subCellHeight)];
	}
}

- (void)configureWithEventModel:(GRStreamCellModel *)event {
	if ([event requiresSubCell]) {
		if (!subCellView.superview) {
			[self addSubview:subCellView];
		}
		[subCellView setText:[event subText]];
		[subCellView setImage:[event subImage]];
	}
	else {
		[subCellView removeFromSuperview];
	}
	
	subCellHeight = [event subCellHeight];
	
    eventModel = event;
	
	
    [timeLabel setText:[event dateStringFromEvent]];
    [titleLabel setAttributedString:[event eventString]];
	[titleLabel setNeedsDisplay];
	[usernameLabel setText:[event username]];
	[imageView setImage:[event imageIcon]];
//	[repoLabel setText:eventModel.event.repository.name];
//	[imageView setImage:[event imageIcon]];
}

@end
