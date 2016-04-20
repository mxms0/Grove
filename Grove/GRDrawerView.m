//
//  GRDrawerView.m
//  Grove
//
//  Created by Max Shavrick on 4/19/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRDrawerView.h"
#import "GRDrawerMenuItem.h"

@implementation GRDrawerView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
	if ((self = [super initWithFrame:frame style:style])) {
		self.delegate = self;
		self.dataSource = self;
		
		[self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"drawerCell"];
	}
	return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.menuItems count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"drawerCell"];
	if (!c) {
		c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drawerCell"];
	}
	
	GRDrawerMenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
	c.textLabel.text = [item text];
	
	return c;
}

- (void)setMenuItems:(NSArray<GRDrawerMenuItem *> *)menuItems {
	NSLog(@"ffffff %@", menuItems);
	_menuItems = menuItems;
	
	[self reload];
}

- (void)reload {
	[self reloadData];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

@end
