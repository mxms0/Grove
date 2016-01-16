//
//  GRRepositoryViewController.h
//  Grove
//
//  Created by Max Shavrick on 9/26/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"
#import "GRRepositoryViewSelector.h"

@class GSRepository;
@interface GRRepositoryViewController : GRViewController <GRRepositoryViewSelectorDelegate>
@property (nonatomic, weak) GSRepository *repository;
@end
