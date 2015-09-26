//
//  Grove.h
//  Grove
//
//  Created by Max Shavrick on 8/17/15.
//  Copyright (c) 2015 Milo. All rights reserved.
//

#ifndef Grove_Grove_h
#define Grove_Grove_h

#import <Masonry/Masonry.h>

static inline UIColor *GRColorFromRGB(unsigned long long rgb) {
	return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}
#endif
