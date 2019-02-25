//
//  XViewController.m
//  XSegmentControl
//
//  Created by xuliang2015 on 04/17/2018.
//  Copyright (c) 2018 xuliang2015. All rights reserved.
//

#import "XViewController.h"
#import <XSegmentControl/XSegmentControl.h>

@interface XViewController ()<XSegmentControlDelegate>

@property (nonatomic, strong) XSegmentControl *segControl;
@property (nonatomic, strong) XSegmentControl *segControl2;
@property (nonatomic, strong) XSegmentControl *segControl3;

@end

@implementation XViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _segControl = [[XSegmentControl alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 44)];
    _segControl.delegate = self;
    _segControl.separatorColor = [UIColor clearColor];
    _segControl.selectedColor = [UIColor orangeColor];
    _segControl.unselectedColor = [UIColor grayColor];
    _segControl.titleFont = [UIFont boldSystemFontOfSize:12];
    [_segControl setItemTitles:@[@"January", @"February", @"March", @"April", @"May"]];
    [self.view addSubview:_segControl];
    
    _segControl2 = [[XSegmentControl alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 44)];
    _segControl2.delegate = self;
    _segControl2.separatorColor = [UIColor clearColor];
    _segControl2.selectedColor = [UIColor orangeColor];
    _segControl2.unselectedColor = [UIColor grayColor];
    _segControl2.titleFont = [UIFont boldSystemFontOfSize:12];
    [_segControl2 setItemTitles:@[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"] segmentWidthStyle:XSegmentWidthStyle_EqualText segmentIndicatorStyle:XSegmentIndicatorStyle_Slide];
    [self.view addSubview:_segControl2];
    
    _segControl3 = [[XSegmentControl alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 44)];
    _segControl3.delegate = self;
    _segControl3.separatorColor = [UIColor clearColor];
    _segControl3.selectedColor = [UIColor orangeColor];
    _segControl3.unselectedColor = [UIColor grayColor];
    _segControl3.titleFont = [UIFont boldSystemFontOfSize:12];
    [_segControl3 setItemTitles:@[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"] segmentWidthStyle:XSegmentWidthStyle_EqualText segmentIndicatorStyle:XSegmentIndicatorStyle_Zoom];
    [self.view addSubview:_segControl3];
}

#pragma mark - XSegmentControlDelegate
- (BOOL)segmentControl:(XSegmentControl *)segmentControl willSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"segmentControl:%@ willSelectItemAtIndex:%ld", segmentControl, index);
    return YES;
}

- (void)segmentControl:(XSegmentControl *)segmentControl didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"segmentControl:%@ didSelectItemAtIndex:%ld", segmentControl, index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
