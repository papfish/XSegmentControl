//
//  XSegmentControl.m
//  x
//
//  Created by x on 2017/7/20.
//  Copyright © 2017 x. All rights reserved.
//

#import "XSegmentControl.h"

#define XSegmentControlBtnTag 10000

@interface XSegmentControl()

// Save the item of the array.
@property (nonatomic, strong) NSMutableArray *items;

// Indicator at the bottom of the line.
@property (nonatomic, strong) UIView *indicatorView;

@end

@implementation XSegmentControl

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInitData];
        [self customInitUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInitData];
        [self customInitUI];
    }
    return self;
}

#pragma mark - Init Data
- (void)customInitData
{
    _items = [NSMutableArray array];
}

#pragma mark - Init UI
- (void)customInitUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectedColor = [UIColor redColor];
    self.unselectedColor = [UIColor grayColor];
    self.separatorColor = [UIColor lightGrayColor];
}

// Set item titles array
- (void)setItemTitles:(NSArray *)itemTitles
{
    _itemTitles = itemTitles;
    
    [self setupItems];
}

- (void)setupItems
{
    if (_itemTitles.count > 0) {
        
        // items array remove all object
        [_items removeAllObjects];
        
        NSInteger count = _itemTitles.count;
        
        // item width
        CGFloat itemW = self.bounds.size.width/count;
        // item height
        CGFloat itemH = self.bounds.size.height;
        
        for (NSInteger i = 0; i < count; i ++) {
            NSString *title = [_itemTitles objectAtIndex:i];
            
            // item button
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:itemBtn];
            itemBtn.frame = CGRectMake(itemW * i, 0, itemW, itemH);
            [itemBtn setTitle:title forState:UIControlStateNormal];
            [itemBtn setTitleColor:self.unselectedColor forState:UIControlStateNormal];
            [itemBtn setTitleColor:self.selectedColor forState:UIControlStateSelected];
            [itemBtn setTitleColor:self.selectedColor forState:UIControlStateHighlighted];
            [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [itemBtn addTarget:self action:@selector(segmentControlItemClick:) forControlEvents:UIControlEventTouchUpInside];
            [itemBtn setTag:XSegmentControlBtnTag + i];
            [_items addObject:itemBtn];
            
            // default selected button
            if (i == 0) {
                itemBtn.selected = YES;
            }else {
                itemBtn.selected = NO;
            }
            // default selected index
            _selectedIndex = 0;
            _lastSelectedIndex = 0;
            
            // add vertical separator line
            if (i != 0) {
                UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, itemH)];
                vLine.backgroundColor = self.separatorColor;
                [itemBtn addSubview:vLine];
            }
        }
        
        // indicator view
        CGFloat indicatorW = itemW/2;
        CGFloat indicatorH = 3;
        CGFloat indicatorX = (itemW - indicatorW)/2;
        CGFloat indicatorY = itemH - indicatorH;
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(indicatorX , indicatorY, indicatorW, indicatorH)];
        _indicatorView.backgroundColor = self.selectedColor;
        [self addSubview:_indicatorView];
        
        // add bottom separartor line
        UIView *bottomSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        bottomSeparatorLine.backgroundColor = self.separatorColor;
        [self addSubview:bottomSeparatorLine];
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

// Item will be selected
- (void)segmentControlItemWillSelect:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    // selected index
    NSInteger index = sender.tag - XSegmentControlBtnTag;
    
    // will selected
    if (_delegate && [_delegate respondsToSelector:@selector(segmentControlWillSelectItemAtIndex:)]) {
        BOOL shouldSelected = [_delegate segmentControlWillSelectItemAtIndex:index];
        if (!shouldSelected) {
            return;
        }
    }
    
    // last selected index
    for (UIButton *btn in _items) {
        if (btn.selected) {
            _lastSelectedIndex = btn.tag - XSegmentControlBtnTag;
            break;
        }
    }
    
    // item select with animation
    _selectedIndex = index;
    [self segmentControlItemDidSelect:sender];
    
    // did selected
    if (_delegate && [_delegate respondsToSelector:@selector(segmentControlDidSelectItemAtIndex:)]) {
        [_delegate segmentControlDidSelectItemAtIndex:index];
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
    
    // position animation
    CGFloat dx = sender.center.x - _indicatorView.center.x;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_indicatorView.layer.position.x);
    positionAnimation.toValue = @(_indicatorView.layer.position.x + dx);
    positionAnimation.duration = 0.2;
    [_indicatorView.layer addAnimation:positionAnimation forKey:@"basic"];
    
    // keep frame
    _indicatorView.layer.position = CGPointMake(_indicatorView.layer.position.x + dx, _indicatorView.layer.position.y);
}

@end