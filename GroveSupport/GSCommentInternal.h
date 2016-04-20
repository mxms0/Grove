//
//  GSCommentInternal.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef Grove_GSCommentInternal_h
#define Grove_GSCommentInternal_h

#import "GSComment.h"

@interface GSComment ()
@property (nonatomic, nullable, readonly, strong) NSURL *pullRequestAPIURL;
@property (nonatomic, nullable, readonly, strong) NSURL *issueAPIURL;
@end

#endif
