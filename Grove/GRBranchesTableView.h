//
//  GRBranchesTableView.h
//  Grove
//
//  Created by Rocco Del Priore on 11/10/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRModelTableView.h"

@interface GRBranchesTableView : GRModelTableView

@property (nonatomic, readonly) UINavigationController *navigationController;

- (instancetype)initWithModel:(id<GRDataSource>)model
         navigationController:(UINavigationController *)navigationController;

@end
