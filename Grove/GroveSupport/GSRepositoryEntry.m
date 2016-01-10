//
//  GSRepositoryEntry.m
//  GroveSupport
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright (c) 2016 Milo. All rights reserved.
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
	
	NSString *type = nil;
	GSAssign(dictionary, @"type", type);
	_type= [self _entryTypeForString:type];
	
	if (!_name) {
		_name = [_path lastPathComponent];
	}
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; Name = %@; Path = %@;>", NSStringFromClass([self class]), self, _name, _path];
}

- (GSRepositoryEntryType)_entryTypeForString:(NSString *)str {
	NSDictionary *const fileTypeMap = @{
										@"file":		@(GSRepositoryEntryTypeFile),
										@"symlink":		@(GSRepositoryEntryTypeSymlink),
										@"dir":			@(GSRepositoryEntryTypeDirectory),
										@"submodule":	@(GSRepositoryEntryTypeSubmodule),
										@"blob":		@(GSRepositoryEntryTypeFile),
										@"tree":		@(GSRepositoryEntryTypeDirectory),
										@"commit":		@(GSRepositoryEntryTypeSubmodule),
										};
	
	return (GSRepositoryEntryType)(fileTypeMap[str] ? [fileTypeMap[str] intValue] : GSRepositoryEntryTypeUnknown);
}

@end
