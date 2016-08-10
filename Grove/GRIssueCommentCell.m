//
//  GRIssueCommentCell.m
//  Grove
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRIssueCommentCell.h"

@implementation GRIssueCommentCell {
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *commentLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Initialize Variables
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //Properties
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [timeLabel setFont:[UIFont systemFontOfSize:14]];
        [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [commentLabel setNumberOfLines:0];
        
        [imageView setBackgroundColor:[UIColor greenColor]];
        [nameLabel setBackgroundColor:[UIColor blackColor]];
        [timeLabel setBackgroundColor:[UIColor darkGrayColor]];
        [commentLabel setBackgroundColor:[UIColor orangeColor]];
        
        //Add Subviews
        for (UIView *view in @[imageView, nameLabel, commentLabel, timeLabel]) {
            [self.contentView addSubview:view];
        }
        
//        //Set constraints
//        [imageView makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.left.equalTo(self.contentView).offset(10);
//            make.size.equalTo(@30);
//        }];
//        [nameLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView).offset(5);
//            make.left.equalTo(imageView.right).offset(10);
//            make.height.equalTo(@14);
//            make.right.equalTo(timeLabel.left).offset(5);
//        }];
//        [timeLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(nameLabel);
//            make.bottom.equalTo(nameLabel);
//            make.right.equalTo(self.contentView).offset(-5);
//            make.width.equalTo(@24);
//        }];
//        [commentLabel makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(nameLabel.bottom);
//            make.left.equalTo(nameLabel);
//            make.right.equalTo(self.contentView).offset(-10);
//            make.bottom.equalTo(self.contentView).offset(-5);
//        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
}

@end
