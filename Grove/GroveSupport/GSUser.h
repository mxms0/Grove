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
@property (nonatomic, nullable, strong) NSURL *browserURL;
@property (nonatomic, assign) int type; // either User or Organization afaik
@property (nonatomic, assign, getter=isAdmin) BOOL admin;
@property (nonatomic, nullable, strong) NSString *fullName;
@property (nonatomic, nullable, strong) NSString *company;
@property (nonatomic, nullable, strong) NSString *blog;
@property (nonatomic, nullable, strong) NSString *location;
@property (nonatomic, nullable, strong) NSString *email;
@property (nonatomic, nullable, strong) NSString *hireable;
@property (nonatomic, nullable, strong) NSString *biography;
@property (nonatomic, nullable, strong) NSNumber *followersCount;
@property (nonatomic, nullable, strong) NSNumber *followingCount;
@property (nonatomic, nullable, strong) NSNumber *publicRepoCount;
@property (nonatomic, nullable, strong) NSNumber *publicGistCount;
@property (nonatomic, nullable, strong) NSDate *createdDate;
@property (nonatomic, nullable, strong) NSNumber *privateGistsCount;
@property (nonatomic, nullable, strong) NSNumber *totalPrivateRepoCount;
@property (nonatomic, nullable, strong) NSNumber *ownedPrivateRepoCount;
@property (nonatomic, nullable, strong) NSNumber *diskUsage;
@property (nonatomic, nullable, strong) NSNumber *collaboratorCount;
 /* Missing
 "plan": {
  "name": "micro",
  "space": 976562499,
  "collaborators": 0,
  "private_repos": 5
 }
 */
+ (nullable GSUser *)cachedUserWithUsername:(NSString *__nonnull)username;
@end
