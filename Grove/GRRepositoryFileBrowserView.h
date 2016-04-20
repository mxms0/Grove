//
//  GRRepositoryFileBrowserView.h
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRRepositoryFileBrowserModel.h"
#import "GRRepositoryGenericSectionView.h"

NS_ASSUME_NONNULL_BEGIN

@class GSRepository;
@interface GRRepositoryFileBrowserView : GRRepositoryGenericSectionView <GRRepositoryFileBrowserModelDelegate, UITableViewDataSource, UITableViewDelegate>
@end

NS_ASSUME_NONNULL_END