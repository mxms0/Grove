//
//  GRRepositoryFileBrowserModel.h
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GRRepositoryFileBrowserModelDelegate <NSObject>
// this is muy importante
- (void)prepareForLayout;
- (void)reloadData;
@end

@class GSRepository, GSRepositoryEntry;
@interface GRRepositoryFileBrowserModel : NSObject
@property (nonatomic, weak, nullable) id <GRRepositoryFileBrowserModelDelegate> delegate;
- (instancetype)initWithRepository:(GSRepository *)repo;
- (void)update;
- (NSUInteger)numberOfItemsInCurrentDirectory;
- (GSRepositoryEntry *)repositoryEntryForIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
