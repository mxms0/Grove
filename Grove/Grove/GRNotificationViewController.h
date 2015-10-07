//
//  GRNotificationViewController.h
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"
#import "GRSyntaxHighlightedTextView.h"

@interface GRNotificationViewController : GRViewController <UITableViewDataSource, UITableViewDelegate> {
	UITableView *tableView;
	NSDictionary *notifications;
}

@end
