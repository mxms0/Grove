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

NS_ASSUME_NONNULL_BEGIN

@class GSURLRequest;
@interface GSNetworkManager : NSObject
+ (instancetype)sharedInstance;
- (void)requestOAuth2TokenWithUsername:(NSString *)username password:(NSString *)password twoFactorToken:(NSString *__nullable)twoFa handler:(void (^)(NSString *token, NSError *error))handler;
- (void)requestEventsForUser:(NSString *)user token:(NSString *)token completionHandler:(void (^)(NSArray *__nullable events, NSError *__nullable error))handler;
- (void)requestUserInformationForToken:(NSString *)token completionHandler:(void (^)(NSDictionary *__nullable response, NSError *__nullable error))handler;
- (void)requestUserInformationForUsername:(NSString *)username token:(NSString *__nullable)token completionHandler:(void (^)(NSDictionary *__nullable response, NSError *__nullable error))handler;
- (void)downloadResourceFromURL:(NSURL *)url token:(NSString *__nullable)token completionHandler:(void (^)(NSURL *__nullable filePath, NSError *__nullable error))handler;

- (void)requestUserNotificationsWithToken:(NSString *)token completionHandler:(void (^)(NSArray *__nullable notifications, NSError *__nullable error))handler;
- (void)requestRepositoriesForUsername:(NSString *)username completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)requestRepositoriesForCurrentUserWithToken:(NSString *)token completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)sendRequest:(GSURLRequest *)request completionHandler:(void (^)(GSSerializable *__nullable serializeable, NSError *__nullable error))handler;
- (void)requestRepositoryContentsForRepositoryNamed:(NSString *)repoName repositoryOwner:(NSString *)username token:(NSString *)token path:(NSString *__nullable)path completionHandler:(void (^)(NSArray *__nullable items, NSError *__nullable error))handler;
- (void)recursivelyRequestRepositoryTreeForRepositoryNamed:(NSString *)repoName repositoryOwner:(NSString *)owner treeOrBranch:(NSString *)treeOrBranch token:(NSString *)token completionHandler:(void (^)(NSDictionary *__nullable result, NSError *__nullable serror))handler;
// not sure if i like exposing endpoints outside of the network manager. this is an idea for now.
- (void)requestAPIEndpoint:(NSString *)endp token:(NSString *__nullable)token completionHandler:(void (^)(GSSerializable *__nullable s, NSError *__nullable error))handler;
@end

NS_ASSUME_NONNULL_END
