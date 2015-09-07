//
//  INSPullToRefreshBackgroundView.m
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
//
//  This class based on BMYCircularProgressPullToRefresh Copyright (c) 2014, Beamly
//
////////////////////////////////////////////////////////
//
//  Copyright (c) 2014, Beamly
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of Beamly nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL BEAMLY BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "INSPullToRefreshBackgroundView.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "UIView+INSFirstReponder.h"

CGFloat const INSPullToRefreshDefaultResetContentInsetAnimationTime = 0.3;
CGFloat const INSPullToRefreshDefaultDragToTriggerOffset = 80;

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)

@interface INSPullToRefreshBackgroundView ()
@property (nonatomic, weak) UIScrollView *scrollView;
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
            [self resetScrollViewContentInsetWithCompletion:nil];
            break;
        }
            
        case INSPullToRefreshBackgroundViewStateLoading: {
            [self setScrollViewContentInsetForLoadingAnimated:YES];
            
            if (previousState == INSPullToRefreshBackgroundViewStateTriggered && self.actionHandler) {
                self.actionHandler(self.scrollView);
            }
            break;
        }
    }
}

- (void)setPreserveContentInset:(BOOL)preserveContentInset {
    if (_preserveContentInset != preserveContentInset) {
        _preserveContentInset = preserveContentInset;
        
        if (self.bounds.size.height > 0.0f) {
            [self resetFrame];
        }
    }
}

- (void)setEnabled:(BOOL)enabled {
    if (_enabled != enabled) {
        _enabled = enabled;
        if (_enabled) {
            [self resetFrame];
        } else {
            [self endRefreshing];
        }
        self.hidden = !_enabled;
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
        _automaticallyTurnOffAdjustsScrollViewInsetsWhenTranslucentNavigationBar = YES;
        _dragToTriggerOffset = INSPullToRefreshDefaultDragToTriggerOffset;
        _scrollView = scrollView;
        _externalContentInset = scrollView.contentInset;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _state = INSPullToRefreshBackgroundViewStateNone;
        _preserveContentInset = NO;
        _scrollToTopAfterEndRefreshing = YES;
        _enabled = YES;
        
        [self resetFrame];
    }
    
    return self;
}

#pragma mark - Public

- (void)beginRefreshing {
    if (!self.enabled) {
        return;
    }
    
    if (self.state == INSPullToRefreshBackgroundViewStateNone) {
        [self changeState:INSPullToRefreshBackgroundViewStateTriggered];
        
        dispatch_async(dispatch_get_main_queue(), ^{
			if (self.state != INSPullToRefreshBackgroundViewStateNone) {
				[self.scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x, -CGRectGetHeight(self.frame) -_externalContentInset.top ) animated:YES];
			}
        });
        
        [self changeState:INSPullToRefreshBackgroundViewStateLoading];
    }
}
- (void)endRefreshing {
    if (self.state != INSPullToRefreshBackgroundViewStateNone) {
        [self changeState:INSPullToRefreshBackgroundViewStateNone];
        if (self.scrollToTopAfterEndRefreshing) {
            CGPoint originalContentOffset = CGPointMake(-_externalContentInset.left, -_externalContentInset.top);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scrollView setContentOffset:originalContentOffset animated:NO];
            });
        }
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

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (self.superview) {
        [self removeObserversFromView:self.superview];
    }
    
    if (newSuperview) {
        [self addScrollViewObservers:newSuperview];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.automaticallyTurnOffAdjustsScrollViewInsetsWhenTranslucentNavigationBar) {
        UIViewController *firstReponderViewController = [self ins_firstResponderViewController];
        
        if (firstReponderViewController.navigationController && firstReponderViewController.navigationController.navigationBar.translucent && firstReponderViewController.automaticallyAdjustsScrollViewInsets && self.scrollView.superview == firstReponderViewController.view) {
            firstReponderViewController.automaticallyAdjustsScrollViewInsets = NO;
            self.scrollView.contentInset = UIEdgeInsetsMake(firstReponderViewController.navigationController.navigationBar.frame.origin.y + firstReponderViewController.navigationController.navigationBar.bounds.size.height, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
        }
    }
}

- (void)removeObserversFromView:(UIView *)view {
    NSParameterAssert([view isKindOfClass:[UIScrollView class]]);

    [view removeObserver:self forKeyPath:@"contentOffset"];
    [view removeObserver:self forKeyPath:@"contentSize"];
    [view removeObserver:self forKeyPath:@"frame"];
    [view removeObserver:self forKeyPath:@"contentInset"];
}

- (void)addScrollViewObservers:(UIView *)view {
    NSParameterAssert([view isKindOfClass:[UIScrollView class]]);

    [view addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [view addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [view addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (!self.enabled) {
        return;
    }
    
    //NSLog(@"%@ %@",keyPath,change[@"new"]);
    
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
        if (!_updatingScrollViewContentInset && self.scrollView.ins_infiniteScrollBackgroundView.state == INSInfiniteScrollBackgroundViewStateNone) {
            self.externalContentInset = [[change valueForKey:NSKeyValueChangeNewKey] UIEdgeInsetsValue];
            [self resetFrame];
        }
    }
}

- (BOOL)isScrollViewIsTableViewAndHaveSections {
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        if (tableView.numberOfSections > 1) {
            return YES;
        } else if (tableView.numberOfSections == 1) {
            if ([tableView.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
                return [tableView.delegate tableView:tableView heightForHeaderInSection:0] > 0;
            }
        }
    }
    return NO;
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if (self.state == INSPullToRefreshBackgroundViewStateLoading) {
        UIEdgeInsets loadingInset = self.externalContentInset;
        CGFloat top = loadingInset.top + CGRectGetHeight(self.bounds);
        
		if ([self isScrollViewIsTableViewAndHaveSections] && self.scrollView.contentOffset.y > -(CGRectGetHeight(self.bounds) + self.externalContentInset.top)) {
			if (self.scrollView.contentOffset.y >= - self.externalContentInset.top) {
                top = loadingInset.top;
            } else {
                top = fabs(self.scrollView.contentOffset.y);
            }
        }
        
        loadingInset.top = top;
        [self setScrollViewContentInset:loadingInset forLoadingAnimated:NO];
    } else {
        CGFloat dragging = -contentOffset.y - _externalContentInset.top;
        if (!self.scrollView.isDragging && self.state == INSPullToRefreshBackgroundViewStateTriggered) {
            [self changeState:INSPullToRefreshBackgroundViewStateLoading];
        }
        else if (dragging >= self.dragToTriggerOffset && self.scrollView.isDragging && self.state == INSPullToRefreshBackgroundViewStateNone) {
            [self changeState:INSPullToRefreshBackgroundViewStateTriggered];
        }
        else if (dragging < self.dragToTriggerOffset && self.state != INSPullToRefreshBackgroundViewStateNone) {
            [self changeState:INSPullToRefreshBackgroundViewStateNone];
        }
        
        if (dragging >= 0 && self.state != INSPullToRefreshBackgroundViewStateLoading) {
            if ([self.delegate respondsToSelector:@selector(pullToRefreshBackgroundView:didChangeTriggerStateProgress:)]) {
                
                CGFloat progress = (dragging * 1 / self.dragToTriggerOffset);
                if (progress > 1) {
                    progress = 1;
                }
                
                [self.delegate pullToRefreshBackgroundView:self didChangeTriggerStateProgress:progress];
            }
        }
    }
}

#pragma mark - ScrollView

- (void)resetScrollViewContentInsetWithCompletion:(void(^)(BOOL finished))completion {
    [UIView animateWithDuration:INSPullToRefreshDefaultResetContentInsetAnimationTime
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         [self setScrollViewContentInset:self.externalContentInset];
                     }
                     completion:completion];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)insetes forLoadingAnimated:(BOOL)animated {
    
    void (^updateBlock)(void) = ^{
        [self setScrollViewContentInset:insetes];
    };
    if (animated) {
        [UIView animateWithDuration:INSPullToRefreshDefaultResetContentInsetAnimationTime
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState)
                         animations:updateBlock
                         completion:nil];
    } else {
        updateBlock();
    }
}

- (void)setScrollViewContentInsetForLoadingAnimated:(BOOL)animated {
    UIEdgeInsets loadingInset = self.externalContentInset;
    loadingInset.top += CGRectGetHeight(self.bounds);
    
    [self setScrollViewContentInset:loadingInset forLoadingAnimated:animated];
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
