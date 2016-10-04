//
//  GSObjectInternal.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef GroveSupport_GSObjectInternal_h
#define GroveSupport_GSObjectInternal_h

#define GSAssign(dictionary, key, obj) \
	do { \
		if (dictionary[key] && dictionary[key] != [NSNull null]) { \
			obj = dictionary[key]; \
		} \
	} while (0);

#define GSObjectAssign(dictionary, key, obj, cls) \
	do { \
		if (dictionary[key] && dictionary[key] != [NSNull null]) { \
			obj = [[cls alloc] initWithDictionary:dictionary[key]]; \
		} \
	} while (0);

#define GSURLAssign(dictionary, key, obj) \
	do { \
		if (dictionary[key] && dictionary[key] != [NSNull null]) { \
			obj = [[NSURL alloc] initWithString:dictionary[key]]; \
		} \
	} while (0);

#define GSDecodeAssign(coder, key, obj) \
	do { \
		obj = [coder decodeObjectForKey:key]; \
	} while (0);

#define GSEncode(coder, key, obj) \
	do { \
		[coder encodeObject:obj forKey:key]; \
	} while (0);

#define GSSafeHandlerCall(x, ...) \
	do { \
		if ((x)) { \
			x(__VA_ARGS__); \
		} \
	} while (0);

// perhaps create one of these for dates too. that seeems to cover most of the possibilities.

NS_ASSUME_NONNULL_BEGIN

@interface GSObject ()
@property (nonatomic, nullable, readonly) NSURL *directAPIURL;
@property (nonatomic, nullable, readonly) NSNumber *identifier;
@property (atomic, nullable, readwrite, strong) NSDate *updatedDate;
@property (atomic, nullable, readwrite, strong) NSDate *createdDate;
@property (atomic, assign) BOOL updating;
- (nonnull instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (nullable NSDate *)dateFromISO8601String:(NSString *)string;
- (void)configureWithDictionary:(NSDictionary *__nullable)dictionary;
- (void)_configureWithDictionary:(NSDictionary *)dictionary;
@end

NS_ASSUME_NONNULL_END

#endif
