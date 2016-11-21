//
//  GSRepositoryGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSGitHubEngine (GSRepositoryGitHubEngine)
// Repositories
- (void)repositoriesForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSRepository *> *__nullable repos, NSError *__nullable error))handler;
- (void)repositoriesForUsername:(NSString *)username completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler;
- (void)collaboratorsForRepository:(GSRepository *)repo completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error;
- (void)collaboratorsForRepositoryNamed:(NSString *)repoName owner:(NSString *)owner completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error;
- (void)branchesForRepository:(GSRepository *)repo completionHandler:(void (^)(NSArray *, NSError *))handler;
- (void)commitsForRepository:(GSRepository *)repo branch:(NSString *)branch completionHandler:(void (^)(NSArray *, NSError *))handler;
- (void)repositoryContentsForRepository:(GSRepository *)repo atPath:(NSString *__nullable)path recurse:(BOOL)recurse completionHandler:(nonnull void (^)(GSRepositoryTree *_Nullable, NSError *_Nullable))handler;
- (void)readmeForRepository:(GSRepository *)repo completionHandler:(void (^)(NSString *__nullable contents, NSError *__nullable error))handler;

// Starring
- (void)starRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler;
- (void)unstarRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler;
- (void)repositoriesStarredByUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler;

@end

NS_ASSUME_NONNULL_END
