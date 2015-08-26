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
@property (nonatomic, strong) NSURL *browserURL;
@property (nonatomic, assign) int type; // either User or Organization afaik
@property (nonatomic, assign, getter=isAdmin) BOOL admin;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *blog;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *hireable;
@property (nonatomic, strong) NSString *biography;
@property (nonatomic, strong) NSNumber *followersCount;
@property (nonatomic, strong) NSNumber *followingCount;
@property (nonatomic, strong) NSNumber *publicRepoCount;
@property (nonatomic, strong) NSNumber *publicGistCount;
@property (nonatomic, strong) NSDate *createdDate;
@property (nonatomic, strong) NSDate *updatedDate;
@property (nonatomic, strong) NSNumber *privateGistsCount;
@property (nonatomic, strong) NSNumber *totalPrivateRepoCount;
@property (nonatomic, strong) NSNumber *ownedPrivateRepoCount;
@property (nonatomic, strong) NSNumber *diskUsage;
@property (nonatomic, strong) NSNumber *collaboratorCount;
 /* Missing
 "plan": {
  "name": "micro",
  "space": 976562499,
  "collaborators": 0,
  "private_repos": 5
 }
 */
@end
