//
//  GRRepositoryGenericSectionView.h
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GRRepositoryGenericSectionModel.h"

@interface GRRepositoryGenericSectionView : UIView <GRRepositoryGenericSectionModelDelegate> {
@protected
    GRRepositoryGenericSectionModel *_model;
}
- (nonnull Class)designatedModelClass;
- (void)commonInit;
- (void)setRepository:(nullable GSRepository *)repo;
@end
