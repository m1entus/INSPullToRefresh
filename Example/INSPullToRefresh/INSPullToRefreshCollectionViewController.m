//
//  INSPullToRefreshCollectionViewController.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 22.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSPullToRefreshCollectionViewController.h"

@interface INSPullToRefreshCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat numberOfRows;
@end

@implementation INSPullToRefreshCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    // Do any additional setup after loading the view, typically from a nib.
    self.numberOfRows = 15;

    if (self.style == INSPullToRefreshStylePreserveContentInset) {
        self.collectionView.contentInset = UIEdgeInsetsMake(100.0f, 0.0f, 100.0f, 0.0f);
    }


    [self.collectionView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [scrollView ins_endPullToRefresh];

        });
    }];

    self.collectionView.ins_pullToRefreshBackgroundView.preserveContentInset = NO;
    if (self.style == INSPullToRefreshStylePreserveContentInset) {
        self.collectionView.ins_pullToRefreshBackgroundView.preserveContentInset = YES;
    }

    if (self.style == INSPullToRefreshStyleText) {
        self.collectionView.ins_pullToRefreshBackgroundView.dragToTriggerOffset = 60.0;
    }

    __weak typeof(self) weakSelf = self;
    
    [self.collectionView ins_addInfinityScrollWithHeight:60 handler:^(UIScrollView *scrollView) {
        
        int64_t delayInSeconds = 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [weakSelf.collectionView performBatchUpdates:^{
                weakSelf.numberOfRows += 15;
                NSMutableArray* newIndexPaths = [NSMutableArray new];
                
                for(NSInteger i = weakSelf.numberOfRows - 15; i < weakSelf.numberOfRows; i++) {
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [newIndexPaths addObject:indexPath];
                }
                [weakSelf.collectionView insertItemsAtIndexPaths:newIndexPaths];
                
            } completion:nil];
            
            [scrollView ins_endInfinityScroll];
            
        });
    }];

    UIView <INSAnimatable> *infinityIndicator = [self infinityIndicatorViewFromCurrentStyle];
    [self.collectionView.ins_infiniteScrollBackgroundView addSubview:infinityIndicator];
    [infinityIndicator startAnimating];

    self.collectionView.ins_infiniteScrollBackgroundView.preserveContentInset = NO;

    if (self.style == INSPullToRefreshStylePreserveContentInset) {
        self.collectionView.ins_infiniteScrollBackgroundView.preserveContentInset = YES;
    }

    UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [self pullToRefreshViewFromCurrentStyle];
    self.collectionView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
    [self.collectionView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfRows;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
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
    [self.collectionView ins_removeInfinityScroll];
    [self.collectionView ins_removePullToRefresh];
}

@end
