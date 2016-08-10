//
//  GRDrawerView.h
//  Grove
//
//  Created by Max Shavrick on 4/19/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRDrawerMenuItem;
@interface GRDrawerView : UITableView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray<GRDrawerMenuItem *> *menuItems;
@end
