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
#import "GRNotificationHeaderTableViewCell.h"

@implementation GRNotificationViewController

- (instancetype)init {
	if ((self = [super init])) {
		tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
		[tableView setDelegate:self];
		[tableView setDataSource:self];
		[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		
		GRApplicationUser *user = [[GRSessionManager sharedInstance] currentUser];

		__weak id weakSelf = self;
		__weak UITableView *weakTableView = tableView;
		[[GSGitHubEngine sharedInstance] notificationsForUser:user.user completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
			
			[weakSelf sortNewNotifications:notifs];
			
			[weakTableView reloadData];
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
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[tableView setBackgroundColor:[UIColor clearColor]];
	
	[self.view addSubview:tableView];
	[tableView setFrame:self.view.bounds];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[notifications allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[notifications objectForKey:[notifications allKeys][section]] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *reuseIdentifier = @"notificationCell";
	static NSString *headerReuseIdentifier = @"notificationHeaderCell";
	
	NSString *activeIdentifier = reuseIdentifier;
	
	BOOL isHeaderCell = (indexPath.row == 0);
	
	if (isHeaderCell) {
		activeIdentifier = headerReuseIdentifier;
	}
	
	GRNotificationTableViewCell *cell = (GRNotificationTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:activeIdentifier];

	if (!cell) {
		Class cellClass = [GRNotificationTableViewCell class];
		
		if (isHeaderCell) {
			cellClass = [GRNotificationHeaderTableViewCell class];
		}
		cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activeIdentifier];
	}
	
	if (isHeaderCell) {
		cell.textLabel.text = [[notifications allKeys] objectAtIndex:indexPath.section];
	}
	else {
		GSNotification *notification = [[notifications objectForKey:[[notifications allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row - 1];
		cell.textLabel.text = [notification title];
	}
	
	[cell setNeedsLayout];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GRNotificationTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	GRNotificationTableViewCellPosition position = GRNotificationTableViewCellMiddle;
	
	if (indexPath.row == 0) {
		position |= GRNotificationTableViewCellTop;
	}
	
	if (indexPath.row == [[notifications objectForKey:[notifications allKeys][indexPath.section]] count]) {
		position |= GRNotificationTableViewCellBottom;
	}
	
	[cell setPosition:position];
	
}

@end
