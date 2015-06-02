//
//  UIScrollView+INSPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIScrollView+INSPullToRefresh.h"
#import <objc/runtime.h>

static char INSPullToRefreshBackgroundViewKey;
static char INSInfiniteScrollBackgroundViewKey;

@implementation UIScrollView (INSPullToRefresh)
@dynamic ins_pullToRefreshBackgroundView;
@dynamic ins_infiniteScrollBackgroundView;

#pragma mark - Dynamic Accessors

- (INSPullToRefreshBackgroundView *)ins_pullToRefreshBackgroundView {
    return objc_getAssociatedObject(self, &INSPullToRefreshBackgroundViewKey);
}

- (void)setIns_pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView {
    objc_setAssociatedObject(self, &INSPullToRefreshBackgroundViewKey,
                             pullToRefreshBackgroundView,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (INSInfiniteScrollBackgroundView *)ins_infiniteScrollBackgroundView {
    return objc_getAssociatedObject(self, &INSInfiniteScrollBackgroundViewKey);
}

- (void)setIns_infiniteScrollBackgroundView:(INSInfiniteScrollBackgroundView *)infiniteScrollBackgroundView {
    objc_setAssociatedObject(self, &INSInfiniteScrollBackgroundViewKey,
                             infiniteScrollBackgroundView,
                             OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Public

- (void)ins_beginPullToRefresh {
    [self.ins_pullToRefreshBackgroundView beginRefreshing];
}
- (void)ins_endPullToRefresh {
    [self.ins_pullToRefreshBackgroundView endRefreshing];
}

- (void)ins_setPullToRefreshEnabled:(BOOL)enabled {
    self.ins_pullToRefreshBackgroundView.enabled = enabled;
}

- (void)ins_addPullToRefreshWithHeight:(CGFloat)height handler:(INSPullToRefreshActionHandler)actionHandler {

    [self ins_removePullToRefresh];

    INSPullToRefreshBackgroundView *view = [[INSPullToRefreshBackgroundView alloc] initWithHeight:height scrollView:self];
    [self addSubview:view];
    self.ins_pullToRefreshBackgroundView = view;
    self.ins_pullToRefreshBackgroundView.actionHandler = actionHandler;
}

- (void)ins_removePullToRefresh {
    [self ins_removePullToRefreshBackgroundView];
}

- (void)ins_removePullToRefreshBackgroundView {
    [self.ins_pullToRefreshBackgroundView removeFromSuperview];
    self.ins_infiniteScrollBackgroundView = nil;
}

- (void)ins_addInfinityScrollWithHeight:(CGFloat)height handler:(INSInfinityScrollActionHandler)actionHandler {
    [self ins_removeInfinityScrollBackgroundView];

    INSInfiniteScrollBackgroundView *view = [[INSInfiniteScrollBackgroundView alloc] initWithHeight:height scrollView:self];
    [self addSubview:view];
    self.ins_infiniteScrollBackgroundView = view;
    self.ins_infiniteScrollBackgroundView.actionHandler = actionHandler;
}

- (void)ins_removeInfinityScrollBackgroundView {
    [self.ins_infiniteScrollBackgroundView removeFromSuperview];
    self.ins_infiniteScrollBackgroundView = nil;
}

- (void)ins_removeInfinityScroll {
    [self ins_removeInfinityScrollBackgroundView];
}

- (void)ins_setInfinityScrollEnabled:(BOOL)enabled {
    self.ins_infiniteScrollBackgroundView.enabled = enabled;
}

- (void)ins_beginInfinityScroll {
    [self.ins_infiniteScrollBackgroundView beginInfiniteScrolling];
}
- (void)ins_endInfinityScroll {
    [self.ins_infiniteScrollBackgroundView endInfiniteScrolling];
}
- (void)ins_endInfinityScrollWithStoppingContentOffset:(BOOL)stopContentOffset {
    [self.ins_infiniteScrollBackgroundView endInfiniteScrollingWithStoppingContentOffset:stopContentOffset];
}

@end
