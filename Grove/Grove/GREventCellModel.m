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
#import "GRStreamEventCell.h"

// This class needs to be adapted to work without actual GSEvent, for NSCoding purposes.

@implementation GREventCellModel {
	NSAttributedString *attributedMessage;
	UIImage *avatar;
	BOOL frameDirty;
	CGFloat cachedCellHeight;
}

- (nonnull instancetype)initWithEvent:(GSEvent *__nonnull)event {
	if ((self = [super init])) {
		
		frameDirty = YES;
		self.event = event;
		CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
		self.cellSize = CGSizeMake(screenWidth, 0);
		
		[[GSCacheManager sharedInstance] findAvatarForActor:self.event.actor downloadIfNecessary:YES completionHandler:^(UIImage *image, NSError *error) {
			avatar = image;
			dispatch_async(dispatch_get_main_queue(), ^ {
				[self.tableCell setAvatar:avatar];
			});
		}];
	}
	return self;
}

- (NSString *)username {
	return [@"@" stringByAppendingString:self.event.actor.username];
}

- (UIImage *)imageIcon {
	return avatar;
}

- (void)setCellSize:(CGSize)cellSize {
	if (CGSizeEqualToSize(self.cellSize, cellSize)) return;
	frameDirty = YES;
	_cellSize = cellSize;
}

- (CGFloat)requiredTableCellHeight {
	if (frameDirty && (self.fontSize != 0)) {
		
		CGFloat leftOffsetUsed = 0.0f;
		CGFloat verticalOffsetUsed = 0.0f;
		
		leftOffsetUsed += GRGenericHorizontalPadding;
		
		const CGFloat avatarSize = 38.0f;
		
		// image
		
		leftOffsetUsed += avatarSize;
		
		leftOffsetUsed += GRGenericHorizontalPadding;
		
		verticalOffsetUsed += GRGenericVerticalPadding;
		
		// username label
		
		verticalOffsetUsed += (self.fontSize);
		
		verticalOffsetUsed += floorf(GRGenericVerticalPadding / 2);
		
		CGSize textSize = [[self _generatedEventString] boundingRectWithSize:CGSizeMake(self.cellSize.width - (leftOffsetUsed + GRGenericHorizontalPadding), CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:NULL].size;
		
		
		CGFloat properHeight = MIN(textSize.height, self.fontSize * 3);
		
		cachedCellHeight = verticalOffsetUsed + properHeight + GRGenericVerticalPadding;
		
		CGFloat minimumCellHeight = self.avatarSize.height + 2 * GRGenericVerticalPadding;
		
		cachedCellHeight = MAX(minimumCellHeight, cachedCellHeight);
		
		frameDirty = NO;
	}
	
	return cachedCellHeight;
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
	@try {
	switch (self.event.type) {
		case GSEventTypeFork: {
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"🍴 Forked " attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *cp1 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
			[components addObjectsFromArray:@[message, cp1]];
			break;
		}
		case GSEventTypeCommitComment:
			break;
		case GSEventTypeCreate:{
			NSAttributedString *verb = nil;
			NSAttributedString *subject = nil;
			// Could be created repository, unsure what other "created" events there are.
			
			switch ([self.event refType]) {
				case GSEventRefTypeBranch:
					verb = [[NSAttributedString alloc] initWithString:@"💡 Created branch " attributes:@{NSFontAttributeName: regularFont}];
					subject = [[NSAttributedString alloc] initWithString:self.event.ref attributes:@{NSFontAttributeName: regularFont}];
					break;
				case GSEventRefTypeRepository:
					verb = [[NSAttributedString alloc] initWithString:@"💡 Created repository " attributes:@{NSFontAttributeName: regularFont}];
					subject = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
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
			NSAttributedString *msg = [[NSAttributedString alloc] initWithString:@"💔 Deleted " attributes:@{NSFontAttributeName: regularFont}];
			NSAttributedString *target1 = nil;
			NSAttributedString *thing = [[NSAttributedString alloc] initWithString:@" at " attributes:@{NSFontAttributeName: regularFont}];
			NSAttributedString *target2 = nil;
			
			switch ([[self event] refType]) {
				case GSEventRefTypeBranch:
					target1 = [[NSAttributedString alloc] initWithString:self.event.ref attributes:@{NSFontAttributeName: regularFont}];
					target2 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
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
			break;
		case GSEventTypeMember: {
			NSAttributedString *verb = nil;
			NSAttributedString *person = [[NSAttributedString alloc] initWithString:self.event.member.username attributes:@{NSFontAttributeName: regularFont}];
			NSAttributedString *prep = nil;
			NSAttributedString *destination = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
			switch ([self.event action]) {
				case GSEventActionAdded:
					verb = [[NSAttributedString alloc] initWithString:@"Added " attributes:@{NSFontAttributeName: regularFont}];
					prep = [[NSAttributedString alloc] initWithString:@" to " attributes:@{NSFontAttributeName: regularFont}];
					break;
				default:
					NSLog(@"Unhandled member-type event. %@", self.event);
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
			NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"👞 Pushed to " attributes:@{NSFontAttributeName: regularFont}];
			NSAttributedString *branch = [[NSAttributedString alloc] initWithString:self.event.ref attributes:@{NSFontAttributeName : regularFont}];
			[components addObjectsFromArray:@[verb, branch]];
			break;
		}
		case GSEventTypeRelease:
		case GSEventTypeRepository:
		case GSEventTypeStatus:
		case GSEventTypeTeamAdd:
			
			break;
		case GSEventTypeStar: {
			// watch = star, cool
			// https://developer.github.com/changes/2012-9-5-watcher-api/
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"⭐️ Starred " attributes:@{NSFontAttributeName : regularFont}];
			NSAttributedString *repository = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:@{NSFontAttributeName: regularFont}];
			[components addObjectsFromArray:@[message, repository]];
			break;
		}
		case GSEventTypeUnknown:
			break;
	}
	}
	@catch(id e) {
		NSLog(@"exc[%@] evt[%@]", e, self.event);
		abort();
	}
	
	NSAttributedString *string = [NSAttributedString attributedStringWithAttributedStrings:components];
	
	return string;
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
