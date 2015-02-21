//
//  INSPullToRefresh.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 19.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INSPullToRefreshBackgroundView.h"

@interface INSPullToRefresh : UIView
- (void)startAnimating;
- (void)stopAnimating;

- (void)handleProgress:(CGFloat)progress inState:(INSPullToRefreshBackgroundViewState)state;
@end
