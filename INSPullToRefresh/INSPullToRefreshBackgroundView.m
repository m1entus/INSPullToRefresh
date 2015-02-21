//
//  INSPullToRefreshBackgroundView.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSPullToRefreshBackgroundView.h"
#import "UIScrollView+INSPullToRefresh.h"

static CGFloat const INSPullToRefreshResetContentInsetAnimationTime = 0.3;
static CGFloat const INSPullToRefreshDragToTrigger = 80;

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

@interface INSPullToRefreshBackgroundView ()
@property (nonatomic, readwrite) INSPullToRefreshBackgroundViewState state;
@property (nonatomic, assign) UIEdgeInsets externalContentInset;
@property (nonatomic, assign, getter = isUpdatingScrollViewContentInset) BOOL updatingScrollViewContentInset;
@end

@implementation INSPullToRefreshBackgroundView

#pragma mark - Setters

- (void)setState:(INSPullToRefreshBackgroundViewState)newState {

    if (_state == newState)
        return;

    INSPullToRefreshBackgroundViewState previousState = _state;
    _state = newState;

    [self setNeedsLayout];
    [self layoutIfNeeded];

    switch (newState) {
        case INSPullToRefreshBackgroundViewStateTriggered:
        case INSPullToRefreshBackgroundViewStateNone: {
            [self resetScrollViewContentInset];
            break;
        }

        case INSPullToRefreshBackgroundViewStateLoading: {
            [self setScrollViewContentInsetForLoadingAnimated:YES];

            if (previousState == INSPullToRefreshBackgroundViewStateTriggered && self.actionHandler) {
                [UIView animateWithDuration:INSPullToRefreshResetContentInsetAnimationTime
                                 animations:^{
                                     self.actionHandler(self.scrollView);
                                 }];
            }
            break;
        }
    }
}

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithHeight:0.0f scrollView:nil];
}

- (instancetype)initWithHeight:(CGFloat)height scrollView:(UIScrollView *)scrollView {
    NSParameterAssert(height > 0.0f);
    NSParameterAssert(scrollView);

    CGRect frame = CGRectMake(0.0f, 0.0f, 0.0f, height);
    if (self = [super initWithFrame:frame]) {
        _scrollView = scrollView;
        _externalContentInset = scrollView.contentInset;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _state = INSPullToRefreshBackgroundViewStateNone;
        _preserveContentInset = NO;

        [self resetFrame];
    }

    return self;
}

#pragma mark - Public

- (void)beginRefreshing {
    if (self.state == INSPullToRefreshBackgroundViewStateNone) {
        [self changeState:INSPullToRefreshBackgroundViewStateTriggered];
        
        [self.scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, -CGRectGetHeight(self.frame) -_externalContentInset.top ) animated:YES];
        
        [self changeState:INSPullToRefreshBackgroundViewStateLoading];
    }
}
- (void)endRefreshing {
    if (self.state != INSPullToRefreshBackgroundViewStateNone) {
        [self changeState:INSPullToRefreshBackgroundViewStateNone];
        CGPoint originalContentOffset = CGPointMake(-_externalContentInset.left, -_externalContentInset.top);
        [self.scrollView setContentOffset:originalContentOffset animated:NO];
    }
}

- (void)changeState:(INSPullToRefreshBackgroundViewState)state {
    if (self.state == state) {
        return;
    }
    self.state = state;
    if ([self.delegate respondsToSelector:@selector(pullToRefreshBackgroundView:didChangeState:)]) {
        [self.delegate pullToRefreshBackgroundView:self didChangeState:self.state];
    }
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    }
    else if ([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        [self resetFrame];
    }
    else if ([keyPath isEqualToString:@"frame"]) {
        [self layoutSubviews];
    }
    else if ([keyPath isEqualToString:@"contentInset"]) {
        // Prevent to change external content inset when infinity scroll is loading
        if (!_updatingScrollViewContentInset && self.scrollView.ins_infinityScrollBackgroundView.state == INSInfinityScrollBackgroundViewStateNone) {
            self.externalContentInset = [[change valueForKey:NSKeyValueChangeNewKey] UIEdgeInsetsValue];
            [self resetFrame];
        }
    }
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if (self.state == INSPullToRefreshBackgroundViewStateLoading) {
        [self setScrollViewContentInsetForLoadingAnimated:NO];
    } else {
        CGFloat dragging = -contentOffset.y - _externalContentInset.top;
        if (!self.scrollView.isDragging && self.state == INSPullToRefreshBackgroundViewStateTriggered) {
            [self changeState:INSPullToRefreshBackgroundViewStateLoading];
        }
        else if (dragging >= INSPullToRefreshDragToTrigger && self.scrollView.isDragging && self.state == INSPullToRefreshBackgroundViewStateNone) {
            [self changeState:INSPullToRefreshBackgroundViewStateTriggered];
        }
        else if (dragging < INSPullToRefreshDragToTrigger && self.state != INSPullToRefreshBackgroundViewStateNone) {
            [self changeState:INSPullToRefreshBackgroundViewStateNone];
        }

        if (dragging >= 0 && self.state != INSPullToRefreshBackgroundViewStateLoading) {
            if ([self.delegate respondsToSelector:@selector(pullToRefreshBackgroundView:didChangeTriggerStateProgress:)]) {

                CGFloat progress = (dragging * 1 / INSPullToRefreshDragToTrigger);
                if (progress > 1) {
                    progress = 1;
                }

                [self.delegate pullToRefreshBackgroundView:self didChangeTriggerStateProgress:progress];
            }
        }
    }
}

#pragma mark - ScrollView

- (void)resetScrollViewContentInset {
    [UIView animateWithDuration:INSPullToRefreshResetContentInsetAnimationTime
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         [self setScrollViewContentInset:self.externalContentInset];
                     }
                     completion:nil];
}

- (void)setScrollViewContentInsetForLoadingAnimated:(BOOL)animated {
    UIEdgeInsets loadingInset = self.externalContentInset;
    loadingInset.top += CGRectGetHeight(self.bounds);
    void (^updateBlock)(void) = ^{
        [self setScrollViewContentInset:loadingInset];
    };
    if (animated) {
        [UIView animateWithDuration:INSPullToRefreshResetContentInsetAnimationTime
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                         animations:updateBlock
                         completion:nil];
    } else {
        updateBlock();
    }
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    BOOL alreadyUpdating = _updatingScrollViewContentInset; // Check to prevent errors from recursive calls.
    if (!alreadyUpdating) {
        self.updatingScrollViewContentInset = YES;
    }
    self.scrollView.contentInset = contentInset;
    if (!alreadyUpdating) {
        self.updatingScrollViewContentInset = NO;
    }
}

#pragma mark - Utilities

- (void)resetFrame {
    CGFloat height = CGRectGetHeight(self.bounds);

    if (_preserveContentInset) {
        self.frame = CGRectMake(0.0f,
                                -height -_externalContentInset.top,
                                CGRectGetWidth(_scrollView.bounds),
                                height);
    }
    else {
        self.frame = CGRectMake(-_externalContentInset.left,
                                -height,
                                CGRectGetWidth(_scrollView.bounds),
                                height);
    }
    
}

@end
