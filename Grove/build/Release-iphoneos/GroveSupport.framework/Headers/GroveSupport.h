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

// In this header, you should import all the public headers of your framework using statements like #import <GroveSupport/PublicHeader.h>

static NSString *const GSClientIdentifier = @"1e27f6fb656a735a3a9c";
static NSString *const GSClientSecret = @"192812c39ecc20317489a9b8c3d62989aa7e287f";

static NSString *const GSErrorDomain = @"go away";
// Perhaps move these to a server, should never ship with these tokens

void _GSAssert(BOOL cond, NSString *fmt, ...);
#define GSAssert() _GSAssert(NO, @"(%s) in [%s:%d]", __PRETTY_FUNCTION__, __FILE__, __LINE__)
