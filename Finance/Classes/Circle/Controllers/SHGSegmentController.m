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

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface SHGSegmentController ()<IChatManagerDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (strong, nonatomic) ChatListViewController *chatViewController;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) UILabel *titleLabel;

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
    if(self.block){
        self.block(self.titleLabel);
    }
    [SHGGlobleOperation registerAttationClass:[self class] method:@selector(loadAttationState:attationState:)];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kNavBarTitleFontSize];
        _titleLabel.textColor = TEXT_COLOR;
        _titleLabel.text = @"动态";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (void)loadAttationState:(id)object attationState:(BOOL)attationState
{
    [[SHGHomeViewController sharedController] loadAttationState:object attationState:attationState];
}


- (void)initMessageObject
{
    [self registerEaseMobNotification];

    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
}

- (UIBarButtonItem *)rightBarButtonItem
{
    
    if (!_rightBarButtonItem)
    {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"sendCard"];
        [rightButton setBackgroundImage:image forState:UIControlStateNormal];
        [rightButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [rightButton addTarget:self action:@selector(actionPost:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton sizeToFit];
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    }
    return _rightBarButtonItem;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem)
    {
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectZero];
        UIImage *image = [UIImage imageNamed:@"newNews"];
        [leftButton setBackgroundImage:image forState:UIControlStateNormal];
        [leftButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [leftButton addTarget:self action:@selector(jumpToMessageViewController:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton sizeToFit];
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    }
    return _leftBarButtonItem;
}

- (ChatListViewController *)chatViewController
{
    if (!_chatViewController){
        _chatViewController = [[ChatListViewController alloc] init];
    }
    return _chatViewController;
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
    SHGHomeViewController *controller = [SHGHomeViewController sharedController];
    controller.needRefreshTableView = YES;
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

//发布
- (void)actionPost:(UIButton *)button
{
    __weak typeof(self)weakSelf = self;

    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            if([weakSelf.selectedViewController respondsToSelector:@selector(actionPost:)]){
                [weakSelf.selectedViewController performSelector:@selector(actionPost:) withObject:button];
            }
        } else{
            SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
            [self.selectedViewController.navigationController pushViewController:controller animated:YES];
            [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity"];
        }
    } showAlert:YES leftBlock:^{
        [[SHGGloble sharedGloble] recordUserAction:@"" type:@"dynamic_identity_cancel"];
    } failString:@"认证后才能发起动态哦～"];
    
}
//进入消息界面
- (void)jumpToMessageViewController:(UIButton *)button
{
    [self.selectedViewController.navigationController pushViewController:self.chatViewController animated:YES];
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
            __weak typeof(self) weakSelf = self;
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
    UIButton *leftButton = (UIButton *)self.leftBarButtonItem.customView;
    if (unreadCount > 0) {
        [leftButton setBadgeNumber:[NSString stringWithFormat:@"%i",(int)unreadCount]];
    } else{
        [leftButton removeBadgeNumber];
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

    unreadCount = unreadCount+[[[ApplyViewController shareController] dataSource] count];
    UIButton *leftButton = (UIButton *)self.leftBarButtonItem.customView;
    if (unreadCount > 0) {
        [leftButton setBadgeNumber:[NSString stringWithFormat:@"%i",(int)unreadCount]];
    } else{
        [leftButton removeBadgeNumber];
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
    if (message.isGroup) {
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
        __weak typeof(self) weakSelf = self;
        [[SHGGloble sharedGloble] refreshFriendListWithUid:fromUser finishBlock:^(BasePeopleObject *object) {
            [weakSelf.chatViewController.contactsSource addObject:object];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendList" object:nil];
            });
        }];
    }

    BOOL needShowNotification = message.isGroup ? [self needShowNotification:message.conversationChatter] : YES;
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
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    // 收到消息时，震动
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间

    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {

        NSString *title = message.from;
        if (message.isGroup) {
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

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif

    [_chatViewController reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif

        [_chatViewController reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
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
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        SHGAlertView *alertView = [[SHGAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") contentText:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") leftButtonTitle:nil rightButtonTitle:NSLocalizedString(@"ok", @"OK")];
        alertView.rightBlock = ^{
            [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
                if (error && error.errorCode != EMErrorServerNotLogin) {
                }
                else{
                    LoginViewController *splitViewController =[[[LoginViewController alloc] init] initWithNibName:@"LoginViewController" bundle:nil];
                    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:splitViewController];
                    //设置导航title字体
                    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:kNavBarTitleFontSize], NSForegroundColorAttributeName:NavRTitleColor}];
                    //清除配置信息
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_UID];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_PASSWORD];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USER_NAME];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USER_AREA];
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_TOKEN];
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTOLOGIN];
                    [AppDelegate currentAppdelegate].window.rootViewController = nav;
                }
            } onQueue:nil];
        };
        [alertView show];

    } onQueue:nil];
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

#pragma mark - public
- (void)jumpToChatList
{
    if(self.chatViewController)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self jumpToMessageViewController:nil];
        });

    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
