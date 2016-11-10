//
//  GRModelTableView.m
//  Grove
//
//  Created by Rocco Del Priore on 11/10/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRModelTableView.h"

static NSString *_Nonnull cellIdentifier = @"identifier";

@interface GRModelTableView () <GRDataSourceDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) id<GRDataSource> model;
@end

@implementation GRModelTableView

- (instancetype)initWithModel:(id<GRDataSource>)model {
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.model     = model;
        
        [self.model setDelegate:self];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
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
