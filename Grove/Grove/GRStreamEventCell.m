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
#import "GREventCellModel.h"
#import "GSEvent.h"

@implementation GRStreamEventCell {
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *timeLabel;
	UILabel *usernameLabel;
    
    GREventCellModel *eventModel;
}

#pragma mark Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Initialize Variables
        imageView		= [[UIImageView alloc] initWithFrame:CGRectZero];
        titleLabel		= [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel		= [[UILabel alloc] initWithFrame:CGRectZero];
        usernameLabel	= [[UILabel alloc] initWithFrame:CGRectZero];
        
        //Set Properties
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
		[imageView setBackgroundColor:[UIColor whiteColor]];
		[imageView.layer setCornerRadius:2.0f];
		[imageView.layer setMasksToBounds:YES];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleLabel setNumberOfLines:0];
		[titleLabel setFont:[UIFont systemFontOfSize:13]];
        [timeLabel setFont:[UIFont systemFontOfSize:11]];
        [timeLabel setTextColor:[UIColor darkGrayColor]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
		
		[usernameLabel setFont:[UIFont boldSystemFontOfSize:13]];
        
        //Add Views
        for (UIView *view in @[imageView, titleLabel, usernameLabel, timeLabel]) {
            [self.contentView addSubview:view];
        }
    }
    return self;
}

- (void)setAvatar:(UIImage *)image {
	[imageView setImage:image];
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGFloat leftOffsetUsed = 0.0f;
	CGFloat verticalOffsetUsed = 0.0f;
	CGFloat genericHorizontalPadding = 10.0f;
	CGFloat genericVerticalPadding = 10.0f;
	
	leftOffsetUsed += genericHorizontalPadding;
	
	const CGFloat avatarSize = 38.0f;
	
	[imageView setFrame:CGRectMake(leftOffsetUsed, genericVerticalPadding, avatarSize, avatarSize)];
	
	leftOffsetUsed += imageView.frame.size.width;
	
	leftOffsetUsed += genericHorizontalPadding;
	
	verticalOffsetUsed += genericVerticalPadding;
	
	[usernameLabel setFrame:CGRectMake(leftOffsetUsed, verticalOffsetUsed, self.frame.size.width - (leftOffsetUsed + genericHorizontalPadding), 13)];
	
	verticalOffsetUsed += usernameLabel.frame.size.height;
	
	verticalOffsetUsed += floorf(genericVerticalPadding / 2);
	
	[titleLabel setFrame:CGRectMake(leftOffsetUsed, verticalOffsetUsed, self.frame.size.width - (leftOffsetUsed + genericHorizontalPadding), 40)];
	[titleLabel sizeToFit];
	
	[timeLabel setFrame:CGRectMake((self.frame.size.width - genericHorizontalPadding - 75.0f), genericVerticalPadding, 75.0f, 13)];
}

- (void)configureWithEventModel:(GREventCellModel *)event; {
    eventModel = event;
    
    [timeLabel setText:[event dateStringFromEvent]];
    [titleLabel setAttributedText:[event eventString]];
	[usernameLabel setText:[event username]];
	[imageView setImage:[event imageIcon]];
//	[repoLabel setText:eventModel.event.repository.name];
//	[imageView setImage:[event imageIcon]];
}

@end
