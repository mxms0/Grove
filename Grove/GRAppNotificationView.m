//
//  GRAppNotificationView.m
//  Grove
//
//  Created by Max Shavrick on 11/7/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRAppNotificationView.h"

@implementation GRAppNotificationView {
	UILabel *headerLabel;
	UILabel *bodyLabel;
	UIImageView *icon;
}

- (instancetype)initWithHeadline:(NSString *)headline bodyText:(NSString *)body notificationType:(GRAppNotificationType)typ {
	if ((self = [super init])) {
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setText:headline];
		[headerLabel setBackgroundColor:GSRandomUIColor()];
		
		bodyLabel = [[UILabel alloc] init];
		[bodyLabel setText:body];
		[bodyLabel setBackgroundColor:GSRandomUIColor()];
		
		icon = [[UIImageView alloc] init];
		[icon setBackgroundColor:GSRandomUIColor()];
		
		// switch (typ);
		
		[self addSubviews:@[headerLabel, bodyLabel, icon]];
		
	}
	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	// this will probably get moved to autolayout, cus Rocco.
	
	const CGFloat initialVerticalPadding = 20.0f; // status bar height
	
	const CGFloat usableHeight = self.frame.size.height - initialVerticalPadding;
	
	const CGFloat horizontalPadding = 10.0f;
	const CGFloat verticalPadding = 10.0f;
	
	CGFloat utilizedLeftSpace = 0.0f;
	CGFloat utilizedTopSpace = initialVerticalPadding;
	
	[icon setFrame:CGRectMake(horizontalPadding, verticalPadding / 2 + utilizedTopSpace, usableHeight - 1.5 * verticalPadding, usableHeight - 1.5 * verticalPadding)];
	
	utilizedLeftSpace = icon.frame.origin.x + icon.frame.size.width;
	
	[headerLabel setFrame:CGRectMake(utilizedLeftSpace + horizontalPadding, icon.frame.origin.y, self.frame.size.width - utilizedLeftSpace - 2 * horizontalPadding, 20)];
	
	utilizedTopSpace = headerLabel.frame.size.height + headerLabel.frame.origin.y;
	
	[bodyLabel setFrame:CGRectMake(headerLabel.frame.origin.x, utilizedTopSpace + verticalPadding, headerLabel.frame.size.width, self.frame.size.height - (utilizedTopSpace + 2 * verticalPadding))];
}

@end
