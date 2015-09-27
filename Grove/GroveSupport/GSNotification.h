//
//  GSNotification.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/20/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSRepository;

@interface GSNotification : GSObject
@property (nonatomic, assign) BOOL read;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSDate *updatedDate;
@property (nonatomic, copy) NSDate *lastReadDate;
@property (nonatomic, strong) GSRepository *repository;
@end
