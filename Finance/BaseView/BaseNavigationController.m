//
//  BaseNavigationController.m
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "SHGBusinessNewDetailViewController.h"
#import "SHGNewUserCenterViewController.h"

@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, weak) UIViewController *currentShowVC;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏不透明
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        self.navigationBar.translucent = NO;
    } else{
        [UINavigationBar appearance].translucent = NO;
    }
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    BaseNavigationController *nav = [super initWithRootViewController:rootViewController];
    nav.interactivePopGestureRecognizer.delegate = self;
    nav.delegate = self;
    return nav;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[SHGBusinessNewDetailViewController class]] || ([viewController isKindOfClass:[TabBarViewController class]] && [TabBarViewController tabBar].selectedIndex == 3)) {
        [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(navigationController.viewControllers.count == 1) {
        self.currentShowVC = nil;
    } else {
        self.currentShowVC = viewController;
    }
    if (![viewController isKindOfClass:[SHGBusinessNewDetailViewController class]] && !([viewController isKindOfClass:[TabBarViewController class]] && [TabBarViewController tabBar].selectedIndex == 3)) {
        [self.navigationBar setShadowImage:nil];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController && self.interactivePopGestureRecognizer.enabled);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
