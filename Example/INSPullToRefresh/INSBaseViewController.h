//
//  INSBaseViewController.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 22.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+INSPullToRefresh.h"
#import "INSAnimatable.h"

typedef NS_ENUM(NSUInteger, INSPullToRefreshStyle){
    INSPullToRefreshStyleDefault = 0,
    INSPullToRefreshStyleCircle,
    INSPullToRefreshStyleTwitter,
    INSPullToRefreshStyleFacebook,
    INSPullToRefreshStyleLappsy,
    INSPullToRefreshStyleVine,
    INSPullToRefreshStylePinterest,
    INSPullToRefreshStyleText,
    INSPullToRefreshStylePreserveContentInset
};

@interface INSBaseViewController : UIViewController
@property (nonatomic, assign) INSPullToRefreshStyle style;

- (UIView <INSPullToRefreshBackgroundViewDelegate> *)pullToRefreshViewFromCurrentStyle;
- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle;
@end
