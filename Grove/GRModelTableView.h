//
//  GRModelTableView.h
//  Grove
//
//  Created by Rocco Del Priore on 11/10/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRModelTableView : UIView <GRDataSourceDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) id<GRDataSource> model;

- (instancetype)initWithModel:(id<GRDataSource> )model;

@end
