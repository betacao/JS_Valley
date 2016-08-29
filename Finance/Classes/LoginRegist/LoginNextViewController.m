//
//  LoginNextViewController.m
//  Finance
//
//  Created by HuMin on 15/4/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "LoginNextViewController.h"
#import "SHGHomeViewController.h"
#import "ApplyViewController.h"
#import "SHGRecommendViewController.h"
@interface LoginNextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *lblPassward;
@property (weak, nonatomic) IBOutlet UIButton *forgetPassward;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) NSString *recommend;
@property (nonatomic, strong) NSString *isFull;
@end

@implementation LoginNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"输入密码";
    [self addSdLayout];
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, MarginFactor(12.0f), MarginFactor(55.0f))];
    self.lblPassward.leftView = leftView;
    self.lblPassward.leftViewMode = UITextFieldViewModeAlways;

    [self.lblPassward setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    self.lblPassward.font = FontFactor(16.0f);
    self.lblPassward.textColor = [UIColor colorWithHexString:@"161616"];

    [self.forgetPassward setTitleColor:[UIColor colorWithHexString:@"989898"] forState:UIControlStateNormal];
    self.forgetPassward.titleLabel.font = FontFactor(12.0f);
    [self.loginButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor colorWithHexString:@"f04241"]];
    self.loginButton.titleLabel.font = FontFactor(17.0f);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.lblPassward becomeFirstResponder];

}

- (void)addSdLayout
{
    
    self.lblPassward.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    
    self.forgetPassward.sd_layout
    .topSpaceToView(self.lblPassward, MarginFactor(10.0f))
    .rightSpaceToView(self.view, 0.0f)
    .widthIs(MarginFactor(80.0f))
    .heightIs(MarginFactor(15.0f));

    self.loginButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.lblPassward, MarginFactor(181.0f))
    .heightIs(MarginFactor(40.0f));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)actionFogetPwd:(id)sender
{
    ResetPasswardViewController *vc = [[ResetPasswardViewController alloc] initWithNibName:@"ResetPasswardViewController" bundle:nil];
    vc.phone = self.phone;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogin:(id)sender
{
    if (IsStrEmpty(_lblPassward.text)){
        [Hud showMessageWithText:@"请输入密码"];
        return;
    }
    [Hud showWait];
    [self login];

}

- (void)login
{
    WEAK(self, weakSelf);
    NSString *password = [_lblPassward.text md5];
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];
    NSDictionary *param = @{@"phone":self.phone, @"pwd":[_lblPassward.text md5], @"ctype":@"iPhone", @"os":@"iOS", @"osv":[UIDevice currentDevice].systemVersion, @"appv":LOCAL_Version, @"yuncid":channelId?:@"", @"yunuid":userId?:@"", @"phoneType":[SHGGloble sharedGloble].platform};
    
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,actionlogin] class:nil parameters:param success:^(MOCHTTPResponse *response){
        [Hud hideHud];
        NSString *uid = response.dataDictionary[@"uid"];
        NSString *token = response.dataDictionary[@"token"];
        NSString *state = response.dataDictionary[@"state"];
        NSString *name = response.dataDictionary[@"name"];
        NSString *head_img = response.dataDictionary[@"head_img"];
        NSString *area = response.dataDictionary[@"area"];
        NSString *companyName = response.dataDictionary[@"companyname"];
        weakSelf.isFull = response.dataDictionary[@"isfull"];
        weakSelf.recommend = response.dataDictionary[@"recommend"];
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:companyName forKey:KEY_COMPANYNAME];
        [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:area forKey:KEY_USER_AREA];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey: KEY_AUTOLOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //环信登录
        [weakSelf registerToken];
    } failed:^(MOCHTTPResponse *response){
        //[Hud showMessageWithText:response.errorMessage];
        SHGAlertView *alert = [[SHGAlertView alloc] initWithTitle:@"提示" contentText:response.errorMessage leftButtonTitle:@"重试" rightButtonTitle:@"退出"];
        alert.rightBlock = ^{
            [[AppDelegate currentAppdelegate] exitApplication];
        };
        
        alert.leftBlock = ^{
            [self login];
        };
        [alert show];
        [Hud hideHud];
    }];
}

- (void)registerToken
{
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *uid =  [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    NSDictionary *param = @{@"uid":uid, @"t":token?:@"", @"channelid":channelId?:@"", @"channeluid":@"getui"};
    WEAK(self, weakSelf);

    [[SHGGloble sharedGloble] registerToken:param block:^(BOOL success, MOCHTTPResponse *response) {
        if (success) {
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                if ([weakSelf.recommend isEqualToString:@"1"]) {
                    [weakSelf chatLoagin];
                    [weakSelf loginSuccess];
                } else{
                    SHGRecommendViewController *viewController = [[SHGRecommendViewController alloc] init];
                    [self.navigationController pushViewController:viewController animated:YES];
                }
                
            }
        } else{
            [Hud showMessageWithText:response.errorMessage];
        }
    }];
}

- (void) chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid password:password completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         if (loginInfo && !error) {
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];

             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             [[ApplyViewController shareController] loadDataSourceFromLocalDB];
             
         }else {
             switch (error.errorCode) {
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
                     break;
             }

         }
     } onQueue:nil];
}

- (void)loginSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];
    [[AppDelegate currentAppdelegate] moveToRootController:self.rid];
    //重新登录时刷新我的页面数据
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.lblPassward resignFirstResponder];
}

@end
