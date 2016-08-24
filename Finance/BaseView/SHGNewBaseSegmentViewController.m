//
//  SHGNewBaseSegmentViewController.m
//  Finance
//
//  Created by changxicao on 16/8/24.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGNewBaseSegmentViewController.h"

@interface SHGNewBaseSegmentViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation SHGNewBaseSegmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self addAutoLayout];
}

- (void)initView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;

    UIView *lastView = nil;
    for (UIViewController *viewController in self.viewControllers) {
        [self addChildViewController:viewController];
        [self.scrollView addSubview:viewController.view];
        viewController.view.sd_layout
        .leftSpaceToView(lastView ? lastView : self.scrollView, 0.0f)
        .topSpaceToView(self.scrollView, 0.0f)
        .bottomSpaceToView(self.scrollView, 0.0f)
        .widthIs(SCREENWIDTH);
        lastView = viewController.view;
    }
    [self.scrollView setContentSize:CGSizeMake(self.viewControllers.count * SCREENWIDTH, 0.0f)];
    [self.view addSubview:self.scrollView];
    [self resetView];
}

- (void)addAutoLayout
{
    self.scrollView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
}

- (void)resetView
{
    self.selectedIndex = 0;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    for (UIViewController *viewController in self.viewControllers) {
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
    _viewControllers = viewControllers;

    [self resetView];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;
{
    if (self.selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    CGPoint point = CGPointMake(selectedIndex * SCREENWIDTH, 0);
    [self.scrollView setContentOffset:point animated:animated];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = (NSInteger)(floorf(scrollView.contentOffset.x / SCREENWIDTH));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
