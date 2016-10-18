
//
//  GRMarkdownView.m
//  Grove
//
//  Created by Max Shavrick on 10/18/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRMarkdownView.h"

typedef NS_OPTIONS(NSInteger, GRMarkdownLineStyle) {
	GRMarkdownLineStyleHeader1 = 1 << 0,
	GRMarkdownLineStyleHeader2,
	GRMarkdownLineStyleHeader1Post,
	GRMarkdownLineStyleHeader2Post, // While markdown is nice for writing, it's a nightmare to implement.
	GRMarkdownLineStyleHeader3,
	GRMarkdownLineStyleHeader4,
	GRMarkdownLineStyleHeader5,
	GRMarkdownLineStyleHeader6,
	GRMarkdownLineStyleBlockquotes,
	GRMarkdownLineStylePreformattedCodeBlock,
	GRMarkdownLineStyleHorizontalRule,
	GRMarkdownLineStyleUnorderedList,
	GRMarkdownLineStyleOrderedList,
	GRMarkdownLineStylePlain,
};

@implementation GRMarkdownView

- (void)setText:(NSString *)text {
	[super setText:text];
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^ {
		[self parseMarkdown];
	});
}

- (GRMarkdownLineStyle)bestGuessLineStyleFromLine:(NSString *)line {
	
	NSDictionary *const prefixMap = @{
									   @"######": @(GRMarkdownLineStyleHeader6),
									   @"#####": @(GRMarkdownLineStyleHeader5),
									   @"####": @(GRMarkdownLineStyleHeader4),
									   @"###": @(GRMarkdownLineStyleHeader3),
									   @"##": @(GRMarkdownLineStyleHeader2),
									   @"#": @(GRMarkdownLineStyleHeader1),
									   @"=": @(GRMarkdownLineStyleHeader1Post),
									   @"-": @(GRMarkdownLineStyleHeader2Post | GRMarkdownLineStyleHorizontalRule),
									   @"*": @(GRMarkdownLineStyleUnorderedList | GRMarkdownLineStyleHorizontalRule),
									   @"1.": @(GRMarkdownLineStyleOrderedList),
									   @"2.": @(GRMarkdownLineStyleOrderedList),
									   @">": @(GRMarkdownLineStyleBlockquotes),
									   @"`": @(GRMarkdownLineStylePreformattedCodeBlock)
									   };
	
	NSRange rangeTillEndOfFirstBlock = [line rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
	
	if (rangeTillEndOfFirstBlock.location == NSNotFound) {
		//
	}
	else {
		NSString *prefix = [line substringToIndex:rangeTillEndOfFirstBlock.location];
		
		id bestGuess = prefixMap[prefix];
		
		GRMarkdownLineStyle bestGuessStyle = GRMarkdownLineStylePlain;
		
		if (bestGuess) {
			bestGuessStyle = (GRMarkdownLineStyle)[prefixMap[prefix] integerValue];
		}
		
		return bestGuessStyle;
	}
	
	
	return GRMarkdownLineStylePlain;
}

- (GRMarkdownLineStyle)lineStyleFromLine:(NSString *)line {
	
	GRMarkdownLineStyle style = [self bestGuessLineStyleFromLine:line];
	
	
	return style;
}

- (NSDictionary *)stylesForLineStyle:(GRMarkdownLineStyle)styl {
	return @{};
}

- (void)parseMarkdown {
	NSArray *lines = [self.text componentsSeparatedByString:@"\r\n"];
	
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
	
	for (int i = 0; i < [lines count]; i++) {
		NSString *line = [lines[i] stringByAppendingString:@"\r\n"];
		
		GRMarkdownLineStyle style = [self lineStyleFromLine:line];
		
		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:line attributes:[self stylesForLineStyle:style]];
		
		[attributedString appendAttributedString:string];
	}
	
	self.attributedText = attributedString;
}

//- (void)drawRect:(CGRect)rect {
//	
//}

@end
