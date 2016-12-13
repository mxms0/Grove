//
//  GRCodeModel.m
//  Grove
//
//  Created by Rocco Del Priore on 12/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>
#import "GRSessionManager.h"

#import "GRCodeModel.h"

@interface GRCodeModel ()
@property (nonatomic) GSRepository *repository;
@property (nonatomic) GSRepositoryTree *tree;
@end

@implementation GRCodeModel {
    NSArray *entries;
}
@synthesize delegate;

- (instancetype)initWithTree:(GSRepositoryTree *)tree entry:(GSRepositoryEntry *)entry {
    self = [super init];
    if (self) {
        self.tree = tree;
        entries   = [self.tree entriesForPath:entry.path];
    }
    return self;
}

- (instancetype)initWithRepository:(GSRepository *)localRepository {
    self = [super init];
    if (self) {
        self.repository = localRepository;
        entries         = [NSArray array];
    }
    return self;
}

- (void)reloadDataAtPath:(NSString *)path {
    [[GSGitHubEngine sharedInstance] repositoryContentsForRepository:self.repository atPath:path recurse:YES completionHandler:^(GSRepositoryTree* _Nullable tree, NSError * _Nullable error) {
        self.tree = tree;
        entries   = [self.tree rootEntries];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate reloadData];
        });
    }];
}

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return entries.count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    GSRepositoryEntry *entry = entries[indexPath.row];
    return entry.name;
}

- (NSObject *)modelObjectForIndexPath:(NSIndexPath *)indexPath {
    return entries[indexPath.row];
}

- (NSInteger)typeForIndexPath:(NSIndexPath *)indexPath {
    GSRepositoryEntry *entry = entries[indexPath.row];
    return entry.type;
}

@end
