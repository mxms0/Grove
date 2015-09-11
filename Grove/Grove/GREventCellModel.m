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

@implementation GREventCellModel

- (nonnull instancetype)initWithEvent:(GSEvent *__nonnull)event {
	if ((self = [super init])) {
		self.event = event;
	}
	return self;
}

- (NSAttributedString *)eventString {
	return nil;
	NSAttributedString *message = [[NSAttributedString alloc] initWithString:@""];
	
	UIColor *blue = [UIColor colorWithRed:0.2627 green:0.4784 blue:0.7451 alpha:1.0];
	UIFont *boldFont = [UIFont boldSystemFontOfSize:18];
	UIFont *regularFont = [UIFont systemFontOfSize:18];
	NSLog(@"fdsds %@:%@", self.event.actor.username, self.event);
	
	NSAttributedString *actorString = [[NSAttributedString alloc] initWithString:self.event.actor.username attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
	NSAttributedString *branch = nil;
	NSAttributedString *a = nil;
	NSAttributedString *b = nil;
	NSAttributedString *c = nil;
	
	switch (self.event.type) {
		case GSEventTypeCreate:
			if (!self.event.payload.branch) {
				// created new repo
				branch = [[NSAttributedString alloc] initWithString:self.event.repository.name attributes:@{NSForegroundColorAttributeName: blue, NSFontAttributeName: boldFont}];
				a = [[NSAttributedString alloc] initWithString:@" created repository " attributes:@{NSFontAttributeName:regularFont}];
				message = [NSAttributedString attributedStringWithAttributedStrings:@[actorString, a, branch]];
			}
			else {
				branch = [[NSAttributedString alloc] initWithString:self.event.payload.branch attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
				a = [[NSAttributedString alloc] initWithString:@" created branch " attributes:@{NSFontAttributeName:regularFont}];
				message = [NSAttributedString attributedStringWithAttributedStrings:@[actorString, a, branch]];
			}
			break;
		case GSEventTypeFork:
			break;
		case GSEventTypeWatch:
			break;
		case GSEventTypeCommitComment:
			branch = [[NSAttributedString alloc] initWithString:self.event.repository.name attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
			c = [[NSAttributedString alloc] initWithString:self.event.repository.name attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
			a = [[NSAttributedString alloc] initWithString:@" commented on commit " attributes:@{NSFontAttributeName:regularFont}];
			b = [[NSAttributedString alloc] initWithString:@" in " attributes:@{NSFontAttributeName:regularFont}];
			message = [NSAttributedString attributedStringWithAttributedStrings:@[actorString, a, branch]];
			break;
		case GSEventTypePush:
			branch = [[NSAttributedString alloc] initWithString:self.event.payload.branch attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
			a = [[NSAttributedString alloc] initWithString:@" pushed to " attributes:@{NSFontAttributeName:regularFont}];
			message = [NSAttributedString attributedStringWithAttributedStrings:@[actorString, a, branch]];
			break;
		case GSEventTypeUnknown:
			break;
			
		default:
			break;
	}
	
	return message;
}

- (UIImage *)imageIcon {
	UIImage *image = nil;
	
	switch (self.event.type) {
		case GSEventTypeCreate:
			image = [UIImage imageNamed:@"Create"];
			break;
		case GSEventTypeFork:
			break;
		case GSEventTypeWatch:
			break;
		case GSEventTypeCommitComment:
			break;
		case GSEventTypePush:
			image = [UIImage imageNamed:@"Push"];
			break;
		case GSEventTypeUnknown:
			break;
			
		default:
			break;
	}
	
	return image;
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
