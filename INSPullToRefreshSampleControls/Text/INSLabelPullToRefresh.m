//
//  INSLabelPullToRefresh.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 22.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSLabelPullToRefresh.h"

@interface INSLabelPullToRefresh ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, copy) NSString *noneState;
@property (nonatomic, copy) NSString *triggeredState;
@property (nonatomic, copy) NSString *loadingState;
@end

@implementation INSLabelPullToRefresh

- (instancetype)initWithFrame:(CGRect)frame noneStateText:(NSString *)noneState triggeredStateText:(NSString *)triggered loadingStateText:(NSString *)loadingState {
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:frame];
        _noneState = noneState;
        _triggeredState = triggered;
        _loadingState = loadingState;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, -500 + frame.size.height, frame.size.width, 500)];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.24 green:0.6 blue:0.85 alpha:1];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont fontWithName:@"Avenir" size:16.0];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.text = _noneState;
        [self addSubview:self.contentView];
        [self addSubview:self.label];
    }
    return self;
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

- (void)handleProgress:(CGFloat)progress forState:(INSPullToRefreshBackgroundViewState)state {

}
- (void)handleStateChange:(INSPullToRefreshBackgroundViewState)state {
    if (state == INSPullToRefreshBackgroundViewStateNone) {
        self.label.text = self.noneState;
        self.contentView.backgroundColor = [UIColor colorWithRed:0.24 green:0.6 blue:0.85 alpha:1];
    } else if (state == INSPullToRefreshBackgroundViewStateTriggered) {
        self.label.text = self.triggeredState;
        self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.81 blue:0.19 alpha:1];
    } else {
        self.label.text = self.loadingState;
        self.contentView.backgroundColor = [UIColor colorWithRed:0.75 green:0.2 blue:0.17 alpha:1];
    }
}
@end
