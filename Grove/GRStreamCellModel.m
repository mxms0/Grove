//
//  GREventCellModel.m
//  Grove
//
//  Created by Max Shavrick on 9/10/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRStreamCellModel.h"
#import "GSEvent.h"
#import "GRStreamEventCell.h"

static NSString *const GRStreamCellModelStorageAttributedStringKey = @"AttributedString";
static NSString *const GRStreamCellModelStorageAvatarKey = @"AvatarImage";
static NSString *const GRStreamCellModelStorageCellHeightKey = @"CellHeight";
static NSString *const GRStreamCellModelStorageUsernameKey = @"Username";
static NSString *const GRStreamCellModelStorageCreatedDateKey = @"CreatedDate";

NSAttributedString *GRFormattedMessageWithEvent(GSEvent *event, BOOL *requiresSubCell, NSString **subCellText);
// This class needs to be adapted to work without actual GSEvent, for NSCoding purposes.

@implementation GRStreamCellModel {
	NSAttributedString *attributedMessage;
	NSString *cachedUsername;
	NSString *cachedSubCellText;
	UIImage *avatar;

	NSDate *createdDate;

	BOOL frameDirty;
	BOOL requiresSubCell;
	CGFloat cachedCellHeight;
	CGFloat safeTextHeight;
	CGFloat subCellHeight;
	
	
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super init])) {
		// This is borked when you try to tap on these events, since they contain no event types
		// Consider copying everything over, or putting encodings in GroveSupport
		// should probably cache more information about the event
		if ([aDecoder containsValueForKey:GRStreamCellModelStorageAttributedStringKey]) {
			attributedMessage = [aDecoder decodeObjectForKey:GRStreamCellModelStorageAttributedStringKey];
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
//		
//		[[GSGitHubEngine sharedInstance] userForUsername:cachedUsername completionHandler:^(GSUser * _Nullable user, NSError * _Nullable error) {
//			if (user) {
//				[[GSCacheManager sharedInstance] findAvatarForActor:user downloadIfNecessary:YES completionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
//					if (image)
//						avatar = image;
//					
//					[self.tableCell setAvatar:image];
//				}];
//			}
//		}];
//		
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:attributedMessage forKey:GRStreamCellModelStorageAttributedStringKey];
	[aCoder encodeObject:cachedUsername forKey:GRStreamCellModelStorageUsernameKey];
	[aCoder encodeObject:createdDate forKey:GRStreamCellModelStorageCreatedDateKey];
	[aCoder encodeFloat:cachedCellHeight forKey:GRStreamCellModelStorageCellHeightKey];
}

- (nonnull instancetype)initWithEvent:(GSEvent *__nonnull)event {
	if (!event) return nil;
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

- (CGFloat)safeTextHeight {
	return safeTextHeight;
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
		
		CGFloat properHeight = GRMinf(textSize.height, self.fontSize * 3);
		
		safeTextHeight = properHeight;
		
		cachedCellHeight = verticalOffsetUsed + properHeight + GRGenericVerticalPadding * (3.0 / 2.0);
		
		CGFloat minimumCellHeight = self.avatarSize.height + 2 * GRGenericVerticalPadding;
		
		cachedCellHeight = GRMaxf(minimumCellHeight, cachedCellHeight);
		
		cachedCellHeight = ceilf(cachedCellHeight);
		
		frameDirty = NO;
		
		if (self.requiresSubCell) {
			
			CGSize subCellSize = CGSizeMake(self.cellSize.width - (leftOffsetUsed + GRGenericHorizontalPadding * 3), CGFLOAT_MAX);
			
			CGSize subCellTextSize = [[self subText] boundingRectWithSize:subCellSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:NULL].size;
			
			subCellHeight = subCellTextSize.height;
			subCellHeight += GRGenericVerticalPadding * (3.0 / 2.0);
			
			cachedCellHeight += [self subCellHeight];
			cachedCellHeight += GRGenericVerticalPadding;
		}
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

- (CGSize)subCellSize {
	return CGSizeZero;
}

- (CGFloat)subCellHeight {
	return GRMinf(subCellHeight, 58.0);
}

- (NSString *)subText {
	return cachedSubCellText;
}

- (UIImage *)subImage {
	return nil; // Likely won't be used.
}

- (BOOL)requiresSubCell {
	return requiresSubCell;
}

- (NSAttributedString *)_generatedEventString {
	NSString *subCellText = nil;
	BOOL subCellReq = NO;
	NSAttributedString *ret = GRFormattedMessageWithEvent(self.event, &subCellReq, &subCellText);
	cachedSubCellText = subCellText;
	requiresSubCell = subCellReq;
	return ret;
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
