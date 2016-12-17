//
//  GRSectionHeaderFooterView.h
//  Grove
//
//  Created by Jim Boulter on 10/25/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GRSectionHeaderFooterMode) {
	GRSectionModeHeader,
	GRSectionModeFooter
};

@interface GRSectionHeaderFooterView : UIView {
@protected
    GRSectionHeaderFooterMode mode;
    UILabel *label;
}

- (instancetype)initWithFrame:(CGRect)frame mode:(GRSectionHeaderFooterMode)mode text:(NSString *)text;
@end
