//
//  INSInfinityScrollBackgroundView.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 19.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^INSInfinityScrollActionHandler)(UIScrollView *scrollView);

typedef NS_ENUM(NSUInteger, INSInfinityScrollBackgroundViewState) {
    INSInfinityScrollBackgroundViewStateNone = 0,
    INSInfinityScrollBackgroundViewStateLoading,
};

@class INSInfinityScrollBackgroundView;

@protocol INSInfinityScrollBackgroundViewDelegate <NSObject>
@optional
- (void)infinityScrollBackgroundView:(INSInfinityScrollBackgroundView *)infinityScrollBackgroundView didChangeState:(INSInfinityScrollBackgroundViewState)state;
@end

@interface INSInfinityScrollBackgroundView : UIView
@property (nonatomic, copy) INSInfinityScrollActionHandler actionHandler;
@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) id <INSInfinityScrollBackgroundViewDelegate> delegate;

@property (nonatomic, readonly) INSInfinityScrollBackgroundViewState state;
@property (nonatomic, assign) BOOL preserveContentInset;

@property (nonatomic, assign) CGFloat additionalBottomOffsetForInfinityScrollTrigger;

- (instancetype)initWithHeight:(CGFloat)height scrollView:(UIScrollView *)scrollView;

- (void)beginInfiniteScrolling;
- (void)endInfiniteScrolling;
@end
