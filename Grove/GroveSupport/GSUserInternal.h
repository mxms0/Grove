//
//  GSUserInternal.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/21/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef Grove_GSUserInternal_h
#define Grove_GSUserInternal_h

#import "GSUser.h"

@interface GSUser ()
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSURL *followersAPIURL;
@property (nonatomic, strong) NSURL *followingAPIURL;
@property (nonatomic, strong) NSURL *gistsAPIURL;
@property (nonatomic, strong) NSURL *starredAPIURL;
@property (nonatomic, strong) NSURL *subscriptionsAPIURL;
@property (nonatomic, strong) NSURL *organizationsAPIURL;
@property (nonatomic, strong) NSURL *repositoriesAPIURL;
@property (nonatomic, strong) NSURL *eventsAPIURL;
@property (nonatomic, strong) NSURL *receivedEventsAPIURL;
@end

#endif
