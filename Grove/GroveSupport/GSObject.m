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
	/*
	 Consider the implications of this:
	 Whenever configuring, will always report updated date
	 Even if the data is the same
	 Shouldn't be an issue, the user can just post it back to the UI no issue
	 But should it be significant not to notify user if no data has changed?
	 Tried a hash, but -hash isn't good enough, gonna need an MD5
	 Which could be slow and costly.
	 */
	GSAssign(dictionary, @"id", _identifier);
	GSURLAssign(dictionary, @"url", _directAPIURL);
	@synchronized(self) {
		self.updatedDate = [NSDate date];
	}
}

- (NSDate *)dateFromISO8601String:(NSString *)string {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
	return [formatter dateFromString:string];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	GSEncode(aCoder, @"id", self.identifier);
	GSEncode(aCoder, @"url", self.directAPIURL);
	GSEncode(aCoder, @"updatedDate", self.updatedDate);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		GSDecodeAssign(aDecoder, @"id", _identifier);
		GSDecodeAssign(aDecoder, @"url", _directAPIURL);
		GSDecodeAssign(aDecoder, @"updatedDate", self.updatedDate);
	}
	return self;
}

- (BOOL)updateSynchronouslyWithError:(NSError *__autoreleasing *)error; {
	dispatch_semaphore_t wait = dispatch_semaphore_create(0);
	__block NSError *lError = nil;
	[self updateWithCompletionHandler:^(NSError *error) {
		dispatch_semaphore_signal(wait);
		lError = error;
	}];
	
	dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
	
	if (error) {
		*error = lError;
	}
	return (!!error);
}

- (void)update {
	[self updateWithCompletionHandler:nil];
}

- (void)updateWithCompletionHandler:(void (^)(NSError *error))handler {
	if (self.directAPIURL) {
		[[GSGitHubEngine sharedInstance] _dirtyRequestWithObject:self completionHandler:^(NSDictionary *ret, NSError *error) {
			if (!error) {
				[self configureWithDictionary:ret];
			}
			else {
				NSLog(@"error %@", error);
				GSAssert();
			}
			if (handler)
				handler(error);
		}];
	}
	else {
		if (handler)
			handler([NSError errorWithDomain:GSErrorDomain code:(INT_MAX - 15) userInfo:@{NSLocalizedDescriptionKey: @"Couldn't send proper request."}]);
	}
}

@end
