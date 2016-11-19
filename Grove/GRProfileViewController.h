//
//  GRProfileViewController.h
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"
#import "GRViewModel.h"
#import "GRTableViewController.h"

@class GSUser;
@interface GRProfileViewController : GRTableViewController <UITableViewDataSource, UITableViewDelegate, GRViewModelDelegate>
@property (nonatomic, weak, setter=setUser:) GSUser *user;
- (instancetype)initWithUsername:(NSString *)username;
// need method to load based on just username as a string. Would probably be useful. 
@end
