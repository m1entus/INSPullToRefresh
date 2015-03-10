//
//  ViewController.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSPullToRefreshViewController.h"
#import "UIScrollView+INSPullToRefresh.h"


@interface INSPullToRefreshViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSUInteger numberOfRows;
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

    if (self.style == INSPullToRefreshStyleText) {
        self.tableView.ins_pullToRefreshBackgroundView.dragToTriggerOffset = 60.0;
    }

    __weak typeof(self) weakSelf = self;
    
    [self.tableView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {
        
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakSelf.tableView beginUpdates];
            
            weakSelf.numberOfRows += 15;
            NSMutableArray* newIndexPaths = [NSMutableArray new];
            
            for(NSInteger i = weakSelf.numberOfRows - 15; i < weakSelf.numberOfRows; i++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [newIndexPaths addObject:indexPath];
            }
            
            [weakSelf.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
            
            
            [weakSelf.tableView endUpdates];
            
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

    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];

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
#pragma mark - dealloc

- (void)dealloc {
    [self.tableView ins_removeInfinityScroll];
    [self.tableView ins_removePullToRefresh];
}

@end
