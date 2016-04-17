//
//  GRStreamEventCell.h
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSEvent, GRStreamCellModel;
@interface GRStreamEventCell : UITableViewCell
- (void)configureWithEventModel:(GRStreamCellModel *)event;
- (void)setAvatar:(UIImage *)image;
@end
