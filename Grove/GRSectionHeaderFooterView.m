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
	
	CGFloat yDelta = 0.0;
	CGFloat ratio = 0.8;
	
	if (mode == GRSectionModeHeader) {
		yDelta = self.frame.size.height * (1.0 - ratio);
	}
	
	[contentView setFrame:CGRectMake(GRProfileTableHorizontalPadding, yDelta, self.frame.size.width - 2 * GRProfileTableHorizontalPadding, self.frame.size.height)];
	
	[self setClipsToBounds:YES];
	

	[label setFrame:CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height * ratio)];
	
	UIRectCorner rc = (mode == GRSectionModeHeader ? (UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerBottomRight));
	
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:rc cornerRadii:CGSizeMake(GRProfileTableCornerRadius, GRProfileTableCornerRadius)];

	roundingMask.frame = contentView.bounds;
	roundingMask.path = path.CGPath;
	contentView.layer.mask = roundingMask;
}

@end
