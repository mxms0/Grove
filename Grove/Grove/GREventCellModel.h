//
//  GREventCellModel.h
//  Grove
//
//  Created by Max Shavrick on 9/10/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSEvent;
@interface GREventCellModel : NSObject
@property (nonatomic, strong, nonnull) GSEvent *event;
- (nonnull instancetype)initWithEvent:(GSEvent *__nonnull)event;

- (nonnull NSAttributedString *)eventString;
- (nonnull UIImage *)imageIcon;
- (nonnull NSString *)dateStringFromEvent;
@end
