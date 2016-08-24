//
//  SHGBusinessSegmentViewController.m
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessSegmentViewController.h"
#import "SHGSegmentTitleView.h"
#import "SHGBusinessMineViewController.h"

@interface SHGBusinessSegmentViewController ()

@end

@implementation SHGBusinessSegmentViewController

- (void)viewDidLoad
{
    [super initView];
    [super viewDidLoad];
}

- (void)didCreateOrModifyBusiness
{
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[SHGBusinessMineViewController class]]){
            [(SHGBusinessMineViewController *)viewController didCreateOrModifyBusiness];
        }
    }
}

- (void)deleteBusinessWithBusinessID:(NSString *)businessID
{
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:[SHGBusinessMineViewController class]]){
            [(SHGBusinessMineViewController *)viewController deleteBusinessWithBusinessID:businessID];
        }
    }
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

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    SHGSegmentTitleView *titleView = (SHGSegmentTitleView *)self.navigationItem.titleView;
    titleView.selectedIndex = selectedIndex;
}

- (void)btnBackClick:(id)sender
{
    [self.navigationController popToViewController:[TabBarViewController tabBar] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
