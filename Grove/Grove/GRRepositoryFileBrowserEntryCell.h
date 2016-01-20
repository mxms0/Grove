//
//  GRRepositoryFileBrowserEntryCell.h
//  Grove
//
//  Created by Max Shavrick on 1/7/16.
//  Copyright (c) 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSRepositoryEntry;
@interface GRRepositoryFileBrowserEntryCell : UITableViewCell
- (void)configureWithEntry:(GSRepositoryEntry *)entry;
@end
