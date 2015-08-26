//
//  GSNetworkManagerHelpers.h
//  Grove
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const GSAPIHostURL = @"https://api.github.com/";

typedef NS_ENUM(NSInteger, GSAPIEndpoint) {
	GSAPIEndpointRepos,
	GSAPIEndpointUsers,
	GSAPIEndpointOrganizations,
	GSAPIEndpointNetworks,
	GSAPIEndpointUser,
	GSAPIEndpointTeams,
	GSAPIEndpointNotifications,
	GSAPIEndpointIssues,
	GSAPIEndpointGists,
	GSAPIEndpointAuthorizations,
	GSAPIEndpointFeeds
};

typedef NS_ENUM(NSInteger, GSAPIHTTPVerb) {
	GSAPIHTTPVerbHead,
	GSAPIHTTPVerbGet,
	GSAPIHTTPVerbPost,
	GSAPIHTTPVerbPatch,
	GSAPIHTTPVerbPut,
	GSAPIHTTPVerbDelete
};

NSString *GSHTTPVerbStringForVerb(GSAPIHTTPVerb verb);

NSURL *GSAPIURLForEndpoint(GSAPIEndpoint endp);
