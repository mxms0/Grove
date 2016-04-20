//
//  GRTableViewController.h
//  Grove
//
//  Created by Max Shavrick on 1/15/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRDrawerMenuItem;
@protocol GRDrawerMenuViewDataSource <NSObject>
@required
- (NSArray<GRDrawerMenuItem *> *)drawerMenuItems;
@end

@interface GRTableViewController : UITableViewController <GRDrawerMenuViewDataSource>

@end
