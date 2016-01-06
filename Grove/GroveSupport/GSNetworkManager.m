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

@implementation GSNetworkManager

+ (instancetype)sharedInstance {
	static id _instance = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^ {
		_instance = [[self alloc] init];
	});
	
	return _instance;
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
			GSAssert();
			// grab error message and pass it on
		}
		// check this with properties attached i.e. hash and last8 chars
		handler(token, nil);
	}];
}

- (void)sendRequest:(GSURLRequest *__nonnull)request completionHandler:(void (^__nonnull)(GSSerializable *__nullable serializeable, NSError *__nullable error))handler {
	NSLog(@"sending request...");
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		handler(response, error);
	}];
}

- (void)sendDataRequest:(NSURLRequest *)request completionHandler:(void (^)(GSSerializable *response, NSError *error))handler {
	if (!request) {
		NSLog(@"te fuck");
	}
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
#if 1
		NSLog(@"Request:%@ Response: %@", request, response);
#endif
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response; // put safety checks here. albeit unlikely
		switch ([httpResponse statusCode]) {
			case 200: {
				NSError *serializationError = nil;
				NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&serializationError];
				
				if (response) {
					handler(response, nil);
				}
				else {
					handler(nil, serializationError);
				}
				break;
			}
			case 201: {
				NSError *serializationError = nil;
				NSDictionary *responsePacket = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingOptions)0 error:&serializationError];
				if (!responsePacket) {
					handler(nil, serializationError);
				}
				else {
					handler(responsePacket, nil);
				}
				break;
			}
			case 304: {
#if DEBUG
				NSLog(@"Not modified for req %@", request);
#endif
				handler(nil, nil);
				break;
			}
			case 401: {
#if DEBUG
				NSLog(@"Not authorized %@:%@:%@", data, response, request);
#endif
				NSMutableDictionary *errorInfo = [@{NSLocalizedDescriptionKey: @"Not Authorized."} mutableCopy];
				NSString *authEtc = [[httpResponse allHeaderFields] objectForKey:GSHTTPTwoFactorAuthHeaderKey];
				if (authEtc) {
					[errorInfo setObject:authEtc forKey:GSAuthCriteria];
				}
				NSError *error = [NSError errorWithDomain:GSErrorDomain code:401 userInfo:errorInfo];
				handler(nil, error);
				break;
			}
			default:
				NSLog(@"HTTP Code %ld", (long)[httpResponse statusCode]);
				GSAssert();
				handler(nil, error);
				break;
		}
	}];
	
	NSLog(@"session crafted %@", task);
	
	[task resume];
}

- (void)requestEventsForUser:(NSString *)user token:(NSString *)token completionHandler:(void (^)(NSArray *events, NSError *error))handler {
	NSURL *properURL = [GSAPIURLForEndpoint(GSAPIEndpointUsers) URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/received_events", user]];
	
	GSURLRequest *req = [[GSURLRequest alloc] initWithURL:properURL];
	[req setAuthToken:token];
	[self sendDataRequest:req completionHandler:^(id dictionary, NSError *error) {
		if (error) {
			handler(nil, error);
			return;
		}
		
		if ([dictionary isKindOfClass:[NSArray class]]) {
			handler(dictionary, nil);
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

- (void)requestRepositoriesForCurrentUserWithToken:(NSString *)token completionHandler:(void (^)(NSArray *__nullable repos, NSError *__nullable error))handler {
	NSURL *requestURL = GSAPIURLComplex(GSAPIEndpointUser, GSAPIEndpointRepos, nil);
	NSLog(@"requ url %@", requestURL);
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
	
	NSURL *requestURL = GSAPIURLComplex(GSAPIEndpointUsers, username, GSAPIEndpointRepos);
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
