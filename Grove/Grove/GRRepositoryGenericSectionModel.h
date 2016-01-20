//
//  GRRepositoryGenericSectionModel.h
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRRepositoryGenericSectionModelDelegate <NSObject>


@end

@class GSRepository;
@interface GRRepositoryGenericSectionModel : NSObject
@property (nonatomic, weak) id <GRRepositoryGenericSectionModelDelegate> delegate;
- (instancetype)initWithRepository:(GSRepository *)repo;
- (void)update;
@end
