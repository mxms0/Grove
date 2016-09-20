//
//  GRProfileStatisticButton.m
//  Grove
//
//  Created by Max Shavrick on 8/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

#import "GRProfileStatisticButton.h"

@implementation GRProfileStatisticButton {
	UILabel *text;
	UILabel *subText;
}

- (instancetype)init {
    if ((self = [super init])) {
        text    = [[UILabel alloc] init];
        subText = [[UILabel alloc] init];
        
        [text setFont:[UIFont boldSystemFontOfSize:17]];
        [text setTextAlignment:NSTextAlignmentCenter];
        [text setMinimumScaleFactor:0.5];
        [text setBackgroundColor:[UIColor clearColor]];
        [subText setTextAlignment:NSTextAlignmentCenter];
        [subText setFont:[UIFont systemFontOfSize:14]];
        [subText setMinimumScaleFactor:0.8];
        [subText setBackgroundColor:[UIColor clearColor]];
        
        [self addSubviews:@[text, subText]];
        
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(5));
            make.left.right.equalTo(self);
            make.height.equalTo(@(30));
        }];
        [subText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@(20));
        }];
    }
    return self;
}

- (void)setText:(NSString *)_text {
	[text setText:_text];
}

- (void)setSubText:(NSString *)_text {
	[subText setText:_text];
}

@end
