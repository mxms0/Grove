//
//  GRRepositoryViewController.h
//  Grove
//
//  Created by Rocco Del Priore on 11/12/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRViewController.h"

@class GSRepository;
@interface GRRepositoryViewController : GRViewController

@property (nonatomic, weak) GSRepository *repository;

- (instancetype)initWithRepository:(GSRepository *)repository;

@end
