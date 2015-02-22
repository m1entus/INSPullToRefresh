//
//  INSLabelPullToRefresh.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 22.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+INSPullToRefresh.h"

@interface INSLabelPullToRefresh : UIView <INSPullToRefreshBackgroundViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame noneStateText:(NSString *)noneState triggeredStateText:(NSString *)triggered loadingStateText:(NSString *)loadingState;
@end
