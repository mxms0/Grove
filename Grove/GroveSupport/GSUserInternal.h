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
@property (nonatomic, nullable, strong) NSString *token;
@property (nonatomic, nullable, strong) NSURL *followersAPIURL;
@property (nonatomic, nullable, strong) NSURL *followingAPIURL;
@property (nonatomic, nullable, strong) NSURL *gistsAPIURL;
@property (nonatomic, nullable, strong) NSURL *starredAPIURL;
@property (nonatomic, nullable, strong) NSURL *subscriptionsAPIURL;
@property (nonatomic, nullable, strong) NSURL *organizationsAPIURL;
@property (nonatomic, nullable, strong) NSURL *repositoriesAPIURL;
@property (nonatomic, nullable, strong) NSURL *eventsAPIURL;
@property (nonatomic, nullable, strong) NSURL *receivedEventsAPIURL;
@property (nonatomic, nullable, readwrite, strong) NSNumber *starredRepositoryCount;
@end

#endif
