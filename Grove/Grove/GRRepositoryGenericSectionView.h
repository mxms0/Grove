//
//  GRRepositoryGenericSectionView.h
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GRRepositoryGenericSectionModel.h"

@class GSRepository;
@interface GRRepositoryGenericSectionView : UIView <GRRepositoryGenericSectionModelDelegate> {
@protected
	GRRepositoryGenericSectionModel *model;
}
@property (nonatomic, strong, nullable, setter=setRepository:) GSRepository *repository;
- (nonnull Class)designatedModelClass;
- (void)commonInit;
@end
