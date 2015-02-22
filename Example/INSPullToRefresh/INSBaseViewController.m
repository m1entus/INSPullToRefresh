//
//  INSBaseViewController.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 22.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSBaseViewController.h"
#import "INSCircleInfiniteIndicator.h"
#import "INSCirclePullToRefresh.h"
#import "INSTwitterPullToRefresh.h"
#import "INSDefaultInfiniteIndicator.h"
#import "INSDefaultPullToRefresh.h"
#import "INSVinePullToRefresh.h"
#import "INSPinterestPullToRefresh.h"
#import "INSLabelPullToRefresh.h"
#import "INSLappsyPullToRefresh.h"
#include "INSLappsyInfiniteIndicator.h"

@interface INSBaseViewController ()

@end

@implementation INSBaseViewController


- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle {

    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);

    switch (self.style) {
        case INSPullToRefreshStyleCircle:
            return [[INSCirclePullToRefresh alloc] initWithFrame:defaultFrame];
            break;
        case INSPullToRefreshStyleTwitter:
            return [[INSTwitterPullToRefresh alloc] initWithFrame:defaultFrame];
            break;
        case INSPullToRefreshStyleFacebook:
            return [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:nil frontImage:[UIImage imageNamed:@"iconFacebook"]];
            break;
        case INSPullToRefreshStyleLappsy:
            return [[INSLappsyPullToRefresh alloc] initWithFrame:defaultFrame];
        case INSPullToRefreshStylePinterest:
            return [[INSPinterestPullToRefresh alloc] initWithFrame:defaultFrame logo:[UIImage imageNamed:@"iconPinterestLogo"] backImage:[UIImage imageNamed:@"iconPinterestCircleLight"] frontImage:[UIImage imageNamed:@"iconPinterestCircleDark"]];
            break;
        case INSPullToRefreshStyleVine:
            return [[INSVinePullToRefresh alloc] initWithFrame:defaultFrame];
        case INSPullToRefreshStyleText:
            return [[INSLabelPullToRefresh alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60.0) noneStateText:@"Pull to refresh" triggeredStateText:@"Release to refresh" loadingStateText:@"Loading..."];
        default:
            return [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:[UIImage imageNamed:@"circleLight"] frontImage:[UIImage imageNamed:@"circleDark"]];
            break;
    }
}

- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle {

    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);

    switch (self.style) {
        case INSPullToRefreshStyleCircle:
            return [[INSCircleInfiniteIndicator alloc] initWithFrame:defaultFrame];
            break;
        case INSPullToRefreshStyleLappsy:
            return [[INSLappsyInfiniteIndicator alloc] initWithFrame:defaultFrame];
        default:
            return [[INSDefaultInfiniteIndicator alloc] initWithFrame:defaultFrame];
            break;
    }
}

@end
