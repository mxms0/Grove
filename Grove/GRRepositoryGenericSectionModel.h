//
//  GRRepositoryGenericSectionModel.h
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRRepositoryGenericSectionModelDelegate <NSObject>
- (void)reloadView;
@end

@class GSRepository;
@interface GRRepositoryGenericSectionModel : NSObject
@property (nonatomic, weak) id <GRRepositoryGenericSectionModelDelegate> delegate;
@property (nonatomic, strong) GSRepository* repository;
- (instancetype)initWithRepository:(GSRepository *)repo;
- (NSString *)sectionLabelForSection:(NSUInteger)section;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
- (NSUInteger)numberOfSections;
- (void)update;
@end
