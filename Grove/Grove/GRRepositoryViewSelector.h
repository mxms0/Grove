//
//  GRRepositoryViewSelector.h
//  Grove
//
//  Created by Max Shavrick on 1/15/16.
//  Copyright © 2016 Milo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GRRepositoryViewSelectorType) {
	GRRepositoryViewSelectorTypeInfoView,
	GRRepositoryViewSelectorTypeCodeView,
	GRRepositoryViewSelectorTypeIssuesView,
	GRRepositoryViewSelectorTypePullRequestsView,
};

@class GRRepositoryViewSelector;
@protocol GRRepositoryViewSelectorDelegate <NSObject>
- (void)viewSelector:(GRRepositoryViewSelector *)selector didChangeToViewType:(GRRepositoryViewSelectorType)viewType;

@end

@interface GRRepositoryViewSelector : UIView
@property (nonatomic, weak) id <GRRepositoryViewSelectorDelegate> delegate;
@end
