//
//  GRBranchesTableView.m
//  Grove
//
//  Created by Rocco Del Priore on 11/10/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRBranchesTableView.h"
#import "GRRepositoryCommitsView.h"

@implementation GRBranchesTableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GRRepositoryCommitsView *view = [[GRRepositoryCommitsView alloc] init];
    [self.delegate pushView:view];
}

@end
