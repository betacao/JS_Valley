//
//  LoginViewController.m
//  Finance
//
//  Created by HuMin on 15/4/8.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "RegistViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "BindPhoneViewController.h"
#import "ApplyViewController.h"
#import <QZoneConnection/ISSQZoneApp.h>

#define kButtonMargin 44.0f//第三方按钮之间的距离

@interface LoginViewController ()
- (IBAction)actionShowMem:(id)sender;
- (IBAction)actionLogin:(id)sender;
- (IBAction)actionFogetPwd:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textPwd;
@property (weak, nonatomic) IBOutlet UITextField *textUser;
@property (weak, nonatomic) IBOutlet UILabel *loginLab;
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;
@property (weak, nonatomic) IBOutlet UIButton *QQButton;
@property (weak, nonatomic) IBOutlet UIButton *weiBoButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;



@end

@implementation LoginViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.title = @"登录/注册";
    }
    
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.loginLab.textColor = RGB(96, 96, 96);
    if ([[NSUserDefaults standardUserDefaults]objectForKey:KEY_PHONE]){
         _textUser.text = [[NSUserDefaults standardUserDefaults]objectForKey:KEY_PHONE];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self adjustButtonFrame];
}

- (void)adjustButtonFrame
{
    if(![WXApi isWXAppInstalled]){
        self.weChatButton.hidden = YES;
        CGFloat middle = SCREENWIDTH / 2.0f;
        
        CGRect frame = self.QQButton.frame;
        frame.origin.x = middle - kButtonMargin / 2.0f - CGRectGetWidth(frame);
        self.QQButton.frame = frame;
        
        frame = self.weiBoButton.frame;
        frame.origin.x = middle + kButtonMargin / 2.0f;
        self.weiBoButton.frame = frame;
    }
    
    CGRect frame = self.lineLabel.frame;
    frame.origin.y = CGRectGetMaxY(self.textUser.frame) + 5.0f;
    frame.size.height = 0.5f;
    self.lineLabel.frame = frame;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark =============  Button Action =============

-(void)actionRegist:(id)sender
{
    NSLog(@"regist");
    RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)actionShowMem:(id)sender {
    NSLog(@"showMem");
    
}

- (IBAction)actionLogin:(id)sender {
    NSLog(@"login");

    if (IsStrEmpty(_textUser.text)) {
        [Hud showMessageWithText:@"手机号不能为空"];
        return;
    }
    if (![_textUser.text isValidateMobile]) {
        [Hud showMessageWithText:@"手机号非法"];

        return;
    }
    [Hud showLoadingWithMessage:@"登录验证中……"];
    [self login];
}

- (IBAction)thirdPartyLog:(id)sender
{
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    UIButton *button =(UIButton*)sender;
    ShareType type;
    NSString *logType=@"";
    switch (button.tag) {
        case 1000:
            type = ShareTypeSinaWeibo;
            logType = @"weibo";
            break;
        case 1001:
            type= ShareTypeWeixiSession;
            logType = @"weixin";
            break;
        case 1002:{
            type = ShareTypeQQSpace;
            logType = @"qq";
            id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
            [app setIsAllowWebAuthorize:YES];
        }
            
            break;
            
        default:
            break;
    }
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error){
        if (result){
            NSLog(@"%@",[userInfo sourceData]);
            
            NSString *osv = [UIDevice currentDevice].systemVersion;
            NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
            NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];
            NSDictionary *param = @{@"loginNum":[userInfo uid],
                                    @"loginType":logType,
                                    @"ctype":@"iphone",
                                    @"os":@"ios",
                                    @"osv":osv,
                                    @"appv":LOCAL_Version,
                                    @"yuncid":channelId?:@"",
                                    @"yunuid":userId?:@""};
            
            [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"thirdLogin/isThirdLogin"] class:nil parameters:param success:^(MOCHTTPResponse *response){
                [Hud hideHud];
                NSString *isthirdlogin = response.dataDictionary[@"isthirdlogin"];
                NSString *uid = response.dataDictionary[@"uid"];
                NSString *token = response.dataDictionary[@"token"];
                NSString *state = response.dataDictionary[@"state"];
                NSString *name = response.dataDictionary[@"name"];
                NSString *head_img = response.dataDictionary[@"head_img"];
                NSString *isfull = response.dataDictionary[@"isfull"];
                NSString *pwd =response.dataDictionary[@"pwd"];
                [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
                [[NSUserDefaults standardUserDefaults] setObject:[userInfo uid] forKey:KEY_THIRDPARTY_UID];
                [[NSUserDefaults standardUserDefaults] setObject:isfull forKey:KEY_ISFULL];
                [[NSUserDefaults standardUserDefaults] setObject:logType forKey:KEY_THIRDPARTY_TYPE];
                [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
                [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
                [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey: KEY_AUTOLOGIN];
                [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:KEY_PASSWORD];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if ([isthirdlogin isEqualToString:@"false"]){
                    BindPhoneViewController *bindViewCon =[[BindPhoneViewController alloc]init];
                    [self.navigationController pushViewController:bindViewCon animated:YES];
                }else{
                    [self chatLoagin];
                    TabBarViewController *vc = [TabBarViewController tabBar];
                    vc.rid = self.rid;
                    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
                    [AppDelegate currentAppdelegate].window.rootViewController =nav;
                }
                
            } failed:^(MOCHTTPResponse *response) {
                [Hud showMessageWithText:response.errorMessage];
                [Hud hideHud];
            }];
            
        }else{
            if  ([error errorCode] == -6004){ //跳转网页版
                [Hud showMessageWithText:@"请先安装客户端"];
            }else if ([error errorCode] == -22003){
                [Hud showMessageWithLongText:@"当前您未安装微信，请使用手机号，QQ或微博登录"];
            }
            NSLog(@"登陆失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
        }
    }];
}

-(void)login
{
    
    [MOCHTTPRequestOperationManager getWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"login",@"validate"] class:[LoginObj class] parameters:@{@"phone":self.textUser.text}success:^(MOCHTTPResponse *response)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.textUser.text forKey:KEY_PHONE];
        [Hud hideHud];
        NSLog(@"%@",response.dataDictionary);
        NSLog(@"%@",response);
        NSString *state = response.dataDictionary[@"state"];
        if ([state boolValue])
        {
            LoginNextViewController *vc = [[LoginNextViewController alloc] initWithNibName:@"LoginNextViewController" bundle:nil];
            vc.phone = self.textUser.text;
            vc.rid = self.rid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //未注册;
            RegistViewController *vc = [[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil];
            vc.phoneNumber = self.textUser.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failed:^(MOCHTTPResponse *response)
    {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
        NSLog(@"%@",response.data);
        NSLog(@"%@",response.errorMessage);
        
    }];
}
- (IBAction)actionFogetPwd:(id)sender {
    
    NSLog(@"goget");

}
- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid password:password completion: ^(NSDictionary *loginInfo, EMError *error) {
        if (loginInfo && !error) {
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
            //发送自动登陆状态通知
            //             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            //将旧版的coredata数据导入新的数据库
            EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
            if (!error) {
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
                    break;
                case EMErrorServerTimeout:
                    NSLog(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                    break;
                default:
                    break;
            }
        }
    } onQueue:nil];
}
@end
