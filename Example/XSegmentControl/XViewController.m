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
    [_segControl setItemTitles:@[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"]];
    [self.view addSubview:_segControl];
}

#pragma mark - XSegmentControlDelegate
- (BOOL)segmentControlWillSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"segmentControlWillSelectItemAtIndex:%ld", index);
    return YES;
}

- (void)segmentControlDidSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"segmentControlDidSelectItemAtIndex:%ld", index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
