//
//  GRRepositoryPullRequestTableViewCell.m
//  Grove
//
//  Created by Jim Boulter on 11/19/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPullRequestTableViewCell.h"

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
		[_titleLabel setTextColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]];
        [self.contentView addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] init];
		[_subtitleLabel setFont:[UIFont systemFontOfSize:14]];
		[_subtitleLabel setTextColor:[UIColor darkGrayColor]];
        [_subtitleLabel setNumberOfLines:1];
        [self.contentView addSubview:_subtitleLabel];
        
        UIEdgeInsets pad = UIEdgeInsetsMake(5, 10, -5, -10);
        
        [_mergedStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@20);
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_mergedStatusView.mas_right).offset(pad.left);
            make.right.equalTo(self.contentView).offset(pad.right);
            make.top.equalTo(self.contentView).offset(pad.top);
        }];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(pad.top);
			make.left.equalTo(_titleLabel);
            make.right.equalTo(_titleLabel);
            make.bottom.equalTo(self.contentView).offset(pad.bottom);
        }];
    }
    return self;
}

-(void)configureWithPullRequest:(GSPullRequest*)pullRequest {
    if(pullRequest.isOpen) {
        _mergedStatusView.backgroundColor = [UIColor greenColor];
    } else {
        _mergedStatusView.backgroundColor = [UIColor redColor];
    }
    
    _titleLabel.text = pullRequest.title;
    
    // Calculate days since creation
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSInteger days = [cal component:NSCalendarUnitDay fromDate:pullRequest.createdAt];
    
    _subtitleLabel.text = [NSString stringWithFormat:@"#%@ opened %ld days ago by %@", pullRequest.number, (long)days, pullRequest.user.username];
}

@end
