//
//  GRRepositoryPathBar.m
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright (c) 2016 Milo. All rights reserved.
//

#import "GRRepositoryPathBar.h"

@implementation GRRepositoryPathBar {
	UILabel *pathLabel;
	NSMutableArray *pathComponents;
	UIButton *backButton;
	BOOL isAtRoot;
}

- (instancetype)init {
	if ((self = [super init])) {
		[self commonInit];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	pathLabel = [[UILabel alloc] init];
	[pathLabel setTextAlignment:NSTextAlignmentCenter];
	
	backButton = [[UIButton alloc] init];
	[backButton setTitle:@"Back" forState:UIControlStateNormal];
	[backButton addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[backButton setHidden:YES];
	
	for (UIView *v in @[pathLabel, backButton]) {
		[self addSubview:v];
	}
}

- (void)backButtonPressed:(UIButton *)b {
	[self popLastPathItem];
}

- (void)popLastPathItem {
	[self.delegate popPathForPathBar:self];
	isAtRoot = [self.delegate isAtRootForPathBar:self];
	[backButton setHidden:isAtRoot];
	[pathLabel setText:[self.delegate currentDirectory]];
}

- (void)pushPath:(NSString *)path {
	isAtRoot = [self.delegate isAtRootForPathBar:self];
	[backButton setHidden:isAtRoot];
	[pathLabel setText:[self.delegate currentDirectory]];
}

- (void)setRoot:(NSString *)root {
	_root = root;
	pathComponents = @[root].mutableCopy;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat leftOffsetUsed = 0.0f;
	
	const CGFloat genericHorizontalPadding = 5.0f;
	const CGFloat genericVerticalPadding = 0.0f;
	
	if (!isAtRoot) {
		[backButton setFrame:CGRectMake(genericHorizontalPadding, genericVerticalPadding, 84.0f, self.frame.size.height - 2*genericVerticalPadding)];
		leftOffsetUsed += backButton.frame.size.width + backButton.frame.origin.x;
	}
	
	[pathLabel setFrame:CGRectMake(leftOffsetUsed + genericHorizontalPadding + genericHorizontalPadding, genericVerticalPadding, (self.frame.size.width - (leftOffsetUsed + genericHorizontalPadding + genericHorizontalPadding + genericHorizontalPadding)), self.frame.size.height - 2*genericVerticalPadding)];
}

@end
