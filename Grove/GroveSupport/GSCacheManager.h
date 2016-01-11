//
//  GSCacheManager.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSUser;
@interface GSCacheManager : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)findUserAvatarFromActor:(GSActor *__nonnull)user downloadIfNecessary:(BOOL)necessary completionHandler:(void (^__nonnull)(UIImage *__nullable image, NSError *__nullable error))handler;
- (void)findImageAssetWithURL:(NSURL *__nonnull)url loggedInUser:(GSUser *__nullable)user downloadIfNecessary:(BOOL)download completionHandler:(void (^__nonnull)(UIImage *__nullable image, NSError *__nullable error))handler;
@end
