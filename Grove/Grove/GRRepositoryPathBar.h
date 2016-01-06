//
//  GRRepositoryPathBar.h
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GRRepositoryPathBar;
@protocol GRRepositoryPathBarDelegate <NSObject>
- (BOOL)isAtRootForPathBar:(GRRepositoryPathBar *)bar;
- (void)popPathForPathBar:(GRRepositoryPathBar *)bar;
- (void)popToRootForPathBar:(GRRepositoryPathBar *)bar;
@end

@interface GRRepositoryPathBar : UIView
@property (nonatomic, weak, nullable) id <GRRepositoryPathBarDelegate> delegate;
@property (nonatomic, strong, nullable, setter=setRoot:) NSString *root;
- (void)pushPath:(NSString *)path;
@end

NS_ASSUME_NONNULL_END