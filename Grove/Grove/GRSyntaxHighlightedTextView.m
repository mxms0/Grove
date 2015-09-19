//
//  GRSyntaxHighlightedTextView.m
//  Grove
//
//  Created by Max Shavrick on 9/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "GRSyntaxHighlightedTextView.h"

@implementation GRSyntaxHighlightedTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
	if ((self = [super initWithFrame:frame textContainer:textContainer])) {
		_syntaxLanguage = GRSyntaxLanguageUnknown;
	}
	return self;
}

- (void)asynchronouslyHighlightSyntax {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
		switch (_syntaxLanguage) {
			case GRSyntaxLanguageObjectiveC:
				[self _asyncSyntaxHighlight_objc_live:YES];
				break;
			default:
				break;
		}
	});
}

- (void)_asyncSyntaxHighlight_objc_live:(BOOL)live {

	NSString *base = (self.text ?: self.attributedText.string);
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:base];
	NSUInteger stringLength = [self.text length];
	
	NSRange formattingRange = [self attributeRangeBeginningWithString:@"//" endingWithCharacterSet:[NSCharacterSet newlineCharacterSet] queryRange:NSMakeRange(0, stringLength)];
	
	NSUInteger location = 0;
	
	while (formattingRange.location != NSNotFound) {
		[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:formattingRange];
		
		dispatch_async(dispatch_get_main_queue(), ^ {
			self.attributedText = attributedString;
			[self setNeedsDisplay];
		});
		
		location = formattingRange.location + formattingRange.length + 2; // length of //
		
		formattingRange = [self attributeRangeBeginningWithString:@"//" endingWithCharacterSet:[NSCharacterSet newlineCharacterSet] queryRange:NSMakeRange(location, stringLength - location)];
	}
	
	formattingRange = [self attributeRangeBeginningWithString:@"/*" endingWithString:@"*/" queryRange:NSMakeRange(0, stringLength)];
	NSLog(@"fds %@", NSStringFromRange(formattingRange));
	location = 0;
	
	while (formattingRange.location != NSNotFound) {
		[attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:formattingRange];
		
		dispatch_async(dispatch_get_main_queue(), ^ {
			self.attributedText = attributedString;
			[self setNeedsDisplay];
		});
		
		location = formattingRange.location + formattingRange.length + 2; // length of //
		
		formattingRange = [self attributeRangeBeginningWithString:@"/*" endingWithString:@"*/" queryRange:NSMakeRange(location, stringLength - location)];
	}
	
}

- (NSRange)attributeRangeBeginningWithString:(NSString *)string endingWithString:(NSString *)endString queryRange:(NSRange)inRange {
	// this second one iss a little smarter
	// doesn't check for things inside of the found range, that way /*/ doesn't return /* as the entire range
	// still needs work, not entirely accurate
	NSRange beginningRange = [self.text rangeOfString:string options:0 range:inRange];
	if (beginningRange.location == NSNotFound) {
		return beginningRange;
	}
	NSRange endRange = [self.text rangeOfString:endString options:0 range:NSMakeRange(beginningRange.location + beginningRange.length, [self.text length] - (beginningRange.location + beginningRange.length))];
	NSLog(@"%@:%@", NSStringFromRange(beginningRange), NSStringFromRange(endRange));
	if (beginningRange.location == NSNotFound || endRange.location == NSNotFound) {
		return NSMakeRange(NSNotFound, 0);
	}
	
	return NSMakeRange(beginningRange.location, endRange.location - beginningRange.location);
}

- (NSRange)attributeRangeBeginningWithString:(NSString *)string endingWithCharacterSet:(NSCharacterSet *)endSet queryRange:(NSRange)inRange {
	NSRange beginningRange = [self.text rangeOfString:string options:0 range:inRange];
	NSRange endRange = [self.text rangeOfCharacterFromSet:endSet options:0 range:inRange];
	if (beginningRange.location == NSNotFound || endRange.location == NSNotFound) {
		return NSMakeRange(NSNotFound, 0);
	}
	
	return NSMakeRange(beginningRange.location, endRange.location - beginningRange.location);
}

- (NSRange)attributeRangeBeginningWithCharacterSet:(NSCharacterSet *)inSet endingWithCharacterSet:(NSCharacterSet *)endSet queryRange:(NSRange)inRange {
	NSRange beginningRange = [self.text rangeOfCharacterFromSet:inSet options:0 range:inRange];
	NSRange endRange = [self.text rangeOfCharacterFromSet:endSet options:0 range:inRange];
	if (beginningRange.location == NSNotFound || endRange.location == NSNotFound) {
		return NSMakeRange(NSNotFound, 0);
	}
	
	return NSMakeRange(beginningRange.location, endRange.location - beginningRange.location);
}

@end
