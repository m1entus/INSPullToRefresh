//
//  INSPinterestPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSPinterestPullToRefresh.h"

#define degreesToRadians(x) ((x) * M_PI / 180.0)

@interface INSPinterestPullToRefresh ()
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) CAShapeLayer *backCircleLayer;
@property (nonatomic, strong) CAShapeLayer *frontCircleLayer;
@property (nonatomic, strong) CAShapeLayer *pieLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation INSPinterestPullToRefresh

- (instancetype)initWithFrame:(CGRect)frame logo:(UIImage *)logo backImage:(UIImage *)backCircleImage frontImage:(UIImage *)frontCircleImage {
    if (self = [super initWithFrame:frame]) {
        self.logoImageView = [[UIImageView alloc] initWithFrame:frame];
        self.logoImageView.image = logo;
        [self addSubview:self.logoImageView];

        _backCircleLayer = [CAShapeLayer layer];
        _frontCircleLayer = [CAShapeLayer layer];
        _pieLayer = [CAShapeLayer layer];

        [self.layer addSublayer:_backCircleLayer];
        [self.layer addSublayer:_frontCircleLayer];
        [self.layer addSublayer:_pieLayer];

        self.backCircleLayer.contents = (__bridge id)[backCircleImage CGImage];
        self.frontCircleLayer.contents = (__bridge id)[frontCircleImage CGImage];
        self.frontCircleLayer.mask = _pieLayer;

        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicator.hidden = YES;
        [self addSubview:_activityIndicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
    self.backCircleLayer.frame = self.bounds;
    self.frontCircleLayer.frame = self.bounds;
    self.pieLayer.frame = self.bounds;
}

- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state {
    if (progress > 0 && state != INSPullToRefreshBackgroundViewStateLoading) {
        self.frontCircleLayer.hidden = NO;
        self.backCircleLayer.hidden = NO;
        self.pieLayer.hidden = NO;
        self.logoImageView.hidden = NO;

        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

        if (progress >= 1) {
            [self updatePie:self.pieLayer forAngle:359.99f];
        } else {
            [self updatePie:self.pieLayer forAngle:progress * 360.0f];
        }


        self.frontCircleLayer.mask = self.pieLayer;
        self.logoImageView.alpha = progress;

        [CATransaction commit];

        self.logoImageView.transform = CGAffineTransformMakeRotation(degreesToRadians(progress * 360.0f));
    }


}
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone || state == INSPullToRefreshBackgroundViewStateTriggered) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.activityIndicator.alpha = 0.0;

        } completion:nil];

        [self updatePie:self.pieLayer forAngle:0];
        self.frontCircleLayer.mask = self.pieLayer;
    } else {
        self.frontCircleLayer.hidden = YES;
        self.backCircleLayer.hidden = YES;
        self.pieLayer.hidden = YES;
        self.logoImageView.hidden = YES;
        self.activityIndicator.alpha = 1.0;
        [self.activityIndicator startAnimating];
    }
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

#pragma mark - Private Methods

- (void)updatePie:(CAShapeLayer *)layer forAngle:(CGFloat)degrees {
    CGFloat angle = degreesToRadians(-90);
    CGPoint center_ = CGPointMake(CGRectGetWidth(layer.frame)/2.0, CGRectGetWidth(layer.frame)/2.0);
    CGFloat radius = CGRectGetWidth(layer.frame)/2.0;

    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center_];
    [piePath addLineToPoint:CGPointMake(center_.x, center_.y - radius)];
    [piePath addArcWithCenter:center_ radius:radius startAngle:angle endAngle:degreesToRadians(360 - degrees - 90.0f) clockwise:NO];
    [piePath addLineToPoint:center_];
    [piePath closePath];
    
    layer.path = piePath.CGPath;
}

@end
