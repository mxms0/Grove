//
//  GRModelViewController.m
//  Grove
//
//  Created by Rocco Del Priore on 12/13/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRModelViewController.h"

@interface GRModelViewController ()
@property (nonatomic) id<GRDataSource> model;
@end

@implementation GRModelViewController

- (instancetype)initWithModel:(id<GRDataSource>)localModel {
    self = [self init];
    if (self) {
        self.model = localModel;
    }
    return self;
}

@end
