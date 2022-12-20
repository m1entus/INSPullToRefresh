//
//  INSDefaultInfiniteIndicator.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "INSAnimatable.h"

@interface INSDefaultInfiniteIndicator : UIView <INSAnimatable>
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign, readonly) BOOL isAnimating;
@end
