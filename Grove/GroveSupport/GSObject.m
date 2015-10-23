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
		[self configureWithDictionary:dictionary];
	}
	return self;
}

- (void)configureWithDictionary:(NSDictionary *)dictionary {
	GSAssign(dictionary, @"id", _identifier);
	GSAssign(dictionary, @"url", _directAPIURL);
	self.updatedDate = [NSDate date];
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
		GSDecodeAssign(aDecoder, @"id", _identifier);
	}
	return self;
}

- (void)update {
	
}

@end
