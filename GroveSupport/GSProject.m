//
//  GSProject.m
//  Grove
//
//  Created by Rocco Del Priore on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSProject.h"
#import "GroveSupportInternal.h"

@interface GSProject ()
@property (nonatomic, nullable, strong) NSURL *ownerURL;
@property (nonatomic, nullable, strong) NSURL *URL;
@property (nonatomic, nullable, strong) NSString *name;
@property (nonatomic, nullable, strong) NSString *body;
@property (nonatomic, nullable, strong) NSNumber *number;
@end

@implementation GSProject

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
    [super _configureWithDictionary:dictionary];
    
#if 1
    NSLog(@"Project information %@", dictionary);
#endif
    
    NSMutableDictionary *defaultKVS = [@{GSKProjectName : self.name,
                                         GSKProjectBody : self.body,
                                         GSKProjectNumber : self.number
                                         } mutableCopy];
    
    NSMutableDictionary *urlKVS = [@{GSKProjectOwnerUrl : self.ownerURL,
                                     GSKProjectUrl : self.URL
                                     } mutableCopy];
    
    for (NSString *key in defaultKVS.allKeys) {
        GSAssign(dictionary, key, defaultKVS[key]);
    }
    for (NSString *key in urlKVS.allKeys) {
        GSURLAssign(dictionary, key, urlKVS[key]);
    }
}

@end
