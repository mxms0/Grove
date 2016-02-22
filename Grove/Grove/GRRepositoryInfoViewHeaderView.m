//
//  GRRepositoryInfoViewHeaderView.m
//  Grove
//
//  Created by Max Shavrick on 2/5/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryInfoViewHeaderView.h"
#import "GRSmallCapsLabel.h"

@implementation GRRepositoryInfoViewHeaderView {
	GRSmallCapsLabel *headerLabel;
}

- (instancetype)init {
	if ((self = [super init])) {
		headerLabel = [[GRSmallCapsLabel alloc] init];
		
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
