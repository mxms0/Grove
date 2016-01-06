//
//  GRRepositoryFileBrowserView.h
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRRepositoryFileBrowserModel.h"

NS_ASSUME_NONNULL_BEGIN

@class GSRepository;
@interface GRRepositoryFileBrowserView : UIView <GRRepositoryFileBrowserModelDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, nullable, setter=setRepository:) GSRepository *repository;
- (instancetype)initWithRepository:(GSRepository *)repo;
@end

NS_ASSUME_NONNULL_END