//
//  GSObject.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSObject : NSObject <NSCoding>
@property (atomic, strong) NSDate *updatedDate;
- (void)configureWithDictionary:(NSDictionary *)dictionary;
- (void)update; // Asynchronous
- (BOOL)updateSynchronouslyWithError:(NSError *__autoreleasing *)error;
- (void)updateWithCompletionHandler:(void (^)(NSError *error))handler; // Asynchronous
@end
