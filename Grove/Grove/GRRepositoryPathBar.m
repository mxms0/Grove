//
//  GRRepositoryPathBar.m
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryPathBar.h"

@implementation GRRepositoryPathBar {
	UILabel *pathLabel;
	NSMutableArray *pathComponents;
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
	[self addSubview:pathLabel];
}

- (void)pushPath:(NSString *)path {
	[pathComponents addObject:path];
}

- (void)setRoot:(NSString *)root {
	_root = root;
	pathComponents = @[root].mutableCopy;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	const CGFloat pathLabelPadding = 5.0f;
	[pathLabel setFrame:CGRectMake(pathLabelPadding, 0, self.frame.size.width - 2*pathLabelPadding, self.frame.size.height)];
}

@end
