//
//  GSOrganizationGitHubEngine.h
//  Grove
//
//  Created by Rocco Del Priore on 11/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>
#import <GroveSupport/GSOrganization.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSGitHubEngine (GSOrganizationGitHubEngine)

- (void)organizationsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSOrganization *> *__nullable organizations, NSError *__nullable error))handler;

@end

NS_ASSUME_NONNULL_END