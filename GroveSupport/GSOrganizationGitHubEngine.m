//
//  GSOrganizationGitHubEngine.m
//  Grove
//
//  Created by Rocco Del Priore on 11/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSOrganizationGitHubEngine.h"
#import "GSNetworkManager.h"
#import "GroveSupportInternal.h"
#import "GSURLRequest.h"

@implementation GSGitHubEngine (GSOrganizationGitHubEngine)

- (void)organizationsForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSOrganization *> *__nullable organizations, NSError *__nullable error))handler {
    
    void (^basicHandler)(NSArray<NSDictionary *> *__nullable repos, NSError *__nullable error) = ^(NSArray<NSDictionary *>* __nullable organizations, NSError *__nullable error) {
        
        //NSLog(@"ORGS. %@", organizations);
        
        GSInsuranceBegin(organizations, NSArray, error);
        
        GSInsuranceError {
            handler(nil, error);
        }
        
        GSInsuranceBadData {
            GSAssert();
        }
        
        GSInsuranceGoodData {
            NSMutableArray *orgObjects = [[NSMutableArray alloc] init];
            for (NSDictionary *dictionary in organizations) {
                GSOrganization *organization = [[GSOrganization alloc] initWithDictionary:dictionary];
                [orgObjects addObject:organization];
            }
            handler(orgObjects, nil);
        }
        
        GSInsuranceEnd();
    };
    
    if ([self.activeUser isEqual:user] && self.activeUser.token) {
        [[GSNetworkManager sharedInstance] requestOrganizationsForCurrentUserWithToken:self.activeUser.token completionHandler:basicHandler];
    }
    else {
        [[GSNetworkManager sharedInstance] requestOrganizationsForUsername:user.username completionHandler:basicHandler];
    }
}

@end
