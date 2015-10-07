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
		if (dictionary[key] != [NSNull null]) { \
			obj = dictionary[key]; \
		} \
	} while (0);

#define GSObjectAssign(dictionary, key, obj, cls) \
	do { \
		if (dictionary[key] != [NSNull null]) { \
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

// perhaps create one of these for dates too. that seeems to cover most of the possibilities.

@interface GSObject ()
@property (nonatomic, nullable, readonly) NSURL *directAPIURL;
@property (nonatomic, nullable, readonly) NSNumber *identifier;
- (nonnull instancetype)initWithDictionary:(NSDictionary *__nonnull)dictionary;
- (nullable NSDate *)dateFromISO8601String:(NSString *__nonnull)string;
@end

#endif
