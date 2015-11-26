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

@interface GSGitHubEngine ()
- (void)_userForUsername:(NSString *__nonnull)username token:(NSString *__nullable)_token completionHandler:(void (^__nonnull)(NSDictionary *__nullable user, NSError *__nullable error))handler;

@end

#endif /* GSGitHubEngineInternal_h */
