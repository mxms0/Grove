//
//  GRRepositoryFileBrowserModel.h
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GRRepositoryGenericSectionModel.h"
#import "GRRepositoryPathBar.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GRRepositoryFileBrowserModelDelegate <GRRepositoryGenericSectionModelDelegate>
// this is muy importante
- (void)prepareForLayout;
- (void)presentLoadingIndicator;
- (void)pushToPreviousDirectory;
- (void)pushToNewDirectory;
- (void)reloadData;
@end

@class GSRepository, GSRepositoryEntry;
@interface GRRepositoryFileBrowserModel : GRRepositoryGenericSectionModel <GRRepositoryPathBarDelegate>
@property (nonatomic, weak, nullable) id <GRRepositoryFileBrowserModelDelegate> delegate;
@property (nonatomic, weak) GRRepositoryPathBar *pathBar;
- (instancetype)initWithRepository:(GSRepository *)repo;
- (void)update;
- (NSUInteger)numberOfItemsInCurrentDirectory;
- (GSRepositoryEntry *)repositoryEntryForIndex:(NSUInteger)index;
- (void)pushItemFromIndexPath:(NSIndexPath *)path;
- (NSString *)currentDirectory;
- (BOOL)isAtRootDirectory;
@end

NS_ASSUME_NONNULL_END
