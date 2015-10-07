//
//  GSOrganization.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSActor.h"

@interface GSOrganization : GSActor
@property (nonatomic, strong) NSString *login;
@property (nonatomic, strong) NSNumber *orgId;
@property (nonatomic, strong) NSString *orgDescription;

@end
