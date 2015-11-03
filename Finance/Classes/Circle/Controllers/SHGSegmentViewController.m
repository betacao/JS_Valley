//
//  SHGSegmentViewController.m
//  Finance
//
//  Created by changxicao on 15/11/3.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGSegmentViewController.h"

static const float TAB_BAR_HEIGHT = 44.0f;
static const NSInteger TAG_OFFSET = 1000;

@interface SHGSegmentViewController ()
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, strong) UIView *tabButtonsContainerView;
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@end

@implementation SHGSegmentViewController

- (void)centerIndicatorOnButton:(UIButton *)button
{
    CGRect rect = self.indicatorImageView.frame;
    rect.origin.x = button.center.x - floorf(self.indicatorImageView.frame.size.width/2.0f);
    rect.origin.y = TAB_BAR_HEIGHT - self.indicatorImageView.frame.size.height;
    self.indicatorImageView.frame = rect;
    self.indicatorImageView.hidden = NO;
}

- (void)selectTabButton:(UIButton *)button
{
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    UIImage *image = [[UIImage imageNamed:@"MHTabBarActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}


- (void)deselectTabButton:(UIButton *)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    UIImage *image = [[UIImage imageNamed:@"MHTabBarInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];

    [button setTitleColor:[UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)removeTabButtons
{
    NSArray *buttons = [self.tabButtonsContainerView subviews];
    for (UIButton *button in buttons)
        [button removeFromSuperview];
}

- (void)addTabButtons
{
    NSUInteger index = 0;
    for (UIViewController *viewController in self.viewControllers)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = TAG_OFFSET + index;
        [button setTitle:viewController.title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        button.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [self deselectTabButton:button];
        [self.tabButtonsContainerView addSubview:button];

        ++index;
    }
}

- (void)reloadTabButtons
{
    [self removeTabButtons];
    [self addTabButtons];

    // Force redraw of the previously active tab.
    NSUInteger lastIndex = _selectedIndex;
    _selectedIndex = NSNotFound;
    self.selectedIndex = lastIndex;
}

- (void)layoutTabButtons
{
    NSUInteger index = 0;
    NSUInteger count = [self.viewControllers count];

    CGRect rect = CGRectMake(0, 0, floorf(self.view.bounds.size.width / count), TAB_BAR_HEIGHT);

    self.indicatorImageView.hidden = YES;

    NSArray *buttons = [self.tabButtonsContainerView subviews];
    for (UIButton *button in buttons)
    {
        if (index == count - 1)
            rect.size.width = self.view.bounds.size.width - rect.origin.x;

        button.frame = rect;
        rect.origin.x += rect.size.width;

        if (index == self.selectedIndex)
            [self centerIndicatorOnButton:button];

        ++index;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, TAB_BAR_HEIGHT);
    self.tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
    self.tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tabButtonsContainerView];

    rect.origin.y = TAB_BAR_HEIGHT;
    rect.size.height = self.view.bounds.size.height - TAB_BAR_HEIGHT;
    self.contentContainerView = [[UIView alloc] initWithFrame:rect];
    self.contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.contentContainerView];

    self.indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHTabBarIndicator"]];
    [self.view addSubview:self.indicatorImageView];

    [self reloadTabButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tabButtonsContainerView = nil;
    self.contentContainerView = nil;
    self.indicatorImageView = nil;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self layoutTabButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    for (UIViewController *viewController in self.viewControllers)
    {
        if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
            return NO;
    }
    return YES;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
    NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");

    UIViewController *oldSelectedViewController = self.selectedViewController;

    // Remove the old child view controllers.
    for (UIViewController *viewController in _viewControllers)
    {
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }

    _viewControllers = [newViewControllers copy];

    // This follows the same rules as UITabBarController for trying to
    // re-select the previously selected view controller.
    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
    if (newIndex != NSNotFound)
        _selectedIndex = newIndex;
    else if (newIndex < [_viewControllers count])
        _selectedIndex = newIndex;
    else
        _selectedIndex = 0;

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

    if ([self.delegate respondsToSelector:@selector(SHGTabBarController:shouldSelectViewController:atIndex:)]){
        UIViewController *toViewController = [self.viewControllers objectAtIndex:newSelectedIndex];
        if (![self.delegate SHGTabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
            return;
    }

    if (![self isViewLoaded]){
        _selectedIndex = newSelectedIndex;
    } else if (_selectedIndex != newSelectedIndex){
        UIViewController *fromViewController;
        UIViewController *toViewController;

        if (_selectedIndex != NSNotFound){
            UIButton *fromButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TAG_OFFSET + _selectedIndex];
            [self deselectTabButton:fromButton];
            fromViewController = self.selectedViewController;
        }

        NSUInteger oldSelectedIndex = _selectedIndex;
        _selectedIndex = newSelectedIndex;

        UIButton *toButton;
        if (_selectedIndex != NSNotFound)
        {
            toButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TAG_OFFSET + _selectedIndex];
            [self selectTabButton:toButton];
            toViewController = self.selectedViewController;
        }

        if (toViewController == nil){
            [fromViewController.view removeFromSuperview];
        } else if (fromViewController == nil){
            toViewController.view.frame = self.contentContainerView.bounds;
            [self.contentContainerView addSubview:toViewController.view];
            [self centerIndicatorOnButton:toButton];
            if ([self.delegate respondsToSelector:@selector(SHGTabBarController:didSelectViewController:atIndex:)])
                [self.delegate SGGTabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
        } else if (animated){
            CGRect rect = self.contentContainerView.bounds;
            if (oldSelectedIndex < newSelectedIndex)
                rect.origin.x = rect.size.width;
            else
                rect.origin.x = -rect.size.width;

            toViewController.view.frame = rect;
            self.tabButtonsContainerView.userInteractionEnabled = NO;
            [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.3 options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut animations:^{
                 CGRect rect = fromViewController.view.frame;
                 if (oldSelectedIndex < newSelectedIndex)
                     rect.origin.x = -rect.size.width;
                 else
                     rect.origin.x = rect.size.width;

                 fromViewController.view.frame = rect;
                 toViewController.view.frame = self.contentContainerView.bounds;
                 [self centerIndicatorOnButton:toButton];
             } completion:^(BOOL finished){
                 self.tabButtonsContainerView.userInteractionEnabled = YES;
                 if ([self.delegate respondsToSelector:@selector(SHGTabBarController:didSelectViewController:atIndex:)])
                     [self.delegate SGGTabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
             }];
        }
        else  // not animated
        {
            [fromViewController.view removeFromSuperview];
            
            toViewController.view.frame = self.contentContainerView.bounds;
            [self.contentContainerView addSubview:toViewController.view];
            [self centerIndicatorOnButton:toButton];
            if ([self.delegate respondsToSelector:@selector(SHGTabBarController:didSelectViewController:atIndex:)])
                [self.delegate SGGTabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
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

- (void)tabButtonPressed:(UIButton *)sender
{
    [self setSelectedIndex:sender.tag - TAG_OFFSET animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
