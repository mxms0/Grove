//
//  GRNotificationHeaderLabel.m
//  Grove
//
//  Created by Max Shavrick on 2/22/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRNotificationHeaderLabel.h"
#import <CoreText/CoreText.h>

@implementation GRNotificationHeaderLabel

- (void)setText:(NSString *)text {
	[self setAttributedText:[self attributedStringWithText:text]];
}

- (NSAttributedString *)attributedStringWithText:(NSString *)txt {
	static UIFont *fontCache = nil;
	static dispatch_once_t onceToken;
	// probably isn't necessary anymore.
	dispatch_once(&onceToken, ^{
		NSArray *fontFeatureSettings = @[@{UIFontFeatureTypeIdentifierKey:@(kSmallCapsSelector), UIFontFeatureSelectorIdentifierKey:@(kSmallCapsSelector)}];
		
		NSDictionary *fontAttributes = @{UIFontDescriptorFeatureSettingsAttribute:fontFeatureSettings, UIFontDescriptorNameAttribute:@"Avenir-Heavy"};
		// DO NOT NAME FORGET THE '-'
		// Causes considerable lag when looking up fonts.
		// between GillSans and AvenirNext-Medium
		
		UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:fontAttributes];
		
		fontCache = [UIFont fontWithDescriptor:fontDescriptor size:[self font].pointSize];
	});
	
	NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[txt uppercaseString]];
	
	NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
	style.alignment = NSTextAlignmentCenter;
	
	[str addAttribute:NSFontAttributeName value:fontCache range:NSMakeRange(0, txt.length)];
	[str addAttribute:NSKernAttributeName value:@(1.5) range:NSMakeRange(0, txt.length)];
	
	return str;
}

@end
