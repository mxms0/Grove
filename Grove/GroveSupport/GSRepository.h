//
//  GSRepository.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

typedef NS_OPTIONS(NSInteger, GSRepositoryPermissions) {
	GSRepositoryPermissionsNone = 0,
	GSRepositoryPermissionsPush = 1 << 0,
	GSRepositoryPermissionsPull = 1 << 1,
	GSRepositoryPermissionsAdmin = 1 << 2,
};

@class GSUser;
@interface GSRepository : GSObject
@property (nonatomic, readonly, strong) GSUser *owner;
@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, assign) GSRepositoryPermissions permissions;
@property (nonatomic, readonly, getter=isPrivate) BOOL private; // private is a keyword, should change this.
@property (nonatomic, readonly, getter=isFork) BOOL fork;
@property (nonatomic, readonly, assign) BOOL downloadsAvailable;
@property (nonatomic, readonly, assign) BOOL wikiAvailable;
@property (nonatomic, readonly, assign) BOOL pagesAvailable;
@property (nonatomic, readonly, assign) BOOL issuesAvailable;
@property (nonatomic, readonly, strong) NSURL *browserURL; //https://github.com/...
@property (nonatomic, readonly, strong) NSURL *browserHomepageURL; // website specified by repo
@property (nonatomic, readonly, strong) NSURL *sshURL;
@property (nonatomic, readonly, strong) NSURL *gitURL;
@property (nonatomic, readonly, strong, getter=pathString) NSString *pathString;
@property (nonatomic, readonly, strong) NSString *language;
@property (nonatomic, readonly, strong, getter=defaultBranch) NSString *defaultBranch;
// I really prefer language to be an enum, but then i'd be converting it from string, just so the user could convert it back again...
// Also I'd need to keep an updated list of all languages..
@property (nonatomic, readonly, strong) NSString *userDescription;
@property (nonatomic, readonly, strong) NSNumber *numberOfForks;
@property (nonatomic, readonly, strong) NSNumber *numberOfOpenIssues;
@property (nonatomic, readonly, strong) NSNumber *numberOfWatchers;
@property (nonatomic, readonly, strong) NSNumber *numberOfStargazers;
@property (nonatomic, readonly, strong) NSNumber *repositorySize;
@property (nonatomic, readonly, strong) NSDate *lastPushDate;
@property (nonatomic, readonly, assign, getter=isFull) BOOL full;

@end
