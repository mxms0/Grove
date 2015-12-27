//
//  GSObject.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSObject : NSObject <NSCoding> {
	NSDate *_updatedDate;
}
@property (atomic, nullable, readonly, strong) NSDate *updatedDate;
- (void)update; // Asynchronous
- (BOOL)updateSynchronouslyWithError:(NSError *__autoreleasing __nullable *__nullable)error;
- (void)updateWithCompletionHandler:(void (^__nullable)(NSError *__nullable error))handler; // Asynchronous
@end

NS_ASSUME_NONNULL_END
