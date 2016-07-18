//
//  AppDelegate.m
//  Finance
//
//  Created by HuMin on 15/4/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
// 9月1号

#import "AppDelegate.h"
#import "MOCHTTPRequestOperationManager.h"
#import "SHGSegmentController.h"
#import "ChatListViewController.h"
#import "ContactSelectionViewController.h"
#import "AppDelegate+EaseMob.h"
#import "RegistViewController.h"
#import "CircleDetailViewController.h"
#import "ApplyViewController.h"
#import "CircleDetailViewController.h"
#import "UncaughtExceptionHandler.h"
#import "MessageViewController.h"
#import "SHGPersonalViewController.h"
#import "GeTuiSdk.h"
#import "GeTuiSdkError.h"
#import "LinkViewController.h"
#import "SHGBusinessObject.h"
#import "SHGBusinessNewDetailViewController.h"
#import "SHGBusinessRecommendViewController.h"
#import "CCLocationManager.h"

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//for idfa
#import <AdSupport/AdSupport.h>

#define resultcodekey       @"code"
#define successcode         @"000"
#define datakey             @"data"
#define messagekey          @"msg"


@interface AppDelegate ()<GeTuiSdkDelegate>
{
    NSString *shareRid;
}

//新浪微博
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;
@property (strong, nonatomic) NSString *deviceToken;
@property (strong, nonatomic) NSString *clientId;
@property (strong, nonatomic) NSString *payloadId;
@property (strong, nonatomic) NSDictionary *pushInfo;
@end

@implementation AppDelegate


+ (AppDelegate *)currentAppdelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self umengTrack];
    InstallUncaughtExceptionHandler();
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [MOCNetworkReachabilityManager startMonitor:kNetworkCheckAddress viaWWAN:^{

    } viaWiFi:^{

    } notReachable:^{

    }];
    
    //一天启动次数
    NSInteger numberOfLaunch =[[[NSUserDefaults standardUserDefaults] objectForKey:@"LaunchTimes"] intValue];
    NSString *lastLaunchTime =[[NSUserDefaults standardUserDefaults] objectForKey:@"LastLauncnTime"];
    //判端启动时间是否在当天，是的话次数加一
    NSDateFormatter *formater =[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSDate *lastTime = [formater dateFromString:lastLaunchTime];
    NSDate *nowTime = [NSDate date];
    if ([nowTime compare:lastTime] == NSOrderedSame){
        numberOfLaunch++;
        [[NSUserDefaults standardUserDefaults] setObject:@(numberOfLaunch) forKey:@"LaunchTimes"];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[NSUserDefaults standardUserDefaults] setObject:[formater stringFromDate:nowTime] forKey:@"LastLauncnTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [MOCHTTPRequestOperationManager setupRequestOperationManager:resultcodekey successCode:successcode dataKey:datakey messageKey:messagekey];
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self setupShare];
    //
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Finance.sqlite"];
    [self addObserver:self forKeyPath:@"pushInfo" options:NSKeyValueObservingOptionNew context:nil];
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    [[CCLocationManager shareLocation] getCity:nil];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    RootViewController *rootVC =[[RootViewController alloc]init];
    if (userInfo) {
        NSLog(@"从消息启动______:%@",userInfo);
        rootVC.rid =userInfo;
    }
    self.pushInfo = @{};
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCircle:) name:kMPNotificationViewTapReceivedNotification object:nil];
    //设置导航title字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kNavBarTitleFontSize],NSForegroundColorAttributeName:NavRTitleColor}];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString*)appKey appSecret:(NSString *)appSecret
{
    NSError *err =nil;

    //[1-1]:通过 AppId、appKey 、appSecret 启动SDK

    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];

    //[1-2]:设置是否后台运行开关
    [GeTuiSdk runBackgroundEnable:YES];

    //[1-3]:设置地理围栏功能，开启LBS定位服务和是否允许SDK 弹出用户定位请求，请求NSLocationAlwaysUsageDescription权限,如果UserVerify设置为NO，需第三方负责提示用户定位授权。

    [GeTuiSdk lbsLocationEnable:NO andUserVerify:NO];


    if (err) {
        NSLog(@"%@",[NSString stringWithFormat:@"%@", [err localizedDescription]]);
        
    }
}

- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error
{

}

- (void)setupShare
{
    [ShareSDK registerApp:KEY_SHARESDK];
    [ShareSDK connectSMS];
    //连接微信
    [ShareSDK connectWeChatWithAppId:@"wx8868d86915c77c36" appSecret:@"73c0d5f3e3b4844d69c2ea59407ec404" wechatCls:[WXApi class]];
    //连接微博
    [ShareSDK connectSinaWeiboWithAppKey:@"347846106" appSecret:@"50e6c6fa2d245ec2e008e1b8e2aefe71" redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    [ShareSDK connectQZoneWithAppKey:@"1104624210" appSecret:@"PnZ1JkvJ3qd53uKY" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    //连接QQ
    [ShareSDK connectQQWithQZoneAppKey:@"1104624210" qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    //连接微信好友
    [ShareSDK connectWeChatSessionWithAppId:@"wx8868d86915c77c36" appSecret:@"73c0d5f3e3b4844d69c2ea59407ec404" wechatCls:[WXApi class]];
    //连接微信朋友圈
    [ShareSDK connectWeChatTimelineWithAppId:@"wx8868d86915c77c36" appSecret:@"73c0d5f3e3b4844d69c2ea59407ec404" wechatCls:[WXApi class]];
    
}

- (void)umengTrack
{
    [MobClick setLogEnabled:YES];
    //友盟分析,线下渠道
    [MobClick startWithAppkey:kUMENGAppKey reportPolicy:BATCH  channelId:@"App Store"];

    NSString *appKey = @"558e0e1367e58ea419006a14";
    NSString *deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *mac = [self macString];
    NSString *idfa = [self idfaString];
    NSString *idfv = [self idfvString];
    NSString *urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    self.pushInfo = nil;
    completionHandler(UIBackgroundFetchResultNewData);

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"isViewLoad"]) {
        BOOL isViewLoad = [[change objectForKey:@"new"] boolValue];
        if (self.pushInfo && ![self.pushInfo isEqualToDictionary:@{}] && isViewLoad) {
            [self pushToNoticeViewController:self.pushInfo];
            self.pushInfo = @{};
        }
    }

    if ([keyPath isEqualToString:@"pushInfo"]) {
        NSDictionary *dic = [change objectForKey:@"new"];
        if (dic && ![dic isEqual:[NSNull null]] && ![dic isEqualToDictionary:@{}]) {
            TabBarViewController *controller = [TabBarViewController tabBar];
            if (controller.isViewLoad) {
                [self pushToNoticeViewController:self.pushInfo];
                self.pushInfo = @{};
            }
        }
    }
}

- (void)receiveNotification:(NSDictionary *)userInfo
{
    if ([userInfo objectForKey:@"code"]){
        NSString *code = [userInfo objectForKey:@"code"];
        if (!self.pushInfo){
            self.pushInfo = [NSDictionary dictionaryWithDictionary:userInfo];
        } else{
            //程序活跃在前台
            NSString *rid = @"";
            if ([userInfo objectForKey:@"rid"]){
                rid = [userInfo objectForKey:@"rid"];
            }
            if ([userInfo objectForKey:@"aps"]){
                NSDictionary *aps = [userInfo objectForKey:@"aps"];
                if ([aps isKindOfClass:[NSDictionary class]]){
                    NSDictionary *dicAps = [aps objectForKey:@"aps"];
                    if ([dicAps objectForKey:@"alert"]) {
                        NSString *alert = [dicAps[@"alert"] objectForKey:@"body"];
                        UIImage *image = [UIImage imageNamed:@"80.png"];
                        image = [image reSizeImagetoSize:CGSizeMake(28, 28)];
                        [MPNotificationView notifyWithText:@"大牛圈" detail:alert image:image duration:3.0 andTouchBlock:nil pushId:userInfo];
                    }
                }
            } else{
                if ([code isEqualToString:@"3001"]) {
                    [[SHGSegmentController sharedSegmentController] deleteObjectByRid:rid];
                }
            }
        }
        //身份认证信息推送
        if ([code isEqualToString:@"1005"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTHSTATE];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
        } else if ([code isEqualToString:@"1006"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTHSTATE];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
        }
        //有好友关注推送
        if ([code isEqualToString:@"1004"]){
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_UPDATE_FRIEND_LIST object:nil];  //刷新好友列表
            //进入对方的个人空间
        }
    }
}

#ifdef __IPHONE_8_0
// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

#endif
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];

    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken:%@",self.deviceToken);
    // [3]:向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:self.deviceToken];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    NSLog(@"%@",userInfo);
    if ([TabBarViewController tabBar]){
        [[TabBarViewController tabBar] jumpToChatList];
    }
    if (application.applicationState != UIApplicationStateActive){
        [self presentViewControllerWithUserInfo:userInfo];
    }

}
- (void)presentViewControllerWithUserInfo:(NSDictionary *)userInfo{
    
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification
{
    if ([TabBarViewController tabBar]) {
        [[TabBarViewController tabBar] jumpToChatList];
    }

}

#pragma mark 个推 Delegate
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId  // SDK 返回clientid
{
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    self.clientId = clientId;
    if (self.deviceToken) {
        [GeTuiSdk registerDeviceToken:self.deviceToken];
        [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:KEY_BPUSH_CHANNELID];
        [[NSUserDefaults standardUserDefaults] setObject:@"getui" forKey:KEY_BPUSH_USERID];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (clientId && !IsStrEmpty(UID)) {
            [self registerToken:clientId];
        }
    }
}

- (void)registerToken:(NSString *)channelId
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    NSDictionary *param = @{@"uid":UID, @"t":token?:@"", @"channelid":channelId?:@"", @"channeluid":@"getui"};
    [[SHGGloble sharedGloble] registerToken:param block:^(BOOL success, MOCHTTPResponse *response) {

    }];
}

- (void)GeTuiSdkDidReceivePayload:(NSString *)payloadId andTaskId:(NSString *)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    self.payloadId = payloadId;
    NSData* payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据 payloadId 取回 Payload
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes length:payload.length encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",payloadMsg);
    NSDictionary *userInfo = [NSJSONSerialization JSONObjectWithData:payload options:NSJSONReadingMutableContainers error:nil];
    [self receiveNotification:userInfo];
    NSLog(@"收到了透传消息");
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    NSLog(@"个推出错啦");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [GeTuiSdk enterBackground];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [GeTuiSdk resume];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // [EXT] 重新上线
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[SHGGloble sharedGloble] recordUserAction:@"" type:@"systemExit"];
    [MagicalRecord cleanUp];
    [self saveContext];
}

#pragma mark - Split view


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.xitai.Finance.Finance" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Finance" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Finance.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

/*
 统一处理收到推送的时候消息处理
 */
- (void)pushToNoticeViewController:(NSDictionary*)userInfo;
{
    UIViewController *TopVC = [[SHGGloble sharedGloble] getCurrentRootViewController];
    NSString *ridCode = [userInfo objectForKey:@"code"];
    if ([ridCode isEqualToString:@"1001"]){ //进入通知
        MessageViewController *detailVC=[[MessageViewController alloc] init];
        [self pushIntoViewController:TopVC newViewController:detailVC];
    } else if ([ridCode isEqualToString:@"1004"]){  //进入个人关注主页
        SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
        controller.userId = [NSString stringWithFormat:@"%@",userInfo[@"uid"]];
        [self pushIntoViewController:TopVC newViewController:controller];
    } else if ([ridCode isEqualToString:@"1005"] || [ridCode isEqualToString:@"1006"]){ //进入认证页面
        if ([ridCode isEqualToString:@"1005"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTHSTATE];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTHSTATE];
        }

        SHGAuthenticationViewController *controller =[[SHGAuthenticationViewController alloc]init];
        [self pushIntoViewController:TopVC newViewController:controller];
    } else if ([ridCode isEqualToString:@"1010"] || [ridCode isEqualToString:@"1011"]){
        //之前的活动
    } else if ([ridCode isEqualToString:@"1013"]){
        //feed流
        CircleListObj *object = [[CircleListObj alloc] init];
        object.feedhtml = [userInfo objectForKey:@"feedHtml"];
        LinkViewController *controller = [[LinkViewController alloc] init];
        controller.url = object.feedhtml;
        controller.object = object;
        [self pushIntoViewController:TopVC newViewController:controller];
    } else if ([ridCode isEqualToString:@"3000"]){
        //之前的业务详情
    } else if ([ridCode isEqualToString:@"1014"]){
        //新版业务的推送
        NSString *businessId = [userInfo objectForKey:@"rid"];
        NSString *businessType = [userInfo objectForKey:@"businessType"];
        SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc] init];
        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
        object.businessID = businessId;
        object.type = businessType;
        controller.object = object;
        [self pushIntoViewController:TopVC newViewController:controller];
    } else if ([ridCode isEqualToString:@"1015"]){
        NSString *businessId = [userInfo objectForKey:@"rid"];
        NSString *type = [userInfo objectForKey:@"businessType"];
        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
        object.businessID = businessId;
        object.type = type;
        SHGBusinessNewDetailViewController *controller = [[SHGBusinessNewDetailViewController alloc] init];
        controller.object = object;
        [self pushIntoViewController:TopVC newViewController:controller];
    } else if ([ridCode isEqualToString:@"1016"]){
        //优质业务的推送
        NSString *businessId = [userInfo objectForKey:@"rid"];
        NSString *businessType = [userInfo objectForKey:@"businessType"];
        NSString *time = [userInfo objectForKey:@"time"];
        SHGBusinessRecommendViewController *controller = [[SHGBusinessRecommendViewController alloc] init];
        SHGBusinessObject *object = [[SHGBusinessObject alloc] init];
        object.businessID = businessId;
        object.type = businessType;
        controller.time = time;
        controller.object = object;
        [self pushIntoViewController:TopVC newViewController:controller];
        
    } else if ([ridCode isEqualToString:@"1017"]){
        SHGBusinessMineViewController *controller = [[SHGBusinessMineViewController alloc] init];
        [self pushIntoViewController:TopVC newViewController:controller];
    } else if ([ridCode isEqualToString:@"1002"] || [ridCode isEqualToString:@"1003"] || [ridCode isEqualToString:@"1007"] || [ridCode isEqualToString:@"1008"]){ //进入帖子详情
        CircleDetailViewController *vc = [[CircleDetailViewController alloc] initWithNibName:@"CircleDetailViewController" bundle:nil];
        NSString* rid = [userInfo objectForKey:@"rid"];
        vc.rid = rid;
        [self pushIntoViewController:TopVC newViewController:vc];
    }
}

- (void)pushIntoViewController:(UIViewController*)viewController newViewController:(UIViewController*)newController
{
    UINavigationController *navs;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        navs = (UINavigationController *)viewController;
        for (UIViewController *viewControl in navs.viewControllers){
            if ([viewControl isKindOfClass:[LoginViewController class]]){ //未登录,先登录再查看
                LoginViewController *viewControll = (LoginViewController*)viewControl;
                viewControll.rid = self.pushInfo;
                break;
            }else{
                if (navs.visibleViewController.navigationController){
                    [navs.visibleViewController.navigationController pushViewController:newController animated:YES];
                    break;
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
//点击顶部通知栏，app活跃在前台
-(void)pushCircle:(NSNotification *)noti
{
    NSDictionary *dic =[noti object];
    [self pushToNoticeViewController:dic];
}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self]|[WXApi handleOpenURL:url delegate:self];
}

#pragma mark - share

- (void)sendSmsWithText:(NSString *)text rid:(NSString *)rid
{
    // 判断是否可以发送短信
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
    if (canSendSMS){
        [Hud showWait];
        MFMessageComposeViewController *smsPicker = [[MFMessageComposeViewController alloc] init];
        smsPicker.messageComposeDelegate = self;
        NSString *shareBody = text;
        smsPicker.body = shareBody;
        
        if (rid.length  > 9) {
            smsPicker.recipients = [NSArray arrayWithObject:rid];
        }
        
        shareRid = rid;
        [[AppDelegate currentAppdelegate].window.rootViewController presentViewController:smsPicker animated:YES completion:^{
            [Hud hideHud];
        }];
    } else{
        [Hud showMessageWithText:@"设备不支持短信"];
    }
}

// 发送短信api的回调函数
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSString *text ;
    if (shareRid.length > 9) {
        switch (result){
            case MessageComposeResultCancelled:
                text = @"发送取消";
                break;
            case MessageComposeResultSent:
                text = @"发送成功";
                break;
            case MessageComposeResultFailed:
                text = @"发送失败";
                break;
            default:
                break;
        }
        [Hud showMessageWithText:text];
    } else{
        switch (result){
            case MessageComposeResultCancelled:
                text = @"分享取消";
                [Hud showMessageWithText:text];
                break;
            case MessageComposeResultSent:
                text = @"分享成功";
                if (shareRid.length > 0){
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_SHARE_TO_SMSSUCCESS object:shareRid];
                }
                break;
            case MessageComposeResultFailed:
                text = @"分享失败";
                [Hud showMessageWithText:text];
                break;
            default:
                break;
        }
    }
}

#pragma mark weibo

#pragma Internal Method

- (void) sendmessageToShareWithObjContent:(NSString *)content rid:(NSString *)rid
{
    shareRid = rid;
    WBMessageObject *message = [WBMessageObject message];
    message.text = content;
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:self.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
}

#pragma mark - weiboSDKDelegate

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken){
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID){
            self.wbCurrentUserID = userID;
        }
        int stateCode = response.statusCode;
        NSString *messages ;
        switch (stateCode) {
            case 0:
                messages = @"分享成功";
                if (shareRid.length > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_SHARE_TO_SMSSUCCESS object:shareRid];
                }
                break;
            case -1:
                messages = @"取消分享";
                break;
            case -2:
                message = @"发送失败，请稍后再试";
                break;
            case -3:
                message = @"授权失败";
                
                break;
            default:
                break;
        }
        [Hud showMessageWithText:message];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        //[alert show];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
    }
}
-(void)exitApplication
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    self.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
}
- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
}
#pragma mark - weChat share

-(void)onReq:(BaseReq*)req
{
    NSLog(@"sss");
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        GetMessageFromWXReq *temp = (GetMessageFromWXReq *)req;
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@", temp.openID];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", temp.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        LaunchFromWXReq *temp = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = temp.message;
        
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = [NSString stringWithFormat:@"openID: %@, messageExt:%@", temp.openID, msg.messageExt];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]]){
        NSString *message = @"";
        if (resp.errCode == 0) {
            message = @"分享成功";
            if (shareRid.length > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_SHARE_TO_SMSSUCCESS object:shareRid];
            } else{
                [Hud showMessageWithText:@"分享成功"];
            }
            
        } else if(resp.errCode == -1){
            message = @"分享失败";
            [Hud showMessageWithText:message];
            
        } else{
            message = @"分享取消";
            [Hud showMessageWithText:message];
            
        }
    }
    
}

- (void)sendLinkContentWithMessage:(WXMediaMessage *)message type:(NSInteger)type
{
    // WXMediaMessage *message = [WXMediaMessage message];
    
    NSString *shareUrl = message.messageExt;
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = shareUrl;
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = (int)type ;
    [WXApi sendReq:req];
}

- (void)wechatShareWithText:(NSString *)text shareUrl:(NSString *)shareUrl shareType:(NSInteger)scene
{    
    if([WXApi isWXAppInstalled ]){
        if ([WXApi isWXAppSupportApi]){
            WXMediaMessage *message = [WXMediaMessage message];
            NSString *detail = text;
            if (text.length > 0) {
            } else{
                detail = @"大牛圈";
            }
            message.messageExt = shareUrl;
            if (scene == 0) {
                message.title = @"大牛圈";
            } else{
                message.title = detail;
            }
            message.description =detail;
            [message setThumbImage:[UIImage imageNamed:@"80.png"]];
            shareRid = @"";
            [self sendLinkContentWithMessage:message type:scene];
        } else{
            [Hud showMessageWithText:@"现版本微信不支持分享,请更新"];
        }
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示 " message:@"安装微信后，即可与您的好友分享，现在安装？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费安装",nil];
        alert.tag = 1201;
        [alert show];
    }
}

- (void)wechatShare:(CircleListObj *)obj shareType:(NSInteger)scene
{
    if([WXApi isWXAppInstalled]){
        if ([WXApi isWXAppSupportApi]){
            WXMediaMessage *message = [WXMediaMessage message];
            NSString *detail = obj.detail;
            if ([obj.postType isEqualToString:@"business"]) {
                detail = [NSString stringWithFormat:@"【业务】%@",obj.detail];
            }
            NSString *title = obj.groupPostTitle;
            if (obj.detail.length > 0) {
                if (obj.detail.length > 15){
                    detail = [NSString stringWithFormat:@"%@...",[obj.detail substringToIndex:15]];
                }
            } else{
                detail = @"大牛圈";
            }
            message.messageExt = [NSString stringWithFormat:@"%@%@",rBaseAddressForHttpShare,obj.rid];
            if (scene == 0) {
                message.title = title;
            } else{
                message.title = detail;
            }
            message.description =detail;
            [message setThumbImage:[UIImage imageNamed:@"80.png"]];
            shareRid = obj.rid;
            [self sendLinkContentWithMessage:message type:scene];
        } else{
            [Hud showMessageWithText:@"现版本微信不支持分享,请更新"];
        }
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"友情提示 " message:@"安装微信后，即可与您的好友分享，现在安装？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费安装",nil];
        alert.tag = 1201;
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1201)
    {
        if (buttonIndex == 1)
        {
            NSString *appleID = @"414478124";
            
            if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
                NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appleID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            } else {
                NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appleID];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }
    }
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{

}

#pragma mark ------活动的分享
- (void)shareActionToSMS:(NSString *)content
{
    // 判断是否可以发送短信
    BOOL canSendSMS = [MFMessageComposeViewController canSendText];
    if (canSendSMS){
        MFMessageComposeViewController *smsPicker = [[MFMessageComposeViewController alloc] init];
        smsPicker.messageComposeDelegate = self;
        NSString *shareBody = content;
        smsPicker.body = shareBody;

        shareRid = @"";
        [[AppDelegate currentAppdelegate].window.rootViewController presentViewController:smsPicker animated:YES completion:nil];
    } else{
        [Hud showMessageWithText:@"设备不支持短信"];
    }
}

- (void)shareActionToWeChat:(NSInteger)type content:(NSString *)content title:(NSString *)title url:(NSString *)url
{
    if ([WXApi isWXAppSupportApi]){
        WXMediaMessage *message = [WXMediaMessage message];
        NSString *detail = content;
        message.messageExt = url;
        if (type == 0) {
            message.title = title;
        } else{
            message.title = detail;
        }
        message.description = detail;
        [message setThumbImage:[UIImage imageNamed:@"80.png"]];
        shareRid = @"";
        [self sendLinkContentWithMessage:message type:type];
    } else{
        [Hud showMessageWithText:@"现版本微信不支持分享,请更新"];
    }
}

- (NSString * )macString
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }

    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return macString;
}

- (NSString *)idfaString
{

    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];

    if (adSupportBundle == nil) {
        return @"";
    } else {

        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");

        if(asIdentifierMClass == nil){
            return @"";
        }
        else{

            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];

            if (asIM == nil) {
                return @"";
            }
            else{

                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}


- (void)moveToRootController:(NSDictionary *)dictionary
{
    [[SHGGloble sharedGloble] requestHomePageData];
    TabBarViewController *controller = [TabBarViewController tabBar];
    if ([controller isViewLoaded]) {
        controller.selectedIndex = 0;
        [controller tabBar:controller.tabBar didSelectItem:[controller.tabBar.items firstObject]];
    }
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = nav;
}

@end
