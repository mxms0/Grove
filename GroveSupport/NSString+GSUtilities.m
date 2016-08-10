//
//  NSString+GSUtilities.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "NSString+GSUtilities.h"

@implementation NSString (GSUtilities)

- (NSString *)base64Encoded {
	NSData *tempData = [self dataUsingEncoding:NSUTF8StringEncoding];
	return [tempData base64EncodedStringWithOptions:0];
}

@end
