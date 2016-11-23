//
//  GRNotificationModel.h
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRViewModel.h"

@class GSNotification;
@interface GRNotificationModel : GRViewModel
- (CGFloat)heightForSectionHeader:(NSInteger)section;
- (CGFloat)heightForSectionFooter:(NSInteger)section;
- (GSNotification *)notificationAtIndexPath:(NSIndexPath *)path;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)path;
@end
