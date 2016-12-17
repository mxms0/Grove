//
//  GRCommitsModel.h
//  Grove
//
//  Created by Rocco Del Priore on 11/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSRepository;
@interface GRCommitsModel : NSObject <GRDataSource>

@property (nonatomic, readonly) GSRepository *repository;
@property (nonatomic, readonly) NSString *branch;

- (instancetype)initWithRepository:(GSRepository *)repository branch:(NSString *)branch;

@end
