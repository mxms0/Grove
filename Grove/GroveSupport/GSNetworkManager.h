//
//  GSNetworkManager.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//	Checking data-types should /really/ be managed by the GSGitHubEngine
//	However, I didn't want to bloat it. So I distributed the tasks.
//

#import <Foundation/Foundation.h>
#import "GSNetworkManagerHelpers.h"

@class GSURLRequest;
@interface GSNetworkManager : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)requestOAuth2TokenWithUsername:(NSString *__nonnull)username password:(NSString *__nonnull)password handler:(void (^ __nullable)(NSString *__nullable token, NSError *__nullable error))handler;
- (void)requestEventsForUser:(NSString *__nonnull)user token:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(NSArray *__nullable events, NSError *__nullable error))handler;
- (void)requestUserInformationForToken:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(NSDictionary *__nullable response, NSError *__nullable error))handler;
- (void)requestUserInformationForUsername:(NSString *__nonnull)username token:(NSString *__nullable)token completionHandler:(void (^__nonnull)(NSDictionary *__nullable response, NSError *__nullable error))handler;
- (void)downloadResourceFromURL:(NSURL *__nonnull)url token:(NSString *__nullable)token completionHandler:(void (^__nonnull)(NSURL *__nullable filePath, NSError *__nullable error))handler;

- (void)requestUserNotificationsWithToken:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(NSArray *__nullable notifications, NSError *__nullable error))handler;
- (void)requestStarredRepositoriesForUsername:(NSString *__nonnull)user token:(NSString *__nullable)token completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler;

- (void)sendRequest:(GSURLRequest *__nonnull)request completionHandler:(void (^__nonnull)(GSSerializable *__nullable serializeable, NSError *__nullable error))handler;

// not sure if i like exposing endpoints outside of the network manager. this is an idea for now.
- (void)requestAPIEndpoint:(NSString *__nonnull)endp token:(NSString *__nullable)token completionHandler:(void (^__nonnull)(GSSerializable *__nullable s, NSError *__nullable error))handler;
@end
