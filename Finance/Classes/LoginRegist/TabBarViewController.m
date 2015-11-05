//
//  TabBarViewController.m
//  DingDCommunity
//
//  Created by HuMin on 14-12-2.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "TabBarViewController.h"
#import "SHGHomeViewController.h"
#import "ProductListViewController.h"
#import "MeViewController.h"
#import "ChatListViewController.h"
#import "ApplyViewController.h"
#import "CircleDetailViewController.h"
#import "DiscoverViewController.h"
#import "headImage.h"
#import "MessageViewController.h"
#import "CircleSomeOneViewController.h"
#import "VerifyIdentityViewController.h"
#import "SHGSegmentController.h"
#import "SHGAttationViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface TabBarViewController()<SHGSegmentControllerDelegate>
{
    BOOL isShowSearchbar;
}
@property (strong, nonatomic) SHGSegmentController *segmentViewController;
@property (strong, nonatomic) SHGHomeViewController *homeViewController;
@property (strong, nonatomic) SHGAttationViewController *attationViewController;
@property (strong, nonatomic) DiscoverViewController *prodViewController;
@property (strong, nonatomic) MeViewController *meViewController;
@property (strong, nonatomic) ChatListViewController *chatViewController;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) UIView *segmentTitleView;
@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(TabBarViewController *)tabBar
{
    static TabBarViewController *tabBar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        tabBar = [[self alloc]init];
    });
    return tabBar;
}

-(id)init
{
    if (self=[super init])
    {
        
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageNavTitle:) name:NOTIFI_CHANGE_NAV_TITLEVIEW object:nil];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(51, 51, 51), NSForegroundColorAttributeName, nil];;
    [[UITabBarItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];

    self.tabBar.tintColor = RGB(255, 57, 67);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    
    self.navigationController.delegate = self;
    [self initSubpage];
    [self registerEaseMobNotification];
    
    [self setupUnreadMessageCount];
    [self setupUntreatedApplyCount];
   
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.rid)
    {
        [self pushCircle:self.rid];
        self.rid = nil;
    }
}
-(void)pushCircle:(NSDictionary*)userInfo
{

    pushInfo = [userInfo copy];
    if ([userInfo objectForKey:@"code"])
    {
        UIViewController *TopVC = [self getCurrentRootViewController];
        NSString *ridCode = [userInfo objectForKey:@"code"];
        if ([ridCode isEqualToString:@"1001"])
        { //进入通知
            MessageViewController *detailVC=[[MessageViewController alloc] init];
            [self pushIntoViewController:TopVC newViewController:detailVC];
        }else if ([ridCode isEqualToString:@"1004"])
        {  //进入关注人的个人主页
            CircleSomeOneViewController  *detaiVC =[[CircleSomeOneViewController alloc]init];
            detaiVC.userId = [NSString stringWithFormat:@"%@",userInfo[@"uid"]];
            detaiVC.userName = userInfo[@"uname"];
            [self pushIntoViewController:TopVC newViewController:detaiVC];
        }else if ([ridCode isEqualToString:@"1005"] || [ridCode isEqualToString:@"1006"])
        { //进入认证页面
            if ([ridCode isEqualToString:@"1005"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTHSTATE];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTHSTATE];
            }
            VerifyIdentityViewController *meControl =[[VerifyIdentityViewController alloc]init];
            [self pushIntoViewController:TopVC newViewController:meControl];
        }else
        {  //进入帖子详情
            CircleDetailViewController *vc = [[CircleDetailViewController alloc] init];
            NSString* rid = [userInfo objectForKey:@"rid"];
            vc.rid = rid;
            [self pushIntoViewController:TopVC newViewController:vc];
        }
    }
}
-(void)pushIntoViewController:(UIViewController*)viewController newViewController:(UIViewController*)newController
{
    UINavigationController *navs;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        navs = (UINavigationController *)viewController;
        for (UIViewController *viewControl in navs.viewControllers){
            if ([viewControl isKindOfClass:[LoginViewController class]]){ //未登录,先登录再查看
                LoginViewController *viewControll = (LoginViewController*)viewControl;
                viewControll.rid=pushInfo;
                break;
            }else{
                if (navs.visibleViewController.navigationController){
                    [navs.visibleViewController.navigationController pushViewController:newController animated:YES];
                }
            }
        }
    }else if ([viewController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tab = (UITabBarController *)viewController;
        navs = (UINavigationController *)tab.selectedViewController;
        if (navs.visibleViewController.navigationController) {
            [navs.visibleViewController.navigationController pushViewController:newController animated:YES];
        }
    }else{
        navs = viewController.navigationController;
        if (navs.visibleViewController.navigationController) {
            [navs.visibleViewController.navigationController pushViewController:newController animated:YES];
        }
    }
}
/**
 *  获取当前的界面
 *
 *  @return 当前的界面
 */
- (UIViewController *)getCurrentRootViewController {
    
    UIViewController *result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        
        NSArray *windows = [[UIApplication sharedApplication] windows];
        
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
        result = nextResponder;
    
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        
        result = topWindow.rootViewController;
    
    else
        
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    return result;
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


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.navigationItem.titleView = nil;
    if (item.tag == 1000)
    {
        self.navigationItem.titleView = self.segmentTitleView;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.segmentViewController.rightBarButtonItem;
        [MobClick event:@"SHGHomeViewController" label:@"onClick"];
    }else if (item.tag == 2000)
    {
        self.navigationItem.titleView = self.chatViewController.titleView;
        self.navigationItem.rightBarButtonItems=@[self.chatViewController.rightBarButtonItem];
        self.navigationItem.leftBarButtonItem=nil;
        [MobClick event:@"ChatListViewController" label:@"onClick"];
    }else if (item.tag == 3000)
    {
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.titleView = self.prodViewController.titleLabel;
        self.navigationItem.rightBarButtonItem = nil;
        [MobClick event:@"DiscoverViewController" label:@"onClick"];
    }else if (item.tag == 4000)
    {
        self.navigationItem.titleView = self.meViewController.titleLabel;
        self.navigationItem.rightBarButtonItems=@[self.meViewController.rightBarButtonItem];
        [MobClick event:@"MeViewController" label:@"onClick"];
    }
}
#pragma mark - 子页面初始化
-(void)initSubpage
{
    //圈子
    UIImage *image = [UIImage imageNamed:@"dynamic_normal"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:@"dynamic_selected"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.segmentViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:image selectedImage:selectedImage];
    self.segmentViewController.tabBarItem.tag = 1000;
    __weak typeof(self)weakSelf = self;
    self.segmentViewController.block = ^(UIView *view){
        weakSelf.segmentTitleView = view;
        weakSelf.navigationItem.titleView = weakSelf.segmentTitleView;
    };
    self.navigationItem.rightBarButtonItem = self.segmentViewController.rightBarButtonItem;

    //消息
    image = [UIImage imageNamed:@"信息14-默认"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"信息14-选中"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.chatViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:image selectedImage:selectedImage];
    self.chatViewController.tabBarItem.tag = 2000;
    
    //产品
    image = [UIImage imageNamed:@"discovery_normal"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"discovery_selected"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.prodViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:image selectedImage:selectedImage];
    self.prodViewController.tabBarItem.tag = 3000;
    
    //我的
    image = [UIImage imageNamed:@"mine_normal"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"mine_selected"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.meViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:image selectedImage:selectedImage];
    self.meViewController.tabBarItem.tag = 4000;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    self.viewControllers = [NSArray arrayWithObjects:self.segmentViewController,self.chatViewController,self.prodViewController ,self.meViewController ,nil];
    self.selectedIndex = 0;
    
}

- (SHGSegmentController *)segmentViewController
{
    if(!_segmentViewController){
        _segmentViewController = [SHGSegmentController sharedSegmentController];
        _segmentViewController.delegate = self;
        _segmentViewController.viewControllers = @[self.homeViewController, self.attationViewController];
    }
    return _segmentViewController;
}

-(SHGHomeViewController *)homeViewController
{
    if (!_homeViewController){
        _homeViewController = [[SHGHomeViewController alloc]initWithNibName:@"SHGHomeViewController" bundle:nil];
    }
    return _homeViewController;
}

- (SHGAttationViewController *)attationViewController
{
    if(!_attationViewController){
        _attationViewController = [[SHGAttationViewController alloc] initWithNibName:@"SHGAttationViewController" bundle:nil];
    }
    return _attationViewController;
}

-(DiscoverViewController *)prodViewController
{
    if (!_prodViewController)
    {
        _prodViewController = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
    }
    return _prodViewController;
}

-(ChatListViewController *)chatViewController
{
    if (!_chatViewController)
    {
        _chatViewController = [[ChatListViewController alloc] init];
        _chatViewController.chatListType = ChatListView;
    }
    return _chatViewController;
}
-(MeViewController *)meViewController
{
    if (!_meViewController)
    {
        _meViewController = [[MeViewController alloc] initWithNibName:@"MeViewController" bundle:nil];
    }
    return _meViewController;
}

-(void)chageNavTitle:(NSNotification *)noti
{
    NSString *str = noti.object;
    isShowSearchbar = [str boolValue];
    
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            // [lastController viewWillDisappear:animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    //[viewController viewWillAppear:animated];
}
#pragma mark - 操作

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    unreadCount = unreadCount+[[[ApplyViewController shareController] dataSource] count];
    if (self.chatViewController) {
        if (unreadCount > 0) {
            self.chatViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            self.chatViewController.tabBarItem.badgeValue = nil;
        }
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
    if (self.chatViewController) {
        if (unreadCount > 0) {
            self.chatViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            self.chatViewController.tabBarItem.badgeValue = nil;
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
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
-(void)didUnreadMessagesCountChanged
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
-(void)didReceiveMessage:(EMMessage *)message
{
    
    NSArray *user = [HeadImage queryAll];
    BOOL hasExsist = NO;
    NSString *uid  = message.conversationChatter;
    for (NSManagedObject *obj in user)
    {
        uid  =  [obj valueForKey:@"uid"];
        if ([uid isEqualToString:message.conversationChatter])
        {
            hasExsist = YES;
            break;
        }
    }
    if (!hasExsist)
    {
        //
        [self refreshFriendListWithUid:uid];
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
-(void)refreshFriendListWithUid:(NSString *)userId
{
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/user/%@",rBaseAddressForHttp,userId] parameters:nil success:^(MOCHTTPResponse *response) {
        NSMutableArray *arr = [NSMutableArray array];
        NSDictionary *dic = response.dataDictionary;
        BasePeopleObject *obj = [[BasePeopleObject alloc] init];
        obj.name = [dic valueForKey:@"nick"];
        obj.headImageUrl = [dic valueForKey:@"avatar"];
        obj.uid = [dic valueForKey:@"username"];
        obj.rela = [dic valueForKey:@"rela"];
        obj.company = [dic valueForKey:@"company"];
        obj.commonfriend = @"";
        obj.commonfriendnum = @"";
        [self.chatViewController.contactsSource addObject:obj];
        [arr addObject:obj];
        [HeadImage inertWithArr:arr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshFriendList" object:nil];
            
        });
    } failed:^(MOCHTTPResponse *response) {
        
    }];
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
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.vidio", @"Vidio");
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        if (message.isGroup) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
//  #warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatViewController isConnect:NO];
    }
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

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
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
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            if (error && error.errorCode != EMErrorServerNotLogin) {
            }
            else{
                LoginViewController *splitViewController =[[[LoginViewController alloc] init] initWithNibName:@"LoginViewController" bundle:nil];
                BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:splitViewController];
                //设置导航title字体
                [[UINavigationBar appearance] setTitleTextAttributes:
                 
                 @{NSFontAttributeName:[UIFont systemFontOfSize:kNavBarTitleFontSize],
                   
                   NSForegroundColorAttributeName:NavRTitleColor}];
                
                //清楚配置信息
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_UID];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_PASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_USER_NAME];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KEY_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTOLOGIN];
                //    设置导航栏不透明
                // [UINavigationBar appearance].translucent = NO;
                
                [AppDelegate currentAppdelegate].window.rootViewController = nav;
                
            }
        } onQueue:nil];
    }
}
#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
    } onQueue:nil];
}

//- (void)didConnectionStateChanged:(EMConnectionState)connectionState
//{
//    [_chatListVC networkChanged:connectionState];
//}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    [self hideHud];
    // [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    [self hideHud];
    //    if (error) {
    //        [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
    //    }else{
    //       // [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
    //    }
}

#pragma mark - ICallManagerDelegate

//- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
//{
////    if (callSession.status == eCallSessionStatusConnected)
////    {
////        EMError *error = nil;
////        BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
////
////#warning 在后台不能进行视频通话
////        if(callSession.type == eCallSessionTypeVideo && [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground){
////            error = [EMError errorWithCode:EMErrorInitFailure andDescription:@"后台不能进行视频通话"];
////        }
////        else if (!isShowPicker){
////            [[EMSDKFull sharedInstance].callManager removeDelegate:self];
////            //            _callController = nil;
////            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:YES];
////            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
////            //            _callController = callController;
////            [self presentViewController:callController animated:NO completion:nil];
////        }
////
////        if (error || isShowPicker) {
////            [[EMSDKFull sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReason_Hangup];
////        }
////    }
//}

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
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:self.chatViewController];
    }
}
- (void)ToMess{
    if (self.meViewController) {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:self.meViewController];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
