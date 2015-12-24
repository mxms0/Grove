//
//  GRRepositoryViewController.h
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"

@class GSRepository;
@interface GRRepositoryViewController : GRViewController
@property (nonatomic, weak) GSRepository *repository;
@end
