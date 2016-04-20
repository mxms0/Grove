//
//  GRDrawerMenuItem.h
//  Grove
//
//  Created by Max Shavrick on 4/17/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRDrawerMenuItem : NSObject
@property (nonatomic, readonly, weak) id target;
@property (nonatomic, readonly) SEL selector;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *icon;
+ (instancetype)drawerMenuItemWithText:(NSString *)text icon:(UIImage *)img target:(id)ta selector:(SEL)selector;
- (instancetype)initWithText:(NSString *)text icon:(UIImage *)img target:(id)target selector:(SEL)selector;
@end
