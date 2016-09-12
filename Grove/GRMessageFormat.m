//
//  GRMessageFormat.m
//  Grove
//
//  Created by Max Shavrick on 3/31/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAttributedString+GRExtensions.h"
#import <GroveSupport/GSEvent.h>

NSAttributedString *GRFormattedMessageWithEvent(GSEvent *event, BOOL *requiresSubCell, NSString **subCellText) {
	
	//	UIColor *blue = [UIColor colorWithRed:0.2627 green:0.4784 blue:0.7451 alpha:1.0];
	//	UIFont *boldFont = [UIFont boldSystemFontOfSize:18];
	UIFont *regularFont = [UIFont systemFontOfSize:13];
	
	NSMutableArray *components = [[NSMutableArray alloc] init];
	
	NSDictionary *defaultAttributes = @{NSFontAttributeName : regularFont};
	NSDictionary *highlightedAttributes = @{NSFontAttributeName : regularFont, GRHighlightAttribute: @(YES)};

	// clean up this mess, soon.
	// getting all the logic down and finding out what data gets used is fine for now
	@try {
		switch (event.type) {
			case GSEventTypeFork: {
				NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"Forked  " attributes:defaultAttributes];
				NSAttributedString *cp1 = [[NSAttributedString alloc] initWithString:event.repository.pathString attributes:highlightedAttributes];
				[components addObjectsFromArray:@[message, cp1]];
				break;
			}
			case GSEventTypeCommitComment: {
				NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"Commented on Commit  " attributes:defaultAttributes];
				NSString *destinationString = event.repository.pathString;
				NSString *commitHash = event.comment.commitIdentifier;
				if (commitHash && [commitHash length] >= 10) {
					commitHash = [commitHash substringToIndex:10];
					destinationString = [destinationString stringByAppendingFormat:@"@%@", commitHash];
				}
				NSAttributedString *dest = [[NSAttributedString alloc] initWithString:destinationString attributes:highlightedAttributes];
				[components addObjectsFromArray:@[verb, dest]];
				
				if (requiresSubCell)
					*requiresSubCell = YES;
				
				if (subCellText)
					*subCellText = [event.comment body];
				
				break;
			}
			case GSEventTypeCreate: {
				NSAttributedString *verb = nil;
				NSAttributedString *subject = nil;
				// Could be created repository, unsure what other "created" events there are.
				
				switch ([event refType]) {
					case GSEventRefTypeBranch:
						verb = [[NSAttributedString alloc] initWithString:@"Created branch  " attributes:defaultAttributes];
						subject = [[NSAttributedString alloc] initWithString:event.ref attributes:highlightedAttributes];
						break;
					case GSEventRefTypeRepository:
						verb = [[NSAttributedString alloc] initWithString:@"Created repository  " attributes:defaultAttributes];
						subject = [[NSAttributedString alloc] initWithString:event.repository.pathString attributes:highlightedAttributes];
						break;
					case GSEventRefTypeTag:
					case GSEventRefTypeUnknown:
					default:
						//GSAssert();
						break;
				}
				
				[components addObjectsFromArray:@[verb, subject]];
				
				break;
			}
			case GSEventTypeDelete: {
				NSAttributedString *msg = [[NSAttributedString alloc] initWithString:@"Deleted  " attributes:defaultAttributes];
				NSAttributedString *target1 = nil;
				NSAttributedString *thing = [[NSAttributedString alloc] initWithString:@"  at  " attributes:defaultAttributes];
				NSAttributedString *target2 = nil;
				
				switch ([event refType]) {
					case GSEventRefTypeBranch:
						target1 = [[NSAttributedString alloc] initWithString:event.ref attributes:highlightedAttributes];
						target2 = [[NSAttributedString alloc] initWithString:event.repository.pathString attributes:highlightedAttributes];
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
				NSAttributedString *person = [[NSAttributedString alloc] initWithString:event.member.username attributes:defaultAttributes];
				NSAttributedString *prep = nil;
				NSAttributedString *destination = [[NSAttributedString alloc] initWithString:event.repository.pathString attributes:highlightedAttributes];
				switch ([event action]) {
					case GSEventActionAdded:
						verb = [[NSAttributedString alloc] initWithString:@"Added " attributes:defaultAttributes];
						prep = [[NSAttributedString alloc] initWithString:@" to " attributes:defaultAttributes];
						break;
					default:
						NSLog(@"Unhandled member-type event. %@", event);
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
				NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"Made  " attributes:defaultAttributes];
				NSAttributedString *target = [[NSAttributedString alloc] initWithString:event.repository.pathString attributes:highlightedAttributes];
				// right now I'm confident no notification gets pushed to users if someone makes a repo private.. so
				if (!event.publicallyAvailable) {
					NSLog(@"THIS EVENT IS BEHAVING STRANGELY. %@", event);
				}
				NSAttributedString *destination = [[NSAttributedString alloc] initWithString:@"  public" attributes:defaultAttributes];
				[components addObjectsFromArray:@[verb, target, destination]];
				break;
			}
			case GSEventTypePullRequest:
			case GSEventTypePullRequestReviewComment:
				break;
			case GSEventTypePush: {
				NSAttributedString *verb = [[NSAttributedString alloc] initWithString:@"Pushed to  " attributes:defaultAttributes];
				NSString *perhapsBranch = [event.ref lastPathComponent];
				NSAttributedString *branch = [[NSAttributedString alloc] initWithString:perhapsBranch attributes:highlightedAttributes];
				NSAttributedString *prep = [[NSAttributedString alloc] initWithString:@"  at  " attributes:defaultAttributes];
				NSAttributedString *repo = [[NSAttributedString alloc] initWithString:[event.repository pathString] attributes:highlightedAttributes];
				[components addObjectsFromArray:@[verb, branch, prep, repo]];
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
				NSAttributedString *message = [[NSAttributedString alloc] initWithString:@"Starred  " attributes:defaultAttributes];
				NSAttributedString *repository = [[NSAttributedString alloc] initWithString:event.repository.pathString attributes:highlightedAttributes];
				[components addObjectsFromArray:@[message, repository]];
				break;
			}
			case GSEventTypeUnknown:
				break;
		}
	}
	@catch(id e) {
		NSLog(@"exc[%@] evt[%@]", e, event);
//		abort();
	}
	
	NSAttributedString *string = [NSAttributedString attributedStringWithAttributedStrings:components];
	
	return string;
}