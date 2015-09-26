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
#import "GRNotificationTableViewCell.h"

@implementation GRNotificationViewController

- (instancetype)init {
	if ((self = [super init])) {
		tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		[tableView setSeparatorInset:UIEdgeInsetsMake(0, 20.0f, 0, 20.0f)];
		
		GRApplicationUser *user = [[GRSessionManager sharedInstance] currentUser];

		__weak id weakSelf = self;
		[[GSGitHubEngine sharedInstance] notificationsForUser:user.user completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
			
			[weakSelf sortNewNotifications:notifs];
			
			[tableView reloadData];
		}];
		
    }
    return self;
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
	
	NSLog(@"fds %@", repositoryNotificationMap);

}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.view addSubview:tableView];
	[tableView setFrame:self.view.bounds];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[notifications allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[notifications objectForKey:[notifications allKeys][section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GRNotificationTableViewCell *cell = (GRNotificationTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:@"notifCell"];

	if (!cell) {
		cell = [[GRNotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notifCell"];
	}
	
	[cell setNeedsLayout];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GRNotificationTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	GRNotificationTableViewCellPosition position = GRNotificationTableViewCellMiddle;
	NSLog(@"hi");
	
	if (indexPath.row == 0) {
		position |= GRNotificationTableViewCellTop;
	}
	
	if (indexPath.row + 1 == [[notifications objectForKey:[notifications allKeys][indexPath.section]] count]) {
		position |= GRNotificationTableViewCellBottom;
	}
	
	[cell setPosition:position];
	
}

@end
