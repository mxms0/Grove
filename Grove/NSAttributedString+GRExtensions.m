//
//  NSAttributedString+GRExtensions.m
//  Grove
//
//  Created by Rocco Del Priore on 8/19/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#import "NSAttributedString+GRExtensions.h"
#import "GroveSupport.h"

@implementation NSAttributedString (GRExtensions)

+ (NSAttributedString *)attributedStringWithAttributedStrings:(NSArray *)strings {
    NSMutableAttributedString *response = [[NSMutableAttributedString alloc] init];
    
    for (NSAttributedString *string in strings) {
        if (![string isKindOfClass:[NSAttributedString class]]) {
            GSAssert();
        }
        [response appendAttributedString:string];
    }
    
    return response;
}

@end
