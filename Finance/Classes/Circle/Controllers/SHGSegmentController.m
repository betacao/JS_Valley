/*!
 * \file MHTabBarController.m
 *
 * Copyright (c) 2011 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "SHGSegmentController.h"

@interface SHGSegmentController ()
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@end

@implementation SHGSegmentController
{
	UISegmentedControl *tabButtonsContainerView;
	UIView *contentContainerView;
}

@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize delegate = _delegate;


+ (instancetype)sharedSegmentController
{
    static SHGSegmentController *sharedGlobleInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedGlobleInstance = [[self alloc] init];
    });
    return sharedGlobleInstance;
}

- (void)reloadTabButtons
{
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    CGRect rect = CGRectMake(0, 50, 170, 26);
    tabButtonsContainerView = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"动态", @"资讯", nil]];
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

	contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
	contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:contentContainerView];
	[self reloadTabButtons];
    if(self.block){
        self.block(tabButtonsContainerView);
    }
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem)
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"right_send"];
        [rightButton setBackgroundImage:image forState:UIControlStateNormal];
        [rightButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [rightButton addTarget:self action:@selector(actionPost:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton sizeToFit];
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _rightBarButtonItem;
}

- (NSMutableArray *)dataArray
{
    if([self.selectedViewController respondsToSelector:@selector(currentDataArray)]){
        return [self.selectedViewController performSelector:@selector(currentDataArray)];
    }
    return nil;
}

- (NSMutableArray *)listArray
{
    if([self.selectedViewController respondsToSelector:@selector(currentDataArray)]){
        return [self.selectedViewController performSelector:@selector(currentDataArray)];
    }
    return nil;
}

- (void)reloadData
{
    for (UIViewController *controller in self.viewControllers) {
        UITableView *listTable = [controller performSelector:@selector(currentTableView)];
        [listTable reloadData];
    }
}

- (void)reloadDataAtIndexPaths:(NSArray *)indexPaths
{
    for (NSInteger i = 0; i < indexPaths.count; i++) {
        UIViewController *controller =[self.viewControllers objectAtIndex:i];
        UITableView *listTable = [controller performSelector:@selector(currentTableView)];
        [listTable reloadRowsAtIndexPaths:@[[indexPaths objectAtIndex:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)refreshAttaionView
{
    if([[self.viewControllers lastObject] respondsToSelector:@selector(refreshLoad)]){
        [[self.viewControllers lastObject] performSelector:@selector(refreshLoad)];
    }
}

- (void)refreshLoad
{

}

- (void)refreshHomeView
{
    if([[self.viewControllers firstObject] respondsToSelector:@selector(refreshHeader)]){
        [[self.viewControllers firstObject] performSelector:@selector(refreshHeader)];
    }
}

- (void)removeObject:(CircleListObj *)object
{
    [[[self.viewControllers firstObject] performSelector:@selector(currentListArray)] removeObject:object];
    [[[self.viewControllers firstObject] performSelector:@selector(currentDataArray)] removeObject:object];
}

- (void)removeObjects:(NSArray *)array
{
    [[[self.viewControllers lastObject] performSelector:@selector(currentDataArray)] removeObjectsInArray:array];
}

- (NSArray *)targetObjectsByRid:(NSString *)string
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *array1 = [[self.viewControllers firstObject] performSelector:@selector(currentDataArray)];
    NSMutableArray *array2 = [[self.viewControllers lastObject] performSelector:@selector(currentDataArray)];
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *object = (CircleListObj *)obj;
            if([object.rid isEqualToString:string]){
                [result addObject:object];
            }
        }
    }];
    [array2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *object = (CircleListObj *)obj;
            if([object.rid isEqualToString:string]){
                [result addObject:object];
            }
        }
    }];
    return result;
}

- (NSArray *)targetObjectsByUserID:(NSString *)string
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *array1 = [[self.viewControllers firstObject] performSelector:@selector(currentDataArray)];
    NSMutableArray *array2 = [[self.viewControllers lastObject] performSelector:@selector(currentDataArray)];
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *object = (CircleListObj *)obj;
            if([object.userid isEqualToString:string]){
                [result addObject:object];
            }
        }
    }];
    [array2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *object = (CircleListObj *)obj;
            if([object.userid isEqualToString:string]){
                [result addObject:object];
            }
        }
    }];
    return result;
}

- (CircleListObj *)targetObjectByIndex:(NSInteger)index
{
    return [[self.selectedViewController performSelector:@selector(currentDataArray)] objectAtIndex:index];
}

- (NSArray *)indexOfObjectByRid:(NSString *)string
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *array1 = [[self.viewControllers firstObject] performSelector:@selector(currentDataArray)];
    NSMutableArray *array2 = [[self.viewControllers lastObject] performSelector:@selector(currentDataArray)];
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *object = (CircleListObj *)obj;
            if([object.rid isEqualToString:string]){
                [result addObject:@(idx)];
            }
        }
    }];
    [array2 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *object = (CircleListObj *)obj;
            if([object.rid isEqualToString:string]){
                [result addObject:@(idx)];
            }
        }
    }];
    return result;
}

//发布
- (void)actionPost:(UIButton *)button
{
    __weak typeof(self)weakSelf = self;
    [[SHGGloble sharedGloble] requsetUserVerifyStatus:^(BOOL status) {
        if (status) {
            if([weakSelf.selectedViewController respondsToSelector:@selector(actionPost:)]){
                [weakSelf.selectedViewController performSelector:@selector(actionPost:) withObject:button];
            }
        } else{
            VerifyIdentityViewController *controller = [[VerifyIdentityViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    } failString:@"认证后才能发起动态哦～"];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Only rotate if all child view controllers agree on the new orientation.
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

	if ([self.delegate respondsToSelector:@selector(SHG_SegmentController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = [self.viewControllers objectAtIndex:newSelectedIndex];
		if (![self.delegate SHG_SegmentController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}

	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;

		if (_selectedIndex != NSNotFound)
		{
			fromViewController = self.selectedViewController;
		}

		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;

		if (_selectedIndex != NSNotFound)
		{
			toViewController = self.selectedViewController;
		}

		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                toViewController.view.frame = contentContainerView.bounds;
                [contentContainerView addSubview:toViewController.view];
                if ([weakSelf.delegate respondsToSelector:@selector(SHG_SegmentController:didSelectViewController:atIndex:)])
                    [weakSelf.delegate SHG_SegmentController:weakSelf didSelectViewController:toViewController atIndex:newSelectedIndex];
            });
		}
		else if (animated)
		{
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
                if ([self.delegate respondsToSelector:@selector(SHG_SegmentController:didSelectViewController:atIndex:)]){
                    [self.delegate SHG_SegmentController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
                }
            }];
        } else{ // not animated
            [fromViewController.view removeFromSuperview];
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
            if ([self.delegate respondsToSelector:@selector(SHG_SegmentController:didSelectViewController:atIndex:)]){
                [self.delegate SHG_SegmentController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
            }
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

@end
