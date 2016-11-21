//
//  GRNotificationModel.m
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationModel.h"
#import "GRSessionManager.h"
#import <GroveSupport/GSGitHubEngine.h>
#import <GroveSupport/GSNotification.h>
#import <GroveSupport/GSRepository.h>

@implementation GRNotificationModel {
	NSDictionary *notifications;
}

- (void)requestNewData {
	GRApplicationUser *user = [[GRSessionManager sharedInstance] currentUser];
	
	[[GSGitHubEngine sharedInstance] notificationsForUser:user.user completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
		if (error) GSAssert();
		
		[self sortNewNotifications:notifs];
		
		dispatch_async(dispatch_get_main_queue(), ^	{
			//TODO: dont forget to weakref
			[self.delegate reloadData];
		});
	}];
}

- (void)sortNewNotifications:(NSArray *)newNotifs {
	NSMutableDictionary *repositoryNotificationMap = [[NSMutableDictionary alloc] init];
	
	for (GSNotification *notification in newNotifs) {
		GSRepository *relevantRepository = [notification repository];
		NSMutableArray *associatedNotifications = repositoryNotificationMap[[relevantRepository pathString]];
		
		if (associatedNotifications) {
			[associatedNotifications addObject:notification];
		}
		else {
			NSMutableArray *notificationBucket = [[NSMutableArray alloc] initWithObjects:notification, nil];
			repositoryNotificationMap[[relevantRepository pathString]] = notificationBucket;
		}
	}
	
	notifications = repositoryNotificationMap;
}

- (void)prepareForTeardown {
	[super prepareForTeardown];
}

- (NSInteger)numberOfSections {
	return [[notifications allKeys] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
	NSString *key = [[notifications allKeys] objectAtIndex:section];
	
	return [[notifications objectForKey:key] count];
}

- (GSNotification *)notificationAtIndexPath:(NSIndexPath *)path {
	NSString *key = [[notifications allKeys] objectAtIndex:path.section];
	
	GSNotification *notification = [[notifications objectForKey:key] objectAtIndex:path.row];
	
	return notification;
}

- (CGFloat)heightForSectionHeader:(NSInteger)section {
	return 50.0f;
}

- (CGFloat)heightForSectionFooter:(NSInteger)section {
	if ([self numberOfRowsInSection:section] == 0) {
		return 0.0;
	}
	return 15;
}

- (NSString *)titleForSection:(NSInteger)section {
	return [[notifications allKeys] objectAtIndex:section];
}

@end
