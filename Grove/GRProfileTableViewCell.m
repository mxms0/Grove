//
//  GRProfileTableViewCell.m
//  Grove
//
//  Created by Max Shavrick on 11/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRProfileTableViewCell.h"
#import "GRProfileTableViewCellContentView.h"

@implementation GRProfileTableViewCell {
    GRProfileTableViewCellContentView *contentView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        contentView = [[GRProfileTableViewCellContentView alloc] init];
        
        [self.contentView addSubview:contentView];
        
        UILabel *textLabel = self.textLabel;
        UILabel *detailLabel = self.detailTextLabel;
        UIImageView *imageView = self.imageView;
        
        [textLabel removeFromSuperview];
        [detailLabel removeFromSuperview];
        [imageView removeFromSuperview];
        
        [contentView addSubview:textLabel];
        [contentView addSubview:detailLabel];
        [contentView addSubview:imageView];
        
		[self setBackgroundColor:[UIColor clearColor]];
		[contentView setBackgroundColor:[UIColor whiteColor]];
        
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self.contentView setFrame:CGRectMake(GRProfileTableHorizontalPadding, 0, self.contentView.frame.size.width - 2 * GRProfileTableHorizontalPadding, self.contentView.frame.size.height)];
    
    [contentView setFrame:self.contentView.bounds];
}

@end
