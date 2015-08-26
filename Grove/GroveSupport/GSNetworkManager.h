//
//  GSNetworkManager.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSNetworkManagerHelpers.h"

@interface GSNetworkManager : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)requestOAuth2TokenWithUsername:(NSString *__nonnull)username password:(NSString *__nonnull)password handler:(void (^ __nullable)(NSString *__nullable token, NSError *__nullable error))handler;
- (void)requestEventsForUser:(NSString *__nonnull)user token:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(id __nullable events, NSError *__nullable error))handler;
- (void)requestUserInformationForToken:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(NSDictionary *__nullable response, NSError *__nullable error))handler;
- (void)requestUserInformationForUsername:(NSString *__nonnull)username token:(NSString *__nullable)token completionHandler:(void (^__nonnull)(NSDictionary *__nullable response, NSError *__nullable error))handler;
- (void)downloadResourceFromURL:(NSURL *__nonnull)url token:(NSString *__nullable)token completionHandler:(void (^__nonnull)(NSURL *__nullable filePath, NSError *__nullable error))handler;
@end
