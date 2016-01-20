//
//  SetPassWordViewController.m
//  Finance
//
//  Created by zhuaijun on 15/8/13.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "SetPassWordViewController.h"
#import "ApplyViewController.h"
#import "ImproveMatiralViewController.h"
@interface SetPassWordViewController ()
{
    
    IBOutlet UITextField *confirmWordText;//确认密码
    IBOutlet UITextField *passWordText; //密码
}
@end

@implementation SetPassWordViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        self.title = @"设置密码";
    }
    
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
#pragma mark -注册密码
- (IBAction)registPassWord:(id)sender
{
    if (IsStrEmpty(passWordText.text))
    {
        [Hud showMessageWithText:@"请输入密码"];
        return;
    }
    
    if (passWordText.text.length > 20 || passWordText.text.length < 6) {
        [Hud showMessageWithText:@"密码长度为6-20位"];
        return;
    }
    
    if (![passWordText.text isEqualToString:confirmWordText.text]){
        [Hud showMessageWithText:@"两次输入的密码不同，重新输入"];
        return;
    }
    
    NSString *thirdUid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_THIRDPARTY_UID];
    NSString *logType =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_THIRDPARTY_TYPE];
    NSString *osv = [UIDevice currentDevice].systemVersion;
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];
    NSString *phone =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PHONE];
    NSString *authCode =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTHCODE];

    NSDictionary *param = @{@"loginNum":thirdUid, @"loginType":logType, @"ctype":@"iphone", @"phone":phone, @"pwd":[passWordText.text md5], @"validateCode":authCode, @"os":@"ios", @"osv":osv, @"appv":LOCAL_Version, @"yuncid":channelId?:@"", @"yunuid":userId?:@""};
    
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"thirdLogin/thirdUserRegister"] class:nil parameters:param success:^(MOCHTTPResponse *response){
        [Hud hideHud];
        //         NSString *isthirdlogin = response.dataDictionary[@"bindResult"];
        NSString *uid = response.dataDictionary[@"uid"];
        NSString *token = response.dataDictionary[@"token"];
        NSString *state = response.dataDictionary[@"state"];
        NSString *name = response.dataDictionary[@"name"];
        NSString *head_img = response.dataDictionary[@"head_img"];
        NSString *isfull = response.dataDictionary[@"isfull"];
        NSString *area = response.dataDictionary[@"area"];
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
        [[NSUserDefaults standardUserDefaults] setObject:isfull forKey:KEY_ISFULL];
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
        [[NSUserDefaults standardUserDefaults] setObject:area forKey:KEY_USER_AREA];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTOLOGIN];
        [[NSUserDefaults standardUserDefaults] setObject:[passWordText.text md5] forKey:KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self chatLoagin];
        ImproveMatiralViewController *vc = [[ImproveMatiralViewController alloc] init];
        vc.rid = self.rid;
        [self.navigationController pushViewController:vc animated:YES];
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        [Hud hideHud];
    }];

}
- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
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
                     NSLog(@"%@",error.description);
                     break;
                 case EMErrorServerTimeout:
                     NSLog(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                     //					 TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Logon failure"));
                     break;
             }
         }
     } onQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
