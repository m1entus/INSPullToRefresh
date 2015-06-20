//
//  UIView+INSFirstReponder.h
//  INSPullToRefresh
//
//  Created by Michal Zaborowski on 20.06.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (INSFirstReponder)
- (UIViewController *)ins_firstResponderViewController;
@end
