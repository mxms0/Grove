//
//  GSComment.m
//  GroveSupport
//
//  Created by Max Shavrick on 8/25/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GSComment.h"
#import "GroveSupportInternal.h"

@implementation GSComment

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	if ((self = [super initWithDictionary:dictionary])) {
		GSAssign(dictionary, @"diff_hunk", _diffHunk);
		GSAssign(dictionary, @"path", _path);
		GSAssign(dictionary, @"position", _position);
		GSAssign(dictionary, @"original_position", _originalPosition);
		GSAssign(dictionary, @"commit_id", _commitIdentifier);
		GSAssign(dictionary, @"original_commit_id", _originalCommitIdentifier);
		GSAssign(dictionary, @"line", _line);
		
		GSAssign(dictionary, @"body", _body);
		GSURLAssign(dictionary, @"html_url", _browserURL);
		GSURLAssign(dictionary, @"pull_request_url", _pullRequestAPIURL);
		GSURLAssign(dictionary, @"issue_url", _issueAPIURL);
		
		GSObjectAssign(dictionary, @"user", _user, GSUser);
		
		// missing created_at, updated_at, and _links array
	}
	return self;
}

@end
