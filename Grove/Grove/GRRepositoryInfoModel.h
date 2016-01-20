//
//  GRRepositoryInfoModel.h
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRRepositoryGenericSectionModel.h"

@class GSRepository;
@interface GRRepositoryInfoModel : GRRepositoryGenericSectionModel
- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfRowsInSection:(NSUInteger)section;
@end
