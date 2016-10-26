//
//  GRSectionHeaderFooterView.h
//  Grove
//
//  Created by Jim Boulter on 10/25/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
	GRSectionHeaderMode,
	GRSectionFooterMode
} GRSectionHeaderFooterMode;

@interface GRSectionHeaderFooterView : UIView

- (instancetype)initWithFrame:(CGRect)frame mode:(GRSectionHeaderFooterMode)mode;

@end
