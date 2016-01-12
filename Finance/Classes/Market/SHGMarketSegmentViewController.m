//
//  SHGMarketSegmentViewController.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSegmentViewController.h"
#import "SHGMarketSendViewController.h"
#import "SHGMarketSearchViewController.h"
#import "SHGMarketManager.h"

@interface SHGMarketSegmentViewController ()
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@end

@implementation SHGMarketSegmentViewController
{
    UISegmentedControl *tabButtonsContainerView;
    UIView *contentContainerView;
}
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;


+ (instancetype)sharedSegmentController
{
    static SHGMarketSegmentViewController *sharedGlobleInstance = nil;
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

    tabButtonsContainerView = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"全部", @"我的", nil]];
    tabButtonsContainerView.frame = CGRectMake(0.0f, 50.0f, 170.0f, 26.0f);;
    tabButtonsContainerView.enabled = YES;
    tabButtonsContainerView.layer.masksToBounds = YES;
    tabButtonsContainerView.layer.cornerRadius = 4;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"d53432"],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];

    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:17],NSFontAttributeName ,nil];
    //设置标题的颜色 字体和大小 阴影和阴影颜色
    [tabButtonsContainerView setTitleTextAttributes:dic1 forState:UIControlStateNormal];
    [tabButtonsContainerView setTitleTextAttributes:dic forState:UIControlStateSelected];
    tabButtonsContainerView.tintColor = [UIColor clearColor];
    tabButtonsContainerView.layer.borderColor =  [UIColor whiteColor].CGColor;
    tabButtonsContainerView.layer.borderWidth = 1.0;
    UIImage *segImage = [CommonMethod imageWithColor:[UIColor colorWithHexString:@"d53432"] andSize:CGSizeMake(85, 26)];
    UIImage *selectImage = [CommonMethod imageWithColor:[UIColor whiteColor] andSize:CGSizeMake(85, 26)];
    [tabButtonsContainerView setBackgroundImage:segImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    [tabButtonsContainerView setBackgroundImage:selectImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];

    [tabButtonsContainerView setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"d53432"] andSize:CGSizeMake(85, 26)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];


    tabButtonsContainerView.selected = NO;
    tabButtonsContainerView.selectedSegmentIndex = 0;

    [tabButtonsContainerView addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];

    contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentContainerView.backgroundColor = [UIColor whiteColor];
    contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:contentContainerView];
    [self reloadTabButtons];

    if(self.block){
        self.block(tabButtonsContainerView);
    }
}


- (UIBarButtonItem *)rightBarButtonItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectZero];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [rightButton sizeToFit];
    [rightButton addTarget:self action:@selector(addNewMarket:) forControlEvents:UIControlEventTouchUpInside];    return  [[UIBarButtonItem alloc] initWithCustomView:rightButton];

}

- (UIBarButtonItem *)leftBarButtonItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectZero];
    UIImage *image = [UIImage imageNamed:@"marketSearch"];
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(searchMarket:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    return  [[UIBarButtonItem alloc] initWithCustomView:leftButton];

}
- (void)searchMarket:(UIButton *)button
{
    [MobClick event:@"ActionMarketSearchClicked" label:@"onClick"];
    SHGMarketSearchViewController *controller = [[SHGMarketSearchViewController alloc] init];
    controller.dataArr = ((BaseTableViewController *)[self.viewControllers firstObject]).dataArr;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)addNewMarket:(UIButton *)button
{
    [MobClick event:@"ActionCreateMarketClicked" label:@"onClick"];
    SHGMarketSendViewController *controller = [[SHGMarketSendViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
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


#pragma mark ------ 点赞和取消点赞
- (void)addOrDeletePraise:(SHGMarketObject *)object block:(void (^)(BOOL success))block
{
    __weak typeof(self)weakSelf = self;
    if ([object.isPraise isEqualToString:@"N"]) {
        [SHGMarketManager addPraiseWithObject:object finishBlock:^(BOOL success) {
            [weakSelf didChangePraiseState:object isPraise:YES];
            if (block) {
                block(success);
            }
        }];
    } else{
        [SHGMarketManager deletePraiseWithObject:object finishBlock:^(BOOL success) {
            [weakSelf didChangePraiseState:object isPraise:NO];
            if (block) {
                block(success);
            }
        }];
    }
}

#pragma mark ------ 点赞状态改变

- (void)didChangePraiseState:(SHGMarketObject *)object isPraise:(BOOL)isPraise
{
    for (UIViewController *controller in self.viewControllers){
        if ([controller respondsToSelector:@selector(currentDataArray)]) {
            NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
            for (SHGMarketObject * obj in array){
                if ([object.marketId isEqualToString:obj.marketId]) {
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

- (void)didCommentAction:(SHGMarketObject *)object
{
    for (UIViewController *controller in self.viewControllers){
        if ([controller respondsToSelector:@selector(currentDataArray)]) {
            NSMutableArray *array = [controller performSelector:@selector(currentDataArray)];
            for (SHGMarketObject * obj in array){
                if ([object.marketId isEqualToString:obj.marketId]) {
                    obj.commentNum = [NSString stringWithFormat:@"%ld",(long)[obj.commentNum integerValue] + 1];
                    break;
                }
            }
        }
        [controller performSelector:@selector(reloadData)];
    }
}

- (void)didCreateNewMarket
{

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
@end
