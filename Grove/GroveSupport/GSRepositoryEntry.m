//
//  GSRepositoryEntry.m
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSRepositoryEntry.h"
#import "GroveSupportInternal.h"

@implementation GSRepositoryEntry

- (void)_configureWithDictionary:(NSDictionary *)dictionary {
	[super _configureWithDictionary:dictionary];
	GSURLAssign(dictionary, @"download_url", _downloadURL);
	GSURLAssign(dictionary, @"git_url", _gitURL);
	GSURLAssign(dictionary, @"html_url", _browserURL);

	GSAssign(dictionary, @"name", _name);
	GSAssign(dictionary, @"path", _path);
	GSAssign(dictionary, @"size", _size);
	GSAssign(dictionary, @"sha", _shaHash);
}

@end
