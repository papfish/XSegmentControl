//
//  XSegmentControl.h
//  x
//
//  Created by x on 2017/7/20.
//  Copyright © 2017 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XSegmentControl;
@protocol XSegmentControlDelegate <NSObject>

@optional
// The item will be selected.
- (BOOL)segmentControl:(XSegmentControl *)segmentControl willSelectItemAtIndex:(NSInteger)index;

// The item did selected.
- (void)segmentControl:(XSegmentControl *)segmentControl didSelectItemAtIndex:(NSInteger)index;

@end

// Default, each item width is equal.
typedef NS_ENUM(NSUInteger, XSegmentWidthStyle) {
    XSegmentWidthStyle_EqualEach,   // Default.
    XSegmentWidthStyle_EqualText    // Item width is equal to text.
};

// Default, a slide view on the bottom.
typedef NS_ENUM(NSUInteger, XSegmentIndicatorStyle) {
    XSegmentIndicatorStyle_Slide,   // Default
    XSegmentIndicatorStyle_Zoom
};

@interface XSegmentControl : UIView

// Set the delegate.
@property (nonatomic, weak) id<XSegmentControlDelegate> delegate;

// The color of the separator line.
@property (nonatomic, strong) UIColor *separatorColor;

// The color of the selected status.
@property (nonatomic, strong) UIColor *selectedColor;

// The color of the unselected status.
@property (nonatomic, strong) UIColor *unselectedColor;

// The title font of the selected & unselected status. Default is `[UIFont systemFontOfSize:15]`.
@property (nonatomic, strong) UIFont *titleFont;

// The scale of the selected status. When the width style is equal text. Default is 1.3
@property (nonatomic, assign) CGFloat itemScale;

// The space between the items. Default is 8.0
@property (nonatomic, assign) CGFloat itemSpace;

// The selected index of the segment control, readonly.
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

// The last selected index of the segment control, readonly.
@property (nonatomic, assign, readonly) NSInteger lastSelectedIndex;

// Init with Frame
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

// The item title of the array, can only be NSStrings.
- (void)setItemTitles:(NSArray<NSString *> *)itemTitles;

// The item title of the array, can only be NSStrings.
- (void)setItemTitles:(NSArray<NSString *> *)itemTitles segmentWidthStyle:(XSegmentWidthStyle)widthStyle segmentIndicatorStyle:(XSegmentIndicatorStyle)indicatorStyle;

// Set the selected item with index.
- (void)selectItemWithIndex:(NSInteger)index;

@end


