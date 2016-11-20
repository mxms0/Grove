//
//  GRRepositoryPullRequestTableViewCell.m
//  Grove
//
//  Created by Jim Boulter on 11/19/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPullRequestTableViewCell.h"
#import "GroveSupport.h"

@interface GRRepositoryPullRequestTableViewCell ()
@property (nonatomic, strong, nonnull) UIView* mergedStatusView;
@property (nonatomic, strong, nonnull) UILabel* titleLabel;
@property (nonatomic, strong, nonnull) UILabel* subtitleLabel;
@end

@implementation GRRepositoryPullRequestTableViewCell

-(instancetype)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    if(self) {
        _mergedStatusView = [[UIView alloc] init];
        [self.contentView addSubview:_mergedStatusView];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setNumberOfLines:0];
        [self.contentView addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] init];
        [_subtitleLabel setNumberOfLines:1];
        [self.contentView addSubview:_subtitleLabel];
        
        UIEdgeInsets pad = UIEdgeInsetsMake(10, 10, -10, -10);
        
        [_mergedStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@20);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_mergedStatusView).offset(pad.left);
            make.right.equalTo(self.contentView).offset(pad.right);
            make.top.equalTo(self.contentView).offset(pad.top);
        }];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(pad.top);
            make.left.equalTo(_titleLabel).offset(pad.left);
            make.right.equalTo(_titleLabel);
            make.bottom.equalTo(self.contentView).offset(pad.bottom);
        }];
    }
    return self;
}

-(void)configureWithPullRequest:(GSPullRequest*)pullRequest {
    
}

@end
