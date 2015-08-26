//
//  GSNetworkManagerHelpers.m
//  Grove
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSNetworkManagerHelpers.h"

NSString *GSHTTPVerbStringForVerb(GSAPIHTTPVerb verb) {
	NSString *ret = nil;
	switch (verb) {
		case GSAPIHTTPVerbHead:
			ret = @"HEAD";
			break;
		case GSAPIHTTPVerbGet:
			ret = @"GET";
			break;
		case GSAPIHTTPVerbPost:
			ret = @"POST";
			break;
		case GSAPIHTTPVerbPatch:
			ret = @"PATCH";
			break;
		case GSAPIHTTPVerbPut:
			ret = @"PUT";
			break;
		case GSAPIHTTPVerbDelete:
			ret = @"DELETE";
			break;
		default:
			ret = @"UNKNOWN";
			break;
	}
	return ret;
}

NSURL *GSAPIURLForEndpoint(GSAPIEndpoint endp) {
	NSString *pathExtension = nil;
	switch (endp) {
		case GSAPIEndpointGists:
			pathExtension = @"gists";
			break;
		case GSAPIEndpointIssues:
			pathExtension = @"issues";
			break;
		case GSAPIEndpointNetworks:
			pathExtension = @"networks";
			break;
		case GSAPIEndpointNotifications:
			pathExtension = @"notifications";
			break;
		case GSAPIEndpointOrganizations:
			pathExtension = @"orgs";
			break;
		case GSAPIEndpointRepos:
			pathExtension = @"repos";
			break;
		case GSAPIEndpointTeams:
			pathExtension = @"teams";
			break;
		case GSAPIEndpointUser:
			pathExtension = @"user";
			break;
		case GSAPIEndpointUsers:
			pathExtension = @"users";
			break;
		case GSAPIEndpointAuthorizations:
			pathExtension = @"authorizations";
			break;
		case GSAPIEndpointFeeds:
			pathExtension = @"feeds";
			break;
		default:
			GSAssert();
			pathExtension = @"unknown";
			break;
	}
	return [NSURL URLWithString:[GSAPIHostURL stringByAppendingPathComponent:pathExtension]];
}
