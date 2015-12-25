//
//  GREventCellModel.m
//  Grove
//
//  Created by Max Shavrick on 9/10/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GREventCellModel.h"
#import "GSEvent.h"
#import "NSAttributedString+GRExtensions.h"

@implementation GREventCellModel {
	NSAttributedString *attributedMessage;
}

- (nonnull instancetype)initWithEvent:(GSEvent *__nonnull)event {
	if ((self = [super init])) {
		self.event = event;
	}
	return self;
}

- (NSAttributedString *)eventString {
	@synchronized(self) {
		if (!attributedMessage) {
			attributedMessage = [self _generatedEventString];
		}
	}
	return attributedMessage;
}

- (NSAttributedString *)_generatedEventString {
	
//	UIColor *blue = [UIColor colorWithRed:0.2627 green:0.4784 blue:0.7451 alpha:1.0];
//	UIFont *boldFont = [UIFont boldSystemFontOfSize:18];
	UIFont *regularFont = [UIFont systemFontOfSize:18];
	
	NSMutableArray *components = [[NSMutableArray alloc] init];
	
	// clean up this mess, soon.
	// getting all the logic down and finding out what data gets used is fine for now
	
	switch (self.event.type) {
		case GSEventTypeFork: {
			NSAttributedString *user = [[NSAttributedString alloc] initWithString:self.event.actor.username attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@" forked " attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *cp1 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
			[components addObjectsFromArray:@[user, message, cp1]];
			break;
		}
		case GSEventTypeCommitComment:
		case GSEventTypeCreate:{
		
			break;
		}
		case GSEventTypeDelete: {
			NSAttributedString *user = [[NSAttributedString alloc] initWithString:self.event.actor.username attributes:nil];
			NSAttributedString *msg = [[NSAttributedString alloc] initWithString:@" deleted " attributes:nil];
			NSAttributedString *target1 = [[NSAttributedString alloc] initWithString:self.event.payload.branch attributes:nil];
			NSAttributedString *thing = [[NSAttributedString alloc] initWithString:@" at " attributes:nil];
			NSAttributedString *target2 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:nil];
			
			[components addObjectsFromArray:@[user, msg, target1, thing, target2]];
			
			break;
		}
		case GSEventTypeDeployment:
		case GSEventTypeDeploymentStatus:
		case GSEventTypeDownload:
		case GSEventTypeFollow:
		case GSEventTypeForkApply:
		case GSEventTypeGistEvent:
		case GSEventTypeGollumEvent:
		case GSEventTypeIssueComment:
		case GSEventTypeIssues:
		case GSEventTypeMember:
		case GSEventTypeMembership:
		case GSEventTypePageBuild:
		case GSEventTypePublic:
		case GSEventTypePullRequest:
		case GSEventTypePullRequestReviewComment:
			break;
		case GSEventTypePush: {
			NSAttributedString *user = [[NSAttributedString alloc] initWithString:self.event.actor.username attributes:@{NSFontAttributeName: regularFont}];
			NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@" pushed to " attributes:@{NSFontAttributeName: regularFont}];
			NSAttributedString *branch = [[NSAttributedString alloc] initWithString:self.event.payload.ref attributes:@{NSFontAttributeName : regularFont}];
			[components addObjectsFromArray:@[user, verb, branch]];
		}
		case GSEventTypeRelease:
		case GSEventTypeRepository:
		case GSEventTypeStatus:
		case GSEventTypeTeamAdd:
			
			break;
		case GSEventTypeStar: {
			// watch = star, cool
			// https://developer.github.com/changes/2012-9-5-watcher-api/
			NSAttributedString *user = [[NSAttributedString alloc] initWithString:self.event.actor.username attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@" starred " attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *repository = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
			[components addObjectsFromArray:@[user, message, repository]];
			break;
		}
		case GSEventTypeUnknown:
			break;
	}
	
	NSAttributedString *string = [NSAttributedString attributedStringWithAttributedStrings:components];
	
	return string;
}

- (UIImage *)imageIcon {
	NSString *imageName = nil;
	
	switch (self.event.type) {
		case GSEventTypeCreate:
			imageName = @"Create";
			break;
		case GSEventTypeFork:
			break;
		case GSEventTypeStar:
			break;
		case GSEventTypeCommitComment:
			break;
		case GSEventTypePush:
			imageName = @"Push";
			break;
		case GSEventTypeUnknown:
			break;
			
		default:
			break;
	}
	if (!imageName) return nil;
	return [UIImage imageNamed:imageName];
}


#pragma mark - Parsers

- (NSString *)dateStringFromEvent {
	unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
	NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:self.event.createdDate toDate:[NSDate date] options:0];
	
	NSInteger months = [conversionInfo month];
	NSInteger days = [conversionInfo day];
	NSInteger hours = [conversionInfo hour];
	NSInteger minutes = [conversionInfo minute];
	
	NSString *dateString = nil;
	if (months > 0) {
		if (months == 1) {
			dateString = @"1 Month";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Months", (long)months];
		}
	}
	else if (days > 0) {
		if (days == 1) {
			dateString = @"1 Day";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Days", (long)days];
		}
	}
	else if (hours > 0) {
		if (hours == 1) {
			dateString = @"1 Hour";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Hours", (long)hours];
		}
	}
	else if (minutes > 0) {
		if (minutes == 1) {
			dateString = @"1 Minute";
		}
		else {
			dateString = [NSString stringWithFormat:@"%li Minutes", (long)minutes];
		}
	}
	
	return dateString;
}

@end
