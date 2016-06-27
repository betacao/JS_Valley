//
//  TabBarViewController.m
//  DingDCommunity
//
//  Created by HuMin on 14-12-2.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "TabBarViewController.h"
#import "SHGHomeViewController.h"
#import "SHGUserCenterViewController.h"
#import "ApplyViewController.h"
#import "CircleDetailViewController.h"
#import "SHGDiscoveryViewController.h"
#import "headImage.h"
#import "MessageViewController.h"
#import "SHGSegmentController.h"
#import "SHGNewsViewController.h"
#import "SHGPersonalViewController.h"
#import "SHGBusinessListViewController.h"
#import "GroupListViewController.h"
//#import "CommonMethod.h"

@interface TabBarViewController()<SHGSegmentControllerDelegate>
@property (strong, nonatomic) SHGSegmentController *homeSegmentViewController;
@property (strong, nonatomic) SHGHomeViewController *homeViewController;
@property (strong, nonatomic) SHGNewsViewController *newsViewController;
@property (strong, nonatomic) SHGDiscoveryViewController *discoveryViewController;
@property (strong, nonatomic) SHGUserCenterViewController *meViewController;
@property (strong, nonatomic) SHGBusinessListViewController *businessListViewController;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) UIView *homeSegmentTitleView;
@property (strong, nonatomic) UIView *businessSegmentTitleView;
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

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    [self.tabBar setShadowImage:[CommonMethod imageWithColor:Color(@"e2e2e2")]];
    [self addObserver:[AppDelegate currentAppdelegate] forKeyPath:@"isViewLoad" options:NSKeyValueObservingOptionNew context:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGB(51, 51, 51), NSForegroundColorAttributeName, nil];;
    [[UITabBarItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];

    self.tabBar.tintColor = RGB(255, 57, 67);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
    [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:options completion:^(EMPushNotificationOptions *options, EMError *error) {

    } onQueue:queue];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SHGGloble sharedGloble] checkForUpdate:nil];
    });
    //拉取群组信息
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[GroupListViewController shareGroupListController] reloadDataSource];
    });
    [self initSubpage];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.isViewLoad = YES;
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItems = nil;
    if (item.tag == 1000){
        self.navigationItem.titleView = self.businessSegmentTitleView;
        self.navigationItem.leftBarButtonItem = self.businessListViewController.leftBarButtonItem;
        self.navigationItem.rightBarButtonItem = self.businessListViewController.rightBarButtonItem;
        [MobClick event:@"EnterMarketController" label:@"onClick"];

    } else if (item.tag == 2000){
        self.navigationItem.titleView = self.homeSegmentTitleView;
        self.navigationItem.rightBarButtonItem = self.homeSegmentViewController.rightBarButtonItem;
        self.navigationItem.leftBarButtonItem = self.homeSegmentViewController.leftBarButtonItem;
        [MobClick event:@"SHGHomeViewController" label:@"onClick"];

    } else if (item.tag == 3000){
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.titleView = self.discoveryViewController.titleLabel;
        self.navigationItem.rightBarButtonItem = nil;
        [MobClick event:@"DiscoverViewController" label:@"onClick"];

    } else if (item.tag == 4000){
        self.navigationItem.titleView = self.meViewController.titleLabel;
        self.navigationItem.leftBarButtonItem = nil;
        [MobClick event:@"MeViewController" label:@"onClick"];
    }
}

#pragma mark - 子页面初始化
- (void)initSubpage
{
    //业务
    __weak typeof(self)weakSelf = self;
    UIImage *image = [UIImage imageNamed:@"business"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:@"business_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.businessListViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"业务" image:image selectedImage:selectedImage];
    self.businessListViewController.tabBarItem.tag = 1000;
    self.businessListViewController.block = ^(UIView *view){
        weakSelf.businessSegmentTitleView = view;
        weakSelf.navigationItem.titleView = weakSelf.businessSegmentTitleView;
    };
    //首页
    image = [UIImage imageNamed:@"home"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"home_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.homeSegmentViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"动态" image:image selectedImage:selectedImage];
    self.homeSegmentViewController.tabBarItem.tag = 2000;
    self.homeSegmentViewController.block = ^(UIView *view){
        weakSelf.homeSegmentTitleView = view;
        weakSelf.navigationItem.titleView = weakSelf.homeSegmentTitleView;
    };

    //产品
    image = [UIImage imageNamed:@"find"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"find_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.discoveryViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:image selectedImage:selectedImage];
    self.discoveryViewController.tabBarItem.tag = 3000;
    
    //我的
    image = [UIImage imageNamed:@"my"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [UIImage imageNamed:@"my_height"];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.meViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:image selectedImage:selectedImage];
    self.meViewController.tabBarItem.tag = 4000;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"949494"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"E21F0D"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    self.viewControllers = [NSArray arrayWithObjects:self.businessListViewController,self.homeSegmentViewController,self.discoveryViewController ,self.meViewController ,nil];
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
        _homeViewController = [SHGHomeViewController sharedController];
    }
    return _homeViewController;
}

- (SHGNewsViewController *)newsViewController
{
    if(!_newsViewController){
        _newsViewController = [[SHGNewsViewController alloc] init];
    }
    return _newsViewController;
}

- (SHGBusinessListViewController *)businessListViewController
{
    if(!_businessListViewController){
        _businessListViewController = [SHGBusinessListViewController sharedController];
    }
    return _businessListViewController;
}

- (SHGDiscoveryViewController *)discoveryViewController
{
    return [SHGDiscoveryViewController sharedController];
}

- (SHGUserCenterViewController *)meViewController
{
    if (!_meViewController)
    {
        _meViewController = [[SHGUserCenterViewController alloc] init];
    }
    return _meViewController;
}

#pragma mark - 操作
- (void)setSelectedIndex:(NSUInteger)selectedIndex
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
