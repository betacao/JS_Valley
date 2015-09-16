//
//  BaseNavigationController.m
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"
@interface BaseNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, weak) UIViewController *currentShowVC;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置导航title字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kNavBarTitleFontSize],NSForegroundColorAttributeName:NavRTitleColor}];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"2f2727"]] forBarMetrics:UIBarMetricsDefault];
   
    //    设置导航栏不透明
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        self.navigationBar.translucent = NO;

    }
    else
    {
        [UINavigationBar appearance].translucent = NO;
    }
   // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_navbar.png"] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];

    // Do any additional setup after loading the view.
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    BaseNavigationController *nav = [super initWithRootViewController:rootViewController];
    nav.interactivePopGestureRecognizer.delegate = self;
    nav.delegate = self;
    return nav;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (1 == navigationController.viewControllers.count) {
        self.currentShowVC = nil;
    } else {
        self.currentShowVC = viewController;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController);
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
