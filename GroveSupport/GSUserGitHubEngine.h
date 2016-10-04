//
//  GSUserGitHubEngine.h
//  GroveSupport
//
//  Created by Max Shavrick on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSGitHubEngine (GSUserGitHubEngine)
- (void)userForUsername:(NSString *)username completionHandler:(void (^)(GSUser *__nullable user, NSError *__nullable error))handler;
- (void)_userInformationForUsername:(NSString *)username completionHandler:(void (^)(NSDictionary *__nullable info, NSError *__nullable error))handler;
@end

NS_ASSUME_NONNULL_END
