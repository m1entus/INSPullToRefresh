//
//  INSPinterestPullToRefresh.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+INSPullToRefresh.h"

@interface INSPinterestPullToRefresh : UIView <INSPullToRefreshBackgroundViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame logo:(UIImage *)logo backImage:(UIImage *)backCircleImage frontImage:(UIImage *)frontCircleImage;
@end
