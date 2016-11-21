//
//  GSGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSUser, GSEvent, GSRepository, GSGist, GSNotification, GSRepositoryEntry, GSRepositoryTree, GSPullRequest;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GSTwoFactorAuthMethod) {
	GSTwoFactorAuthMethodUnknown,
	GSTwoFactorAuthMethodApp,
	GSTwoFactorAuthMethodSMS,
};

@interface GSGitHubEngine : NSObject
@property (nonatomic, strong, nullable) GSUser *activeUser;
+ (instancetype)sharedInstance;
- (void)eventsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSEvent *> *__nullable events, NSError *__nullable error))handler;
- (void)notificationsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSNotification *> *__nullable notifications, NSError *__nullable error))handler;
// Users
//- (void)emailsForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable emails, NSError *__nullable error))handler;
// emails have 3 fields, address, verified, and primary. hmm...
//- (void)addEmailAddressForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable emails, NSError *__nullable error))handler;
//- (void)removeEmailAddressForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable emails, NSError *__nullable error))handler;
//- (void)followersForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable followers, NSError *__nullable error))handler;
//- (void)followingUsersForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable following, NSError *__nullable error))handler;

//
//- (void)followUser:(GSUser *__nonnull)user fromUser:(GSUser *__nonnull)us completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler;
//- (void)unfollowUser:(GSUser *__nonnull)user fromUser:(GSUser *__nonnull)us completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler;

@end

NS_ASSUME_NONNULL_END
