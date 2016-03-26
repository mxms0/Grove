//
//  GRRepositoryInfoModel.h
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRRepositoryGenericSectionModel.h"
#import "GRRepositoryReadMeCell.h"

@class GSRepository;
@interface GRRepositoryInfoModel : GRRepositoryGenericSectionModel
@property (nonatomic, weak) GRRepositoryReadMeCell *readMeCell;
@end
