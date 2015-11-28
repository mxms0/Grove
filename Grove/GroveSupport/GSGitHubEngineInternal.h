//
//  GSGitHubEngineInternal.h
//  Grove
//
//  Created by Max Shavrick on 11/25/15.
//  Copyright © 2015 Milo. All rights reserved.
//

#ifndef GSGitHubEngineInternal_h
#define GSGitHubEngineInternal_h

#import "GSGitHubEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSGitHubEngine ()
- (void)_userForUsername:(NSString *)username token:(NSString *__nullable)_token completionHandler:(void (^)(NSDictionary *__nullable user, NSError *__nullable error))handler;
- (void)_dirtyRequestWithDirectAPIURL:(NSURL *)url completionHandler:(void (^)(NSDictionary *__nullable ret, NSError *__nullable error))handler;

@end

NS_ASSUME_NONNULL_END

#endif /* GSGitHubEngineInternal_h */
