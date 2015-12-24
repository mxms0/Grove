//
//  GroveSupport.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for GroveSupport.
FOUNDATION_EXPORT double GroveSupportVersionNumber;

//! Project version string for GroveSupport.
FOUNDATION_EXPORT const unsigned char GroveSupportVersionString[];

#import <GroveSupport/GSUser.h>
#import <GroveSupport/GSGitHubEngine.h>
#import <GroveSupport/GSActor.h>
#import <GroveSupport/GSRepository.h>
#import <GroveSupport/GSEvent.h>
#import <GroveSupport/GSCommit.h>
#import <GroveSupport/GSCacheManager.h>
#import <GroveSupport/GSNotification.h>
#import <GroveSupport/GSComment.h>
#import <GroveSupport/GSOrganization.h>
#import <GroveSupport/GSUtilities.h>

// In this header, you should import all the public headers of your framework using statements like #import <GroveSupport/PublicHeader.h>

static NSString *const GSDomain = @"com.RickSupport.morty";
static NSString *const GSErrorDomain = @"MortiestMorty";
static NSString *const GSUpdatedDateKey = @"updatedDate";

void _GSAssert(BOOL cond, NSString *fmt, ...);
#define GSAssert() _GSAssert(NO, @"(%s) in [%s:%d]", __PRETTY_FUNCTION__, __FILE__, __LINE__)

typedef NSObject<NSCoding> GSSerializable;