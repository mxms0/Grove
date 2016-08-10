//
//  GRSessionManager.h
//  Grove
//
//  Created by Max Shavrick on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRApplicationUser.h"
#import "GSUser.h"

@interface GRSessionManager : NSObject
@property (nonatomic, strong, nullable) GRApplicationUser *currentUser;
@property (nonatomic, readonly, nonnull) NSMutableOrderedSet *users;
+ (nonnull instancetype)sharedInstance;
- (GRApplicationUser *__nonnull)createApplicationUserWithUser:(GSUser *__nonnull)user becomeCurrentUser:(BOOL)becomeCurrentUser;
- (void)save;
- (void)unpack;
@end
