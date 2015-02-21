//
//  UIScrollView+INSPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "UIScrollView+INSPullToRefresh.h"
#import <objc/runtime.h>

static char INSPullToRefreshBackgroundViewKey;
static char INSInfinityScrollBackgroundViewKey;

@implementation UIScrollView (INSPullToRefresh)
@dynamic ins_pullToRefreshBackgroundView;
@dynamic ins_infinityScrollBackgroundView;

#pragma mark - Dynamic Accessors

- (INSPullToRefreshBackgroundView *)ins_pullToRefreshBackgroundView {
    return objc_getAssociatedObject(self, &INSPullToRefreshBackgroundViewKey);
}

- (void)setIns_pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView {
    objc_setAssociatedObject(self, &INSPullToRefreshBackgroundViewKey,
                             pullToRefreshBackgroundView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (INSInfinityScrollBackgroundView *)ins_infinityScrollBackgroundView {
    return objc_getAssociatedObject(self, &INSInfinityScrollBackgroundViewKey);
}

- (void)setIns_infinityScrollBackgroundView:(INSInfinityScrollBackgroundView *)infinityScrollBackgroundView {
    objc_setAssociatedObject(self, &INSInfinityScrollBackgroundViewKey,
                             infinityScrollBackgroundView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Public

- (void)ins_beginPullToRefresh {
    [self.ins_pullToRefreshBackgroundView beginRefreshing];
}
- (void)ins_endPullToRefresh {
    [self.ins_pullToRefreshBackgroundView endRefreshing];
}

- (void)ins_addPullToRefreshWithHeight:(CGFloat)height handler:(INSPullToRefreshActionHandler)actionHandler {

    [self ins_removePullToRefresh];

    INSPullToRefreshBackgroundView *view = [[INSPullToRefreshBackgroundView alloc] initWithHeight:height scrollView:self];
    [self addSubview:view];
    self.ins_pullToRefreshBackgroundView = view;
    [self ins_configurePullToRefreshObservers];

    self.ins_pullToRefreshBackgroundView.actionHandler = actionHandler;
}

- (void)ins_removePullToRefresh {
    if (self.ins_pullToRefreshBackgroundView) {

        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentOffset"];
        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentSize"];
        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"frame"];
        [self removeObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentInset"];

        [self.ins_pullToRefreshBackgroundView removeFromSuperview];
        self.ins_pullToRefreshBackgroundView = nil;
    }
}

- (void)ins_addInfinityScrollWithHeight:(CGFloat)height handler:(INSInfinityScrollActionHandler)actionHandler {
    [self ins_removeInfinityScroll];

    INSInfinityScrollBackgroundView *view = [[INSInfinityScrollBackgroundView alloc] initWithHeight:height scrollView:self];
    [self addSubview:view];
    self.ins_infinityScrollBackgroundView = view;
    [self ins_configureInfinityScrollObservers];

    self.ins_infinityScrollBackgroundView.actionHandler = actionHandler;
}
- (void)ins_removeInfinityScroll {
    if (self.ins_infinityScrollBackgroundView) {

        [self removeObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"contentOffset"];
        [self removeObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"contentSize"];
        [self removeObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"frame"];
        [self removeObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"contentInset"];

        [self.ins_infinityScrollBackgroundView removeFromSuperview];
        self.ins_infinityScrollBackgroundView = nil;
    }
}

- (void)ins_beginInfinityScroll {
    [self.ins_infinityScrollBackgroundView beginInfiniteScrolling];
}
- (void)ins_endInfinityScroll {
    [self.ins_infinityScrollBackgroundView endInfiniteScrolling];
}

#pragma mark - Private Methods

- (void)ins_configurePullToRefreshObservers {
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_pullToRefreshBackgroundView forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)ins_configureInfinityScrollObservers {
    [self addObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.ins_infinityScrollBackgroundView forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

@end
