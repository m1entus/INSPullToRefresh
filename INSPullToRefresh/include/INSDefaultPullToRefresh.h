//
//  INSDefaultPullToRefresh.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+INSPullToRefresh.h"

@interface INSDefaultPullToRefresh : UIView <INSPullToRefreshBackgroundViewDelegate>
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;

- (instancetype)initWithFrame:(CGRect)frame backImage:(UIImage *)backCircleImage frontImage:(UIImage *)frontCircleImage;

@end
