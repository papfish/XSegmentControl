# XSegmentControl

[![CI Status](http://img.shields.io/travis/xuliang2015/XSegmentControl.svg?style=flat)](https://travis-ci.org/xuliang2015/XSegmentControl)
[![Version](https://img.shields.io/cocoapods/v/XSegmentControl.svg?style=flat)](http://cocoapods.org/pods/XSegmentControl)
[![License](https://img.shields.io/cocoapods/l/XSegmentControl.svg?style=flat)](http://cocoapods.org/pods/XSegmentControl)
[![Platform](https://img.shields.io/cocoapods/p/XSegmentControl.svg?style=flat)](http://cocoapods.org/pods/XSegmentControl)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XSegmentControl is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'XSegmentControl'
```

## Usage

```
// 1. create
_segControl = [[XSegmentControl alloc] initWithFrame:CGRectMake(0, 0, 375, 44)];
_segControl.delegate = self;
_segControl.backgroundColor = [UIColor whiteColor];
_segControl.separatorColor = [UIColor clearColor];
[_segControl setItemTitles:@[@"hello", @"world"]];
[self.view addSubview:_segControl];

......

// 2. delegate
#pragma mark - XSegmentControlDelegate
- (BOOL)segmentControlWillSelectItemAtIndex:(NSInteger)index
{
    return YES;
}

- (void)segmentControlDidSelectItemAtIndex:(NSInteger)index
{
    
}
```

## Author

xuliang2015, liang.xv@qq.com

## License

XSegmentControl is available under the MIT license. See the LICENSE file for more info.
