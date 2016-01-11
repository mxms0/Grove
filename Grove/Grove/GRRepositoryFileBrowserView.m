//
//  GRRepositoryFileBrowserView.m
//  Grove
//
//  Created by Max Shavrick on 1/6/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import "GRRepositoryFileBrowserView.h"
#import "GRRepositoryPathBar.h"
#import "GRRepositoryFileBrowserEntryCell.h"

#import <GroveSupport/GroveSupport.h>

@implementation GRRepositoryFileBrowserView {
	GRRepositoryFileBrowserModel *model;
	UIActivityIndicatorView *loadingIndicator;
	GRRepositoryPathBar *pathBar;
	UITableView *directoryTableView;
}

- (instancetype)initWithRepository:(GSRepository *)repo {
	if ((self = [super init])) {
		[self setRepository:repo];
		[self commonInit];
	}
	return self;
}

- (instancetype)init {
	if ((self = [super init])) {
		[self commonInit];
	}
	return self;
}

- (void)commonInit {
	pathBar = [[GRRepositoryPathBar alloc] init];
	[pathBar setBackgroundColor:GSRandomUIColor()];
	
	loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	
	directoryTableView = [[UITableView alloc] init];
	[directoryTableView setDelegate:self];
	[directoryTableView setDataSource:self];
	
	for (UIView *v in @[pathBar, loadingIndicator, directoryTableView]) {
		[self addSubview:v];
	}
	
	[self presentLoadingIndicator];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [model numberOfItemsInCurrentDirectory];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40.0f;
}

- (GRRepositoryFileBrowserEntryCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	GRRepositoryFileBrowserEntryCell *cell = (GRRepositoryFileBrowserEntryCell *)[tableView dequeueReusableCellWithIdentifier:@"c"];
	if (!cell) {
		cell = [[GRRepositoryFileBrowserEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"c"];
	}
	
	GSRepositoryEntry *entry = [model repositoryEntryForIndex:indexPath.row];
	
	[cell configureWithEntry:entry];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[model pushItemFromIndexPath:indexPath];
}

- (void)setRepository:(GSRepository *)repo {
	if (!repo) {
		model = nil;
		return;
	}
	model = [[GRRepositoryFileBrowserModel alloc] initWithRepository:repo];
	[model setDelegate:self];
	[model update];
	[pathBar setDelegate:model];
	[model setPathBar:pathBar];
}

- (void)presentLoadingIndicator {
	[loadingIndicator startAnimating];
	[loadingIndicator setHidden:NO];
	[directoryTableView setHidden:YES];
}

- (void)prepareForLayout {
	[loadingIndicator setHidden:YES];
	[loadingIndicator stopAnimating];
	[directoryTableView setHidden:NO];
	// perhaps a graceful animation in..
}

- (void)pushToNewDirectory {
	[directoryTableView reloadData];
}

- (void)pushToPreviousDirectory {
	[directoryTableView reloadData];
}

- (void)reloadData {
	[directoryTableView reloadData];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGFloat occupiedSpace = 0.0f;
	
	const CGFloat pathBarSize = 40.0f;
	[pathBar setFrame:CGRectMake(0, 0, self.frame.size.width, pathBarSize)];
	
	occupiedSpace += pathBar.frame.size.height + pathBar.frame.origin.y;
	
	const CGFloat indicatorSize = 24.0f;
	[loadingIndicator setFrame:CGRectMake(floorf(self.frame.size.width/2 - indicatorSize/2) , floorf(self.frame.size.height/2 - indicatorSize/2), indicatorSize, indicatorSize)];
	
	[directoryTableView setFrame:CGRectMake(0, occupiedSpace, self.frame.size.width, self.frame.size.height - occupiedSpace)];	
}

@end