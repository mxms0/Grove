//
//  GRRepositoryFileBrowserEntryCell.m
//  Grove
//
//  Created by Max Shavrick on 1/7/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryFileBrowserEntryCell.h"

#import <GroveSupport/GSRepositoryEntry.h>

@implementation GRRepositoryFileBrowserEntryCell

- (void)configureWithEntry:(GSRepositoryEntry *)entry {
	[self.textLabel setText:entry.name];
}

@end
