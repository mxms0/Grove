//
//  GRNotificationTitleView.m
//  Grove
//
//  Created by Max Shavrick on 2/22/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRNotificationTitleView.h"
#import "GRSmallCapsLabel.h"

@implementation GRNotificationTitleView {
	GRSmallCapsLabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        
		label = [[GRSmallCapsLabel alloc] init];
		[label setText:GRLocalizedString(@"notifications", nil, nil)];
        
		[self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.right.equalTo(self);
            make.height.equalTo(@(15));
        }];
	}
	return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, 45);
}

@end
