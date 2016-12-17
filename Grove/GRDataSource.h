//
//  GRDataSource.h
//  Grove
//
//  Created by Max Shavrick on 11/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#ifndef GRDataSource_h
#define GRDataSource_h

@protocol GRDataSourceDelegate <NSObject>
- (void)reloadData;
@end

@protocol GRDataSource <NSObject>
@property (nonatomic) id<GRDataSourceDelegate> delegate;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@optional
- (NSString *)titleForSectionHeader:(NSInteger)section;
- (NSString *)titleForSectionFooter:(NSInteger)section;
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)descriptionForIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)imageForIndexPath:(NSIndexPath *)indexPath;
- (NSObject *)modelObjectForIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)typeForIndexPath:(NSIndexPath *)type;

@end


#endif /* GRDataSource_h */
