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
	UIImage *avatar;
}

- (nonnull instancetype)initWithEvent:(GSEvent *__nonnull)event {
	if ((self = [super init])) {
		self.event = event;
		
		[[GSCacheManager sharedInstance] findImageAssetWithURL:self.event.actor.avatarURL loggedInUser:nil downloadIfNecessary:YES completionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
			avatar = image;
		}];
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
	UIFont *regularFont = [UIFont systemFontOfSize:13];
	
	NSMutableArray *components = [[NSMutableArray alloc] init];
	
	// clean up this mess, soon.
	// getting all the logic down and finding out what data gets used is fine for now
	
	switch (self.event.type) {
		case GSEventTypeFork: {
			NSAttributedString *user = [[NSAttributedString alloc] initWithString:self.event.actor.username attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"Forked " attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *cp1 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
			[components addObjectsFromArray:@[user, message, cp1]];
			break;
		}
		case GSEventTypeCommitComment:
		case GSEventTypeCreate:{
			NSAttributedString *verb = nil;
			NSAttributedString *subject = nil;
			// Could be created repository, unsure what other "created" events there are.
			
			switch ([self.event refType]) {
				case GSEventRefTypeBranch:
					verb = [[NSAttributedString alloc] initWithString:@"Created branch " attributes:nil];
					subject = [[NSAttributedString alloc] initWithString:self.event.ref attributes:nil];
					break;
				case GSEventRefTypeRepository:
					verb = [[NSAttributedString alloc] initWithString:@"Created repository " attributes:nil];
					subject = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:nil];
					break;
				case GSEventRefTypeTag:
				case GSEventRefTypeUnknown:
				default:
					GSAssert();
					break;
			}
			
			[components addObjectsFromArray:@[verb, subject]];

			break;
		}
		case GSEventTypeDelete: {
			NSAttributedString *msg = [[NSAttributedString alloc] initWithString:@"Deleted " attributes:nil];
			NSAttributedString *target1 = nil;
			NSAttributedString *thing = [[NSAttributedString alloc] initWithString:@" at " attributes:nil];
			NSAttributedString *target2 = nil;
			
			switch ([[self event] refType]) {
				case GSEventRefTypeBranch:
					target1 = [[NSAttributedString alloc] initWithString:self.event.ref attributes:nil];
					target2 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:nil];
					break;
				case GSEventRefTypeTag:
				case GSEventRefTypeRepository:
					// Inconsistent with the API. "The object that was deleted. Can be "branch" or "tag"."
				case GSEventRefTypeUnknown:
				default:
					GSAssert();
					break;
			}
			
			[components addObjectsFromArray:@[msg, target1, thing, target2]];
			
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
		case GSEventTypeMember: {
			NSAttributedString *verb = nil;
			NSAttributedString *person = [[NSAttributedString alloc] initWithString:@"<person>" attributes:nil];
			NSAttributedString *prep = nil;
			NSAttributedString *destination = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:nil];
			switch ([self.event action]) {
				case GSEventActionAdded:
					verb = [[NSAttributedString alloc] initWithString:@"Added " attributes:nil];
					prep = [[NSAttributedString alloc] initWithString:@" to " attributes:nil];
					break;
				default:
					NSLog(@"Unhandled member-type event.");
					GSAssert();
					break;
			}
			[components addObjectsFromArray:@[verb, person, prep, destination]];
			break;
		}
		case GSEventTypeMembership:
		case GSEventTypePageBuild:
		case GSEventTypePublic:
		case GSEventTypePullRequest:
		case GSEventTypePullRequestReviewComment:
			break;
		case GSEventTypePush: {
			NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"Pushed to " attributes:@{NSFontAttributeName: regularFont}];
			NSAttributedString *branch = [[NSAttributedString alloc] initWithString:self.event.ref attributes:@{NSFontAttributeName : regularFont}];
			[components addObjectsFromArray:@[verb, branch]];
		}
		case GSEventTypeRelease:
		case GSEventTypeRepository:
		case GSEventTypeStatus:
		case GSEventTypeTeamAdd:
			
			break;
		case GSEventTypeStar: {
			// watch = star, cool
			// https://developer.github.com/changes/2012-9-5-watcher-api/
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"Starred " attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *repository = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
			[components addObjectsFromArray:@[message, repository]];
			break;
		}
		case GSEventTypeUnknown:
			break;
	}
	
	NSAttributedString *string = [NSAttributedString attributedStringWithAttributedStrings:components];
	
	return string;
}

- (NSString *)username {
	return [@"@" stringByAppendingString:self.event.actor.username];
}

- (UIImage *)imageIcon {
	return avatar;
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
