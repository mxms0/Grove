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
    UILabel *repoLabel;
    
    GREventCellModel *eventModel;
}

#pragma mark Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Initialize Variables
        imageView   = [[UIImageView alloc] initWithFrame:CGRectZero];
        titleLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
        repoLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //Set Properties
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleLabel setNumberOfLines:0];
        [timeLabel setFont:[UIFont systemFontOfSize:13]];
        [timeLabel setTextColor:[UIColor darkGrayColor]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        
        //Add Views
        for (UIView *view in @[imageView, titleLabel, repoLabel, timeLabel]) {
            [self.contentView addSubview:view];
        }
        
        //Set Constraints
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.top.equalTo(self.contentView).offset(30);
            make.bottom.equalTo(self.contentView).offset(-30);
            make.height.equalTo(imageView.width);
        }];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.bottom).offset(4);
            make.left.equalTo(imageView.right).offset(7);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(repoLabel.top).offset(-7);
        }];
        [repoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-4);
            make.left.equalTo(titleLabel);
            make.right.equalTo(titleLabel).offset(-5);
            make.height.equalTo(@18);
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(3);
            make.right.equalTo(self.contentView).offset(-3);
            make.height.equalTo(@10);
            make.width.equalTo(@65);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


- (void)configureWithEventModel:(GREventCellModel *)event; {
    eventModel = event;
    
    [timeLabel setText:[event dateStringFromEvent]];
    [titleLabel setAttributedText:[event eventString]];
//	[repoLabel setText:eventModel.event.repository.name];
//	[imageView setImage:[event imageIcon]];
}

@end
