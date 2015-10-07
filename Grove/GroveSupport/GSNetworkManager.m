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

- (void)requestOAuth2TokenWithUsername:(NSString *)username password:(NSString *)password handler:(void (^)(NSString *token, NSError *error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.github.com/authorizations"]];
	
	NSString *authenticationInformation = [NSString stringWithFormat:@"%@:%@", username, password];
	NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authenticationInformation base64Encoded]];
	
	[request addValue:authValue forHTTPHeaderField:@"Authorization"];
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
						   @"note": @"hihihihi",
						   @"client_id": GSClientIdentifier,
						   @"client_secret": GSClientSecret,
						   @"fingerprint": [[NSUUID UUID] UUIDString]
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
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		handler(response, error);
	}];
}

- (void)sendDataRequest:(NSURLRequest *)request completionHandler:(void (^)(GSSerializable *response, NSError *error))handler {
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		
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
				
				handler(responsePacket, nil);
				break;
			}
			case 401: {
				NSError *error = [NSError errorWithDomain:GSDomain code:401 userInfo:@{NSLocalizedDescriptionKey: @"Not Authorized"}];
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
	
	[task resume];
}

- (void)requestEventsForUser:(NSString *)user token:(NSString *)token completionHandler:(void (^)(NSArray *events, NSError *error))handler {
	NSURL *properURL = [GSAPIURLForEndpoint(GSAPIEndpointUsers) URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/received_events", user]];
	
	GSURLRequest *req = [[GSURLRequest alloc] initWithURL:properURL];
    [req addAuthToken:token];
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
    [request addAuthToken:token];
	
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
	if (token)
        [request addAuthToken:token];
	
	[self sendDataRequest:request completionHandler:^(id ret, NSError *error) {
		if (error) {
			handler(nil, error);
			return;
		}
		handler(ret, nil);
	}];
}

- (void)getRepositories:(NSString *)token handler:(void (^)(NSArray *repos, NSError *error))handler {
//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.github.com/user/repos"]];
}

- (void)downloadResourceFromURL:(NSURL *)url token:(NSString *)token completionHandler:(void (^)(NSURL *filePath, NSError *error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:url];
	if (token) {
        [request addAuthToken:token];
	}
	
	NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
		handler(location, error);
	}];
	[task resume];
}

- (void)requestUserNotificationsWithToken:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(NSArray *__nullable notifications, NSError *__nullable error))handler {
	GSURLRequest *request = [[GSURLRequest alloc] initWithURL:GSAPIURLForEndpoint(GSAPIEndpointNotifications)];
	
	if (token) {
		[request addAuthToken:token];
	}
	
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
	if (token) {
		[request addAuthToken:token];;
	}
	
	[self sendDataRequest:request completionHandler:^(GSSerializable *response, NSError *error) {
		handler(response, error);
	}];
}

@end
