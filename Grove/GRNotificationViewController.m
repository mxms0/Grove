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
#import "GRSmallCapsLabel.h"
#import "GRNotificationHeaderTableViewCell.h"
#import "GRNotificationTitleView.h"
#import "GRNotificationModel.h"

@implementation GRNotificationViewController {
	GRNotificationModel *model;
	NSDictionary *notifications;
}

#pragma mark - Initializers

- (instancetype)initWithStyle:(UITableViewStyle)style {
	if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
		
		self.tabBarItem = [[UITabBarItem alloc] initWithTitle:GRLocalizedString(@"Notifications", nil, nil) image:[UIImage imageNamed:@"tb@2x"] tag:0];
		
		GRApplicationUser *user = [[GRSessionManager sharedInstance] currentUser];
		
		[[GSGitHubEngine sharedInstance] notificationsForUser:user.user completionHandler:^(NSArray *__nullable notifs, NSError *__nullable error) {
			if (error) GSAssert();
            
            [self sortNewNotifications:notifs];
            
            dispatch_async(dispatch_get_main_queue(), ^	{
                //TODO: dont forget to weakref
                [self.tableView reloadData];
            });
		}];
	}
	return self;
}

- (instancetype)init {
	if ((self = [super init])) {
        GRNotificationTitleView *headerView = [[GRNotificationTitleView alloc] init];
        [headerView setFrame:CGRectWithContentSize(headerView.intrinsicContentSize)];
        [self.tableView setTableHeaderView:headerView];
    }
    return self;
}

#pragma mark - Helpers

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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[notifications allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[notifications objectForKey:[notifications allKeys][section]] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier       = @"notificationCell";
    static NSString *headerReuseIdentifier = @"notificationHeaderCell";
    NSString *activeIdentifier             = reuseIdentifier;
    BOOL isHeaderCell                      = (indexPath.row == 0);
    Class cellClass                        = [GRNotificationTableViewCell class];
    
	if (isHeaderCell) {
        activeIdentifier = headerReuseIdentifier;
        cellClass        = [GRNotificationHeaderTableViewCell class];
	}
	
	GRNotificationTableViewCell *cell = (GRNotificationTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:activeIdentifier];
	if (!cell) cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activeIdentifier];
	
	if (isHeaderCell) {
		[cell setText:[[notifications allKeys] objectAtIndex:indexPath.section]];
	}
	else {
        GSNotification *notification = [[notifications objectForKey:[[notifications allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row - 1];
        cell.textLabel.text          = [notification title];
	}
	[cell setNeedsLayout];
	
	return cell;
}

#pragma mark - GRTableViewController

- (BOOL)isDismissable {
	return NO;
}

@end
