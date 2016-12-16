//
//  GRRepositoryNavigationBar.m
//  Grove
//
//  Created by Rocco Del Priore on 12/3/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "GRRepositoryNavigationBar.h"

static const CGFloat GRSmallCapsLabelFontSize          = 12.0;
const CGFloat GRRepositoryNavigationBarExpansionHeight = 36.0;

@interface GRRepositoryNavigationBar ()
@property (nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation GRRepositoryNavigationBar {
    GRRepositoryNavigationBarState state;
    UIImageView *customBackgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
        customBackgroundView  = [[UIImageView alloc] initWithFrame:CGRectZero];
        state                 = GRRepositoryNavigationBarStateCollapsed;
        
        NSArray *fontFeatureSettings     = @[@{UIFontFeatureTypeIdentifierKey:@(kSmallCapsSelector), UIFontFeatureSelectorIdentifierKey:@(kSmallCapsSelector)}];
        NSDictionary *fontAttributes     = @{UIFontDescriptorFeatureSettingsAttribute:fontFeatureSettings, UIFontDescriptorNameAttribute:@"Helvetica-Bold"};
        UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:fontAttributes];
        UIFont *font                     = [UIFont fontWithDescriptor:fontDescriptor size:GRSmallCapsLabelFontSize];
        NSMutableParagraphStyle *style   = [[NSMutableParagraphStyle alloc] init];
        
        [self.segmentedControl insertSegmentWithTitle:@"Code" atIndex:0 animated:NO];
        [self.segmentedControl insertSegmentWithTitle:@"Commits" atIndex:1 animated:NO];
        [self.segmentedControl setSelectedSegmentIndex:0];
        [self.segmentedControl setAlpha:0];
        [self.segmentedControl setTintColor:[UIColor blackColor]];
        [style setAlignment:NSTextAlignmentCenter];
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
    
    //Insert Segmented Control, and ensure it is interactable
    if (self.superview) {
        if (![self.superview.subviews containsObject:self.segmentedControl]) {
            [self.superview addSubview:self.segmentedControl];
            [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.height.equalTo(@24);
                make.width.equalTo(@250);
                make.top.equalTo(self.mas_bottom).offset(6);
            }];
        }
        [self.superview bringSubviewToFront:self.segmentedControl];
    }
    
    //Ensure background view is in the background
    [self sendSubviewToBack:customBackgroundView];
    
    //Hide Control if Needed
    if (state == GRRepositoryNavigationBarStateCollapsed) {
        [self.segmentedControl setAlpha:0];
    }
    
    //Set custom background view properties based on actual background view
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
    //Ensure we have a change
    if (state != newState) {
        state        = newState;
        float alpha  = 0;
        CGRect frame = customBackgroundView.frame;
        
        //Set Variables based on state
        if (state == GRRepositoryNavigationBarStateCollapsed) {
            frame.size.height = frame.size.height-GRRepositoryNavigationBarExpansionHeight;
        }
        else {
            frame.size.height = frame.size.height+GRRepositoryNavigationBarExpansionHeight;
            alpha = 1;
        }
        
        //Perform animation
        [customBackgroundView setFrame:frame];
        [UIView animateWithDuration:.15 animations:^{
            [self.segmentedControl setAlpha:alpha];
        }];
    }
}

@end
