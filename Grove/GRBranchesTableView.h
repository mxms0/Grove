//
//  GRBranchesTableView.h
//  Grove
//
//  Created by Rocco Del Priore on 11/10/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRModelTableView.h"
#import "GRRepositoryViewSelector.h"

@interface GRBranchesTableView : GRModelTableView

@property (nonatomic) id<GRRepositoryViewSelectorDelegate> delegate;

@end
