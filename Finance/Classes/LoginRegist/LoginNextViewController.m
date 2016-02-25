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

@interface LoginNextViewController ()
- (IBAction)actionFogetPwd:(id)sender;
- (IBAction)actionLogin:(id)sender;
- (IBAction)deleteButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *lblPassward;
@property (nonatomic, strong) NSString *isFull;
@end

@implementation LoginNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblPassward becomeFirstResponder];

    self.title = @"输入密码";
    
    UIView * padView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20.0, 45.0)];
    self.lblPassward.leftView = padView;
    self.lblPassward.leftViewMode = UITextFieldViewModeAlways;

    [self.lblPassward setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.lblPassward setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
    
    NSLog(@"phonephone=%@",self.phone);
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
    [Hud showLoadingWithMessage:@"登录中……"];
    NSString *password = [_lblPassward.text md5];

    NSString *osv = [UIDevice currentDevice].systemVersion;
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];
    NSDictionary *param = @{@"phone":self.phone, @"pwd":[_lblPassward.text md5], @"ctype":@"iphone", @"os":@"ios", @"osv":osv, @"appv":LOCAL_Version, @"yuncid":channelId?:@"", @"yunuid":userId?:@""};
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,actionlogin] class:nil parameters:param success:^(MOCHTTPResponse *response){
        [Hud hideHud];
        NSString *uid = response.dataDictionary[@"uid"];
        NSString *token = response.dataDictionary[@"token"];
        NSString *state = response.dataDictionary[@"state"];

        NSString *name = response.dataDictionary[@"name"];
        NSString *head_img = response.dataDictionary[@"head_img"];
        NSString *isfull = response.dataDictionary[@"isfull"];
        NSString *area = response.dataDictionary[@"area"];
        self.isFull = isfull;
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:area forKey:KEY_USER_AREA];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey: KEY_AUTOLOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //环信登录
        [self regiestToken];
    } failed:^(MOCHTTPResponse *response){
         [Hud showMessageWithText:response.errorMessage];
         [Hud hideHud];
     }];
}

- (IBAction)deleteButton:(id)sender {
    self.lblPassward.text = @"";
    [self.lblPassward becomeFirstResponder];
}

- (void)regiestToken
{
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *uid =  [[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    NSDictionary *param = @{@"uid":uid, @"t":token?:@"", @"channelid":channelId?:@"", @"channeluid":@"getui"};
    __weak typeof(self) weakSelf = self;
    [MOCHTTPRequestOperationManager putWithURL:rBaseAddressForHttpUBpush class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            if ([weakSelf.isFull isEqualToString:@"1"]){
                [weakSelf chatLoagin];
                [weakSelf loginSuccess];
            } else{
                ImproveMatiralViewController *vc = [[ImproveMatiralViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showLoadingWithMessage:response.errorMessage];
    }];
}

-(void)gotoImprove
{
    ImproveMatiralViewController *vc = [[ImproveMatiralViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
@end
