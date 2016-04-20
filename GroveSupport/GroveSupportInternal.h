//
//  GroveSupportInternal.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef GroveSupport_GroveSupportInternal_h
#define GroveSupport_GroveSupportInternal_h

// Perhaps move these to a server, should never ship with these tokens

#import "GroveSupport.h"
#import "GroveSupportInternalStrings.h"
#import "GSGitHubEngineInternal.h"
#import "GSObjectInternal.h"
#import "GSUserInternal.h"
#import "GSNotificationInternal.h"
#import "GSRepositoryInternal.h"
#import "GSActorInternal.h"
#import "GSIssueInternal.h"
#import "GSCommentInternal.h"
#import "GSNetworkManager.h"
#import "GSRepositoryEntryInternal.h"
#import "GSGistInternal.h"
#import "GSRepositoryTreeInternal.h"

#define API_TRUST_LEVEL 0

#define API_TRUST_LEVEL_NOT_AT_ALL 0
#define API_TRUST_LEVEL_LENIENT 1
#define API_TRUST_LEVEL_AVERAGE 3
#define API_TRUST_LEVEL_STRICT 5
/*
 0 – Not at all
 1 – Trust certain data, like repo names
 2 – unused
 3 – Truat API urls
 4 – unused
 5 – Trust everything
 */
// fallback, if API didn't give us URL for some data, form it ourself
// versus always forming it ourself.

#endif
