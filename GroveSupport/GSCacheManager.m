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
#import "GSObjectInternal.h"
#import "GSUtilities.h"
#import "GSNetworkManager.h"

#include <sys/stat.h>

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
	NSString *lookup = @"defaultPath";
	if (token) {
		lookup = token;
	}

	NSString *extension = nil;
	
	@synchronized(tokenDirectoryMap) {
		extension = tokenDirectoryMap[lookup];
	}
	
	if (!extension) {
		extension = [[self _createWorkingDirectoryForToken:lookup] lastPathComponent];
		@synchronized(tokenDirectoryMap) {
			tokenDirectoryMap[lookup] = extension;
		}
		
		[[NSUserDefaults standardUserDefaults] setObject:tokenDirectoryMap forKey:@"tmpDirectoryMap"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([cacheDirectories count] == 0) {
		GSAssert();
	}
	
	NSString *cachePath = [cacheDirectories objectAtIndex:0];
	
	NSString *filePath = [cachePath stringByAppendingPathComponent:extension];
	
	mkdir([filePath UTF8String], 777);

	return [NSURL fileURLWithPath:filePath];
}

- (NSURL *)_createWorkingDirectoryForToken:(NSString *)token {
	NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ([cacheDirectories count] == 0) {
		GSAssert();
	}
	
	NSString *cachePath = [cacheDirectories objectAtIndex:0];
	
	NSString *pathTarget = [NSString stringWithFormat:@"%@XXXXXX", GSDomain];
	
	NSString *pathTempl = [cachePath stringByAppendingPathComponent:pathTarget];

	char *pathRes = mkdtemp((char *)[pathTempl UTF8String]);
	
	NSString *finalPath = [NSString stringWithUTF8String:pathRes];
	NSURL *finalPathURL = [NSURL fileURLWithPath:finalPath];
	
	return finalPathURL;
}

- (void)_downloadResourceWithURL:(NSURL *)url user:(GSUser *)user completionHandler:(void (^)(NSURL *path, NSError *error))handler {
	[[GSNetworkManager sharedInstance] downloadResourceFromURL:url token:user.token completionHandler:^(NSURL *filePath, NSError *error) {
		if (error) {
			handler(nil, error);
		}
		else {
			NSURL *urlPath = [self _workingDirectoryForToken:user.token];
			NSURL *targetPath = [urlPath URLByAppendingPathComponent:GSMD5HashFromString([url absoluteString])];
			if ([self _moveFileFromPath:filePath toPath:targetPath]) {
				handler(targetPath, error);
			}
			else {
				GSAssert();
			}
		}
	}];
}

- (BOOL)_moveFileFromPath:(NSURL *)path toPath:(NSURL *)newPath {
	[[NSFileManager defaultManager] removeItemAtURL:newPath error:nil];
	NSError *error = nil;
	if (![[NSFileManager defaultManager] moveItemAtURL:path toURL:newPath error:&error]) {
		NSLog(@"ERROR. %@", error);
		GSAssert();
	}
	return YES;
}

- (void)findImageAssetWithURL:(NSURL *)url loggedInUser:(GSUser *)user downloadIfNecessary:(BOOL)download completionHandler:(void (^)(UIImage *image, NSError *error))handler {
	NSURL *directory = [self _workingDirectoryForToken:user.token];
	NSURL *assetPath = [directory URLByAppendingPathComponent:GSMD5HashFromString([url absoluteString])];
	NSString *properAssetPath = [assetPath relativePath];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:properAssetPath]) {
		// leaving this log because never verified this works,
		// especially being that acccess(..., F_OK) hates me (or iOS' sandbox...) [or both...]
		UIImage *image = [UIImage imageWithContentsOfFile:properAssetPath];
		if (image) {
			handler(image, nil);
		}
		else {
			// likely can't read from disk. 
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
					// maybe add extra handling here.
					handler(nil, error);
				}
			}];
		}
	}
}

- (void)findAvatarForActorNamed:(NSString *__nonnull)name downloadIfNecessary:(BOOL)nec completionHandler:(void (^__nonnull)(UIImage *__nullable image, NSError *__nullable error))handler {
	GSAssert();
}

- (void)findAvatarForActor:(GSActor *__nonnull)user downloadIfNecessary:(BOOL)necessary completionHandler:(void (^__nonnull)(UIImage *__nullable image, NSError *__nullable error))handler {
	
	NSURL *avatarURL = user.avatarURL;

	if (!avatarURL) {
		avatarURL = [[NSURL URLWithString:@"https://avatars.githubusercontent.com/u/"] URLByAppendingPathComponent:[user.identifier stringValue]];
		// attempt generic avatar URL
	}
	
	[self findImageAssetWithURL:avatarURL loggedInUser:nil downloadIfNecessary:necessary completionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
		handler(image, error);
	}];
}

- (void)findFileAssetWithURL:(NSURL *)url user:(GSUser *)user downloadIfNecessary:(BOOL)download completionHandler:(void (^)(NSURL *filePath, NSError *error))handler {
	
}

@end
