//
//  GRCodeTableViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 12/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

#import "GRRepositoryCodeTableViewController.h"

#import "GRRepositoryNavigationController.h"

#import "GRCodeModel.h"

@implementation GRRepositoryCodeTableViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.model typeForIndexPath:indexPath] == GSRepositoryEntryTypeDirectory) {
        GSRepositoryEntry *entry                            = (GSRepositoryEntry *)[self.model modelObjectForIndexPath:indexPath];
        GSRepositoryTree *tree                              = [(GRCodeModel *)self.model tree];
        GRCodeModel *model                                  = [[GRCodeModel alloc] initWithTree:tree entry:entry];
        GRRepositoryCodeTableViewController *viewController = [[GRRepositoryCodeTableViewController alloc] initWithModel:model];
        
        [(GRRepositoryNavigationController *)self.navigationController pushViewController:viewController withComponent:entry.name animated:YES];
    }
}

@end
