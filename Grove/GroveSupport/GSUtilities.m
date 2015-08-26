//
//  GSUtilities.c
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#include "GSUtilities.h"
#import <CommonCrypto/CommonCrypto.h>

void _GSAssert(BOOL cond, NSString *fmt, ...) {
#if DEBUG
	if (!cond) {
		va_list args;
		va_start(args, fmt);
		NSString *join = [[NSString alloc] initWithFormat:fmt arguments:args];
		va_end(args);
		NSLog(@"%@:::%@", join, [NSThread callStackSymbols]);
		
		exit(2);
	}
#else
	if (!cond) {
		NSLog(@"Assert called in Prod.");
	}
#endif
}

NSString *GSMD5HashFromString(NSString *string) {
	
	CC_MD5_CTX md5;
	CC_MD5_Init(&md5);

	CC_MD5_Update(&md5, [string UTF8String], (CC_LONG)[string length]);
	
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &md5);
	
	NSMutableString *output;
	output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[output appendFormat: @"%02x", digest[i]];
	}
	return output;
}

NSString *GSMD5HashFromFile(NSURL *filePath) {
	NSInputStream *fileStream = [NSInputStream inputStreamWithFileAtPath:filePath.absoluteString];
	if (fileStream == nil) {
		return nil;
	}
	
	[fileStream open];
	
	CC_MD5_CTX md5;
	CC_MD5_Init(&md5);
	
	int maxLength = 16 * 4096;
	uint8_t buf[maxLength];
	while ([fileStream hasBytesAvailable]) {
		unsigned int bytesRead = (int)[fileStream read:buf maxLength:maxLength];
		CC_MD5_Update(&md5, buf, bytesRead);
	}
	
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5_Final(digest, &md5);
	
	NSMutableString *output;
	output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[output appendFormat: @"%02x", digest[i]];
	}
	return output;
}
