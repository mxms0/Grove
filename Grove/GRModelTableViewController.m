//
//  GRModelTableViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 11/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRModelTableViewController.h"

static NSString *_Nonnull cellIdentifier = @"identifier";

@interface GRModelTableViewController ()
@property (nonatomic) id<GRDataSource> model;
@end

@implementation GRModelTableViewController

- (instancetype)initWithModel:(id<GRDataSource>)localModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.model = localModel;
        
        self.model.delegate = self;
        
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
    return [self.model numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([self.model respondsToSelector:@selector(titleForIndexPath:)]) {
        cell.textLabel.text = [self.model titleForIndexPath:indexPath];
    }
    if ([self.model respondsToSelector:@selector(descriptionForIndexPath:)]) {
        cell.detailTextLabel.text = [self.model descriptionForIndexPath:indexPath];
    }
    if ([self.model respondsToSelector:@selector(imageForIndexPath:)]) {
        if ([self.model imageForIndexPath:indexPath]) {
            cell.imageView.image = [self.model imageForIndexPath:indexPath];
        }
    }
    
    return cell;
}

@end
