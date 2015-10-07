//
//  GREventViewControllerProxy.h
//  Grove
//
//  Created by Rocco Del Priore on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRViewController.h"

#import "GSEvent.h"

@interface GREventViewControllerProxy : GRViewController

- (instancetype)initWithEvent:(GSEvent *)event;

@end
