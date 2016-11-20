//
//  GRStreamEventCell.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

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
	
	BOOL hasSubcell;
	CGFloat subCellHeight;
    GRStreamCellModel *eventModel;
}

#pragma mark Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        imageView     = [[UIImageView alloc] initWithFrame:CGRectZero];
        titleLabel    = [[GRLabel alloc] initWithFrame:CGRectZero];
        timeLabel     = [[UILabel alloc] initWithFrame:CGRectZero];
        usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subCellView   = [[GRStreamSubCellView alloc] init];
		
		[imageView setContentMode:UIViewContentModeScaleAspectFit];
		[imageView setBackgroundColor:[UIColor whiteColor]];
		[imageView.layer setCornerRadius:2.0f];
		[imageView.layer setMasksToBounds:YES];
		[titleLabel setBackgroundColor:[UIColor whiteColor]];
		[timeLabel setFont:[UIFont systemFontOfSize:11]];
		[timeLabel setTextColor:[UIColor darkGrayColor]];
		[timeLabel setTextAlignment:NSTextAlignmentRight];
        [usernameLabel setFont:[UIFont boldSystemFontOfSize:13]];
		
        [self.contentView addSubviews:@[imageView, titleLabel, usernameLabel, timeLabel]];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(eventModel.avatarSize.width));
            make.top.equalTo(self.contentView).offset(GRGenericVerticalPadding);
            make.left.equalTo(self.contentView).offset(GRGenericHorizontalPadding);
        }];
        [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(GRGenericHorizontalPadding);
            make.right.equalTo(timeLabel.mas_left);
            make.top.equalTo(imageView);
            make.height.equalTo(@(13));
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-GRGenericHorizontalPadding);
            make.top.height.equalTo(usernameLabel);
            make.width.equalTo(@(75));
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(usernameLabel.mas_bottom).offset(3);
            make.left.equalTo(usernameLabel);
            make.right.equalTo(timeLabel);
            make.height.greaterThanOrEqualTo(@(25));
        }];

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
    
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(eventModel.avatarSize.width));
    }];
	
    CGFloat leftOffsetUsed     = 0.0f;
    CGFloat verticalOffsetUsed = 0.0f;
	
	leftOffsetUsed += GRGenericHorizontalPadding;
	leftOffsetUsed += imageView.frame.size.width;
	leftOffsetUsed += GRGenericHorizontalPadding;
	
	verticalOffsetUsed += GRGenericVerticalPadding;
	verticalOffsetUsed += usernameLabel.frame.size.height;
	verticalOffsetUsed += 2;
	
	verticalOffsetUsed += GRGenericVerticalPadding;
	verticalOffsetUsed += [eventModel safeTextHeight] + 2;
	
    //TODO: Figure out what the hell this is and how to autolayout
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
