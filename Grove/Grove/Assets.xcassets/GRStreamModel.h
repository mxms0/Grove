//
//  GRStreamModel.h
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRViewModel.h"

@class GSEvent;

@interface GRStreamModel : GRViewModel
@property (nonatomic, readonly) NSArray *events;


- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (GSEvent *)eventForIndexPath:(NSIndexPath *)indexPath;
@end
