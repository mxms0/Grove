//
//  GSGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSUser, GSEvent, GSRepository;

@interface GSGitHubEngine : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)authenticateUserWithUsername:(NSString *__nonnull)username password:(NSString *__nonnull)password completionHandler:(void (^ __nullable)(GSUser *__nullable user, NSError *__nullable error))handler;
- (void)eventsForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable events, NSError *__nullable error))handler;
- (void)userForUsername:(NSString *__nonnull)username completionHandler:(void (^__nonnull)(GSUser *__nullable user, NSError *__nullable error))handler;

// Repositories
- (void)repositoriesForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)repositoriesForUsername:(NSString *__nonnull)username completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)collaboratorsForRepository:(GSRepository *__nonnull)repo completionHandler:(void (^__nonnull)(NSArray *__nullable collabs, NSError *__nullable error))error;
- (void)collaboratorsForRepositoryName:(NSString *__nonnull)repoName owner:(NSString *__nonnull)owner completionHandler:(void (^__nonnull)(NSArray *__nullable collabs, NSError *__nullable error))error;

- (void)starRepository:(GSRepository *__nonnull)repo forUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSError *__nullable error))handler;
- (void)unstarRepository:(GSRepository *__nonnull)repo forUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSError *__nullable error))handler;
- (void)repositoriesStarredByUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler;
@end
