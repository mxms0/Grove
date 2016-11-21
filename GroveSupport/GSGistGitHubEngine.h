//
//  GSGistGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

NS_ASSUME_NONNULL_BEGIN

@class GSGist;
@interface GSGitHubEngine (GSGistGitHubEngine)
- (void)gistsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSGist *> *__nullable gists, NSError *__nullable))handler;

//- (void)forkGist:(GSGist *)gist completionHandler:(void (^)(GSGist *__nullable, NSError *__nullable))handler;
//- (void)forksForGist:(GSGist *)gist completionHandler:(void (^)(NSArray<GSGist *> *__nullable, NSError *__nullable))handler;

- (void)starredGistsWithCompletionHandler:(void (^)(NSArray<GSGist *> *__nullable, NSError *__nullable))handler;
- (void)starGist:(GSGist *)gist completionHandler:(void (^)(NSError *__nullable))handler; // may want to pass updated gist back
- (void)unstarGist:(GSGist *)gist completionHandler:(void (^)(NSError *__nullable))handler; // may want to pass updated gist back
- (void)isGistStarred:(GSGist *)gist completionHandler:(void (^)(BOOL starred, NSError *__nullable))handler;

- (void)commentsForGist:(GSGist *)gist completionHandler:(void (^)(NSArray *__nullable comments, NSError *__nullable))handler;
//- (void)commentOnGist:(GSGist *)gist withMessage:(NSString *)message attachments:(NSArray *__nullable)attachments completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler;
//- (void)editComent:(id)comment gist:(id)gist newMessage:(NSString *)message completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler;
//- (void)deleteComment:(id)comment gist:(id)gist completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler;

//- (void)updateFile:(id)file newContents:(id)contents forGist:(GSGist *)gist completionHandler:(void (^)(NSError *__nullable))handler;
//- (void)updateFileName:(id)filename newName:(id)newname forGist:(GSGist *)gist completionHandler:(void (^)(NSError *__nullable))handler;
//- (void)deleteFileNamed:(id)name fromGist:(GSGist *)gist completionHandler:(void (^)(NSError *__nullable))handler;

//- (void)deleteGist:(GSGist *)gist completionHandler:(void (^)(NSError *__nullable))handler;
@end

NS_ASSUME_NONNULL_END
