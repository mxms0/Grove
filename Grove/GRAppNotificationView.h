//
//  GRAppNotificationView.h
//  Grove
//
//  Created by Max Shavrick on 11/7/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GRAppNotificationType) {
	GRAppNotificationTypeUnknown,
};

@interface GRAppNotificationView : UIView
- (instancetype)initWithHeadline:(NSString *)headline bodyText:(NSString *)body notificationType:(GRAppNotificationType)typ;
@end
