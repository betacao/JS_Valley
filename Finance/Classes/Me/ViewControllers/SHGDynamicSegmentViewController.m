//
//  SHGDynamicSegmentViewController.m
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDynamicSegmentViewController.h"
#import "SHGSegmentTitleView.h"

@interface SHGDynamicSegmentViewController ()


@end

@implementation SHGDynamicSegmentViewController

- (void)viewDidLoad
{
    [super initView];
    [super viewDidLoad];
}

- (void)initView
{
    WEAK(self, weakSelf);
    SHGSegmentTitleView *titleView = [[SHGSegmentTitleView alloc] init];
    titleView.margin = MarginFactor(33.0f);
    titleView.titleArray = @[@"我的发布", @"我的收藏"];
    titleView.block = ^(NSInteger index){
        [weakSelf setSelectedIndex:index animated:YES];
    };
    self.navigationItem.titleView = titleView;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end