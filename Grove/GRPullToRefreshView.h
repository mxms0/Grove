//
//  GRPullToRefreshView.h
//  Grove
//
//  Created by Max Shavrick on 11/24/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRPullToRefreshView : UIView
@property (nonatomic, assign) float animationProgress;
- (instancetype)initWithTableView:(UITableView *)table;
@end
