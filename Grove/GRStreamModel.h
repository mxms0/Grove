//
//  GRStreamModel.h
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRViewModel.h"

@class GSEvent, GRStreamCellModel;

@interface GRStreamModel : GRViewModel
- (instancetype)initWithDelegate:(id <GRViewModelDelegate>)del;
- (void)requestNewData;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (GRStreamCellModel *)eventCellModelForIndexPath:(NSIndexPath *)indexPath;
@end
