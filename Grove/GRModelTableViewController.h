//
//  GRModelTableViewController.h
//  Grove
//
//  Created by Rocco Del Priore on 11/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDataSource.h"

@interface GRModelTableViewController : UITableViewController <GRDataSourceDelegate>
- (instancetype)initWithModel:(id<GRDataSource>)model;
@end
