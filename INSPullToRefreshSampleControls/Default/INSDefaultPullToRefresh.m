//
//  INSDefaultPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//
////////////////////////////////////////////////////////
//
//  Copyright (c) 2014, Beamly
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of Beamly nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL BEAMLY BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "INSDefaultPullToRefresh.h"

@interface INSDefaultPullToRefresh ()
@property (nonatomic, strong) CAShapeLayer *backCircleLayer;
@property (nonatomic, strong) CAShapeLayer *frontCircleLayer;
@property (nonatomic, strong) CAShapeLayer *pieLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation INSDefaultPullToRefresh

- (instancetype)initWithFrame:(CGRect)frame backImage:(UIImage *)backCircleImage frontImage:(UIImage *)frontCircleImage {
    if (self = [super initWithFrame:frame]) {
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

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state {
    if (progress > 0 && state == INSPullToRefreshBackgroundViewStateNone) {
        self.frontCircleLayer.hidden = NO;
        self.backCircleLayer.hidden = NO;
        self.pieLayer.hidden = NO;
    }

    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

    [self updatePie:self.pieLayer forAngle:progress * 360.0f];
    self.frontCircleLayer.mask = self.pieLayer;

    [CATransaction commit];
}
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.activityIndicator.alpha = 0.0;

        } completion:nil];

        [self updatePie:self.pieLayer forAngle:0];
        self.frontCircleLayer.mask = self.pieLayer;
    } else {
        self.frontCircleLayer.hidden = YES;
        self.backCircleLayer.hidden = YES;
        self.pieLayer.hidden = YES;
        self.activityIndicator.alpha = 1.0;
        [self.activityIndicator startAnimating];
    }
}


#pragma mark - Private Methods

- (void)updatePie:(CAShapeLayer *)layer forAngle:(CGFloat)degrees {
    CGFloat angle = -90 * (M_PI / 180.0);
    CGPoint center_ = CGPointMake(CGRectGetWidth(layer.frame)/2.0, CGRectGetWidth(layer.frame)/2.0);
    CGFloat radius = CGRectGetWidth(layer.frame)/2.0;

    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center_];
    [piePath addLineToPoint:CGPointMake(center_.x, center_.y - radius)];
    [piePath addArcWithCenter:center_ radius:radius startAngle:angle endAngle:(degrees - 90.0f) * (M_PI / 180.0) clockwise:YES];
    [piePath addLineToPoint:center_];
    [piePath closePath];

    layer.path = piePath.CGPath;
}

@end
