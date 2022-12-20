//
//  INSDefaultInfiniteIndicator.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSDefaultInfiniteIndicator.h"

@interface INSDefaultInfiniteIndicator ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation INSDefaultInfiniteIndicator

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.hidden = YES;
        [self addSubview:_activityIndicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
}


- (void)didMoveToWindow {
    // CoreAnimation animations are removed when view goes offscreen.
    // So we have to restart them when view reappears.
    if(self.window && self.isAnimating) {
        [self startAnimating];
    }
}

- (void)startAnimating {
    self.isAnimating = YES;

    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
}

- (void)stopAnimating {
    self.isAnimating = NO;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

@end
