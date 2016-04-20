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
@property (nonatomic, readonly, strong) NSString *username; // synonymous with login?
@property (nonatomic, readonly, strong) NSString *gravatarIdentifier;
@property (nonatomic, readonly, strong) NSURL *avatarURL;
@end
