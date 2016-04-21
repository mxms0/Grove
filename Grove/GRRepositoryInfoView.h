//
//  GRRepositoryInfoView.h
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRRepositoryGenericSectionView.h"
#import "GRRepositoryInfoModel.h"

@interface GRRepositoryInfoView : GRRepositoryGenericSectionView <GRRepositoryInfoViewDelegate, UITableViewDataSource, UITableViewDelegate>
@end
