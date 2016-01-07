//
//  GSGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSUser, GSEvent, GSRepository, GSGist, GSNotification, GSRepositoryEntry;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GSTwoFactorAuthMethod) {
	GSTwoFactorAuthMethodUnknown,
	GSTwoFactorAuthMethodApp,
	GSTwoFactorAuthMethodSMS,
};

@interface GSGitHubEngine : NSObject
@property (nonatomic, strong, nullable) GSUser *activeUser;
+ (instancetype)sharedInstance;
- (void)authenticateUserWithUsername:(NSString *)username password:(NSString *)password completionHandler:(void (^__nullable)(GSUser *__nullable, NSError *__nullable))handler;
- (void)authenticateUserWithUsername:(NSString *)username password:(NSString *)password twoFactorToken:(NSString *__nullable)twoFa completionHandler:(void (^__nullable)(GSUser *__nullable, NSError *__nullable))handler;
- (void)eventsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSEvent *> *__nullable events, NSError *__nullable error))handler;
- (void)userForUsername:(NSString *)username completionHandler:(void (^)(GSUser *__nullable user, NSError *__nullable error))handler;
- (void)notificationsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSNotification *> *__nullable notifications, NSError *__nullable error))handler;
// Users
//- (void)emailsForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable emails, NSError *__nullable error))handler;
// emails have 3 fields, address, verified, and primary. hmm...
//- (void)addEmailAddressForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable emails, NSError *__nullable error))handler;
//- (void)removeEmailAddressForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable emails, NSError *__nullable error))handler;
//- (void)followersForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable followers, NSError *__nullable error))handler;
//- (void)followingUsersForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable following, NSError *__nullable error))handler;
// - (void)isUser:(GSUser *__nonnull)user followingUser:(GSUser *__nonnull)followee completionHandler:(void (^__nonnull)(BOOL isFollowing, NSError *__nullable error))handler;
//- (void)followUser:(GSUser *__nonnull)user fromUser:(GSUser *__nonnull)us completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler;
//- (void)unfollowUser:(GSUser *__nonnull)user fromUser:(GSUser *__nonnull)us completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler;

// Repositories
- (void)repositoriesForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSRepository *> *__nullable repos, NSError *__nullable error))handler;
- (void)repositoriesForUsername:(NSString *)username completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)collaboratorsForRepository:(GSRepository *)repo completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error;
- (void)collaboratorsForRepositoryNamed:(NSString *)repoName owner:(NSString *)owner completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error;

- (void)repositoryContentsForRepository:(GSRepository *)repo completionHandler:(void (^)(NSArray<GSRepositoryEntry *> *__nullable items, NSError *__nullable error))handler;

// Starring
- (void)starRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler;
- (void)unstarRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler;
- (void)repositoriesStarredByUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler;

// Gists
- (void)gistsForUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable gists, NSError *__nullable))handler;
- (void)commentsForGist:(GSGist *)gist completionHandler:(void (^)(NSArray *__nullable comments, NSError *__nullable))handler;
- (void)commentOnGist:(GSGist *)gist withMessage:(NSString *)message attachments:(NSArray *__nullable)attachments completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler;
- (void)editComent:(id)comment gist:(id)gist newMessage:(NSString *)message completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler;
- (void)deleteComment:(id)comment gist:(id)gist completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler;
@end

NS_ASSUME_NONNULL_END
