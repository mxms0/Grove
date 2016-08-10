//
//  GRSelectableLabel.h
//  Grove
//
//  Created by Max Shavrick on 3/1/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRSelectableLabel : UIButton
@property (nonatomic, copy) NSString *text;
- (void)setFont:(UIFont *)font;

@end
