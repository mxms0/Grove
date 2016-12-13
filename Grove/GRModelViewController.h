//
//  GRModelViewController.h
//  Grove
//
//  Created by Rocco Del Priore on 12/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRViewController.h"

@interface GRModelViewController : GRViewController

@property (nonatomic, readonly) id<GRDataSource> model;

- (instancetype)initWithModel:(id<GRDataSource> )model;

@end
