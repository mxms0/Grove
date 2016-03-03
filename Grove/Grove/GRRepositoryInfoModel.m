//
//  GRRepositoryInfoModel.m
//  Grove
//
//  Created by Max Shavrick on 1/16/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryInfoModel.h"

#import <GroveSupport/GSRepository.h>
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
}

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
	}
	return self;
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
}

- (NSUInteger)numberOfSections {
	return 1;
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section {
	return 4;
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
