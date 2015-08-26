//
//  GSUtilities.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef __GroveSupport__GSUtilities__
#define __GroveSupport__GSUtilities__

#import <Foundation/Foundation.h>

NSString *GSMD5HashFromString(NSString *string);
NSString *GSMD5HashFromFile(NSURL *filePath);

#endif /* defined(__Grove__GSUtilities__) */
