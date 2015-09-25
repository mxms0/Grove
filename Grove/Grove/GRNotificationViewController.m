//
//  GRNotificationViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRNotificationViewController.h"
#import <GroveSupport/GroveSupport.h>
#import "GRSessionManager.h"

@implementation GRNotificationViewController

- (instancetype)init {
	if ((self = [super init])) {
		tableView = [[UITableView alloc] init];
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		
		GRApplicationUser *user = [[GRSessionManager sharedInstance] currentUser];

		__weak id weakSelf = self;
		[[GSGitHubEngine sharedInstance] notificationsForUser:user.user completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
			notifications = notifs;
			
			[weakSelf sortNewNotifications:notifs];
			
			[tableView reloadData];
			
		}];

    }
    return self;
}

- (void)sortNewNotifications:(NSArray *)newNotifs {
	NSMutableDictionary *repositories = [[NSMutableDictionary alloc] init];
	
	for (GSNotification *notification in newNotifs) {
		GSRepository *relevantRepository = [notification repository];
		
		NSMutableArray *associatedNotifications = repositories[[relevantRepository pathString]];
		
		if (associatedNotifications) {
			[associatedNotifications addObject:notification];
		}
		
		else {
			NSMutableArray *notificationBucket = [[NSMutableArray alloc] initWithObjects:notification, nil];
			repositories[[relevantRepository pathString]] = notificationBucket;
		}
	}
	
	NSLog(@"fds %@", repositories);

}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:tableView];
	[tableView setFrame:self.view.bounds];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [notifications count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"notifCell"];

	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notifCell"];
	}
	
	return cell;
}

@end
