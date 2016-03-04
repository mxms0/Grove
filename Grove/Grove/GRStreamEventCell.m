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

@implementation GRStreamEventCell {
    UIImageView *imageView;
    GRLabel *titleLabel;
    UILabel *timeLabel;
	UILabel *usernameLabel;
    
    GRStreamCellModel *eventModel;
}

#pragma mark Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Initialize Variables
        imageView		= [[UIImageView alloc] initWithFrame:CGRectZero];
        titleLabel		= [[GRLabel alloc] initWithFrame:CGRectZero];
        timeLabel		= [[UILabel alloc] initWithFrame:CGRectZero];
        usernameLabel	= [[UILabel alloc] initWithFrame:CGRectZero];
        
        //Set Properties
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
		[imageView setBackgroundColor:[UIColor whiteColor]];
		[imageView.layer setCornerRadius:2.0f];
		[imageView.layer setMasksToBounds:YES];
		
		[titleLabel setBackgroundColor:[UIColor whiteColor]];
		
//        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
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
	
	verticalOffsetUsed += floorf(GRGenericVerticalPadding / 2);
	
	[titleLabel setFrame:CGRectMake(leftOffsetUsed, verticalOffsetUsed, self.frame.size.width - (leftOffsetUsed + GRGenericHorizontalPadding), 40)];
	//[titleLabel sizeToFit];
	
	[timeLabel setFrame:CGRectMake((self.frame.size.width - GRGenericHorizontalPadding - 75.0f), GRGenericVerticalPadding, 75.0f, 13)];
}

- (void)configureWithEventModel:(GRStreamCellModel *)event; {
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
