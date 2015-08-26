//
//  GSCacheManager.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSCacheManager.h"
#import "GSUser.h"
#import "GSUserInternal.h"
#import "GSUtilities.h"
#import "GSNetworkManager.h"

@implementation GSCacheManager {
	NSMutableDictionary *tokenDirectoryMap;
}

+ (instancetype)sharedInstance {
	static id _instance = nil;
	static dispatch_once_t token;
	dispatch_once(&token, ^{
		_instance = [[self alloc] init];
	});
	return _instance;
}

- (instancetype)init {
	if ((self = [super init])) {
		tokenDirectoryMap = [[NSMutableDictionary alloc] init];
		[self _loadCache];
	}
	return self;
}

- (void)_loadCache {
	NSDictionary *ret = [[NSUserDefaults standardUserDefaults] objectForKey:@"tmpDirectoryMap"];
	if (ret)
		tokenDirectoryMap = [ret mutableCopy];
}

- (NSURL *)_workingDirectoryForToken:(NSString *)token {
	NSURL *directory = nil;
	if (token) {
		@synchronized(tokenDirectoryMap) {
			directory = [NSURL URLWithString:tokenDirectoryMap[token]];
		}
		
		if (!directory) {
			directory = [self _createWorkingDirectoryForToken:token];
		}
	}
	else {
		directory = [NSURL URLWithString:tokenDirectoryMap[@"defaultPath"]];
		if (!directory) {
			directory = [self _createWorkingDirectoryForToken:@"defaultPath"];
		}
	}
	return directory;
}

- (NSURL *)_createWorkingDirectoryForToken:(NSString *)token {
	NSString *tempPath = NSTemporaryDirectory();
	NSString *pathTempl = [tempPath stringByAppendingFormat:@"%@XXXXXX", GSDomain];
	char *pathRes = mkdtemp((char *)[pathTempl UTF8String]);
	
	NSString *finalPath = [NSString stringWithUTF8String:pathRes];
	NSURL *finalPathURL = [NSURL fileURLWithPath:finalPath];
	
	@synchronized(tokenDirectoryMap) {
		tokenDirectoryMap[token] = [finalPathURL absoluteString];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:tokenDirectoryMap forKey:@"tmpDirectoryMap"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	return finalPathURL;
}

- (void)_downloadResourceWithURL:(NSURL *)url user:(GSUser *)user completionHandler:(void (^)(NSURL *path, NSError *error))handler {
	[[GSNetworkManager sharedInstance] downloadResourceFromURL:url token:user.token completionHandler:^(NSURL *filePath, NSError *error) {
		NSURL *urlPath = [self _workingDirectoryForToken:user.token];
		NSURL *targetPath = [urlPath URLByAppendingPathComponent:GSMD5HashFromString([url absoluteString])];
		if ([self _moveFileFromPath:filePath toPath:targetPath]) {
			handler(targetPath, error);
		}
		else {
			GSAssert();
		}
	}];
}

- (BOOL)_moveFileFromPath:(NSURL *)path toPath:(NSURL *)newPath {
	NSError *error = nil;
	if (![[NSFileManager defaultManager] moveItemAtURL:path toURL:newPath error:&error]) {
		GSAssert();
	}
	return YES;
}

- (void)findImageAssetWithURL:(NSURL *)url user:(GSUser *)user downloadIfNecessary:(BOOL)download completionHandler:(void (^)(UIImage *image, NSError *error))handler {
	NSURL *directory = [self _workingDirectoryForToken:user.token];
	NSURL *assetPath = [directory URLByAppendingPathComponent:GSMD5HashFromString([url absoluteString])];

	if ([[NSFileManager defaultManager] fileExistsAtPath:assetPath.absoluteString]) {
		NSLog(@"woo file exists.");
		// leaving this log because never verified this works,
		// especially being that acccess(..., F_OK) hates me (or iOS' sandbox...) [or both...]
		UIImage *image = [UIImage imageWithContentsOfFile:[assetPath absoluteString]];
		if (image) {
			handler(image, nil);
			return;
		}
		else {
			GSAssert();
		}
	}
	else {
		if (download) {
			[self _downloadResourceWithURL:url user:user completionHandler:^(NSURL *filePath, NSError *error) {
				if (filePath) {
					//					UIImage *image = [UIImage imageWithContentsOfFile:filePath.absoluteString]; // null everytime. k
					NSData *data = [NSData dataWithContentsOfURL:filePath];
					if (data) {
						handler([UIImage imageWithData:data], nil);
					}
					else {
						GSAssert();
					}
				}
				else {
					GSAssert();
				}
			}];
			
			return;
		}
	}
	GSAssert();
}

- (void)findFileAssetWithURL:(NSURL *)url user:(GSUser *)user downloadIfNecessary:(BOOL)download completionHandler:(void (^)(NSURL *filePath, NSError *error))handler {
	
}

@end
