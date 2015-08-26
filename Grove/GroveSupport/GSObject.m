//
//  GSObject.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSObject.h"
#import "GroveSupportInternal.h"

@implementation GSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if (!dictionary) {
		return nil;
	}
	if ((self = [super init])) {
		GSAssign(dictionary, @"id", self.identifier);
		GSAssign(dictionary, @"url", _directAPIURL);
	}
	return self;
}

- (NSDate *)dateFromISO8601String:(NSString *)string {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
	return [formatter dateFromString:string];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	GSEncode(aCoder, @"id", self.identifier);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		GSDecodeAssign(aDecoder, @"id", self.identifier);
	}
	return self;
}

@end
