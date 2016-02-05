//
//  GRRepositoryInfoViewHeaderView.m
//  Grove
//
//  Created by Max Shavrick on 2/5/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryInfoViewHeaderView.h"

@implementation GRRepositoryInfoViewHeaderView {
	UILabel *headerLabel;
}

- (instancetype)init {
	if ((self = [super init])) {
		headerLabel = [[UILabel alloc] init];
		
		NSArray *features = @[@{UIFontFeatureTypeIdentifierKey:@(3), UIFontFeatureSelectorIdentifierKey:@(3)}];
		NSDictionary *fontAttributes = @{UIFontDescriptorFeatureSettingsAttribute:features, UIFontDescriptorNameAttribute:@"Helvetica"};
		UIFontDescriptor *fontDescriptor = [[UIFontDescriptor alloc] initWithFontAttributes:fontAttributes];
		[headerLabel setFont:[UIFont fontWithDescriptor:fontDescriptor size:12]];
		
		[self addSubview:headerLabel];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	[headerLabel setFrame:self.bounds];
}

- (void)setText:(NSString *)text {
	_text = text;
	[headerLabel setText:text];
}

@end
