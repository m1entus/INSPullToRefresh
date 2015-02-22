//
//  INSTwitterPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSTwitterPullToRefresh.h"

@interface INSTwitterPullToRefresh ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation INSTwitterPullToRefresh

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicator.hidden = YES;
        [self addSubview:_activityIndicator];

        _imageView = [[UIImageView alloc] initWithFrame:frame];
        _imageView.image = [UIImage imageNamed:@"iconTwitter"];
        _imageView.hidden = NO;
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state {
    if (progress > 0 && state == INSPullToRefreshBackgroundViewStateNone) {
        self.imageView.alpha = 1.0;
    }
}
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone) {

        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.activityIndicator.alpha = 0.0;

        } completion:nil];
    } else {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.imageView.alpha = 0.0;
            self.activityIndicator.alpha = 1.0;
        } completion:nil];
        [self.activityIndicator startAnimating];
    }
}

@end
