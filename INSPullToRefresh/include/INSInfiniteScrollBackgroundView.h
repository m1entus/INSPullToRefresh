//
//  INSInfinityScrollBackgroundView.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 19.02.2015.
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

#import <UIKit/UIKit.h>

typedef void(^INSInfinityScrollActionHandler)(UIScrollView *scrollView);

typedef NS_ENUM(NSUInteger, INSInfiniteScrollBackgroundViewState) {
    INSInfiniteScrollBackgroundViewStateNone = 0,
    INSInfiniteScrollBackgroundViewStateLoading,
};

@class INSInfiniteScrollBackgroundView;

@protocol INSInfiniteScrollBackgroundViewDelegate <NSObject>
@optional
- (void)infinityScrollBackgroundView:(INSInfiniteScrollBackgroundView *)infinityScrollBackgroundView didChangeState:(INSInfiniteScrollBackgroundViewState)state;
@end

@interface INSInfiniteScrollBackgroundView : UIView
@property (nonatomic, copy) INSInfinityScrollActionHandler actionHandler;
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

@property (nonatomic, weak) id <INSInfiniteScrollBackgroundViewDelegate> delegate;

@property (nonatomic, readonly) INSInfiniteScrollBackgroundViewState state;
@property (nonatomic, assign) BOOL preserveContentInset;

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL shouldShowWhenDisabled;

@property (nonatomic, assign) CGFloat additionalBottomOffsetForInfinityScrollTrigger;

@property (nonatomic, assign) BOOL callInfiniteScrollActionImmediately;

- (instancetype)initWithHeight:(CGFloat)height scrollView:(UIScrollView *)scrollView;

- (void)beginInfiniteScrolling;
- (void)endInfiniteScrolling;
- (void)endInfiniteScrollingWithStoppingContentOffset:(BOOL)stopContentOffset;
@end
