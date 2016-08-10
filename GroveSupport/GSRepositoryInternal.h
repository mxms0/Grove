//
//  GSRepositoryInternal.h
//  GroveSupport
//
//  Created by Max Shavrick on 8/20/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef Grove_GSRepositoryInternal_h
#define Grove_GSRepositoryInternal_h

@interface GSRepository ()
@property (nonatomic, strong) NSURL *forksAPIURL;
@property (nonatomic, strong) NSURL *keysAPIURL;
@property (nonatomic, strong) NSURL *collaboratorsAPIURL;
@property (nonatomic, strong) NSURL *teamsAPIURL;
@property (nonatomic, strong) NSURL *hooksAPIURL;
@property (nonatomic, strong) NSURL *issueEventsAPIURL;
@property (nonatomic, strong) NSURL *eventsAPIURL;
@property (nonatomic, strong) NSURL *assigneesAPIURL;
@property (nonatomic, strong) NSURL *branchesAPIURL;
@property (nonatomic, strong) NSURL *tagsAPIURL;
@property (nonatomic, strong) NSURL *blobsAPIURL;
@property (nonatomic, strong) NSURL *gitTagsAPIURL;
@property (nonatomic, strong) NSURL *gitRefsAPIURL;
@property (nonatomic, strong) NSURL *treesAPIURL;
@property (nonatomic, strong) NSURL *statusesAPIURL;
@property (nonatomic, strong) NSURL *languagesAPIURL;
@property (nonatomic, strong) NSURL *stargazersAPIURL;
@property (nonatomic, strong) NSURL *contributorsAPIURL;
@property (nonatomic, strong) NSURL *subscribersAPIURL;
@property (nonatomic, strong) NSURL *subscriptionAPIURL;
@property (nonatomic, strong) NSURL *commitsAPIURL;
@property (nonatomic, strong) NSURL *gitCommitsAPIURL;
@property (nonatomic, strong) NSURL *commentsAPIURL;
@property (nonatomic, strong) NSURL *issueCommentAPIURL;
@property (nonatomic, strong) NSURL *contentsAPIURL;
@property (nonatomic, strong) NSURL *compareAPIURL;
@property (nonatomic, strong) NSURL *mergesAPIURL;
@property (nonatomic, strong) NSURL *archiveAPIURL;
@property (nonatomic, strong) NSURL *downloadsAPIURL;
@property (nonatomic, strong) NSURL *issuesAPIURL;
@property (nonatomic, strong) NSURL *pullsAPIURL;
@property (nonatomic, strong) NSURL *milestonesAPIURL;
@property (nonatomic, strong) NSURL *notificationsAPIURL;
@property (nonatomic, strong) NSURL *labelsAPIURL;
@property (nonatomic, strong) NSURL *releasesAPIURL;

@end

#endif
