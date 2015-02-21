//
//  UIScrollView+INSPullToRefresh.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INSPullToRefreshBackgroundView.h"
#import "INSInfinityScrollBackgroundView.h"

@interface UIScrollView (INSPullToRefresh)

#pragma mark - INSPullToRefresh

@property (nonatomic, strong, readonly) INSPullToRefreshBackgroundView *ins_pullToRefreshBackgroundView;
@property (nonatomic, strong, readonly) INSInfinityScrollBackgroundView *ins_infinityScrollBackgroundView;

- (void)ins_addPullToRefreshWithHeight:(CGFloat)height handler:(INSPullToRefreshActionHandler)actionHandler;
- (void)ins_removePullToRefresh;

- (void)ins_beginPullToRefresh;
- (void)ins_endPullToRefresh;

#pragma mark - INSInfinityScroll

- (void)ins_addInfinityScrollWithHeight:(CGFloat)height handler:(INSInfinityScrollActionHandler)actionHandler;
- (void)ins_removeInfinityScroll;

- (void)ins_beginInfinityScroll;
- (void)ins_endInfinityScroll;

@end
