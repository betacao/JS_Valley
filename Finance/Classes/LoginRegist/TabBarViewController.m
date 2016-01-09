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
#import "ApplyViewController.h"
#import "CircleDetailViewController.h"
#import "DiscoverViewController.h"
#import "headImage.h"
#import "MessageViewController.h"
#import "VerifyIdentityViewController.h"
#import "SHGSegmentController.h"
#import "SHGNewsViewController.h"
#import "SHGPersonalViewController.h"
#import "SHGMarketSegmentViewController.h"
#import "SHGMarketListViewController.h"
#import "SHGMarketMineViewController.h"
#import "UINavigationBar+Awesome.h"

@interface TabBarViewController()<SHGSegmentControllerDelegate>
@property (strong, nonatomic) SHGSegmentController *homeSegmentViewController;
@property (strong, nonatomic) SHGHomeViewController *homeViewController;
@property (strong, nonatomic) SHGNewsViewController *newsViewController;
@property (strong, nonatomic) DiscoverViewController *prodViewController;
@property (strong, nonatomic) MeViewController *meViewController;
@property (strong, nonatomic) SHGMarketSegmentViewController *marketSegmentViewController;
@property (strong, nonatomic) SHGMarketListViewController *marketListViewController;
@property (strong, nonatomic) SHGMarketMineViewController *marketMineViewController;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) UIView *homeSegmentTitleView;
@property (strong, nonatomic) UIView *marketSegmentTitleView;
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

+ (TabBarViewController *)tabBar
{
    static TabBarViewController *tabBar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        tabBar = [[self alloc]init];
    });
    return tabBar;
}

- (instancetype)init
{
    if (self=[super init]){
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(51, 51, 51), NSForegroundColorAttributeName, nil];;
    [[UITabBarItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];

    self.tabBar.tintColor = RGB(255, 57, 67);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    
    self.navigationController.delegate = self;
    [self initSubpage];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.dictionary){
        [self pushCircle:self.dictionary];
        self.dictionary = nil;
    }
}

- (void)pushCircle:(NSDictionary*)userInfo
{
    pushInfo = [userInfo copy];
    if ([userInfo objectForKey:@"code"]){
        UIViewController *TopVC = [self getCurrentRootViewController];
        NSString *ridCode = [userInfo objectForKey:@"code"];
        if ([ridCode isEqualToString:@"1001"]){ //进入通知
            MessageViewController *detailVC=[[MessageViewController alloc] init];
            [self pushIntoViewController:TopVC newViewController:detailVC];
        } else if ([ridCode isEqualToString:@"1004"]){  //进入关注人的个人主页
            SHGPersonalViewController *controller = [[SHGPersonalViewController alloc] initWithNibName:@"SHGPersonalViewController" bundle:nil];
            controller.userId = [NSString stringWithFormat:@"%@",userInfo[@"uid"]];
            [self pushIntoViewController:TopVC newViewController:controller];
        } else if ([ridCode isEqualToString:@"1005"] || [ridCode isEqualToString:@"1006"]){ //进入认证页面
            if ([ridCode isEqualToString:@"1005"]){
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTHSTATE];
            } else{
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KEY_AUTHSTATE];
            }
            VerifyIdentityViewController *meControl =[[VerifyIdentityViewController alloc]init];
            [self pushIntoViewController:TopVC newViewController:meControl];
        } else{  //进入帖子详情
            CircleDetailViewController *vc = [[CircleDetailViewController alloc] init];
            NSString* rid = [userInfo objectForKey:@"rid"];
            vc.rid = rid;
            [self pushIntoViewController:TopVC newViewController:vc];
        }
    }
}

- (void)pushIntoViewController:(UIViewController*)viewController newViewController:(UIViewController*)newController
{
    UINavigationController *navs;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        navs = (UINavigationController *)viewController;
        for (UIViewController *viewControl in navs.viewControllers){
            if ([viewControl isKindOfClass:[LoginViewController class]]){
                //未登录,先登录再查看
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
    if (item.tag == 1000){
        self.navigationItem.titleView = self.homeSegmentTitleView;
        self.navigationItem.rightBarButtonItem = self.homeSegmentViewController.rightBarButtonItem;
        self.navigationItem.leftBarButtonItem = self.homeSegmentViewController.leftBarButtonItem;
        [MobClick event:@"SHGHomeViewController" label:@"onClick"];
    } else if (item.tag == 2000){
        self.navigationItem.titleView = self.marketSegmentTitleView;
        self.navigationItem.rightBarButtonItem = self.marketSegmentViewController.rightBarButtonItem;
        self.navigationItem.leftBarButtonItem = self.marketSegmentViewController.leftBarButtonItem;
        [MobClick event:@"EnterMarketController" label:@"onClick"];

    } else if (item.tag == 3000){
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.titleView = self.prodViewController.titleLabel;
        self.navigationItem.rightBarButtonItem = nil;
        [MobClick event:@"DiscoverViewController" label:@"onClick"];

    } else if (item.tag == 4000){
        self.navigationItem.titleView = self.meViewController.titleLabel;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[self.meViewController.rightBarButtonItem];
        [MobClick event:@"MeViewController" label:@"onClick"];
    }
}
#pragma mark - 子页面初始化
-(void)initSubpage
{
    //首页
    UIImage *image = [UIImage imageNamed:@"home"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:@"home_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.homeSegmentViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:image selectedImage:selectedImage];
    self.homeSegmentViewController.tabBarItem.tag = 1000;
    __weak typeof(self)weakSelf = self;
    self.homeSegmentViewController.block = ^(UIView *view){
        weakSelf.homeSegmentTitleView = view;
        weakSelf.navigationItem.titleView = weakSelf.homeSegmentTitleView;
    };
    self.navigationItem.rightBarButtonItem = self.homeSegmentViewController.rightBarButtonItem;
    self.navigationItem.leftBarButtonItem = self.homeSegmentViewController.leftBarButtonItem;
    //业务
    image = [UIImage imageNamed:@"business"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"business_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.marketSegmentViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"业务" image:image selectedImage:selectedImage];
    self.marketSegmentViewController.tabBarItem.tag = 2000;
    self.marketSegmentViewController.block = ^(UIView *view){
        weakSelf.marketSegmentTitleView = view;
        weakSelf.navigationItem.titleView = weakSelf.marketSegmentTitleView;
    };
    //产品
    image = [UIImage imageNamed:@"find"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"find_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.prodViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:image selectedImage:selectedImage];
    self.prodViewController.tabBarItem.tag = 3000;
    
    //我的
    image = [UIImage imageNamed:@"my"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"my_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.meViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:image selectedImage:selectedImage];
    self.meViewController.tabBarItem.tag = 4000;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    self.viewControllers = [NSArray arrayWithObjects:self.homeSegmentViewController,self.marketSegmentViewController,self.prodViewController ,self.meViewController ,nil];
    self.selectedIndex = 0;
    
}

- (SHGSegmentController *)homeSegmentViewController
{
    if(!_homeSegmentViewController){
        _homeSegmentViewController = [SHGSegmentController sharedSegmentController];
        _homeSegmentViewController.delegate = self;
        _homeSegmentViewController.viewControllers = @[self.homeViewController, self.newsViewController];
    }
    return _homeSegmentViewController;
}

- (SHGHomeViewController *)homeViewController
{
    if (!_homeViewController){
        _homeViewController = [[SHGHomeViewController alloc]initWithNibName:@"SHGHomeViewController" bundle:nil];
    }
    return _homeViewController;
}

- (SHGNewsViewController *)newsViewController
{
    if(!_newsViewController){
        _newsViewController = [[SHGNewsViewController alloc] initWithNibName:@"SHGNewsViewController" bundle:nil];
    }
    return _newsViewController;
}

- (SHGMarketSegmentViewController *)marketSegmentViewController
{
    if(!_marketSegmentViewController){
        _marketSegmentViewController = [SHGMarketSegmentViewController sharedSegmentController];
        _marketSegmentViewController.viewControllers = @[self.marketListViewController, self.marketMineViewController];
    }
    return _marketSegmentViewController;
}

- (SHGMarketListViewController *)marketListViewController
{
    if (!_marketListViewController){
        _marketListViewController = [[SHGMarketListViewController alloc] init];
    }
    return _marketListViewController;
}

- (SHGMarketMineViewController *)marketMineViewController
{
    if(!_marketMineViewController){
        _marketMineViewController = [[SHGMarketMineViewController alloc] init];
    }
    return _marketMineViewController;
}


- (DiscoverViewController *)prodViewController
{
    if (!_prodViewController)
    {
        _prodViewController = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
    }
    return _prodViewController;
}

- (MeViewController *)meViewController
{
    if (!_meViewController)
    {
        _meViewController = [[MeViewController alloc] initWithNibName:@"MeViewController" bundle:nil];
    }
    return _meViewController;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    //若上个view不为空
    if (lastController != nil)
    {
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)]){
        }
    }
    lastController = viewController;
}
#pragma mark - 操作

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)jumpToChatList
{
    [self.homeSegmentViewController jumpToChatList];
}

- (void)setupUntreatedApplyCount
{
    [self.homeSegmentViewController setupUntreatedApplyCount];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
