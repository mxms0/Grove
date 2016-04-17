//
//  GRSmallCapsLabel.m
//  Grove
//
//  Created by Max Shavrick on 2/20/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRSmallCapsLabel.h"
#import <CoreText/CoreText.h>

static const CGFloat GRSmallCapsLabelFontSize = 12.0;

@implementation GRSmallCapsLabel

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self commonInit];
	}
	return self;
}

- (instancetype)init {
	if ((self = [super init])) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	[self setBackgroundColor:[UIColor clearColor]];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	NSArray *fontFeatureSettings = @[@{UIFontFeatureTypeIdentifierKey:@(kSmallCapsSelector), UIFontFeatureSelectorIdentifierKey:@(kSmallCapsSelector)}];
	
	NSDictionary *fontAttributes = @{UIFontDescriptorFeatureSettingsAttribute:fontFeatureSettings, UIFontDescriptorNameAttribute:@"Helvetica-Bold"};
	
	UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:fontAttributes];
	
	UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:GRSmallCapsLabelFontSize];
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentCenter;
	
	[[UIColor blackColor] set];
	[[self.text uppercaseString] drawInRect:rect withAttributes:@{NSKernAttributeName: @(1.5), NSParagraphStyleAttributeName: style, NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]}];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self setNeedsDisplay];
}

@end
