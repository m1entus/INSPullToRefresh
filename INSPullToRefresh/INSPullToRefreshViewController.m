//
//  ViewController.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSPullToRefreshViewController.h"
#import "UIScrollView+INSPullToRefresh.h"
#import "INSInfiniteIndicator.h"
#import "INSPullToRefresh.h"

@interface INSPullToRefreshViewController () <UITableViewDataSource, UITableViewDelegate, INSPullToRefreshBackgroundViewDelegate, INSInfinityScrollBackgroundViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, strong) INSPullToRefresh *pullToRefresh;
@end

@implementation INSPullToRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.numberOfRows = 15;

//    self.tableView.contentInset = UIEdgeInsetsMake(100.0f, 0.0f, 100.0f, 0.0f);

    [self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [scrollView ins_endPullToRefresh];

        });
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] init];

//    self.tableView.ins_pullToRefreshBackgroundView.backgroundColor = [UIColor blackColor];
    self.tableView.ins_pullToRefreshBackgroundView.preserveContentInset = NO;
    self.tableView.ins_pullToRefreshBackgroundView.delegate = self;

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

    INSInfiniteIndicator *infinityIndicator = [[INSInfiniteIndicator alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.tableView.ins_infinityScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];

//    self.tableView.ins_infinityScrollBackgroundView.backgroundColor = [UIColor blackColor];
    self.tableView.ins_infinityScrollBackgroundView.preserveContentInset = YES;
    self.tableView.ins_infinityScrollBackgroundView.delegate = self;
//    self.tableView.ins_infinityScrollBackgroundView.additionalBottomOffsetForInfinityScrollTrigger = 600;

    self.pullToRefresh = [[INSPullToRefresh alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:self.pullToRefresh];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
////        [self.tableView ins_beginPullToRefresh];
//        [self.tableView ins_beginInfinityScroll];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [self.tableView ins_beginInfinityScroll];
//            [self.tableView ins_beginPullToRefresh];
//        });
//    });

}

#pragma mark - UITableViewDataSource

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

    cell.textLabel.text = NSLocalizedString(@"Pull!", nil);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"push" sender:self];
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state {
    NSLog(@"CHANGED STATE TO %lu",state);
    if (state == INSPullToRefreshBackgroundViewStateNone) {
        [self.pullToRefresh stopAnimating];
    } else if (state == INSPullToRefreshBackgroundViewStateLoading){
        [self.pullToRefresh startAnimating];
    }
}

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress {
    NSLog(@"CHANGED PROGRESS TO %f",progress);
    [self.pullToRefresh handleProgress:progress inState:pullToRefreshBackgroundView.state];
}

- (void)infinityScrollBackgroundView:(INSInfinityScrollBackgroundView *)infinityScrollBackgroundView didChangeState:(INSInfinityScrollBackgroundViewState)state {
    NSLog(@"CHANGED STATE TO %lu",state);
}

- (void)dealloc {
    [self.tableView ins_removeInfinityScroll];
    [self.tableView ins_removePullToRefresh];
}

@end
