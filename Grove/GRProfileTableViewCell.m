//
//  GRProfileTableViewCell.m
//  Grove
//
//  Created by Max Shavrick on 11/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRProfileTableViewCell.h"
#import "GRProfileTableViewCellContentView.h"

@implementation GRProfileTableViewCell {
	GRProfileTableViewCellContentView *contentView;
}

- (Class)contentViewClass {
	return [GRProfileTableViewCellContentView class];
}

@end
