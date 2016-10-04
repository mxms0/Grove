//
//  GSGistGitHubEngine.m
//  GroveSupport
//
//  Created by Max Shavrick on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSGistGitHubEngine.h"
#import "GSNetworkManager.h"
#import "GroveSupportInternal.h"

@implementation GSGitHubEngine (GSGistGitHubEngine)

- (void)gistsForUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable gists, NSError *__nullable))handler {
	if (user.token) {
		
	}
	else {
		
	}
}

- (void)commentsForGist:(GSGist *)gist completionHandler:(void (^)(NSArray *__nullable comments, NSError *__nullable))handler {
	GSAssert();
}

- (void)commentOnGist:(GSGist *)gist withMessage:(NSString *)message attachments:(NSArray<id> *__nullable)attachments completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler {
	GSAssert();
}

- (void)editComent:(id)comment gist:(GSGist *)gist newMessage:(NSString *)message completionHandler:(void (^)(__nullable id comment, NSError *__nullable error))handler {
	GSAssert();
}

- (void)deleteComment:(id)comment gist:(GSGist *)gist completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler {
	GSAssert();
}

@end
