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

@end

@class GSRepository;
@interface GRRepositoryFileBrowserModel : NSObject
@property (nonatomic, weak, nullable) id <GRRepositoryFileBrowserModelDelegate> delegate;
- (instancetype)initWithRepository:(GSRepository *)repo;
- (void)update;
@end

NS_ASSUME_NONNULL_END
