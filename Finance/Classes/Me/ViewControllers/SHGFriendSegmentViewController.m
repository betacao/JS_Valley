//
//  SHGFriendSegmentViewController.m
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGFriendSegmentViewController.h"
#import "SHGSegmentTitleView.h"

@interface SHGFriendSegmentViewController ()

@end

@implementation SHGFriendSegmentViewController

- (void)viewDidLoad
{
    [super initView];
    [super viewDidLoad];
}

- (void)initView
{
    WEAK(self, weakSelf);
    SHGSegmentTitleView *titleView = [[SHGSegmentTitleView alloc] init];
    titleView.margin = MarginFactor(28.0f);
    titleView.titleArray = @[@"关注", @"粉丝", @"名片"];
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
