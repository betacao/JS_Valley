//
//  SHGActionSegmentViewController.m
//  Finance
//
//  Created by changxicao on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSegmentViewController.h"
#import "SHGActionManager.h"
#import "VerifyIdentityViewController.h"

@interface SHGActionSegmentViewController ()

@end

@implementation SHGActionSegmentViewController
{
    UISegmentedControl *tabButtonsContainerView;
    UIView *contentContainerView;
}
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;


+ (instancetype)sharedSegmentController
{
    static SHGActionSegmentViewController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonItem];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect rect = CGRectMake(0, 50, 170, 26);
    tabButtonsContainerView = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"所有活动", @"我的活动", nil]];
    tabButtonsContainerView.frame = rect;
    tabButtonsContainerView.enabled = YES;
    tabButtonsContainerView.layer.masksToBounds = YES;
    tabButtonsContainerView.layer.cornerRadius = 4;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 57, 67),NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];

    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];
    //设置标题的颜色 字体和大小 阴影和阴影颜色
    [tabButtonsContainerView setTitleTextAttributes:dic1 forState:UIControlStateSelected];
    [tabButtonsContainerView setTitleTextAttributes:dic forState:UIControlStateNormal];
    tabButtonsContainerView.tintColor = [UIColor clearColor];
    tabButtonsContainerView.layer.borderColor =  [RGB(255, 56, 67) CGColor];
    tabButtonsContainerView.layer.borderWidth = 1.0;
    UIImage *segImage = [CommonMethod imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)];
    UIImage *selectImage = [CommonMethod imageWithColor:RGB(255, 56, 67) andSize:CGSizeMake(85, 26)];
    [tabButtonsContainerView setBackgroundImage:segImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [tabButtonsContainerView setBackgroundImage:selectImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [tabButtonsContainerView setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [tabButtonsContainerView setBackgroundImage:selectImage forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    tabButtonsContainerView.selected = NO;
    tabButtonsContainerView.selectedSegmentIndex = 0;

    [tabButtonsContainerView addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = tabButtonsContainerView;

    contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentContainerView];
    [self reloadTabButtons];
}

- (void)loadUserPermissionStatefinishBlock:(void (^)(BOOL))block
{
    [[SHGActionManager shareActionManager] loadUserPermissionState:^(NSString *state) {
        if ([state isEqualToString:@"0"]) {
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您当前有活动正在审核中，请等待审核后再提交，谢谢。" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            block(NO);
        } else if ([state isEqualToString:@"2"]){
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"您当前有活动申请被驳回，请至我的活动查看。" leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            block(NO);
        } else{
            block(YES);
        }
    }];
}


- (UIBarButtonItem *)rightBarButtonItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectZero];
    UIImage *image = [UIImage imageNamed:@"right_add"];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addNewAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    return  [[UIBarButtonItem alloc] initWithCustomView:rightButton];

}

- (void)addNewAction:(UIButton *)button
{
    [self loadUserPermissionStatefinishBlock:^(BOOL success) {
        if (success) {
            __weak typeof(self)weakSelf = self;
            [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
                if (status) {
                    if([weakSelf.selectedViewController respondsToSelector:@selector(addNewAction:)]){
                        [weakSelf.selectedViewController performSelector:@selector(addNewAction:) withObject:button];
                    }
                } else{
                    VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            } failString:@"认证后才能发起活动哦～"];
        }
    }];
}

- (void)reloadTabButtons
{
    NSUInteger lastIndex = _selectedIndex;
    _selectedIndex = NSNotFound;
    self.selectedIndex = lastIndex;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
    NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");

    UIViewController *oldSelectedViewController = self.selectedViewController;

    // This follows the same rules as UITabBarController for trying to
    // re-select the previously selected view controller.
    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
    if (newIndex != NSNotFound)
        _selectedIndex = newIndex;
    else if (newIndex < [_viewControllers count])
        _selectedIndex = newIndex;
    else
        _selectedIndex = 0;

    // Remove the old child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }

    _viewControllers = [newViewControllers copy];

    // Add the new child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }

    if ([self isViewLoaded])
        [self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    [self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
    NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    if (![self isViewLoaded]){
        _selectedIndex = newSelectedIndex;
    }
    else if (_selectedIndex != newSelectedIndex){
        UIViewController *fromViewController;
        UIViewController *toViewController;

        if (_selectedIndex != NSNotFound){
            fromViewController = self.selectedViewController;
        }

        NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;

        if (_selectedIndex != NSNotFound){
            toViewController = self.selectedViewController;
        }

        if (toViewController == nil){  // don't animate
            [fromViewController.view removeFromSuperview];
        } else if (fromViewController == nil){  // don't animate
            dispatch_async(dispatch_get_main_queue(), ^{
                toViewController.view.frame = contentContainerView.bounds;
                [contentContainerView addSubview:toViewController.view];
            });
        } else if (animated){
            CGRect rect = contentContainerView.bounds;
            if (oldSelectedIndex < newSelectedIndex)
                rect.origin.x = rect.size.width;
            else
                rect.origin.x = -rect.size.width;

            toViewController.view.frame = rect;
            tabButtonsContainerView.userInteractionEnabled = NO;

            [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.3 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect rect = fromViewController.view.frame;
                if (oldSelectedIndex < newSelectedIndex){
                    rect.origin.x = -rect.size.width;
                } else{
                    rect.origin.x = rect.size.width;
                }
                fromViewController.view.frame = rect;
                toViewController.view.frame = contentContainerView.bounds;
            } completion:^(BOOL finished){
                tabButtonsContainerView.userInteractionEnabled = YES;
            }];
        } else{ // not animated
            [fromViewController.view removeFromSuperview];
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
        }
    }
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex != NSNotFound)
        return [self.viewControllers objectAtIndex:self.selectedIndex];
    else
        return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
    [self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
    NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
    if (index != NSNotFound)
        [self setSelectedIndex:index animated:animated];
}

- (void)valueChange:(UISegmentedControl *)seg
{
    [self setSelectedIndex:seg.selectedSegmentIndex animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tabButtonsContainerView = nil;
    contentContainerView = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark ------创建活动的代理

- (void)didCreateNewAction
{
    UIViewController *controller = [self.viewControllers lastObject];
    if ([controller respondsToSelector:@selector(refreshData)]) {
        [controller performSelector:@selector(refreshData)];
    }
}

- (void)refreshData
{

}

#pragma mark ------ 点赞和取消点赞
- (void)addOrDeletePraise:(SHGActionObject *)object block:(void (^)(BOOL success))block
{
    __weak typeof(self)weakSelf = self;
    if ([object.isPraise isEqualToString:@"N"]) {
        [[SHGActionManager shareActionManager] addPraiseWithObject:object finishBlock:^(BOOL success) {
            [weakSelf didChangePraiseState:object isPraise:YES];
            if (block) {
                block(success);
            }
        }];
    } else{
        [[SHGActionManager shareActionManager] deletePraiseWithObject:object finishBlock:^(BOOL success) {
            [weakSelf didChangePraiseState:object isPraise:NO];
            if (block) {
                block(success);
            }
        }];
    }
}

#pragma mark ------ 点赞状态改变

- (void)didChangePraiseState:(SHGActionObject *)object isPraise:(BOOL)isPraise
{
    for (UIViewController *controller in self.viewControllers){
        if ([controller respondsToSelector:@selector(currentDataArray)]) {
            NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
            for (SHGActionObject * obj in array){
                if ([object.meetId isEqualToString:obj.meetId]) {
                    obj.isPraise = isPraise ? @"Y" : @"N";
                    if (isPraise) {

                        obj.praiseNum = [NSString stringWithFormat:@"%ld",(long)[obj.praiseNum integerValue] + 1];
                        
                    } else{
                        obj.praiseNum = [NSString stringWithFormat:@"%ld",(long)[obj.praiseNum integerValue] - 1];

                    }
                    break;
                }
            }
        }
        [controller performSelector:@selector(reloadData)];
    }

}

- (void)didCommentAction:(SHGActionObject *)object
{
    for (UIViewController *controller in self.viewControllers){
        if ([controller respondsToSelector:@selector(currentDataArray)]) {
            NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
            for (SHGActionObject * obj in array){
                if ([object.meetId isEqualToString:obj.meetId]) {
                    obj.commentNum = [NSString stringWithFormat:@"%ld",(long)[obj.commentNum integerValue] + 1];
                    break;
                }
            }
        }
        [controller performSelector:@selector(reloadData)];
    }
}

@end
