//
//  SHGDynamicCollectionViewController.m
//  Finance
//
//  Created by changxicao on 16/8/9.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGDynamicCollectionViewController.h"
#import "SHGSegmentTitleView.h"

@interface SHGDynamicCollectionViewController ()

@property (strong, nonatomic) UIView *contentContainerView;

@end

@implementation SHGDynamicCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self reloadTabButtons];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];

    WEAK(self, weakSelf);
    SHGSegmentTitleView *titleView = [[SHGSegmentTitleView alloc] init];
    titleView.margin = MarginFactor(33.0f);
    titleView.titleArray = @[@"我的发布", @"我的收藏"];
    titleView.block = ^(NSInteger index){
        [weakSelf setSelectedIndex:index animated:YES];
    };
    self.navigationItem.titleView = titleView;

    self.contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.contentContainerView];
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
    for (UIViewController *viewController in _viewControllers) {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }

    _viewControllers = [newViewControllers copy];

    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
    if (newIndex != NSNotFound) {
        _selectedIndex = newIndex;
    } else if (newIndex < [_viewControllers count]) {
        _selectedIndex = newIndex;
    } else {
        _selectedIndex = 0;
    }

    for (UIViewController *viewController in _viewControllers) {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }

    if ([self isViewLoaded]) {
        [self reloadTabButtons];
    }
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    [self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
    NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

    if (![self isViewLoaded]) {
        _selectedIndex = newSelectedIndex;
    } else if (_selectedIndex != newSelectedIndex) {
        UIViewController *fromViewController;
        UIViewController *toViewController;

        if (_selectedIndex != NSNotFound) {
            fromViewController = self.selectedViewController;
        }

        NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;

        if (_selectedIndex != NSNotFound) {
            toViewController = self.selectedViewController;
        }

        if (toViewController == nil) {
            [fromViewController.view removeFromSuperview];
        } else if (fromViewController == nil) {
            toViewController.view.frame = self.contentContainerView.bounds;
            [self.contentContainerView addSubview:toViewController.view];
        } else if (animated) {
            CGRect rect = self.contentContainerView.bounds;
            if (oldSelectedIndex < newSelectedIndex) {
                rect.origin.x = rect.size.width;
            } else {
                rect.origin.x = -rect.size.width;
            }

            toViewController.view.frame = rect;

            [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.25f options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut animations:^{
                CGRect rect = fromViewController.view.frame;
                if (oldSelectedIndex < newSelectedIndex){
                    rect.origin.x = -rect.size.width;
                } else{
                    rect.origin.x = rect.size.width;
                }
                fromViewController.view.frame = rect;
                toViewController.view.frame = self.contentContainerView.bounds;
            } completion:^(BOOL finished){

            }];
        } else {
            [fromViewController.view removeFromSuperview];
            toViewController.view.frame = self.contentContainerView.bounds;
            [self.contentContainerView addSubview:toViewController.view];
        }
    }
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex != NSNotFound) {
        return [self.viewControllers objectAtIndex:self.selectedIndex];
    } else {
        return nil;
    }
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
    [self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
    NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
    if (index != NSNotFound) {
        [self setSelectedIndex:index animated:animated];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
