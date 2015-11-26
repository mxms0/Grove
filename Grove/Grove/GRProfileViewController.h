//
//  GRProfileViewController.h
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"
#import "GRViewModel.h"

@class GSUser;
@interface GRProfileViewController : GRViewController <UITableViewDataSource, UITableViewDelegate, GRViewModelDelegate>
@property (nonatomic, weak, setter=setUser:) GSUser *user;
@end
