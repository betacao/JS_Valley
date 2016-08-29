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
#import "ChatListViewController.h"
#import "ApplyViewController.h"
#import "HeadImage.h"
#import "EMCDDeviceManager.h"
#import "UITabBar+badge.h"
#import "SHGNewUserCenterViewController.h"
#import "SHGCircleSendViewController.h"
#import "SHGCircleCategorySelectView.h"
#import "SHGCircleSearchViewController.h"
#import "SHGHomeCategoryView.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface SHGSegmentController ()<IChatManagerDelegate>

@property (strong, nonatomic) ChatListViewController *chatViewController;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property (strong, nonatomic) UIButton *titleButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *titleImageView;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) SHGCircleCategorySelectView *categorySelectView;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initMessageObject];
    }
    return self;
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
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 57, 67),NSForegroundColorAttributeName,[UIFont systemFontOfSize:kNavBarTitleFontSize],NSFontAttributeName ,nil];

    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:kNavBarTitleFontSize],NSFontAttributeName ,nil];
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
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
    [SHGGlobleOperation registerPraiseClass:[self class] method:@selector(loadPraiseState:praiseState:)];
    [SHGGlobleOperation registerDeleteClass:[self class] method:@selector(loadDelete:)];
        [SHGGlobleOperation registerCollectClass:[self class] method:@selector(loadCollection: collectionState:)];

    [self.categorySelectView addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
    WEAK(self, weakSelf);
    if(self.block){
        self.block(self.titleButton);
    }
    self.categorySelectView.block = ^(NSString *category){
        weakSelf.text = category;
        [SHGHomeCategoryView sharedCategoryView].category = category;
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.categorySelectView.superview) {
        [self.view.window addSubview:self.categorySelectView];
    }
    [self.view.window bringSubviewToFront:self.categorySelectView];
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.backgroundColor = [UIColor clearColor];
        [_titleButton addTarget:self action:@selector(showCircleCategorySelectView:) forControlEvents:UIControlEventTouchUpInside];

        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = FontFactor(17.0f);
        self.titleLabel.textColor = [UIColor whiteColor];
        [_titleButton addSubview:self.titleLabel];

        self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"market_locationArrow"]];
        [self.titleImageView sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + MarginFactor(4.0f), (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        [_titleButton addSubview:self.titleImageView];
    }
    return _titleButton;
}

- (void)loadAttationState:(id)object attationState:(NSNumber *)attationState
{
    [[SHGHomeViewController sharedController] performSelector:@selector(loadAttationState:attationState:) withObject:object withObject:attationState];
    [[SHGHomeCategoryView sharedCategoryView] performSelector:@selector(loadAttationState:attationState:) withObject:object withObject:attationState];
}

- (void)loadPraiseState:(id)object praiseState:(NSNumber *)praiseState
{
    [[SHGHomeViewController sharedController] performSelector:@selector(loadPraiseState:praiseState:) withObject:object withObject:praiseState];
    [[SHGHomeCategoryView sharedCategoryView] performSelector:@selector(loadPraiseState:praiseState:) withObject:object withObject:praiseState];
}

- (void)loadDelete:(NSString *)targetID
{
    [[SHGHomeViewController sharedController] performSelector:@selector(loadDelete:) withObject:targetID];
    [[SHGHomeCategoryView sharedCategoryView] performSelector:@selector(loadDelete:) withObject:targetID];
}

- (void)loadCollection:(id)object collectionState:(NSNumber *)collectionState
{
    [[SHGHomeViewController sharedController] performSelector:@selector(loadCollection:collectionState:) withObject:object withObject:collectionState];
    [[SHGHomeCategoryView sharedCategoryView] performSelector:@selector(loadCollection:collectionState:) withObject:object withObject:collectionState];
}

- (void)initMessageObject
{
    [self registerEaseMobNotification];
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"marketSearch"];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionSearch:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _leftBarButtonItem;
}


- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"sendCard"];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionPost:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    return _rightBarButtonItem;
}

- (ChatListViewController *)chatViewController
{
    if (!_chatViewController){
        _chatViewController = [[ChatListViewController alloc] init];
    }
    return _chatViewController;
}

- (SHGCircleCategorySelectView *)categorySelectView
{
    if (!_categorySelectView) {
        _categorySelectView = [[SHGCircleCategorySelectView alloc] init];
        _categorySelectView.frame = CGRectMake(0.0f, kNavigationBarHeight + kStatusBarHeight, SCREENWIDTH, SCREENHEIGHT - kNavigationBarHeight - kStatusBarHeight);
        _categorySelectView.alpha = 0.0f;
    }
    return _categorySelectView;
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

- (void)setText:(NSString *)text
{
    _text = text;
    if (![text isEqualToString:self.titleLabel.text]) {
        self.titleButton.frame = CGRectMake(2.0f, 0.0f, 0.0f, 0.0f);
        self.titleLabel.text = text;
        self.titleLabel.frame = CGRectMake(MarginFactor(4.0f), 0.0f, 0.0f, 0.0f);
        [self.titleLabel sizeToFit];
        self.titleImageView.origin = CGPointMake(CGRectGetMaxX(self.titleLabel.frame) + MarginFactor(4.0f), (CGRectGetHeight(self.titleLabel.frame) - CGRectGetHeight(self.titleImageView.frame)) / 2.0f);
        self.titleButton.size = CGSizeMake(CGRectGetMaxX(self.titleImageView.frame) + MarginFactor(13.0f), CGRectGetHeight(self.titleLabel.frame));
    }
}

- (void)showCircleCategorySelectView:(UIButton *)button
{
    self.categorySelectView.alpha = 1.0f - self.categorySelectView.alpha;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"alpha"]) {
        NSInteger alpha = [[change objectForKey:@"new"] integerValue];
        if (alpha == 0) {
            self.titleImageView.layer.transform = CATransform3DIdentity;
        } else {
            self.titleImageView.layer.transform = CATransform3DMakeRotation(0.000001 - M_PI, 0.0f, 0.0f, -1.0f);
        }
    }
}

- (void)reloadData
{
    SHGHomeViewController *controller = [SHGHomeViewController sharedController];
    controller.needRefreshTableView = YES;
    
    SEL selector = NSSelectorFromString(@"setNeedRefreshTableView:");
    IMP imp = [[SHGHomeCategoryView sharedCategoryView] methodForSelector:selector];
    void (*func)(id, SEL, BOOL) = (void *)imp;
    func([SHGHomeCategoryView sharedCategoryView], selector, YES);
}

- (void)refreshHomeView
{
    if([[self.viewControllers firstObject] respondsToSelector:@selector(refreshHeader)]){
        [[self.viewControllers firstObject] performSelector:@selector(refreshHeader)];
    }
    [[SHGHomeCategoryView sharedCategoryView] performSelector:@selector(refreshHeader)];
}

- (void)removeObject:(CircleListObj *)object
{
    [[[self.viewControllers firstObject] performSelector:@selector(currentListArray)] removeObject:object];
    [[[self.viewControllers firstObject] performSelector:@selector(currentDataArray)] removeObject:object];
}

- (NSArray *)targetObjectsByRid:(NSString *)string
{
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *array1 = [[self.viewControllers firstObject] performSelector:@selector(currentDataArray)];
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    [array1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CircleListObj class]]){
            CircleListObj *object = (CircleListObj *)obj;
            if([object.rid isEqualToString:string]){
                [result addObject:@(idx)];
            }
        }
    }];
    return result;
}

- (void)deleteObjectByRid:(NSString *)rid
{
    SHGHomeViewController *controller = [self.viewControllers firstObject];
    NSMutableArray *listArray = [controller currentListArray];
    NSMutableArray *dataArray = [controller currentDataArray];

    NSArray *objectArray = [self targetObjectsByRid:rid];
    NSArray *indexArray = [self indexOfObjectByRid:rid];
    [listArray removeObjectsInArray:objectArray];
    [dataArray removeObjectsInArray:objectArray];
    if (indexArray.count > 0) {
        [controller adjustAdditionalObject];
        controller.needRefreshTableView = YES;
    }
}

//搜索
- (void)actionSearch:(UIButton *)button
{
    self.categorySelectView.alpha = 0.0f;
    SHGCircleSearchViewController *controller = [[SHGCircleSearchViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

//发布
- (void)actionPost:(UIButton *)button
{
    self.categorySelectView.alpha = 0.0f;
    [Hud showWait];
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            SHGCircleSendViewController *controller = [[SHGCircleSendViewController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.selectedViewController.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity_cancel"];
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

    NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
    if (newIndex != NSNotFound)
        _selectedIndex = newIndex;
    else if (newIndex < [_viewControllers count])
        _selectedIndex = newIndex;
    else
        _selectedIndex = 0;

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
            WEAK(self, weakSelf);
            toViewController.view.frame = contentContainerView.bounds;
            [contentContainerView addSubview:toViewController.view];
            if ([weakSelf.delegate respondsToSelector:@selector(SHG_SegmentController:didSelectViewController:atIndex:)])
                [weakSelf.delegate SHG_SegmentController:weakSelf didSelectViewController:toViewController atIndex:newSelectedIndex];
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
    if (seg.selectedSegmentIndex == 1) {
        self.rightBarButtonItem = nil;
    }
    [self setSelectedIndex:seg.selectedSegmentIndex animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    tabButtonsContainerView = nil;
    contentContainerView = nil;
}

#pragma mark ------消息界面东西
// 统计未读消息数
- (void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    unreadCount = unreadCount + [[[ApplyViewController shareController] dataSource] count];
    if (unreadCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UITabBar tabBar:[TabBarViewController tabBar].tabBar addBadgeValue:[NSString stringWithFormat:@"%ld",(long)unreadCount] atIndex:3];
            [SHGNewUserCenterViewController sharedController].unReadNumber = unreadCount;
        });
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UITabBar tabBar:[TabBarViewController tabBar].tabBar hideBadgeOnItemIndex:3];
            [SHGNewUserCenterViewController sharedController].unReadNumber = 0;
        });
    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    unreadCount = unreadCount + [[[ApplyViewController shareController] dataSource] count];
    if (unreadCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UITabBar tabBar:[TabBarViewController tabBar].tabBar addBadgeValue:[NSString stringWithFormat:@"%ld",(long)unreadCount] atIndex:3];
            [SHGNewUserCenterViewController sharedController].unReadNumber = unreadCount;
        });
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UITabBar tabBar:[TabBarViewController tabBar].tabBar hideBadgeOnItemIndex:3];
            [SHGNewUserCenterViewController sharedController].unReadNumber = 0;
        });
    }
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification
{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    if(!_chatViewController.isResfresh)
    {
        [_chatViewController reloadDataSource];
    }
}

// 未读消息数量变化回调
- (void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages:(NSArray *)offlineCmdMessages
{

}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds)
    {
        if ([str isEqualToString:fromChatter])
        {
            ret = NO;
            break;
        }
    }

    return ret;
}

// 收到消息回调
- (void)didReceiveMessage:(EMMessage *)message
{
    NSArray *user = [HeadImage queryAll];
    BOOL hasExsist = NO;
    NSString *fromUser = @"";
    if (message.messageType == eMessageTypeGroupChat) {
        fromUser = message.groupSenderName;
    } else{
        fromUser = message.from;
    }
    for (NSManagedObject *obj in user){
        NSString *uid = [obj valueForKey:@"uid"];
        if ([uid isEqualToString:fromUser]){
            hasExsist = YES;
            break;
        }
    }

    if (!hasExsist){
        WEAK(self, weakSelf);
        [[SHGGloble sharedGloble] refreshFriendListWithUid:fromUser finishBlock:^(BasePeopleObject *object) {
            [weakSelf.chatViewController.contactsSource addObject:object];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendList" object:nil];
            });
        }];
    }

    BOOL needShowNotification = message.messageType == eMessageTypeGroupChat ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification)
    {
#if !TARGET_IPHONE_SIMULATOR

        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        if (!isAppActivity)
        {
            [self showNotificationWithMessage:message];
        }else {
            [self playSoundAndVibration];
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }

    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];

    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间

    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {

        NSString *title = message.from;
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = message.groupSenderName;
                    break;
                }
            }
        }
        NSArray *headUrl = [HeadImage queryAll:title];
        if(headUrl.count > 0){
            HeadImage *hi = (HeadImage*)([headUrl firstObject]);
            title = hi.nickname;
        }

        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
                notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
                notification.alertBody = [NSString stringWithFormat:@"%@%@", title, messageStr];
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
                notification.alertBody = [NSString stringWithFormat:@"%@%@", title, messageStr];
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
                notification.alertBody = [NSString stringWithFormat:@"%@%@", title, messageStr];
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
                notification.alertBody = [NSString stringWithFormat:@"%@%@", title, messageStr];
            }
                break;
            default:
                break;
        }

    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }

    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    UIApplication *application = [UIApplication sharedApplication];
    [application scheduleLocalNotification:notification];
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];

    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif

    [_chatViewController reloadApplyView];
}

- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    if (!isAdd)
    {
        NSMutableArray *deletedBuddies = [NSMutableArray array];
        for (EMBuddy *buddy in changedBuddies)
        {
            [deletedBuddies addObject:buddy.username];
        }
        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:deletedBuddies deleteMessages:YES append2Chat:YES];
        [_chatViewController reloadDataSource];
    }
    //    [_chat reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:username deleteMessages:YES append2Chat:YES];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    [self showHint:message];
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif

    [_chatViewController reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId groupname:(NSString *)groupname applyUsername:(NSString *)username reason:(NSString *)reason error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif

        [_chatViewController reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId invitee:(NSString *)username reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    [self showHint:message];
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedToJoin", @"agreed to join the group of \'%@\'"), groupname];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化
- (void)didLoginFromOtherDevice
{
    
}


#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    [self hideHud];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    [self hideHud];
}

#pragma mark - ICallManagerDelegate

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.categorySelectView removeObserver:self forKeyPath:@"alpha"];
}
@end
