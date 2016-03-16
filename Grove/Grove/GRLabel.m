//
//  GRLabel.m
//  Grove
//
//  Created by Max Shavrick on 2/20/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRLabel.h"
#import <CoreText/CoreText.h>

@implementation GRLabel

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setBackgroundColor:[UIColor clearColor]];
	}
	return self;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
	_attributedString = attributedString;
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	NSAttributedString *string = self.attributedString;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)string);
	CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, rect.size.width, rect.size.height - 1), NULL);
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	
	BOOL shouldTruncate = (CTFrameGetVisibleStringRange(frame).length < string.length);
	CFArrayRef lines = CTFrameGetLines(frame);
	NSUInteger lineCount = CFArrayGetCount(lines);
	CGPoint *origins = malloc(sizeof(CGPoint) * lineCount);
	CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
	
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0.0f, rect.size.height);
	CGContextScaleCTM(context, 1.0f, -1.0f);
	
	CGFloat lineHeight = 0.0f;
	
	for (NSUInteger i = 0; i < lineCount; i++) {
		CTLineRef line = CFArrayGetValueAtIndex(lines, i);
		CGPoint point = origins[i];
		CGContextSetTextPosition(context, point.x, point.y);
		
		NSArray *runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
		for (int i = 0; i < [runs count]; i++) {
			CTRunRef run = (__bridge CTRunRef)runs[i];

			CFRange stringRange = CTRunGetStringRange(run);
			CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
			
			double typographicBounds = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading);
			
			CGFloat xOffset = CTLineGetOffsetForStringIndex(line, stringRange.location, nil);
			CGContextSetTextPosition(context, point.x, point.y + descent);
			
			CGFloat currentLineHeight = ascent + descent + leading;
			
			lineHeight = GRMaxf(lineHeight, currentLineHeight);
			
			CGRect runBounds = CGRectMake(point.x + xOffset - 3, point.y - 2, (CGFloat)(typographicBounds) + 6, ascent + descent + 4);
			
			NSDictionary *attributes = (__bridge NSDictionary *)CTRunGetAttributes(run);
			
			if (attributes[GRHighlightAttribute]) {
				[GRColorFromRGB(0xE3F1FD) setFill];
				[[UIBezierPath bezierPathWithRoundedRect:runBounds cornerRadius:3.0] fill];
				[[UIColor blackColor] setFill];
			}
		}
		
		BOOL truncate = (shouldTruncate && (i == lineCount - 1));
		if (!truncate) {
			CTLineDraw(line, context);
		}
		else {
			NSDictionary *attributes = [string attributesAtIndex:(string.length - 1) effectiveRange:NULL];
			
			NSAttributedString *ellipsis = [[NSAttributedString alloc] initWithString:@"\u2026" attributes:attributes];
			
			CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)ellipsis);
			double width = CTLineGetTypographicBounds(line, NULL, NULL, NULL) - CTLineGetTrailingWhitespaceWidth(line);
			CTLineRef truncatedLine = CTLineCreateTruncatedLine(line, width-1, kCTLineTruncationEnd, truncationToken);
			
			if (truncatedLine) {
				CTLineDraw(truncatedLine, context);
			}
			else {
				CTLineDraw(line, context);
			}
			
			if (truncationToken)
				CFRelease(truncationToken);
			if (truncatedLine)
				CFRelease(truncatedLine);
		}
	}
	
	free(origins);
	CGPathRelease(path);
	CFRelease(frame);
	CFRelease(framesetter);
	
	// this is definitely not the best way to do this.
	// Also it truncates (borders/highlights) incorrectly.
	// Should insert space on left alignment in places to hopefully counter.
	// Still looks awkward no matter how it's done :/
}

@end
