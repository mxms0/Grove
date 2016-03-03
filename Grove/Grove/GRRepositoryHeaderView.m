//
//  GRRepositoryHeaderView.m
//  Grove
//
//  Created by Max Shavrick on 12/24/15.
//  Copyright © 2015 Milo. All rights reserved.
//

#import "GRRepositoryHeaderView.h"
#import "GRSelectableLabel.h"

/*
 [User] [/] [Repository Name...]
 [Branch v]
 */

static const CGFloat GRRepositoryHeaderViewStandardFontSize = 16.0f;

@implementation GRRepositoryHeaderView {
	NSString *combinedString;
	GRSelectableLabel *usernameLabel;
	GRSelectableLabel *slashCharacterLabel;
	GRSelectableLabel *repositoryNameLabel;
	
	CGFloat usernameWidth;
	CGFloat slashCharacterWidth;
	CGFloat repositoryNameWidth;
}

- (instancetype)init {
	if ((self = [super init])) {
		usernameLabel = [self _standardSelectableLabel];
		repositoryNameLabel = [self _standardSelectableLabel];
		slashCharacterLabel = [self _standardSelectableLabel];
		[slashCharacterLabel setText:@"/"];
		
		for (UIView *v in @[usernameLabel, repositoryNameLabel, slashCharacterLabel]) {
			[v setBackgroundColor:GSRandomUIColor()];
			[self addSubview:v];
		}
		
		slashCharacterWidth = 8.0f; // do actual calculation here with fonts and all
		
	}
	return self;
}

- (GRSelectableLabel *)_standardSelectableLabel {
	GRSelectableLabel *label = [[GRSelectableLabel alloc] init];
	[label setFont:[UIFont systemFontOfSize:GRRepositoryHeaderViewStandardFontSize]];
	return label;
}

- (void)setRepositoryOwner:(NSString *)owner {
	_repositoryOwner = owner;
	[usernameLabel setText:owner];
}

- (void)setRepositoryName:(NSString *)name {
	_repositoryName = name;
	[repositoryNameLabel setText:name];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat horizontalOffsetUsed = 0.0;
	CGFloat verticalOffsetUsed = floorf(GRGenericVerticalPadding/2);
	
	const CGFloat itemPadding = 3.0;
	
	const CGFloat labelHeight = 25.0;
	
	horizontalOffsetUsed += GRGenericHorizontalPadding;
	
	[usernameLabel setFrame:CGRectMake(horizontalOffsetUsed, verticalOffsetUsed, usernameLabel.frame.size.width, labelHeight)];
	[usernameLabel sizeToFit];
	
	horizontalOffsetUsed += usernameLabel.frame.size.width;
	horizontalOffsetUsed += itemPadding;
	
	[slashCharacterLabel setFrame:CGRectMake(horizontalOffsetUsed, verticalOffsetUsed, slashCharacterWidth, labelHeight)];
	[slashCharacterLabel sizeToFit];
	
	horizontalOffsetUsed += slashCharacterLabel.frame.size.width;
	horizontalOffsetUsed += itemPadding;
	
	[repositoryNameLabel setFrame:CGRectMake(horizontalOffsetUsed, verticalOffsetUsed, repositoryNameWidth, labelHeight)];
	[repositoryNameLabel sizeToFit];
	
	verticalOffsetUsed += repositoryNameLabel.frame.size.height + floorf(GRGenericVerticalPadding/2);
}

@end
