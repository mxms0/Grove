//
//  GRIssuesModel.h
//  Grove
//
//  Created by Rocco Del Priore on 12/3/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRIssuesModel : NSObject <GRDataSource>

- (instancetype)initWithRepository:(GSRepository *)repository;

@end
