//
//  GSNetworkManager.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSNetworkManager.h"
#import "NSString+GSUtilities.h"
#import "GSUser.h"
#import "GroveSupportInternal.h"
#import "GSURLRequest.h"
#include <libkern/OSAtomic.h>

@interface GSNetworkManager ()
@property (nonatomic, assign) NSInteger _requestCount;
@end

@implementation GSNetworkManager {
	NSURLSession *currentSession;
}

- (void)set_requestCount:(NSInteger)reqCount {
	@synchronized(self) {
		__requestCount = reqCount;
	}
#if TARGET_OS_IPHONE
	if (__requestCount == 1) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	}
	else if (__requestCount == 0) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
#endif
}

+ (instancetype)sharedInstance {
	static id _instance = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^ {
		_instance = [[self alloc] init];
	});
	
	return _instance;
}

- (instancetype)init {
	if ((self = [super init])) {
		currentSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	}
	return self;
}

- (void)requestOAuth2TokenWithUsername:(NSString *)username password:(NSString *)password twoFactorToken:(NSString *__nullable)twoFa handler:(void (^)(NSString *token, NSError *error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.github.com/authorizations"]];
	
	NSString *authenticationInformation = [NSString stringWithFormat:@"%@:%@", username, password];
	NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authenticationInformation base64Encoded]];
	
	[request addValue:authValue forHTTPHeaderField:@"Authorization"];
	[request setTwoFactorAuthToken:twoFa];

	[request setHTTPMethod:@"POST"];
	
	NSDictionary *body = @{
						   @"scopes": @[
								   @"user",
								   @"user:email",
								   @"user:follow",
								   @"public_repo",
								   @"repo",
								   @"repo_deployment",
								   @"repo:status",
								   @"delete_repo",
								   @"notifications",
								   @"gist",
								   @"read:repo_hook",
								   @"write:repo_hook",
								   @"admin:repo_hook",
								   @"admin:org_hook",
								   @"read:org",
								   @"write:org",
								   @"admin:org",
								   @"read:public_key",
								   @"write:public_key",
								   @"admin:public_key"
								   ],
						   @"note": @"g",
						   @"client_id": GSClientIdentifier,
						   @"client_secret": GSClientSecret,
						   @"fingerprint": [[NSUUID UUID] UUIDString] // make this symbolic
						   };
	
	NSError *serializationError = nil;
	NSData *jsonSerialized = [NSJSONSerialization dataWithJSONObject:body options:(NSJSONWritingOptions)0 error:&serializationError];
	
	if (serializationError) {
		GSAssert();
	}
	
	[request setHTTPBody:jsonSerialized];
	
	[self sendDataRequest:request completionHandler:^(id response, NSError *error) {
		if (error) {
			handler(nil, error);
			return;
		}
		NSString *token = nil;
		if ([response isKindOfClass:[NSDictionary class]]) {
			token = response[@"token"];
		}
		else {
			NSLog(@"packet %@:%@", response, error);
			GSAssert();
			// grab error message and pass it on
		}
		// check this with properties attached i.e. hash and last8 chars
		handler(token, nil);
	}];
}

- (void)sendRequest:(GSURLRequest *__nonnull)request completionHandler:(void (^__nonnull)(GSSerializable *__nullable serializeable, NSError *__nullable error))handler {
	// placeholder for direction
	// since there may be a download request
	// and an upload request too.

	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		handler(response, error);
	}];
}

- (void)sendDataRequest:(NSURLRequest *)request completionHandler:(void (^)(GSSerializable *response, NSError *error))handler {
	__weak GSNetworkManager *weakSelf = self;
	weakSelf._requestCount = weakSelf._requestCount + 1;
	
	void (^dataHandler)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *responseError) {
#if 0
		NSLog(@"code %ld", (long)[(NSHTTPURLResponse *)response statusCode]);
		NSLog(@"Request:%@ Response: %@ [%@]", request, response, data);
#endif
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response; // put safety checks here. albeit unlikely
		GSSerializable *result = nil;
		NSError *error = nil;
		
		switch ([httpResponse statusCode]) {
			case 0: {
				error = [NSError errorWithDomain:GSErrorDomain code:-1 userInfo:@{
																				  NSLocalizedDescriptionKey: @"Failed to send network request."
																				  }];
				// request failed. weeee.
				break;
			}
			case 200: {
				NSError *serializationError = nil;
				NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&serializationError];

				if (response) {
					result = response;
				}
				else {
					error = serializationError;
				}
				break;
			}
			case 201: {
				NSError *serializationError = nil;
				NSDictionary *responsePacket = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&serializationError];
				if (!responsePacket) {
					error = serializationError;
				}
				else {
					result = responsePacket;
				}
				break;
			}
			case 304: {
#if 0
				NSLog(@"Not modified for req %@", request);
#endif
				result = @{};
				// Perhaps use constant packet with info about this..
				break;
			}
			case 401: {
				NSLog(@"401: %@", data);
				NSMutableDictionary *errorInfo = [@{NSLocalizedDescriptionKey: @"Not Authorized."} mutableCopy];
				NSString *authEtc = [[httpResponse allHeaderFields] objectForKey:GSHTTPTwoFactorAuthHeaderKey];
				if (authEtc) {
					[errorInfo setObject:authEtc forKey:GSAuthCriteria];
				}
				NSError *retError = [NSError errorWithDomain:GSErrorDomain code:401 userInfo:errorInfo];
				error = retError;
				break;
			}
			case 403: {
				if (!error) {
					// check X-RateLimit-Remaining HTTP header.
					NSLog(@"[403] %@", data);
					// this is most likely API rate limit exceeded... ;_; make new error
					error = [NSError errorWithDomain:GSErrorDomain code:22222 userInfo:@{NSLocalizedDescriptionKey: @"Maximum login attempts reached."}];
				}
				else {
					error = responseError;
				}
				break;
			}
			case 404: {
#if 0
				NSLog(@"Not Found %@:%@:%@", data, response, request);
#endif
				NSDictionary *userInfo = nil;
				
				NSError *serializationError = nil;
				NSDictionary *packet = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
				if (serializationError) {
					userInfo = @{
					  NSLocalizedDescriptionKey: @"Not Found",
					  };
				}
				else {
					userInfo = @{
								 NSLocalizedDescriptionKey : packet[@"message"]
								 };
				}
				
				NSError *retError = [NSError errorWithDomain:GSErrorDomain code:404 userInfo:userInfo];
				error = retError;
				break;
			}
			case 503: {
				NSDictionary *userInfo = @{
										   NSLocalizedDescriptionKey: @"Service Unavailable",
										   };
				NSError *retError = [NSError errorWithDomain:GSErrorDomain code:503 userInfo:userInfo];
				error = retError;
				break;
			}
			default:
				NSLog(@"HTTP Code %ld", (long)[httpResponse statusCode]);
				GSAssert();
				error = responseError;
				break;
		}
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
			if (error) {
				handler(nil, error);
			}
			else {
				handler(result, nil);
			}
			weakSelf._requestCount = weakSelf._requestCount - 1;
		});
	};
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
		// this probably isn't necessary anymore.
		
		NSURLSessionDataTask *task = [currentSession dataTaskWithRequest:request completionHandler:dataHandler];
		[task resume];
	});
}

- (void)requestEventsForUser:(NSString *)user token:(NSString *)token completionHandler:(void (^)(NSArray *events, NSError *error))handler {
	NSURL *properURL = [GSAPIURLForEndpoint(GSAPIEndpointUsers) URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/received_events", user]];
	
	GSURLRequest *req = [[GSURLRequest alloc] initWithURL:properURL];
	[req setAuthToken:token];
	[self sendDataRequest:req completionHandler:^(GSSerializable *array, NSError *error) {
		if (error) {
			handler(nil, error);
			return;
		}
		
		if ([array isKindOfClass:[NSArray class]]) {
			handler((NSArray *)array, nil);
		}
		else {
			GSAssert();
			handler(nil, nil);
		}
		
	}];
}

- (void)requestUserInformationForToken:(NSString *)token completionHandler:(void (^)(NSDictionary *response, NSError *error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:GSAPIURLForEndpoint(GSAPIEndpointUser)];
	[request setAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(id response, NSError *error) {
		if (error || !response) {
			handler(nil, error);
			return;
		}
		handler(response, error);
	}];
}

- (void)requestUserInformationForUsername:(NSString *)username token:(NSString *)token completionHandler:(void (^)(NSDictionary *response, NSError *error))handler {
	NSURL *requestURL = [GSAPIURLForEndpoint(GSAPIEndpointUsers) URLByAppendingPathComponent:username];
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:requestURL];
	
	[request setAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(id ret, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else {
			handler(ret, nil);
		}
	}];
}

- (void)requestOrganizationsForUsername:(NSString *)username completionHandler:(void (^)(NSArray *__nullable orgs, NSError *__nullable error))handler {
    NSURL *requestURL = GSAPIURLComplex(GSAPIEndpointUsers, username, GSAPIEndpointOrganizations, nil);
    GSURLRequest *request = [[GSURLRequest alloc] initWithURL:requestURL];
    
    [self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
        if (error) {
            handler(nil, error);
        }
        else {
            handler((NSArray *)response, nil);
        }
    }];
}

- (void)requestOrganizationsForCurrentUserWithToken:(NSString *)token completionHandler:(void (^)(NSArray *__nullable orgs, NSError *__nullable error))handler {
    NSURL *requestURL = GSAPIURLComplex(GSAPIEndpointUser, GSAPIEndpointOrganizations, nil);
    
    GSURLRequest *request = [[GSURLRequest alloc] initWithURL:requestURL];
    [request setAuthToken:token];
    
    [self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
        if (error) {
            handler(nil, error);
        }
        else {
            handler((NSArray *)response, nil);
        }
    }];
}

- (void)requestCommitsForRepository:(GSRepository *)repository branch:(NSString *)branch token:(NSString *)token completionHandler:(void (^)(NSArray<NSDictionary *> *__nullable branches, NSError *__nullable error))handler {
    GSURLRequest *request = [[GSURLRequest alloc] initWithURL:[repository.commitsAPIURL URLByAppendingPathComponent:branch]];
   
    NSLog(@"Commits URL :%@", [repository.commitsAPIURL URLByAppendingPathComponent:branch]);
    
    [self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
        if (error) {
            handler(nil, error);
        }
        else {
            handler((NSArray *)response, nil);
        }
    }];
}

- (void)requestBranchesForRepository:(GSRepository *)repository token:(NSString *)token completionHandler:(void (^)(NSArray<NSDictionary *> *__nullable branches, NSError *__nullable error))handler {
    GSURLRequest *request = [[GSURLRequest alloc] initWithURL:repository.branchesAPIURL];
    [request setAuthToken:token];
    
    [self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
        if (error) {
            handler(nil, error);
        }
        else {
            handler((NSArray *)response, nil);
        }
    }];
}

- (void)requestRepositoriesForCurrentUserWithToken:(NSString *)token completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	NSURL *requestURL = GSAPIURLComplex(GSAPIEndpointUser, GSAPIEndpointRepos, nil);

	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:requestURL];
	[request setAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else {
			handler((NSArray *)response, nil);
		}
	}];
}

- (void)requestRepositoriesForUsername:(NSString *)username completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	
	NSURL *requestURL = GSAPIURLComplex(GSAPIEndpointUsers, username, GSAPIEndpointRepos, nil);
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:requestURL];
	
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else {
			handler((NSArray *)response, nil);
		}
	}];
}

- (void)recursivelyRequestRepositoryTreeForRepositoryNamed:(NSString *)repoName repositoryOwner:(NSString *)owner treeOrBranch:(NSString *)treeOrBranch token:(NSString *)token completionHandler:(void (^)(NSDictionary *__nullable result, NSError *__nullable serror))handler {
	NSURL *requestURL = GSAPIURLComplex(GSAPIEndpointRepos, owner, repoName, @"git", @"trees", treeOrBranch, nil);
	
	NSURLComponents *components = [[NSURLComponents alloc] initWithURL:requestURL resolvingAgainstBaseURL:NO];
	[components setQuery:@"recursive=1"];
	
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:[components URL]];
	
	[request setAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else {
			handler((NSDictionary *)response, error);
		}
	}];
}

- (void)requestRepositoryContentsForRepositoryNamed:(NSString *)repoName repositoryOwner:(NSString *)username token:(NSString *)token path:(NSString *)path completionHandler:(void (^)(NSArray *__nullable items, NSError *__nullable error))handler {
	
	NSURL *requestURL  = GSAPIURLComplex(GSAPIEndpointRepos, username, repoName, @"contents", path, nil);
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:requestURL];
	[request setAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else {
			handler((NSArray *)response, nil);
		}
	}];
}

- (void)downloadResourceFromURL:(NSURL *)url token:(NSString *)token completionHandler:(void (^)(NSURL *filePath, NSError *error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:url];
	[request setAuthToken:token];
	
	NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
		handler(location, error);
	}];
	
	[task resume];
}

- (void)requestUserNotificationsWithToken:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(NSArray *__nullable notifications, NSError *__nullable error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:GSAPIURLForEndpoint(GSAPIEndpointNotifications)];
	
	[request setAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		if ([response isKindOfClass:[NSArray class]]) {
			handler((NSArray *)response, error);
		}
		else {
			GSAssert();
		}
	}];
}

- (void)requestAPIEndpoint:(NSString *)endp token:(NSString *__nullable)token completionHandler:(void (^__nonnull)(GSSerializable *__nullable s, NSError *__nullable error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:GSAPIURLForEndpoint(endp)];
	[request setAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		handler(response, error);
	}];
}

@end
