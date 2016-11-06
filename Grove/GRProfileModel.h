//
//  GRProfileModel.h
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRViewModel.h"

//#define GRProfileModelSectionIndexHeader 0 // this is unused. Header is not a cell atm.
#define GRProfileModelSectionIndexRepositories 0
#define GRProfileModelSectionIndexOrganizations 1
#define GRProfileModelSectionIndexContributions 2

@class GRApplicationUser, GSUser, GSRepository, GSOrganization;
@interface GRProfileModel : GRViewModel
@property (nonatomic, strong, readonly) UIImage *profileImage;
- (instancetype)initWithUser:(GRApplicationUser *)user;
- (UIImage *)avatarForOrganization:(GSOrganization *)organization;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (CGFloat)cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (GRApplicationUser *)visibleUser;
- (CGFloat)heightForProfileHeader;
- (CGFloat)heightForSectionHeader:(NSInteger)section;
- (CGFloat)heightForSectionFooter:(NSInteger)section;;
- (GSRepository *)repositoryForIndexPath:(NSIndexPath *)indexPath;
- (GSOrganization *)organizationForIndexPath:(NSIndexPath *)indexPath;
@end
