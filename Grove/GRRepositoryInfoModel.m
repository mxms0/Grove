//
//  GRRepositoryInfoModel.m
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryInfoModel.h"

#import <GroveSupport/GSRepository.h>
#import <GroveSupport/GSRepositoryGitHubEngine.h>
#include <objc/message.h>

/*
 {Private/Public}
 {is a fork}
 Description
 Watchers
 Stars
 Forks
 (UpdatedDate|Last Push)?
 CreatedDate?
 HomePage
 */

@implementation GRRepositoryInfoModel {
	GSRepository *repository;
	NSArray *sectionsAvailable;
	NSString *readMeString;
	__weak GRRepositoryReadMeCell *_readMeCell;
}
@dynamic delegate;

- (instancetype)initWithRepository:(GSRepository *)repo {
	if ((self = [super init])) {
		repository = repo;
		if ([repo isFull]) {
			[self reloadView];
		}
		else {
			[repo updateWithCompletionHandler:^(NSError * _Nullable error) {
				if (error) GSAssert();
				[self reloadView];
			}];
		}
		
		[[GSGitHubEngine sharedInstance] readmeForRepository:repo completionHandler:^(NSString * _Nullable contents, NSError * _Nullable error) {
			if (error) {
				switch (error.code) {
					case 404:
						break;
					default:
						NSLog(@"May need to try again. For readme");
						break;
				}
			}
			else {
				[self receivedReadMeString:contents];

			}
		}];
	}
	return self;
}

- (void)receivedReadMeString:(NSString *)readme {
	readMeString = readme;
	
	CGSize size = [readme boundingRectWithSize:CGSizeMake([self.delegate allottedWidthForReadMeLabel], CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
	

	
	dispatch_async(dispatch_get_main_queue(), ^ {
		NSLog(@"5ff %@", NSStringFromCGSize(size));
		[self.delegate setReadmeCellHeight:size.height];
		if (self.readMeCell) {
			[self.readMeCell setReadMeString:readMeString];
			// set contents
		}
	});
}

- (NSString *)repositoryDescription {
	return repository.userDescription ? repository.userDescription : @"No description provided";
}

- (void)reloadView {
	NSArray *defaultFormat = @[
							   @{ @"localizationKey" : @"description", @"selector" : @"userDescription", @"type" : @"@" },
							   @{ @"localizationKey" : @"website", @"selector" : @"browserHomepageURL", @"type" : @"@" },
							   @{ @"localizationKey" : @"wiki", @"selector" : @"wikiAvailable", @"type" : @"C"},
							   @{ @"localizationKey" : @"downloads", @"selector": @"downloadsAvailable", @"type": @"C" },
							   ];
	
	NSMutableArray *sections = [[NSMutableArray alloc] init];
	
	for (NSDictionary *row in defaultFormat) {
		const char *type = [row[@"type"] UTF8String];
		SEL cmd = sel_registerName([row[@"selector"] UTF8String]);
		BOOL include = NO;
		switch (type[0]) {
			case '@': { // objc_object
				id ret = ((id (*)(id, SEL))objc_msgSend)(repository, cmd);
				if (ret) include = YES;
				break;
			}
			case 'C': { // BOOL
				BOOL ret = ((BOOL (*)(id, SEL))objc_msgSend)(repository, cmd);
				if (ret) include = YES;
				break;
			}
			case 'l': { // NSInteger
				NSInteger ret = ((NSInteger (*)(id, SEL))objc_msgSend)(repository, cmd);
				if (ret) include = YES;
				break;
			}
			default: {
				NSLog(@"what type is this %@", row);
			}
		}
		if (include) {
			[sections addObject:row];
		}
	}
	[self.delegate reloadView];
}

- (void)setReadMeCell:(GRRepositoryReadMeCell *)readMeCell_ {
	_readMeCell = readMeCell_;
	[_readMeCell setReadMeString:readMeString];
}

- (NSUInteger)numberOfSections {
	return 2;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
//	return [sectionsAvailable count];
	return 1;
}

- (NSString *)sectionLabelForSection:(NSUInteger)section {
	NSString *label = nil;
	switch (section) {
		case 0:
			label = GRLocalizedString(@"description", nil, nil);
			break;
		case 1:
			label = GRLocalizedString(@"readme", nil, nil);
			break;
	}
	return [label uppercaseString];
}

@end
