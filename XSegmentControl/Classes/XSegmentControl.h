//
//  XSegmentControl.h
//  x
//
//  Created by x on 2017/7/20.
//  Copyright © 2017 x. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XSegmentControlDelegate <NSObject>

@optional
// The item will be selected.
- (BOOL)segmentControlWillSelectItemAtIndex:(NSInteger)index;

// The item did selected.
- (void)segmentControlDidSelectItemAtIndex:(NSInteger)index;

@end

@interface XSegmentControl : UIView

// Set the delegate.
@property (nonatomic, weak) id<XSegmentControlDelegate> delegate;

// The color of the separator line.
@property (nonatomic, strong) UIColor *separatorColor;

// The color of the selected status.
@property (nonatomic, strong) UIColor *selectedColor;

// The color of the unselected status.
@property (nonatomic, strong) UIColor *unselectedColor;

// The item title of the array, can only be NSStrings.
@property (nonatomic, strong) NSArray *itemTitles;

// The selected index of the segment control, readonly.
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

// The last selected index of the segment control, readonly.
@property (nonatomic, assign, readonly) NSInteger lastSelectedIndex;

// Set the selected item with index.
- (void)selectItemWithIndex:(NSInteger)index;

@end


