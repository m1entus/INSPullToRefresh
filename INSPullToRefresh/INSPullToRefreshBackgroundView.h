//
//  INSPullToRefreshBackgroundView.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^INSPullToRefreshActionHandler)(UIScrollView *scrollView);

typedef NS_ENUM(NSUInteger, INSPullToRefreshBackgroundViewState) {
    INSPullToRefreshBackgroundViewStateNone = 0,
    INSPullToRefreshBackgroundViewStateTriggered,
    INSPullToRefreshBackgroundViewStateLoading,
};

@class INSPullToRefreshBackgroundView;

@protocol INSPullToRefreshBackgroundViewDelegate <NSObject>
@optional
- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state;

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress;

@end

@interface INSPullToRefreshBackgroundView : UIView

@property (nonatomic, copy) INSPullToRefreshActionHandler actionHandler;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) id <INSPullToRefreshBackgroundViewDelegate> delegate;

@property (nonatomic, readonly) INSPullToRefreshBackgroundViewState state;
@property (nonatomic, assign) BOOL preserveContentInset;

- (instancetype)initWithHeight:(CGFloat)height scrollView:(UIScrollView *)scrollView;

- (void)beginRefreshing;
- (void)endRefreshing;
@end
