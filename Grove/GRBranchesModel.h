//
//  GRBranchesModel.h
//  Grove
//
//  Created by Rocco Del Priore on 11/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSRepository;
@interface GRBranchesModel : NSObject <GRDataSource>
- (instancetype)initWithRepository:(GSRepository *)repository;
@end
