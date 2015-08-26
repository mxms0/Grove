//
//  GSObject.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSObject : NSObject <NSCoding>
@property (nonatomic, strong) NSNumber *__nullable identifier;
- (nonnull instancetype)initWithDictionary:(NSDictionary *__nonnull)dictionary;
- (nullable NSDate *)dateFromISO8601String:(NSString *__nonnull)string;
@end
