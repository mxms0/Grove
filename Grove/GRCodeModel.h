//
//  GRCodeModel.h
//  Grove
//
//  Created by Rocco Del Priore on 12/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSRepository, GSRepositoryTree, GSRepositoryEntry;
@interface GRCodeModel : NSObject <GRDataSource>
@property (nonatomic, readonly) GSRepository *repository;
@property (nonatomic, readonly) GSRepositoryTree *tree;
- (instancetype)initWithTree:(GSRepositoryTree *)tree entry:(GSRepositoryEntry *)entry;
- (instancetype)initWithRepository:(GSRepository *)repository;
- (void)reloadDataAtPath:(NSString *)path;
@end
