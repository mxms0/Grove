//
//  GRRepositoryHeaderView.m
//  Grove
//
//  Created by Max Shavrick on 12/24/15.
//  Copyright © 2015 Milo. All rights reserved.
//

#import "GRRepositoryHeaderView.h"

static CGFloat GRRepositoryGenericPadding = 5.0f;

@implementation GRRepositoryHeaderView {
	BOOL usesOneLine;
	NSString *combinedString;
	UILabel *upperLabel;
	UILabel *lowerLabel;
}

- (instancetype)init {
	if ((self = [super init])) {
		upperLabel = [[UILabel alloc] init];
		lowerLabel = [[UILabel alloc] init];
		
		for (UIView *v in @[upperLabel, lowerLabel]) {
			[self addSubview:v];
		}
	}
	return self;
}

- (void)setRepositoryOwner:(NSString *)owner {
	_repositoryOwner = owner;
	[self recalculateViewProperties];
}

- (void)setRepositoryName:(NSString *)name {
	_repositoryName = name;
	[self recalculateViewProperties];
}

- (void)recalculateViewProperties {
	if (_repositoryOwner && _repositoryName) {
		combinedString = [NSString stringWithFormat:@"%@ / %@", _repositoryOwner, _repositoryName];
		CGSize screenSize = [[UIScreen mainScreen] bounds].size;
		
		CGRect boundingRect = [combinedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
		
		usesOneLine = (boundingRect.size.width < (screenSize.width - 2 * GRRepositoryGenericPadding));
		
				NSLog(@"fds %@:%d:%f", NSStringFromCGRect(boundingRect), usesOneLine, screenSize.width);
		
		if (usesOneLine) {
			[upperLabel setText:combinedString];
			[lowerLabel setHidden:YES];
		}
		
		else {
			[lowerLabel setHidden:NO];
			[upperLabel setText:_repositoryName];
			[lowerLabel setText:_repositoryOwner];
		}
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	if (usesOneLine) {
		[upperLabel setFrame:CGRectMake(GRRepositoryGenericPadding, 0, self.frame.size.width - 2 * GRRepositoryGenericPadding, self.frame.size.height)];
	}
	else {
		CGSize workingSize = self.bounds.size;
		CGFloat ratio = .65;
		CGFloat divideLine = ceilf(workingSize.height * ratio);
		
		[upperLabel setFrame:CGRectMake(GRRepositoryGenericPadding, 0, workingSize.width - 2 * GRRepositoryGenericPadding, divideLine)];
		[lowerLabel setFrame:CGRectMake(GRRepositoryGenericPadding, divideLine, workingSize.width - 2 * GRRepositoryGenericPadding, (workingSize.height - divideLine))];
	}
}

@end
