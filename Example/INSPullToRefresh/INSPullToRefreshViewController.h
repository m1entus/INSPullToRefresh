//
//  ViewController.h
//  INSPullToRefresh
//
//  Created by Michał Zaborowski on 18.02.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, INSPullToRefreshStyle){
    INSPullToRefreshStyleDefault = 0,
    INSPullToRefreshStyleCircle,
    INSPullToRefreshStyleTwitter,
    INSPullToRefreshStyleFacebook,
    INSPullToRefreshStyleLappsy,
    INSPullToRefreshStyleVine,
    INSPullToRefreshStylePinterest,
    INSPullToRefreshStyleText,
    INSPullToRefreshStylePreserveContentInset
};

@interface INSPullToRefreshViewController : UIViewController
@property (nonatomic, assign) INSPullToRefreshStyle style;
@end

