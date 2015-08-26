//
//  GSRepository.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSRepository.h"
#import "GroveSupportInternal.h"

@implementation GSRepository

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {
		GSURLAssign(dictionary, @"url", _browserURL);
		
		NSString *temporaryName = nil;
		GSAssign(dictionary, @"name", temporaryName);
		NSRange range = [temporaryName rangeOfString:@"/"];
		if (range.location != NSNotFound && range.location != 0) {
			NSString *user = [temporaryName substringToIndex:range.location];
			NSString *repoName = [temporaryName substringFromIndex:range.location + 1];

			_name = repoName;
			_owner = user;
		}
		else {
			_name = temporaryName;
			_owner = temporaryName;
			GSAssert();
		}
	}
	return self;
}

@end
