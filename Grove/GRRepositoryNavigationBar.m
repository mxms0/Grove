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

@implementation GRRepositoryNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    }
    return self;
}

@end
