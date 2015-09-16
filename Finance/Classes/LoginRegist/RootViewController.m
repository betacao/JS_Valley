//
//  RootViewController.m
//  Finance
//
//  Created by HuMin on 15/5/12.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "RootViewController.h"
#import "MagicalRecord+Setup.h"
#import "ApplyViewController.h"
#import "LoginViewController.h"
#import "ImproveMatiralViewController.h"
@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImage;
@property (nonatomic, strong) NSString *isFull;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(SCREENHEIGHT < 568.000000){
        self.launchImage.image = [UIImage imageNamed:@"480"];
    } else if(SCREENHEIGHT == 568.000000){
        self.launchImage.image = [UIImage imageNamed:@"568"];
    } else if(SCREENHEIGHT == 667.000000){
        self.launchImage.image = [UIImage imageNamed:@"667"];
    } else if(SCREENHEIGHT > 667.000000){
        self.launchImage.image=[UIImage imageNamed:@"736"];
    }
    
    [[SHGGloble sharedGloble] requestHomePageData];
    NSString *flagStr = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTOLOGIN];
    BOOL flag = NO;
    if (!IsStrEmpty(flagStr))
    {
        flag = [flagStr boolValue];
    }
    if (flag) {
        [self autoLogin];
    }else{
        [self showLoginViewController];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)showLoginViewController
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    [AppDelegate currentAppdelegate].window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:vc];
}

-(void)autoLogin
{
    NSString *key_Uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *key_Token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    if(!key_Uid || !key_Token){
        [self showLoginViewController];
        return;
    }
    NSDictionary *param = @{@"uid":key_Uid,@"t":key_Token};
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"login",@"auto"] class:nil parameters:param success:^(MOCHTTPResponse *response){
        NSString *code =[response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            NSString *uid = response.dataDictionary[@"uid"];
            NSString *token = response.dataDictionary[@"token"];
            NSString *state = response.dataDictionary[@"state"];
            NSString *name = response.dataDictionary[@"name"];
            NSString *head_img = response.dataDictionary[@"head_img"];
            
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
            [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
            [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTOLOGIN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *isfull = response.dataDictionary[@"isfull"];
            self.isFull = isfull;
            {
                if ([self.isFull isEqualToString:@"1"])
                {
                    [self chatLoagin];
                    [self loginSuccess];
                }
                else
                {
                    ImproveMatiralViewController *vc = [[ImproveMatiralViewController alloc] init];
                    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
                    [AppDelegate currentAppdelegate].window.rootViewController = nav;
                }
            }
        }
    }failed:^(MOCHTTPResponse *response){
        [Hud hideHud];
        [Hud showMessageWithText:@"失败"];
        [Hud showMessageWithText:response.errorMessage];
        [AppDelegate currentAppdelegate].window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }];
}

#ifdef __IPHONE_7_0
- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}
#endif
- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error)
    {
         if (loginInfo && !error)
         {
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
             //发送自动登陆状态通知
             //             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             //将旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error)
             {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             
             [[ApplyViewController shareController] loadDataSourceFromLocalDB];
             
         }else
         {
             switch (error.errorCode)
             {
                 case EMErrorServerNotReachable:
                     NSLog(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     NSLog(error.description);
                     break;
                 case EMErrorServerTimeout:
                     NSLog(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     //	TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
                     break;
             }
         }
     } onQueue:nil];
}
#pragma mark - private
//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    BaseNavigationController *nav = nil;
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess)
    {//登陆成功加载主窗口控制器
    }else
    {//登陆失败加载登陆页面控制器
        //		_mainController = nil;
        LoginViewController *loginController = [[LoginViewController alloc] init];
        nav = [[BaseNavigationController alloc] initWithRootViewController:loginController];
        loginController.title = NSLocalizedString(@"AppName", @"EaseMobDemo");
    }
    
    //设置7.0以下的导航栏
    if ([UIDevice currentDevice].systemVersion.floatValue < 7.0)
    {
        nav.navigationBar.barStyle = UIBarStyleDefault;
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"titleBar"]
                                forBarMetrics:UIBarMetricsDefault];
        
        [nav.navigationBar.layer setMasksToBounds:YES];
    }
    
    [AppDelegate currentAppdelegate].window.rootViewController = nav;
    
    [nav setNavigationBarHidden:YES];
    [nav setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation
*/
-(void)loginSuccess
{
    TabBarViewController *vc = [TabBarViewController tabBar];
    vc.rid = self.rid;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [AppDelegate currentAppdelegate].window.rootViewController =nav;
}
@end
