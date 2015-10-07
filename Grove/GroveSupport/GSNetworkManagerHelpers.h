//
//  GSNetworkManagerHelpers.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const GSAPIHostURL = @"https://api.github.com/";
// 1st order components
static NSString *const GSAPIEndpointRepos = @"repos";
static NSString *const GSAPIEndpointUsers = @"users";
static NSString *const GSAPIEndpointOrganizations = @"orgs";
static NSString *const GSAPIEndpointNetworks = @"networks";
static NSString *const GSAPIEndpointUser = @"user";
static NSString *const GSAPIEndpointTeams = @"teams";
static NSString *const GSAPIEndpointNotifications = @"notifications";
static NSString *const GSAPIEndpointIssues = @"issues";
static NSString *const GSAPIEndpointGists = @"gists";
static NSString *const GSAPIEndpointAuthorizations = @"authorizations";
static NSString *const GSAPIEndpointFeeds = @"feeds";
// second order components
static NSString *const GSAPIComponentStarred = @"starred";

typedef NS_ENUM(NSInteger, GSAPIHTTPVerb) {
	GSAPIHTTPVerbHead,
	GSAPIHTTPVerbGet,
	GSAPIHTTPVerbPost,
	GSAPIHTTPVerbPatch,
	GSAPIHTTPVerbPut,
	GSAPIHTTPVerbDelete
};

NSString *GSHTTPVerbStringForVerb(GSAPIHTTPVerb verb);
NSURL *GSAPIURLComplex(NSString *endp, NSString *arg1, NSString *arg2);
NSURL *GSAPIURLForEndpoint(NSString *endp);
