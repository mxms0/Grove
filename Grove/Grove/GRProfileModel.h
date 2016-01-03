//
//  GRProfileModel.h
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRViewModel.h"

@class GRApplicationUser, GSUser, GSRepository;
@interface GRProfileModel : GRViewModel
@property (nonatomic, strong, readonly) UIImage *profileImage;
- (instancetype)initWithUser:(GRApplicationUser *)user;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (CGFloat)cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (GRApplicationUser *)visibleUser;
- (CGFloat)heightForProfileHeader;
- (GSRepository *)repositoryForIndex:(NSUInteger)index;
@end
