//
//  GRAppNotificationManager.h
//  Grove
//
//  Created by Max Shavrick on 11/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRAppNotificationManager : NSObject
+ (instancetype)sharedInstance;
- (void)postNotificationFromError:(NSError *)error;
@end
