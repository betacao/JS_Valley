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

    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
    [SHGGlobleOperation registerPraiseClass:[self class] method:@selector(loadPraiseState:praiseState:)];
    [SHGGlobleOperation registerDeleteClass:[self class] method:@selector(loadDelete:)];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    SHGSegmentTitleView *titleView = (SHGSegmentTitleView *)self.navigationItem.titleView;
    titleView.selectedIndex = selectedIndex;
}

- (void)loadAttationState:(NSString *)targetUserID attationState:(NSNumber *)attationState
{
    for (UIViewController *controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(loadAttationState:attationState:)]) {
            [controller performSelector:@selector(loadAttationState:attationState:) withObject:targetUserID withObject:attationState];
        }
    }
}

- (void)loadPraiseState:(NSString *)targetID praiseState:(NSNumber *)praiseState
{
    for (UIViewController *controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(loadPraiseState:praiseState:)]) {
            [controller performSelector:@selector(loadPraiseState:praiseState:) withObject:targetID withObject:praiseState];
        }
    }
}

- (void)loadDelete:(NSString *)targetID
{
    for (UIViewController *controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(loadDelete:)]) {
            [controller performSelector:@selector(loadDelete:) withObject:targetID];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
