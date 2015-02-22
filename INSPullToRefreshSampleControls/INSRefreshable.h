//
//  INSRefreshable.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//
#import "UIScrollView+INSPullToRefresh.h"

@protocol INSRefreshable
- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state;
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state;
@end