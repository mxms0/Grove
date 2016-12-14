//
//  GRRepositoryNavigationBar.m
//  Grove
//
//  Created by Rocco Del Priore on 12/3/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "GRRepositoryNavigationBar.h"

static const CGFloat GRSmallCapsLabelFontSize = 12.0;
const CGFloat GRRepositoryNavigationBarExpansionHeight = 36.0;

@implementation GRRepositoryNavigationBar {
    GRRepositoryNavigationBarState state;
    UIImageView *customBackgroundView;
    UISegmentedControl *control;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        customBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        control = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        state = GRRepositoryNavigationBarStateCollapsed;
        
        [control insertSegmentWithTitle:@"Code" atIndex:0 animated:NO];
        [control insertSegmentWithTitle:@"Commits" atIndex:1 animated:NO];
        [control setSelectedSegmentIndex:0];
        [control setAlpha:0];
        [control setTintColor:[UIColor blackColor]];
        
        NSArray *fontFeatureSettings = @[@{UIFontFeatureTypeIdentifierKey:@(kSmallCapsSelector), UIFontFeatureSelectorIdentifierKey:@(kSmallCapsSelector)}];
        
        NSDictionary *fontAttributes = @{UIFontDescriptorFeatureSettingsAttribute:fontFeatureSettings, UIFontDescriptorNameAttribute:@"Helvetica-Bold"};
        
        UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:fontAttributes];
        
        UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:GRSmallCapsLabelFontSize];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        
        [[UIColor blackColor] set];
        
        NSDictionary *dictionary = @{NSKernAttributeName: @(1.5), NSParagraphStyleAttributeName: style, NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};

        self.backgroundColor     = [UIColor colorWithWhite:.98 alpha:1];
        self.titleTextAttributes = dictionary;
        self.tintColor           = [UIColor blackColor];
        self.translucent         = NO;
        
        [self addSubview:customBackgroundView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview) {
        if (![self.superview.subviews containsObject:control]) {
            [self.superview addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.height.equalTo(@24);
                make.width.equalTo(@250);
                make.top.equalTo(self.mas_bottom).offset(6);
            }];
        }
        [self.superview bringSubviewToFront:control];
    }
    
    [self sendSubviewToBack:customBackgroundView];
    
    if (state == GRRepositoryNavigationBarStateCollapsed) {
        [control setAlpha:0];
    }
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")] ) {
            [subview setHidden:YES];
            [customBackgroundView setBackgroundColor:subview.backgroundColor];
            [customBackgroundView.layer setShadowColor:subview.layer.shadowColor];
            [customBackgroundView.layer setShadowOffset:subview.layer.shadowOffset];
            [customBackgroundView.layer setShadowOpacity:subview.layer.shadowOpacity];
            [customBackgroundView.layer setShadowRadius:subview.layer.shadowRadius];
            [customBackgroundView.layer setShadowPath:subview.layer.shadowPath];
            
            CGRect frame = subview.frame;
            if (state == GRRepositoryNavigationBarStateExpanded) {
                frame.size.height = frame.size.height+GRRepositoryNavigationBarExpansionHeight;
            }
            [customBackgroundView setFrame:frame];
            
            if ([subview respondsToSelector:@selector(image)]) {
                UIImage *image = [(UIImageView *)subview image];
                UIViewContentMode mode = [(UIImageView *)subview contentMode];
                
                [customBackgroundView setImage:image];
                [customBackgroundView setContentMode:mode];
            }
        }
    }
}

- (void)setState:(GRRepositoryNavigationBarState)newState animated:(BOOL)animated {
    if (state != newState) {
        float alpha = 0;
        if (newState == GRRepositoryNavigationBarStateCollapsed) {
            CGRect frame = customBackgroundView.frame;
            frame.size.height = frame.size.height-GRRepositoryNavigationBarExpansionHeight;
            [customBackgroundView setFrame:frame];
        }
        else {
            CGRect frame = customBackgroundView.frame;
            frame.size.height = frame.size.height+GRRepositoryNavigationBarExpansionHeight;
            [customBackgroundView setFrame:frame];
            alpha = 1;
        }
        state = newState;
        
        [UIView animateWithDuration:.15 animations:^{
            [control setAlpha:alpha];
        }];
    }
}

@end
