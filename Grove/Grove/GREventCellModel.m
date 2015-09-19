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
	NSAttributedString *message = [[NSAttributedString alloc] initWithString:@""];
	
	UIColor *blue = [UIColor colorWithRed:0.2627 green:0.4784 blue:0.7451 alpha:1.0];
	UIFont *boldFont = [UIFont boldSystemFontOfSize:18];
	UIFont *regularFont = [UIFont systemFontOfSize:18];
	NSLog(@"fdsds %@:%@", self.event.actor.username, self.event);
	
	NSAttributedString *actorString = [[NSAttributedString alloc] initWithString:self.event.actor.username attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
	
	switch (self.event.type) {
		case GSEventTypeCommitComment:
		case GSEventTypeCreate:
		case GSEventTypeDelete:
		case GSEventTypeDeployment:
		case GSEventTypeDeploymentStatus:
		case GSEventTypeDownload:
		case GSEventTypeFollow:
		case GSEventTypeFork:
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
		case GSEventTypePush:
		case GSEventTypeRelease:
		case GSEventTypeRepository:
		case GSEventTypeStatus:
		case GSEventTypeTeamAdd:
		case GSEventTypeWatch:
		case GSEventTypeUnknown:
			break;	
	}
	return message;
}

- (UIImage *)imageIcon {
	NSString *imageName = nil;


	
	switch (self.event.type) {
		case GSEventTypeCreate:
			imageName = @"Create";
			break;
		case GSEventTypeFork:
			break;
		case GSEventTypeWatch:
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
