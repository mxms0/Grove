//
//  GSGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSUser, GSEvent, GSRepository, GSGist;

@interface GSGitHubEngine : NSObject
+ (nonnull instancetype)sharedInstance;
- (void)authenticateUserWithUsername:(NSString *__nonnull)username password:(NSString *__nonnull)password completionHandler:(void (^ __nullable)(GSUser *__nullable user, NSError *__nullable error))handler;
- (void)eventsForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable events, NSError *__nullable error))handler;
- (void)userForUsername:(NSString *__nonnull)username completionHandler:(void (^__nonnull)(GSUser *__nullable user, NSError *__nullable error))handler;

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
- (void)repositoriesForUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)repositoriesForUsername:(NSString *__nonnull)username completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)collaboratorsForRepository:(GSRepository *__nonnull)repo completionHandler:(void (^__nonnull)(NSArray *__nullable collabs, NSError *__nullable error))error;
- (void)collaboratorsForRepositoryNamed:(NSString *__nonnull)repoName owner:(NSString *__nonnull)owner completionHandler:(void (^__nonnull)(NSArray *__nullable collabs, NSError *__nullable error))error;

// Starring
- (void)starRepository:(GSRepository *__nonnull)repo forUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler;
- (void)unstarRepository:(GSRepository *__nonnull)repo forUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler;
- (void)repositoriesStarredByUser:(GSUser *__nonnull)user completionHandler:(void (^__nonnull)(NSArray *__nullable repos, NSError *__nullable error))handler;

// Gists
- (void)commentsForGist:(GSGist *__nonnull)gist completionHandler:(void (^__nonnull)(NSArray *__nullable comments, NSError *__nullable))handler;
- (void)commentOnGist:(GSGist *__nonnull)gist withMessage:(NSString *__nonnull)message attachments:(NSArray *__nullable)attachments completionHandler:(void (^__nonnull)(__nullable id comment, NSError *__nullable error))handler;
- (void)editComent:(__nonnull id)comment gist:(__nonnull id)gist newMessage:(NSString *__nonnull)message completionHandler:(void (^__nonnull)(__nullable id comment, NSError *__nullable error))handler;
- (void)deleteComment:(__nonnull id)comment gist:(__nonnull id)gist completionHandler:(void (^__nonnull)(BOOL success, NSError *__nullable error))handler;
@end
