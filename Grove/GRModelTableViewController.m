//
//  GRModelTableViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 11/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRModelTableViewController.h"

static NSString *_Nonnull cellIdentifier = @"identifier";

@implementation GRModelTableViewController {
    id <GRDataSource> model;
}

- (instancetype)initWithModel:(id<GRDataSource>)localModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        model = localModel;
        
        model.delegate = self;
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return self;
}

#pragma mark - GRDataSourceDelegate

- (void)reloadData {
    
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [model numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [model numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([model respondsToSelector:@selector(titleForIndexPath:)]) {
        cell.textLabel.text = [model titleForIndexPath:indexPath];
    }
    if ([model respondsToSelector:@selector(descriptionForIndexPath:)]) {
        cell.detailTextLabel.text = [model descriptionForIndexPath:indexPath];
    }
    if ([model respondsToSelector:@selector(imageForIndexPath:)]) {
        if ([model imageForIndexPath:indexPath]) {
            cell.imageView.image = [model imageForIndexPath:indexPath];
        }
    }
    
    return cell;
}

@end
