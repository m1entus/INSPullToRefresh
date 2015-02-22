//
//  INSVinePullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 21.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSVinePullToRefresh.h"

@interface INSVinePullToRefresh ()
@property (weak, nonatomic) IBOutlet UIImageView *topArrow;
@property (weak, nonatomic) IBOutlet UIImageView *middleArrow;
@property (weak, nonatomic) IBOutlet UIImageView *bottomArrow;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation INSVinePullToRefresh

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];

        [self addSubview:self.contentView];
        self.contentView.frame = self.bounds;

        self.topArrow.alpha = 0.0;
        self.middleArrow.alpha = 0.0;
        self.bottomArrow.alpha = 0.0;

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
    self.contentView.frame = self.bounds;

}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone) {
        self.bottomArrow.alpha = progress*2 < 1 ? progress*2 : 1;
        self.bottomArrow.transform = CGAffineTransformMakeScale(self.bottomArrow.alpha, self.bottomArrow.alpha);

        self.middleArrow.alpha = progress*2 - 0.25 < 1 ? progress*2 - 0.25 : 1;
        self.middleArrow.transform = CGAffineTransformMakeScale(self.middleArrow.alpha, self.middleArrow.alpha);
        self.topArrow.alpha = progress*2 - 0.5 < 1 ? progress*2 - 0.5 : 1;
        self.topArrow.transform = CGAffineTransformMakeScale(self.topArrow.alpha, self.topArrow.alpha);
    }
}
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone || state == INSPullToRefreshBackgroundViewStateTriggered) {

        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.activityIndicator.alpha = 0.0;

        } completion:nil];
    } else {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.topArrow.alpha = 0.0;
            self.topArrow.transform = CGAffineTransformMakeScale(0, 0);
            self.bottomArrow.alpha = 0.0;
            self.bottomArrow.transform = CGAffineTransformMakeScale(0, 0);
            self.middleArrow.alpha = 0.0;
            self.middleArrow.transform = CGAffineTransformMakeScale(0, 0);
            self.activityIndicator.alpha = 1.0;
        } completion:nil];
        [self.activityIndicator startAnimating];
    }
}

@end
