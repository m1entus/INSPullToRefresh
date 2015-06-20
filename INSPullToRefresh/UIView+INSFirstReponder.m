//
//  UIView+INSFirstReponder.m
//  INSPullToRefresh
//
//  Created by Michal Zaborowski on 20.06.2015.
//  Copyright (c) 2015 inspace.io. All rights reserved.
//

#import "UIView+INSFirstReponder.h"

@implementation UIView (INSFirstReponder)

- (UIViewController *)ins_firstResponderViewController {
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]]) {
        responder = [responder nextResponder];
    }
    
    return (UIViewController *)responder;
}

@end
