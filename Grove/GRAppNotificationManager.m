//
//  GRAppNotificationManager.m
//  Grove
//
//  Created by Max Shavrick on 11/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRAppNotificationManager.h"
#import "GRAppNotificationView.h"

#define GRAppNotificationDuration 2.0f

@implementation GRAppNotificationManager {
	NSMutableArray<NSError *> *notifications;
	NSTimer *notificationTimer;
	GRAppNotificationView *notificationView;
}

+ (instancetype)sharedInstance {
	static dispatch_once_t token;
	static id instance = nil;
	
	dispatch_once(&token, ^ {
		instance = [[GRAppNotificationManager alloc] init];
	});
	
	return instance;
}

- (instancetype)init {
	if ((self = [super init])) {
		notifications = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)_notificationTimerFired:(NSTimer *)timer {
	@synchronized (notifications) {
		if ([notifications count] > 0) {
			NSError *error = [notifications lastObject];
			[notifications removeLastObject];
			[self _presentNotificationNowWithError:error];
		}
		else {
			[notificationTimer invalidate];
			notificationTimer = nil;
			
			[self _dismissNotificationView];
		}
	}
}

- (void)_dismissNotificationView {
	[UIView animateWithDuration:.8 animations:^{
		[notificationView setFrame:CGRectMake(0, -notificationView.frame.size.height, notificationView.frame.size.width, notificationView.frame.size.height)];
	}];
}

- (void)_presentNotificationNowWithError:(NSError *)error {
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	
	if (!notificationView) {
		notificationView = [[GRAppNotificationView alloc] initWithHeadline:@"Error" bodyText:error.userInfo[NSLocalizedDescriptionKey] notificationType:0];
		[notificationView setBackgroundColor:[UIColor redColor]];
	}
	
	[notificationView setFrame:CGRectMake(0, 0, window.frame.size.width, 84)];
	
	[window addSubview:notificationView];
	[window bringSubviewToFront:notificationView];
}

- (void)postNotificationFromError:(NSError *)error {
	@synchronized(notifications) {
		if (!notificationTimer && [notifications count] == 0) {
			
			// i dont exactly like this, but its not awful.
			dispatch_async(dispatch_get_main_queue(), ^ {
				
				notificationTimer = [NSTimer scheduledTimerWithTimeInterval:GRAppNotificationDuration target:self selector:@selector(_notificationTimerFired:) userInfo:nil repeats:YES];
				[[NSRunLoop currentRunLoop] addTimer:notificationTimer forMode:NSRunLoopCommonModes];
				
				[self _presentNotificationNowWithError:error];
			});
		}
		else {
			[notifications addObject:error];
		}
	}
	
	NSLog(@"%@:%@", error, notifications);
}

@end
