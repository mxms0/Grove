//
//  GSIssueInternal.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef Grove_GSIssueInternal_h
#define Grove_GSIssueInternal_h

#import "GSIssue.h"

@interface GSIssue ()
@property (nonatomic, readonly, strong) NSURL *commentsAPIURL;
@property (nonatomic, readonly, strong) NSURL *labelsAPIURL;
@property (nonatomic, readonly, strong) NSURL *eventsAPIURL;
@property (nonatomic, readonly, strong) NSURL *browserAPIURL;
@end


#endif
