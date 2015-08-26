//
//  GRViewModel.h
//  Grove
//
//  Created by Max Shavrick on 8/24/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GRViewModelDelegate <NSObject>
- (void)reloadData;
@end

@interface GRViewModel : NSObject
@property (nonatomic) id<GRViewModelDelegate> delegate;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
@end
