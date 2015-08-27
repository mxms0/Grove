//
//  GRStreamEventCell.m
//  Grove
//
//  Created by Rocco Del Priore on 8/18/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "NSAttributedString+GRExtensions.h"

#import "GRStreamEventCell.h"
#import "GSEvent.h"

@implementation GRStreamEventCell {
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *repoLabel;
    
    GSEvent *event;
}

#pragma mark Initializers

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Initialize Variables
        imageView   = [[UIImageView alloc] initWithFrame:CGRectZero];
        titleLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
        repoLabel   = [[UILabel alloc] initWithFrame:CGRectZero];
        
        //Set Properties
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [titleLabel setNumberOfLines:0];
        [timeLabel setFont:[UIFont systemFontOfSize:13]];
        [timeLabel setTextColor:[UIColor darkGrayColor]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        
        //Add Views
        for (UIView *view in @[imageView, titleLabel, repoLabel, timeLabel]) {
            [self.contentView addSubview:view];
        }
        
        //Set Constraints
        [imageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(5);
            make.top.equalTo(self.contentView).offset(30);
            make.bottom.equalTo(self.contentView).offset(-30);
            make.height.equalTo(imageView.width);
        }];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.bottom).offset(4);
            make.left.equalTo(imageView.right).offset(7);
            make.right.equalTo(self.contentView).offset(-20);
            make.bottom.equalTo(repoLabel.top).offset(-7);
        }];
        [repoLabel makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-4);
            make.left.equalTo(titleLabel);
            make.right.equalTo(titleLabel).offset(-5);
            make.height.equalTo(@18);
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(3);
            make.right.equalTo(self.contentView).offset(-3);
            make.height.equalTo(@10);
            make.width.equalTo(@65);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureWithEvent:event];
}


- (void)configureWithEvent:(GSEvent *)aEvent {
    event = aEvent;
    
    [timeLabel setText:[self dateStringFromEvent]];
    [titleLabel setAttributedText:[self messageFromeEvent]];
    [repoLabel setText:event.repository.name];
    [imageView setImage:[self imageFromEvent]];
}

#pragma mark - Parsers

- (NSString *)dateStringFromEvent {
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:event.createdDate toDate:[NSDate date] options:0];
    
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

- (NSAttributedString *)messageFromeEvent {
	return nil;
#warning ROCKY THIS IS INCOMPLETE PLS MAKE STABLE 
    NSAttributedString *message = [[NSAttributedString alloc] initWithString:@""];
    
    UIColor *blue = [UIColor colorWithRed:0.2627 green:0.4784 blue:0.7451 alpha:1.0];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:18];
    UIFont *regularFont = [UIFont systemFontOfSize:18];
	NSLog(@"fdsds %@:%@", event.actor.username, event);
    
    NSAttributedString *actorString = [[NSAttributedString alloc] initWithString:event.actor.username attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
	NSAttributedString *branch = nil;
	NSAttributedString *a = nil;
    NSAttributedString *b = nil;
    NSAttributedString *c = nil;
	
    switch (event.type) {
        case GSEventTypeCreate:
			if (!event.payload.branch) {
				// created new repo
				branch = [[NSAttributedString alloc] initWithString:event.repository.name attributes:@{NSForegroundColorAttributeName: blue, NSFontAttributeName: boldFont}];
				a = [[NSAttributedString alloc] initWithString:@" created repository " attributes:@{NSFontAttributeName:regularFont}];
				message = [NSAttributedString attributedStringWithAttributedStrings:@[actorString, a, branch]];
			}
			else {
				branch = [[NSAttributedString alloc] initWithString:event.payload.branch attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
				a = [[NSAttributedString alloc] initWithString:@" created branch " attributes:@{NSFontAttributeName:regularFont}];
				message = [NSAttributedString attributedStringWithAttributedStrings:@[actorString, a, branch]];
			}
            break;
        case GSEventTypeFork:
            break;
        case GSEventTypeWatch:
            break;
        case GSEventTypeCommitComment:
            branch = [[NSAttributedString alloc] initWithString:event.repository.name attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
            c = [[NSAttributedString alloc] initWithString:event.repository.name attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
            a = [[NSAttributedString alloc] initWithString:@" commented on commit " attributes:@{NSFontAttributeName:regularFont}];
            b = [[NSAttributedString alloc] initWithString:@" in " attributes:@{NSFontAttributeName:regularFont}];
            message = [NSAttributedString attributedStringWithAttributedStrings:@[actorString, a, branch]];
            break;
        case GSEventTypePush:
            branch = [[NSAttributedString alloc] initWithString:event.payload.branch attributes:@{NSForegroundColorAttributeName:blue, NSFontAttributeName:boldFont}];
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

- (UIImage *)imageFromEvent {
    UIImage *image = [UIImage new];
    
    switch (event.type) {
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

@end
