//
//  GRSectionHeaderFooterView.m
//  Grove
//
//  Created by Jim Boulter on 10/25/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRSectionHeaderFooterView.h"
#import <CoreText/CoreText.h>

@implementation GRSectionHeaderFooterView {
	UIView *contentView;
	CAShapeLayer *roundingMask;
}

const CGFloat GRSectionViewIndentationWidth = 10.0f;

- (instancetype)initWithFrame:(CGRect)frame mode:(GRSectionHeaderFooterMode)_mode text:(NSString *)_text {
	if ((self = [super initWithFrame:frame])) {
		
		contentView = [[UIView alloc] init];
		[self addSubview:contentView];
		
		[self setBackgroundColor:[UIColor clearColor]];
		[contentView setBackgroundColor:[UIColor whiteColor]];
		
		mode = _mode;
		
		label = [[UILabel alloc] init];
		[label setText:_text];
		[label setBackgroundColor:[UIColor whiteColor]];
		[label setFont:[UIFont fontWithName:@"Avenir Next" size:14]];
		
//		NSArray *fontFeatureSettings = @[ @{ UIFontFeatureTypeIdentifierKey: @(kLowerCaseType),
//											 UIFontFeatureSelectorIdentifierKey : @(kLowerCaseSmallCapsSelector) } ];
//		
//		NSLog(@"%@", [UIFont familyNames]);
//		NSDictionary *fontAttributes = @{ UIFontDescriptorFeatureSettingsAttribute: fontFeatureSettings ,
//										  UIFontDescriptorNameAttribute: @"Avenir Next" } ;
//		
//		UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes: fontAttributes ];
//		fontDescriptor = [fontDescriptor fontDescriptorByAddingAttributes:@{UIFontDescriptorTraitsAttribute : @{UIFontWeightTrait: @(UIFontWeightMedium)} }];
//		
//		[label setFont:[UIFont fontWithDescriptor:fontDescriptor size:14]];
		
		[contentView addSubview:label];
		
		roundingMask = [[CAShapeLayer alloc] init];
		
	}
	
	return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
    const CGFloat contentViewHeight = 35.0f;
    const CGFloat yDelta = self.frame.size.height - contentViewHeight;

	
	[contentView setFrame:CGRectMake(GRProfileTableHorizontalPadding, yDelta, self.frame.size.width - 2 * GRProfileTableHorizontalPadding, contentViewHeight)];
	
	[self setClipsToBounds:YES];
	

	[label setFrame:CGRectMake(GRSectionViewIndentationWidth, 0, contentView.frame.size.width - 2 * GRSectionViewIndentationWidth, contentViewHeight)];
	
	UIRectCorner rc = (mode == GRSectionModeHeader ? (UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerBottomRight));
	
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:rc cornerRadii:CGSizeMake(GRProfileTableCornerRadius, GRProfileTableCornerRadius)];

	roundingMask.frame = contentView.bounds;
	roundingMask.path = path.CGPath;
	contentView.layer.mask = roundingMask;
    NSLog(@"fds %f", contentView.frame.size.height);
}

@end
