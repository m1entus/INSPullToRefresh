//
//  ViewController.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSPullToRefreshViewController.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "INSCircleInfiniteIndicator.h"
#import "INSCirclePullToRefresh.h"
#import "INSTwitterPullToRefresh.h"
#import "INSDefaultInfiniteIndicator.h"
#import "INSDefaultPullToRefresh.h"
#import "INSVinePullToRefresh.h"
#import "INSPinterestPullToRefresh.h"
#import "INSLabelPullToRefresh.h"
#import "INSLappsyPullToRefresh.h"
#include "INSLappsyInfiniteIndicator.h"

@interface INSPullToRefreshViewController () <UITableViewDataSource, UITableViewDelegate, INSPullToRefreshBackgroundViewDelegate, INSInfiniteScrollBackgroundViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) UIView <INSRefreshable> *pullToRefresh;
@end

@implementation INSPullToRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    // Do any additional setup after loading the view, typically from a nib.
    self.numberOfRows = 15;

    if (self.style == INSPullToRefreshStylePreserveContentInset) {
        self.tableView.contentInset = UIEdgeInsetsMake(100.0f, 0.0f, 100.0f, 0.0f);
    }


    [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [scrollView ins_endPullToRefresh];

        });
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    self.tableView.ins_pullToRefreshBackgroundView.preserveContentInset = NO;
    if (self.style == INSPullToRefreshStylePreserveContentInset) {
        self.tableView.ins_pullToRefreshBackgroundView.preserveContentInset = YES;
    }

    self.tableView.ins_pullToRefreshBackgroundView.delegate = self;

    if (self.style == INSPullToRefreshStyleText) {
        self.tableView.ins_pullToRefreshBackgroundView.dragToTriggerOffset = 60.0;
    }

    [self.tableView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {

        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            [self.tableView beginUpdates];

            self.numberOfRows += 15;
            NSMutableArray* newIndexPaths = [NSMutableArray new];

            for(NSInteger i = self.numberOfRows - 15; i < self.numberOfRows; i++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [newIndexPaths addObject:indexPath];
            }

            [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];


            [self.tableView endUpdates];

            [scrollView ins_endInfinityScroll];
        });
    }];

    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [self.tableView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];

    self.tableView.ins_infiniteScrollBackgroundView.preserveContentInset = NO;

    if (self.style == INSPullToRefreshStylePreserveContentInset) {
        self.tableView.ins_infiniteScrollBackgroundView.preserveContentInset = YES;
    }


    self.pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:self.pullToRefresh];

}

- (UIView <INSRefreshable> *)pullToRefreshViewFromCurrentStyle {

    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);

    switch (self.style) {
        case INSPullToRefreshStyleCircle:
            return [[INSCirclePullToRefresh alloc] initWithFrame:defaultFrame];
            break;
        case INSPullToRefreshStyleTwitter:
            return [[INSTwitterPullToRefresh alloc] initWithFrame:defaultFrame];
            break;
        case INSPullToRefreshStyleFacebook:
            return [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:nil frontImage:[UIImage imageNamed:@"iconFacebook"]];
            break;
        case INSPullToRefreshStyleLappsy:
            return [[INSLappsyPullToRefresh alloc] initWithFrame:defaultFrame];
        case INSPullToRefreshStylePinterest:
            return [[INSPinterestPullToRefresh alloc] initWithFrame:defaultFrame logo:[UIImage imageNamed:@"iconPinterestLogo"] backImage:[UIImage imageNamed:@"iconPinterestCircleLight"] frontImage:[UIImage imageNamed:@"iconPinterestCircleDark"]];
            break;
        case INSPullToRefreshStyleVine:
            return [[INSVinePullToRefresh alloc] initWithFrame:defaultFrame];
        case INSPullToRefreshStyleText:
            return [[INSLabelPullToRefresh alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60.0) noneStateText:@"Pull to refresh" triggeredStateText:@"Release to refresh" loadingStateText:@"Loading..."];
        default:
            return [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:[UIImage imageNamed:@"circleLight"] frontImage:[UIImage imageNamed:@"circleDark"]];
            break;
    }
}

- (UIView <INSAnimatable> *)infinityIndicatorViewFromCurrentStyle {

    CGRect defaultFrame = CGRectMake(0, 0, 24, 24);

    switch (self.style) {
        case INSPullToRefreshStyleCircle:
            return [[INSCircleInfiniteIndicator alloc] initWithFrame:defaultFrame];
            break;
            case INSPullToRefreshStyleLappsy:
            return [[INSLappsyInfiniteIndicator alloc] initWithFrame:defaultFrame];
        default:
            return [[INSDefaultInfiniteIndicator alloc] initWithFrame:defaultFrame];
            break;
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
    }

    cell.textLabel.text = NSLocalizedString(@"Cell", nil);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.style == INSPullToRefreshStyleText) {
        if (scrollView.contentOffset.y <= -200) {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -200);
        }
    }
}

#pragma mark - <INSPullToRefreshBackgroundViewDelegate>

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    [self.pullToRefresh handleStateChange:state];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    [self.pullToRefresh handleProgress:progress forState:pullToRefreshBackgroundView.state];
}

#pragma mark - dealloc

- (void)dealloc {
    [self.tableView ins_removeInfinityScroll];
    [self.tableView ins_removePullToRefresh];
}

@end
