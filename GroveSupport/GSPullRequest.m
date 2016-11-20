//
//  GSPullRequest.m
//  Grove
//
//  Created by Jim Boulter on 11/7/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GSPullRequest.h"
#import "GroveSupportInternal.h"

@interface GSPullRequest ()
@property (nonatomic, readonly) NSURL* url;
@property (nonatomic, readonly) NSURL* htmlUrl;
@property (nonatomic, readonly) NSURL* diffUrl;
@property (nonatomic, readonly) NSURL* patchUrl;
@property (nonatomic, readonly) NSURL* issueUrl;
@property (nonatomic, readonly) NSURL* commitsUrl;
@property (nonatomic, readonly) NSURL* reviewCommentsUrl;
@property (nonatomic, readonly) NSURL* reviewCommentUrl;
@property (nonatomic, readonly) NSURL* commentsUrl;
@property (nonatomic, readonly) NSURL* statusesUrl;
@end

@implementation GSPullRequest

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if(self) {
		GSURLAssign(dictionary, @"url", _url);
		GSURLAssign(dictionary, @"html_url", _htmlUrl);
		GSURLAssign(dictionary, @"diff_url", _diffUrl);
		GSURLAssign(dictionary, @"patch_url", _patchUrl);
		GSURLAssign(dictionary, @"issue_url", _issueUrl);
		GSURLAssign(dictionary, @"commits_url", _commitsUrl);
		GSURLAssign(dictionary, @"review_comments_url", _reviewCommentsUrl);
		GSURLAssign(dictionary, @"review_comment_url", _reviewCommentUrl);
		GSURLAssign(dictionary, @"comments_url", _commentsUrl);
		GSURLAssign(dictionary, @"statuses_url", _statusesUrl);
		
		GSAssign(dictionary, @"number", _number);
		GSAssign(dictionary, @"state", _isOpen);
		GSAssign(dictionary, @"title", _title);
		GSAssign(dictionary, @"body", _body);
		GSAssign(dictionary, @"locked", _locked);
		
		GSObjectAssign(dictionary, @"assignee", _assignee, GSUser);
		GSObjectAssign(dictionary, @"user", _user, GSUser);
		GSObjectAssign(dictionary, @"repo", _repo, GSRepository);
		
		NSDictionary* milestoneData;
		GSAssign(dictionary, @"milestone", milestoneData);
		GSAssign(milestoneData, @"title", _milestone);
		
		NSString* strDate;
		GSAssign(dictionary, @"created_at", strDate);
		_createdAt = [self dateFromISO8601String:strDate];
		GSAssign(dictionary, @"updated_at", strDate);
		_updatedAt = [self dateFromISO8601String:strDate];
		GSAssign(dictionary, @"closed_at", strDate);
		_closedAt = [self dateFromISO8601String:strDate];
		GSAssign(dictionary, @"merged_at", strDate);
		_mergedAt = [self dateFromISO8601String:strDate];
		
		NSDictionary* headData;
		GSAssign(dictionary, @"head", headData);
		GSAssign(headData, @"name", _head)
		
		NSDictionary* baseData;
		GSAssign(dictionary, @"base", baseData);
		GSAssign(baseData, @"name", _base);
	}
	return self;
}

@end
