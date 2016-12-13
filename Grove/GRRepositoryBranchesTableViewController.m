//
//  GRBranchesTableViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 12/2/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryBranchesTableViewController.h"

#import "GRRepositoryNavigationController.h"
#import "GRRepositoryProjectViewController.h"
#import "GRBranchesModel.h"

@implementation GRRepositoryBranchesTableViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithModel:(id<GRDataSource>)model {
    self = [super initWithModel:model];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.title = @"Project";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *component                               = [self.model titleForIndexPath:indexPath];
    GSRepository *repository                          = [(GRBranchesModel *)self.model repository];
    GRRepositoryProjectViewController *viewController = [[GRRepositoryProjectViewController alloc] initWithRepository:repository];
    
    [(GRRepositoryNavigationController *)self.navigationController pushViewController:viewController withComponent:component animated:YES];
    
}

@end
