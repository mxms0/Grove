//
//  GSGistGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSGitHubEngine (GSGistGitHubEngine)
- (void)gistsForUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable gists, NSError *__nullable))handler;
- (void)commentsForGist:(GSGist *)gist completionHandler:(void (^)(NSArray *__nullable comments, NSError *__nullable))handler;
- (void)commentOnGist:(GSGist *)gist withMessage:(NSString *)message attachments:(NSArray *__nullable)attachments completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler;
- (void)editComent:(id)comment gist:(id)gist newMessage:(NSString *)message completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler;
- (void)deleteComment:(id)comment gist:(id)gist completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler;
@end

NS_ASSUME_NONNULL_END
