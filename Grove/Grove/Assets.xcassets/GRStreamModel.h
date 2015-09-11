//
//  GRStreamModel.h
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRViewModel.h"

@class GSEvent, GREventCellModel;

@interface GRStreamModel : GRViewModel

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (GREventCellModel *)eventCellModelForIndexPath:(NSIndexPath *)indexPath;
@end
