//
//  XSegmentControl.m
//  x
//
//  Created by x on 2017/7/20.
//  Copyright © 2017 x. All rights reserved.
//

#import "XSegmentControl.h"

static NSInteger const XSegmentControlButtonTag = 80000;
static NSInteger const XSegmentControlButtonSeperatorTag = 90000;

@interface XSegmentControl()

// The item title of the array, can only be NSStrings.
@property (nonatomic, strong) NSArray<NSString *> *itemTitles;

// The segment style.
@property (nonatomic, assign) XSegmentWidthStyle widthStyle;
@property (nonatomic, assign) XSegmentIndicatorStyle indicatorStyle;

// Save the item of the array.
@property (nonatomic, strong) NSMutableArray<UIButton *> *items;

// The scrollable background view.
@property (nonatomic, strong) UIScrollView *scrollView;

// Indicator at the bottom of the line.
@property (nonatomic, strong) UIView *indicatorView;

// The separator line at the bottom.
@property (nonatomic, strong) UIView *bottomSeparatorLine;

@end

@implementation XSegmentControl

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInitData];
        [self customInitUI];
    }
    return self;
}

- (void)customInitData
{
    _items = [NSMutableArray array];
}

- (void)customInitUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectedColor = [UIColor redColor];
    self.unselectedColor = [UIColor grayColor];
    self.separatorColor = [UIColor lightGrayColor];
    self.titleFont = [UIFont systemFontOfSize:15];
    self.itemScale = 1.3;
    self.itemSpace = 8.0;
}

#pragma mark - UI Setting
- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    
    // update color
    if (_separatorColor) {
        for (UIButton *item in _items) {
            UIView *vSeparatorLine = [item viewWithTag:XSegmentControlButtonSeperatorTag];
            if (vSeparatorLine) {
                vSeparatorLine.backgroundColor = _separatorColor;
            }
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    
    // update color
    if (_selectedColor) {
        for (UIButton *item in _items) {
            [item setTitleColor:_selectedColor forState:UIControlStateSelected];
            [item setTitleColor:_selectedColor forState:UIControlStateHighlighted];
        }
    }
    if (_indicatorView) {
        _indicatorView.backgroundColor = _selectedColor;
    }
}

- (void)setUnselectedColor:(UIColor *)unselectedColor {
    _unselectedColor = unselectedColor;
    
    if (_unselectedColor) {
        // update color
        for (UIButton *item in _items) {
            [item setTitleColor:_unselectedColor forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    
    // update font
    if (_titleFont) {
        for (UIButton *item in _items) {
            [item.titleLabel setFont:_titleFont];
        }
    }
}

// Set item titles array
- (void)setItemTitles:(NSArray<NSString *> *)itemTitles
{
    [self setItemTitles:itemTitles segmentWidthStyle:XSegmentWidthStyle_EqualEach segmentIndicatorStyle:XSegmentIndicatorStyle_Slide];
}

- (void)setItemTitles:(NSArray<NSString *> *)itemTitles segmentWidthStyle:(XSegmentWidthStyle)widthStyle segmentIndicatorStyle:(XSegmentIndicatorStyle)indicatorStyle {
    
    _itemTitles = itemTitles;
    _widthStyle = widthStyle;
    _indicatorStyle = indicatorStyle;
    
    [self setupItems];
}

- (void)setupItems
{
    if (!_itemTitles || _itemTitles.count == 0) return;
    
    // items array remove all object
    [_items removeAllObjects];
    
    // scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    NSInteger count = _itemTitles.count;
    
    // item width, default
    CGFloat itemW = self.bounds.size.width/count;
    // item height
    CGFloat itemH = self.bounds.size.height;
    
    // total width
    CGFloat totalWidth = 0;
    
    for (NSInteger i = 0; i < count; i ++) {
        NSString *title = [_itemTitles objectAtIndex:i];
        
        // The width of the item is equal to text.
        if (_widthStyle == XSegmentWidthStyle_EqualText) {
            itemW = [self widthOfText:title textFont:self.titleFont textHeight:itemH];
            itemW += (self.itemSpace * 2);
        }
        
        // item button
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scrollView addSubview:itemBtn];
        itemBtn.frame = CGRectMake(totalWidth, 0, itemW, itemH);
        [itemBtn setTitle:title forState:UIControlStateNormal];
        [itemBtn setTitleColor:self.unselectedColor forState:UIControlStateNormal];
        [itemBtn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        [itemBtn setTitleColor:self.selectedColor forState:UIControlStateHighlighted];
        [itemBtn.titleLabel setFont:self.titleFont];
        [itemBtn addTarget:self action:@selector(segmentControlItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemBtn setTag:XSegmentControlButtonTag + i];
        [_items addObject:itemBtn];
        
        // default selected button
        itemBtn.selected = (i == 0);
        
        // default selected index
        _selectedIndex = 0;
        _lastSelectedIndex = 0;
        
        // add vertical separator line
        if (i != 0) {
            UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.itemSpace, 1, itemH - (self.itemSpace * 2))];
            vLine.backgroundColor = self.separatorColor;
            vLine.tag = XSegmentControlButtonSeperatorTag;
            [itemBtn addSubview:vLine];
        }
        
        // total width
        totalWidth += itemW;
    }
    
    // scroll view content size
    [_scrollView setContentSize:CGSizeMake(totalWidth, itemH)];
    
    // zoom style
    UIButton *firstItemBtn = [_items firstObject];
    if (_indicatorStyle == XSegmentIndicatorStyle_Zoom) {
        firstItemBtn.transform = CGAffineTransformMakeScale(self.itemScale, self.itemScale);
    }else {
        // indicator view, default frame
        CGFloat firstItemWidth = CGRectGetWidth(firstItemBtn.frame);
        CGFloat indicatorW = firstItemWidth/2;
        CGFloat indicatorH = 3;
        CGFloat indicatorX = (firstItemWidth - indicatorW)/2;
        CGFloat indicatorY = itemH - indicatorH;
        
        if (_widthStyle == XSegmentWidthStyle_EqualText) {
            indicatorW = firstItemWidth - (self.itemSpace * 2);
            indicatorX = self.itemSpace;
        }
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(indicatorX , indicatorY, indicatorW, indicatorH)];
        _indicatorView.backgroundColor = self.selectedColor;
        [_scrollView addSubview:_indicatorView];
    }
}

#pragma mark - item click event
- (void)segmentControlItemClick:(UIButton *)sender
{
    [self segmentControlItemWillSelect:sender];
}

// Set the selected item with index
- (void)selectItemWithIndex:(NSInteger)index
{
    if (index < _items.count) {
        UIButton *itemBtn = [_items objectAtIndex:index];
        [self segmentControlItemWillSelect:itemBtn];
    }
}

#pragma mark - XSegmentControlDelegate
// Item will be selected
- (void)segmentControlItemWillSelect:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    // selected index
    NSInteger index = sender.tag - XSegmentControlButtonTag;
    
    // will selected
    if (_delegate && [_delegate respondsToSelector:@selector(segmentControl:willSelectItemAtIndex:)]) {
        BOOL shouldSelected = [_delegate segmentControl:self willSelectItemAtIndex:index];
        if (!shouldSelected) {
            return;
        }
    }
    
    // last selected index
    for (UIButton *btn in _items) {
        if (btn.selected) {
            _lastSelectedIndex = btn.tag - XSegmentControlButtonTag;
            break;
        }
    }
    
    // item select with animation
    _selectedIndex = index;
    [self segmentControlItemDidSelect:sender];
    
    // did selected
    if (_delegate && [_delegate respondsToSelector:@selector(segmentControl:didSelectItemAtIndex:)]) {
        [_delegate segmentControl:self didSelectItemAtIndex:index];
    }
}

// Item select with animation
- (void)segmentControlItemDidSelect:(UIButton *)sender
{
    // set button selected
    for (UIButton *btn in _items) {
        btn.selected = NO;
    }
    sender.selected = YES;
    
    // scroll view offset
    if (_widthStyle == XSegmentWidthStyle_EqualText) {
        CGFloat offsetX = CGRectGetMidX(sender.frame) - CGRectGetWidth(self.frame)/2;
        if (offsetX < 0) {
            offsetX = 0;
        }
        if (self.scrollView.contentSize.width <= CGRectGetWidth(self.frame)) {
            offsetX = 0;
        }else if (offsetX > self.scrollView.contentSize.width - CGRectGetWidth(self.frame)) {
            offsetX = self.scrollView.contentSize.width - CGRectGetWidth(self.frame);
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    // transform
    if (_indicatorStyle == XSegmentIndicatorStyle_Zoom) {
        UIButton *lastItemBtn = [_items objectAtIndex:_lastSelectedIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                lastItemBtn.transform = CGAffineTransformIdentity;
                sender.transform = CGAffineTransformMakeScale(self.itemScale, self.itemScale);
            }];
        });
    }else {
        __weak typeof(self) wSelf = self;
        // position animation
        CGPoint centerPoint = _indicatorView.center;
        centerPoint.x = sender.center.x;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                wSelf.indicatorView.center = centerPoint;
            }];
        });
        
        if (_widthStyle == XSegmentWidthStyle_EqualText) {
            // width animation
            CGRect bounds = _indicatorView.bounds;
            bounds.size.width = CGRectGetWidth(sender.frame) - (self.itemSpace * 2);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.2 animations:^{
                    wSelf.indicatorView.bounds = bounds;
                }];
            });
        }
    }
}

#pragma mark - Common tool
- (CGFloat)widthOfText:(NSString *)text textFont:(UIFont *)textFont textHeight:(CGFloat)textHeight {
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: textFont} context:nil].size.width;
}

@end
