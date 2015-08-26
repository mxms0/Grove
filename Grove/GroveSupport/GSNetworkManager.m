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

@implementation GSNetworkManager

+ (instancetype)sharedInstance {
	static id _instance = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^ {
		_instance = [[self alloc] init];
	});
	
	return _instance;
}

- (void)requestOAuth2TokenWithUsername:(NSString *__nonnull)username password:(NSString *__nonnull)password handler:(void (^ __nullable)(NSString *__nullable token, NSError *__nullable error))handler {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.github.com/authorizations"]];
	
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
			// grab error message and pass it on
		}
		// check this with properties attached i.e. hash and last8 chars
		handler(token, nil);
	}];
}


- (void)sendDataRequest:(NSURLRequest *__nonnull)request completionHandler:(void (^ __nullable)(id response, NSError *error))handler {
	NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *__nullable data, NSURLResponse *__nullable response, NSError *__nullable error) {
		
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
			default:
				handler(nil, error);
				break;
		}
	}];
	
	[task resume];
}

- (void)requestEventsForUser:(NSString *)user token:(NSString *)token completionHandler:(void (^)(id events, NSError *error))handler {
	NSURL *properURL = [GSAPIURLForEndpoint(GSAPIEndpointUsers) URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/received_events", user]];
	
	NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:properURL];

	[req addValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
	[self sendDataRequest:req completionHandler:^(id dictionary, NSError *error) {
		handler(dictionary, error);

	}];
}

- (void)requestUserInformationForToken:(NSString *__nonnull)token completionHandler:(void (^__nonnull)(NSDictionary *response, NSError *error))handler {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:GSAPIURLForEndpoint(GSAPIEndpointUser)];
	[request addValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
	
	[self sendDataRequest:request completionHandler:^(id response, NSError *error) {
		if (error || !response) {
			handler(nil, error);
			return;
		}
		handler(response, error);
	}];
}

- (void)requestUserInformationForUsername:(NSString *__nonnull)username token:(NSString *)token completionHandler:(void (^__nonnull)(NSDictionary *__nullable response, NSError *__nullable error))handler {
	NSURL *requestURL = [GSAPIURLForEndpoint(GSAPIEndpointUsers) URLByAppendingPathComponent:username];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL];
	if (token)
		[request addValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
	
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
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	if (token) {
		[request addValue:[NSString stringWithFormat:@"token %@", token] forHTTPHeaderField:@"Authorization"];
	}
	
	NSURLSessionDownloadTask *task = [[NSURLSession sharedSession] downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
		handler(location, error);
	}];
	[task resume];
}

@end
