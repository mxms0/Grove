//
//  GSUser.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSActor.h"

@interface GSUser : GSActor <NSCoding>
@property (nonatomic, nullable, readonly, strong) NSURL *browserURL;
@property (nonatomic, assign) int type; // either User or Organization afaik
@property (nonatomic, assign, getter=isAdmin) BOOL admin;
@property (nonatomic, nullable, readonly, strong) NSString *fullName;
@property (nonatomic, nullable, readonly, strong) NSString *company;
@property (nonatomic, nullable, readonly, strong) NSString *blog;
@property (nonatomic, nullable, readonly, strong) NSString *location;
@property (nonatomic, nullable, readonly, strong) NSString *email;
@property (nonatomic, nullable, readonly, strong) NSString *hireable;
@property (nonatomic, nullable, readonly, strong) NSString *biography;
@property (nonatomic, nullable, readonly, strong) NSNumber *followersCount;
@property (nonatomic, nullable, readonly, strong) NSNumber *followingCount;
@property (nonatomic, nullable, readonly, strong) NSNumber *publicRepoCount;
@property (nonatomic, nullable, readonly, strong) NSNumber *publicGistCount;
@property (nonatomic, nullable, readonly, strong) NSDate *createdDate;
@property (nonatomic, nullable, readonly, strong) NSNumber *privateGistsCount;
@property (nonatomic, nullable, readonly, strong) NSNumber *totalPrivateRepoCount;
@property (nonatomic, nullable, readonly, strong) NSNumber *ownedPrivateRepoCount;
@property (nonatomic, nullable, readonly, strong) NSNumber *diskUsage;
@property (nonatomic, nullable, readonly, strong) NSNumber *collaboratorCount;
 /* 
  Missing
 "plan": {
  "name": "micro",
  "space": 976562499,
  "collaborators": 0,
  "private_repos": 5
 }
 */
+ (nullable GSUser *)cachedUserWithUsername:(NSString *__nonnull)username;
@end
