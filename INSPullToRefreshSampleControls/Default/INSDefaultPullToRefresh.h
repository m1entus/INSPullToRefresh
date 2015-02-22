//
//  INSDefaultPullToRefresh.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INSRefreshable.h"

@interface INSDefaultPullToRefresh : UIView <INSRefreshable>

- (instancetype)initWithFrame:(CGRect)frame backImage:(UIImage *)backCircleImage frontImage:(UIImage *)frontCircleImage;

@end
