//
//  INSTableViewController.m
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 20.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "INSTableViewController.h"
#import "INSPullToRefreshViewController.h"

@interface INSTableViewController ()
@property (nonatomic, strong) NSDictionary *dataSource;
@end

@implementation INSTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = @{
                        @"Default" : @(INSPullToRefreshStyleDefault),
                        @"Circle" :@(INSPullToRefreshStyleCircle),
                        @"Twitter" : @(INSPullToRefreshStyleTwitter),
                        @"Facebook" : @(INSPullToRefreshStyleFacebook),
                        @"Lappsy" : @(INSPullToRefreshStyleLappsy),
                        @"Vine" : @(INSPullToRefreshStyleVine),
                        @"Pinterest" : @(INSPullToRefreshStylePinterest),
                        @"Sample Text" : @(INSPullToRefreshStyleText),
                        @"Preserve Content Inset" : @(INSPullToRefreshStylePreserveContentInset)
                        };

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UITableViewCell *cell = sender;
    INSPullToRefreshViewController *destinationVC = segue.destinationViewController;
    destinationVC.style = [self.dataSource[cell.textLabel.text] integerValue];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.allValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    NSArray *dataSource = [self.dataSource.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    cell.textLabel.text = dataSource[indexPath.row];

    return cell;
}

@end
