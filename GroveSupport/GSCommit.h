//
//  GSCommit.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSCommit : GSObject
@property (nonatomic, readonly, strong) NSString *shaHash;
@property (nonatomic, readonly, strong) NSString *message;
@property (nonatomic, readonly) BOOL distinct;
@property (nonatomic, readonly, strong) NSURL *commitURL;
@property (nonatomic, readonly, strong) id author; /* GSActor?? */
@end

NS_ASSUME_NONNULL_END
