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
#if !DEBUG
	NSLog(@"[%@] Packet %@", NSStringFromClass([self class]), dictionary);
#endif
	
	if (dictionary) {
		[self _configureWithDictionary:dictionary];
	}
	
	// Updated date is time of last request, not time of new data.

	[self willChangeValueForKey:GSUpdatedDateKey];
	self.updatedDate = [NSDate date];
	[self didChangeValueForKey:GSUpdatedDateKey];
}

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	GSAssign(dictionary, @"id", _identifier);
	GSURLAssign(dictionary, @"url", _directAPIURL);
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

- (BOOL)updateSynchronouslyWithError:(NSError **)error {
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
	if (self.updating) {
		handler(nil);
		// maybe pass NSError(already updating...);
		return;
	}
	
	if (self.directAPIURL) {
		self.updating = YES;
		[[GSGitHubEngine sharedInstance] _dirtyRequestWithObject:self completionHandler:^(NSDictionary *ret, NSError *error) {
			if (error) {
				_GSAssert(NO, [error description]);
				GSSafeHandlerCall(handler, error);
			}
			else if (!ret) {
				[self configureWithDictionary:nil];
				GSSafeHandlerCall(handler, nil);
			}
			else if (![ret isKindOfClass:[NSDictionary class]]) {
				GSAssert();
			}
			else {
				[self configureWithDictionary:ret];
				GSSafeHandlerCall(handler, nil);
			}
			
			self.updating = NO;
		}];
	}
	else {
		GSSafeHandlerCall(handler, [NSError errorWithDomain:GSErrorDomain code:(INT_MAX - 15) userInfo:@{NSLocalizedDescriptionKey: @"Couldn't send proper request."}]);
	}
}

@end
