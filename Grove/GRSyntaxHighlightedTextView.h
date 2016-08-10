//
//  GRSyntaxHighlightedTextView.h
//  Grove
//
//  Created by Max Shavrick on 9/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GRSyntaxLanguage) {
	GRSyntaxLanguageC,
	GRSyntaxLanguageCxx,
	GRSyntaxLanguageObjectiveC,
	GRSyntaxLanguageObjectiveCxx,
	GRSyntaxLanguageHTML,
	GRSyntaxLanguageCSS,
	GRSyntaxLanguageASM,
	GRSyntaxLanguagePython,
	GRSyntaxLanguageRuby,
	GRSyntaxLanguageJulia,
	GRSyntaxLanguageD,
	GRSyntaxLanguageRust,
	GRSyntaxLanguageSwift,
	GRSyntaxLanguageUnknown,
};

@interface GRSyntaxHighlightedTextView : UITextView
@property (nonatomic, unsafe_unretained) GRSyntaxLanguage syntaxLanguage;
- (void)asynchronouslyHighlightSyntax;
@end
