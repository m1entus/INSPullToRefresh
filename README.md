[![](http://inspace.io/github-cover.jpg)](http://inspace.io)

# Introduction

**INSPullToRefresh** was written by **[Michał Zaborowski](https://github.com/m1entus)** for **[inspace.io](http://inspace.io)**

# INSPullToRefresh

`INSPullToRefresh` is a simple to use very generic pull-to-refresh and infinite scrolling functionalities as a UIScrollView category.

There are a lot of of pull to refresh views. We've never found one we are happy with. We always end up customizing one, so we decided to write one that's highly generic. You can just write you view and it to the content of pull to refresh or infinite scroll container view.

We wrote couple samples that can be found in popular apps like Facebook, Vine, Twitter etc.

[![](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/animation.gif)](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/animation.gif)
[![](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/animation1.gif)](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/animation1.gif)
[![](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/1.png)](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/1.png)
[![](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/2.png)](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/2.png)
[![](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/3.png)](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/3.png)
[![](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/4.png)](https://raw.github.com/inspace-io/INSPullToRefresh/master/Screens/4.png)


# Known Issue

`automaticallyAdjustsScrollViewInsets` property on UIViewController which is by default to YES is breaking a lot of stuff, so it will be automatically turned off when adding pull to refresh and managed by library manually.

# Usage

Objective-C

```objective-c
[self.tableView ins_addPullToRefreshWithHeight:60.0 handler:^(UIScrollView *scrollView) {
    int64_t delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [scrollView ins_endPullToRefresh];

    });
}];

CGRect defaultFrame = CGRectMake(0, 0, 24, 24);

UIView <INSPullToRefreshBackgroundViewDelegate> *pullToRefresh = [[INSDefaultPullToRefresh alloc] initWithFrame:defaultFrame backImage:[UIImage imageNamed:@"circleLight"] frontImage:[UIImage imageNamed:@"circleDark"]];

self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
[self.tableView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
```

Swift

```swift
self.tableView.ins_addPullToRefreshWithHeight(60.0, handler: { scrollView in
    let delayInSeconds: Int64 = 1
    let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * Int64(NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        scrollView.ins_endPullToRefresh()
    }
    
    let defaultFrame = CGRectMake(0, 0, 24, 24)
    let pullToRefresh = INSDefaultPullToRefresh(frame: defaultFrame, backImage: UIImage(named: "default_child"), frontImage: UIImage(named: "default_user"))
    
    self.tableView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh
    self.tableView.ins_pullToRefreshBackgroundView.addSubview(pullToRefresh)
})
```

All you need to do is handle two INSPullToRefreshBackgroundViewDelegate methods in your custom view.

```objective-c
@protocol INSPullToRefreshBackgroundViewDelegate <NSObject>
@optional
- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeState:(INSPullToRefreshBackgroundViewState)state;

- (void)pullToRefreshBackgroundView:(INSPullToRefreshBackgroundView *)pullToRefreshBackgroundView didChangeTriggerStateProgress:(CGFloat)progress;

@end
```

## CocoaPods

Add the following to your `Podfile` and run `$ pod install`.

``` ruby
pod 'INSPullToRefresh'
```

If you don't have CocoaPods installed, you can learn how to do so [here](http://cocoapods.org).

## ARC

`INSElectronicProgramGuideLayout` uses ARC.

## Contact

[inspace.io](http://inspace.io)

[Twitter](https://twitter.com/inspace_io)

# License

The MIT License (MIT)

Copyright (c) 2015 inspace.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
