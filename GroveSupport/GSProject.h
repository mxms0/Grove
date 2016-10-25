//
//  GSProject.h
//  Grove
//
//  Created by Rocco Del Priore on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <GroveSupport/GroveSupport.h>

@interface GSProject : GSObject

@property (nonatomic, nullable, readonly, strong) NSURL *ownerURL;
@property (nonatomic, nullable, readonly, strong) NSURL *URL;
@property (nonatomic, nullable, readonly, strong) NSString *name;
@property (nonatomic, nullable, readonly, strong) NSString *body;
@property (nonatomic, nullable, readonly, strong) NSNumber *number;
//TODO: Implement Creator Object (assumed GSUser)

@end
