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

@protocol GRRepositoryInfoViewDelegate <GRRepositoryGenericSectionModelDelegate>
- (CGFloat)allottedWidthForReadMeLabel;
- (void)setReadmeCellHeight:(CGFloat)height;
@end

@class GSRepository;
@interface GRRepositoryInfoModel : GRRepositoryGenericSectionModel
@property (nonatomic, weak) id <GRRepositoryInfoViewDelegate> delegate;
@property (nonatomic, weak) GRRepositoryReadMeCell *readMeCell;
- (NSString *)repositoryDescription;
@end
