//
//  GSActor.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSObject.h"

@interface GSActor : GSObject <NSCoding>
@property (nonatomic, readonly) NSString *username; // synonymous with login?
@property (nonatomic, readonly) NSString *gravatarIdentifier;
@property (nonatomic, readonly) NSURL *avatarURL;
@end
