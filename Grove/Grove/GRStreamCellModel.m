//
//  GREventCellModel.m
//  Grove
//
//  Created by Max Shavrick on 9/10/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRStreamCellModel.h"
#import "GSEvent.h"
#import "NSAttributedString+GRExtensions.h"
#import "GRStreamEventCell.h"

static NSString *const GRStreamCellModelStorageAttributedStringKey = @"AttributedString";
static NSString *const GRStreamCellModelStorageAvatarKey = @"AvatarImage";
static NSString *const GRStreamCellModelStorageCellHeightKey = @"CellHeight";
static NSString *const GRStreamCellModelStorageUsernameKey = @"Username";
static NSString *const GRStreamCellModelStorageCreatedDateKey = @"CreatedDate";
// This class needs to be adapted to work without actual GSEvent, for NSCoding purposes.

@implementation GRStreamCellModel {
	NSAttributedString *attributedMessage;
	NSString *cachedUsername;
	UIImage *avatar;
	BOOL frameDirty;
	CGFloat cachedCellHeight;
	NSDate *createdDate;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		// This is borked when you try to tap on these events, since they contain no event types
		// Consider copying everything over, or putting encodings in GroveSupport
		// should probably cache more information about the event
		if ([aDecoder containsValueForKey:GRStreamCellModelStorageAttributedStringKey]) {
			attributedMessage = [aDecoder decodeObjectForKey:GRStreamCellModelStorageAttributedStringKey];
		}
		if ([aDecoder containsValueForKey:GRStreamCellModelStorageAvatarKey]) {
			avatar = [aDecoder decodeObjectForKey:GRStreamCellModelStorageAvatarKey];
		}
		if ([aDecoder containsValueForKey:GRStreamCellModelStorageCellHeightKey]) {
			cachedCellHeight = [aDecoder decodeFloatForKey:GRStreamCellModelStorageCellHeightKey];
		}
		if ([aDecoder containsValueForKey:GRStreamCellModelStorageUsernameKey]) {
			cachedUsername = [aDecoder decodeObjectForKey:GRStreamCellModelStorageUsernameKey];
		}
		if ([aDecoder containsValueForKey:GRStreamCellModelStorageCreatedDateKey]) {
			createdDate = [aDecoder decodeObjectForKey:GRStreamCellModelStorageCreatedDateKey];
		}
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:attributedMessage forKey:GRStreamCellModelStorageAttributedStringKey];
	[aCoder encodeObject:avatar forKey:GRStreamCellModelStorageAvatarKey];
	[aCoder encodeObject:cachedUsername forKey:GRStreamCellModelStorageUsernameKey];
	[aCoder encodeObject:createdDate forKey:GRStreamCellModelStorageCreatedDateKey];
	[aCoder encodeFloat:cachedCellHeight forKey:GRStreamCellModelStorageCellHeightKey];
}

- (nonnull instancetype)initWithEvent:(GSEvent *__nonnull)event {
	if ((self = [super init])) {
		
		frameDirty = YES;
		self.event = event;
		
		CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
		self.cellSize = CGSizeMake(screenWidth, 0);
		
		cachedUsername = event.actor.username;
		createdDate = self.event.createdDate;
		
		[[GSCacheManager sharedInstance] findAvatarForActor:self.event.actor downloadIfNecessary:YES completionHandler:^(UIImage *image, NSError *error) {
			avatar = image;
			dispatch_async(dispatch_get_main_queue(), ^ {
				[self.tableCell setAvatar:avatar];
			});
		}];
	}
	return self;
}

- (void)setTableCell:(GRStreamEventCell *)tableCell {
	_tableCell = tableCell;
	[tableCell setAvatar:avatar];
}

- (NSString *)username {
	return cachedUsername;
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
		
		CGSize textSize = [[self eventString] boundingRectWithSize:CGSizeMake(self.cellSize.width - (leftOffsetUsed + GRGenericHorizontalPadding), CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:NULL].size;
		
		
		CGFloat properHeight = MIN(textSize.height, self.fontSize * 3);
		
		cachedCellHeight = verticalOffsetUsed + properHeight + GRGenericVerticalPadding;
		
		CGFloat minimumCellHeight = self.avatarSize.height + 2 * GRGenericVerticalPadding;
		
		cachedCellHeight = MAX(minimumCellHeight, cachedCellHeight);
		
		cachedCellHeight = ceilf(cachedCellHeight);
		
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
	
	NSDictionary *defaultAttributes = @{NSFontAttributeName : regularFont};
	
	// clean up this mess, soon.
	// getting all the logic down and finding out what data gets used is fine for now
	@try {
	switch (self.event.type) {
		case GSEventTypeFork: {
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"🍴 Forked " attributes:defaultAttributes];
			NSAttributedString *cp1 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:defaultAttributes];
			[components addObjectsFromArray:@[message, cp1]];
			break;
		}
		case GSEventTypeCommitComment: {
			NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"✏️ Commented on Commit " attributes:defaultAttributes];
			NSString *destinationString = self.event.repository.pathString;
			NSString *commitHash = self.event.comment.commitIdentifier;
			if (commitHash && [commitHash length] >= 10) {
				commitHash = [commitHash substringToIndex:10];
				destinationString = [destinationString stringByAppendingFormat:@"@%@", commitHash];
			}
			NSAttributedString *dest = [[NSAttributedString alloc] initWithString:destinationString attributes:defaultAttributes];
			[components addObjectsFromArray:@[verb, dest]];
			
			break;
		}
		case GSEventTypeCreate:{
			NSAttributedString *verb = nil;
			NSAttributedString *subject = nil;
			// Could be created repository, unsure what other "created" events there are.
			
			switch ([self.event refType]) {
				case GSEventRefTypeBranch:
					verb = [[NSAttributedString alloc] initWithString:@"💡 Created branch " attributes:defaultAttributes];
					subject = [[NSAttributedString alloc] initWithString:self.event.ref attributes:defaultAttributes];
					break;
				case GSEventRefTypeRepository:
					verb = [[NSAttributedString alloc] initWithString:@"💡 Created repository " attributes:defaultAttributes];
					subject = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:defaultAttributes];
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
			NSAttributedString *msg = [[NSAttributedString alloc] initWithString:@"💔 Deleted " attributes:defaultAttributes];
			NSAttributedString *target1 = nil;
			NSAttributedString *thing = [[NSAttributedString alloc] initWithString:@" at " attributes:defaultAttributes];
			NSAttributedString *target2 = nil;
			
			switch ([[self event] refType]) {
				case GSEventRefTypeBranch:
					target1 = [[NSAttributedString alloc] initWithString:self.event.ref attributes:defaultAttributes];
					target2 = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:defaultAttributes];
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
			NSAttributedString *person = [[NSAttributedString alloc] initWithString:self.event.member.username attributes:defaultAttributes];
			NSAttributedString *prep = nil;
			NSAttributedString *destination = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:defaultAttributes];
			switch ([self.event action]) {
				case GSEventActionAdded:
					verb = [[NSAttributedString alloc] initWithString:@"💌 Added to " attributes:defaultAttributes];
					prep = [[NSAttributedString alloc] initWithString:@" to " attributes:defaultAttributes];
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
			break;
		case GSEventTypePublic: {
			NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"😎 Made " attributes:defaultAttributes];
			NSAttributedString *target = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:defaultAttributes];
			// right now I'm confident no notification gets pushed to users if someone makes a repo private.. so
			if (!self.event.publicallyAvailable) {
				NSLog(@"THIS EVENT IS BEHAVING STRANGELY. %@", self.event);
			}
			NSAttributedString *destination = [[NSAttributedString alloc] initWithString:@" public" attributes:defaultAttributes];
			[components addObjectsFromArray:@[verb, target, destination]];
			break;
		}
		case GSEventTypePullRequest:
		case GSEventTypePullRequestReviewComment:
			break;
		case GSEventTypePush: {
			NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"👞 Pushed to " attributes:defaultAttributes];
			NSAttributedString *branch = [[NSAttributedString alloc] initWithString:self.event.ref attributes:defaultAttributes];
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
			NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"⭐️ Starred " attributes:defaultAttributes];
			NSAttributedString *repository = [[NSAttributedString alloc] initWithString:self.event.repository.pathString attributes:defaultAttributes];
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

- (NSUInteger)hash {
	return [[self username] hash] ^ (int)[createdDate timeIntervalSince1970];
	// this is probably a very bad hashing algorithm
}

- (BOOL)isEqual:(id)object {
	if (self == object) return YES;
	
	if ([object isKindOfClass:[object class]]) {
		return NO;
	}
	
	if (![[object username] isEqualToString:[self username]]) {
		return NO;
	}
	
	// need one more check here..
	// otherwise not very valid
	
	return YES;
}

#pragma mark - Parsers

- (NSString *)dateStringFromEvent {
	return GRRelativeDateStringFromDate(createdDate);
}

@end
