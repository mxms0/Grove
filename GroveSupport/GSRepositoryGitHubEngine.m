//
//  GSRepositoryGitHubEngine.m
//  GroveSupport
//
//  Created by Max Shavrick on 10/4/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSRepositoryGitHubEngine.h"
#import "GSNetworkManager.h"
#import "GroveSupportInternal.h"
#import "GSURLRequest.h"
#import "GSPullRequest.h"

@implementation GSGitHubEngine (GSRepositoryGitHubEngine)

#pragma mark Starring

- (void)starRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler {
	// PUT
	GSAssert();
}

- (void)unstarRepository:(GSRepository *)repo completionHandler:(void (^)(BOOL success, NSError *__nullable error))handler {
	// DELETE
	GSAssert();
}

- (void)repositoriesStarredByUser:(GSUser *)user completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	NSURL *destination = GSAPIURLComplex(GSAPIEndpointUsers, user.username, GSAPIComponentStarred, nil);
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:destination];
	[request setAuthToken:user.token];
	
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable *serializeable, NSError *error) {
		GSInsuranceBegin(serializeable, NSArray, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			NSMutableArray *ret = [[NSMutableArray alloc] init];
			for (NSDictionary *dict in (NSArray *)serializeable) {
				GSRepository *repo = [[GSRepository alloc] initWithDictionary:dict];
				[ret addObject:repo];
			}
			
			handler((NSArray *)ret, nil);
		}
		
		GSInsuranceEnd();
	}];
}

#pragma mark Repositories

- (void)branchesForRepository:(GSRepository *)repo completionHandler:(void (^)(NSArray *, NSError *))handler {
    void (^basicHandler)(NSArray<NSDictionary *> *__nullable branches, NSError *__nullable error) = ^(NSArray<NSDictionary *>* __nullable branches, NSError *__nullable error) {
        
        NSLog(@"BRANCHES. %@", branches);
        
        GSInsuranceBegin(branches, NSArray, error);
        
        GSInsuranceError {
            handler(nil, error);
        }
        
        GSInsuranceBadData {
            GSAssert();
        }
        
        GSInsuranceGoodData {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dictionary in branches) {
                [array addObject:dictionary[@"name"]];
            }
            handler(array, nil);
        }
        
        GSInsuranceEnd();
    };
    
    if (self.activeUser.token) {
        [[GSNetworkManager sharedInstance] requestBranchesForRepository:repo token:self.activeUser.token completionHandler:basicHandler];
    }
}

- (void)repositoriesForUser:(GSUser *)user completionHandler:(void (^)(NSArray<GSRepository *> *__nullable repos, NSError *__nullable error))handler {
	
	void (^basicHandler)(NSArray<NSDictionary *> *__nullable repos, NSError *__nullable error) = ^(NSArray<NSDictionary *>* __nullable repos, NSError *__nullable error) {
		
		//NSLog(@"REPOS. %@", repos);
		
		GSInsuranceBegin(repos, NSArray, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			NSMutableArray *serializedRepos = [[NSMutableArray alloc] init];
			for (NSDictionary *dict in repos) {
				GSRepository *repository = [[GSRepository alloc] initWithDictionary:dict];
				[serializedRepos addObject:repository];
			}
			handler(serializedRepos, nil);
		}
		
		GSInsuranceEnd();
	};
	
	if ([self.activeUser isEqual:user] && self.activeUser.token) {
		[[GSNetworkManager sharedInstance] requestRepositoriesForCurrentUserWithToken:self.activeUser.token completionHandler:basicHandler];
	}
	else {
		[[GSNetworkManager sharedInstance] requestRepositoriesForUsername:user.username completionHandler:basicHandler];
	}
}

- (void)repositoriesForUsername:(NSString *)username completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	GSAssert();
}

- (void)collaboratorsForRepository:(GSRepository *)repo completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error {
	GSAssert();
}

- (void)collaboratorsForRepositoryNamed:(NSString *)repoName owner:(NSString *)owner completionHandler:(void (^)(NSArray *__nullable collabs, NSError *__nullable error))error {
	GSAssert();
}

- (void)repositoryContentsForRepository:(GSRepository *)repo atPath:(NSString *__nullable)path recurse:(BOOL)recurse completionHandler:(nonnull void (^)(GSRepositoryTree *_Nullable, NSError *_Nullable))handler {
	
	if (recurse) {
		[[GSNetworkManager sharedInstance] recursivelyRequestRepositoryTreeForRepositoryNamed:repo.name repositoryOwner:repo.owner.username treeOrBranch:@"master" token:self.activeUser.token completionHandler:^(NSDictionary * _Nullable primitiveTree, NSError * _Nullable error) {
			
			GSInsuranceBegin(primitiveTree, NSDictionary, error);
			
			GSInsuranceError {
				handler(nil, error);
			}
			GSInsuranceBadData {
				GSAssert();
				// this should never happen
			}
			GSInsuranceGoodData {
				GSRepositoryTree *tree = [[GSRepositoryTree alloc] initWithDictionary:primitiveTree];
				[tree setRecursive:recurse];
				handler(tree, nil);
			}
			
			GSInsuranceEnd();
		}];
	}
	else {
		
		[[GSNetworkManager sharedInstance] requestRepositoryContentsForRepositoryNamed:repo.name repositoryOwner:repo.owner.username token:self.activeUser.token path:path completionHandler:^(NSArray * _Nullable items, NSError * _Nullable error) {
			
			GSInsuranceBegin(items, NSArray, error);
			
			GSInsuranceError {
				handler(nil, error);
			}
			GSInsuranceBadData {
				GSAssert();
			}
			GSInsuranceGoodData {
				GSRepositoryTree *tree = [[GSRepositoryTree alloc] initWithRootEntries:items basePath:path];
				handler(tree, nil);
			}
			
			GSInsuranceEnd();
		}];
	}
}

- (void)readmeForRepository:(GSRepository *)repo completionHandler:(void (^)(NSString *__nullable contents, NSError *__nullable error))handler {
	NSURL *destination = GSAPIURLComplex(GSAPIEndpointRepos, repo.owner.username, repo.name, @"readme", nil);
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:destination];
	[request setAuthToken:self.activeUser.token];
	
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable * _Nullable serializeable, NSError * _Nullable error) {
		
		GSInsuranceBegin(serializeable, NSDictionary, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			NSString *contents = [(NSDictionary *)serializeable objectForKey:@"content"];
			contents = [contents stringByReplacingOccurrencesOfString:@"\n" withString:@""];
			NSString *decoded = GSStringFromBase64String(contents);
			handler(decoded, nil);
		}
		
		GSInsuranceEnd();
	}];
}

#pragma mark Requests

- (void)pullRequestsForRepository:(GSRepository*)repo completionHandler:(void (^)(NSArray* _Nullable pullRequests, NSError* _Nullable error))handler {
	
	NSURL* destination = GSAPIURLComplex(GSAPIEndpointRepos, repo.owner.username, repo.name, @"pulls", nil);
	
	GSURLRequest* request = [[GSURLRequest alloc] initWithURL:destination];
	[request setAuthToken:self.activeUser.token];
	
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable * _Nullable serializeable, NSError * _Nullable error) {
		
		GSInsuranceBegin(serializeable, NSArray, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			NSMutableArray* pulls = [[NSMutableArray alloc] init];
			for(NSDictionary* prDict in (NSArray*)serializeable) {
				GSPullRequest* pr = [[GSPullRequest alloc] initWithDictionary:prDict];
				[pulls addObject:pr];
			}
			handler([pulls copy], error);
		}
		
		GSInsuranceEnd()
	}];
}

- (void)pullRequestForRepository:(GSRepository*)repo withNumber:(NSNumber*)number completionHandler:(void (^)(GSPullRequest* _Nullable pullRequest, NSError* _Nullable error))handler {
	
	NSURL* destination = GSAPIURLComplex(GSAPIEndpointRepos, repo.owner.username, repo.name, @"pulls", number, nil);
	
	GSURLRequest* request = [[GSURLRequest alloc] initWithURL:destination];
	[request setAuthToken:self.activeUser.token];
	
	[[GSNetworkManager sharedInstance] sendRequest:request completionHandler:^(GSSerializable * _Nullable serializeable, NSError * _Nullable error) {
		
		GSInsuranceBegin(serializeable, NSDictionary, error);
		
		GSInsuranceError {
			handler(nil, error);
		}
		
		GSInsuranceBadData {
			GSAssert();
		}
		
		GSInsuranceGoodData {
			GSPullRequest* pr = [[GSPullRequest alloc] initWithDictionary:(NSDictionary*)serializeable];
			handler(pr, error);
		}
		
		GSInsuranceEnd()
	}];
}


@end
