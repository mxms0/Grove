//
//  GREmptySectionHeaderFooterView.m
//  Grove
//
//  Created by Rocco Del Priore on 11/3/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GREmptySectionHeaderFooterView.h"

@implementation GREmptySectionHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame mode:(GRSectionHeaderFooterMode)_mode text:(NSString*)_text {
    if (_mode == GRSectionHeaderMode) {
        _text = [@"No " stringByAppendingString:_text.capitalizedString];
    }
    else if (_mode == GRSectionFooterMode && frame.size.height < 10) {
        CGRect modifiedFrame = frame;
        modifiedFrame.size.height = 10;
        frame = modifiedFrame;
    }
    self = [super initWithFrame:frame mode:_mode text:_text];
    if (self) {
        if (_mode == GRSectionHeaderMode) {
            [label setTextAlignment:NSTextAlignmentCenter];
        }
        else {
            [label setHidden:YES];
        }
    }
    return self;
}

@end
