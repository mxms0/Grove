//
//  GSCommit.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

@interface GSCommit : GSObject
@property (nonatomic, readonly) NSString *shaHash;
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) BOOL distinct;
@property (nonatomic, readonly) NSURL *commitURL;
@property (nonatomic, readonly) id author;
@end
