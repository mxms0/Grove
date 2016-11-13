//
//  GRRepositoryCodeViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 11/12/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryCodeBranchesTableViewController.h"
#import "GRRepositoryNavigationController.h"

@implementation GRRepositoryCodeBranchesTableViewController

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
    self.title = @"Code";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.model respondsToSelector:@selector(titleForIndexPath:)]) {
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view.backgroundColor = GSRandomUIColor();
        
        [(GRRepositoryNavigationController *)self.navigationController pushViewController:viewController withComponent:[self.model titleForIndexPath:indexPath] animated:YES];
    }
}

@end
