//
//  GRProfileModel.h
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRViewModel.h"

@class GRApplicationUser, GSUser;
@interface GRProfileModel : GRViewModel
- (instancetype)initWithUser:(GSUser *)user;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (CGFloat)cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (GSUser *)activeUser;
- (CGFloat)heightForProfileHeader;
@end
