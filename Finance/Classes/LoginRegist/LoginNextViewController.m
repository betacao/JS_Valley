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
@property (weak, nonatomic) IBOutlet UITextField *lblPassward;
@property (nonatomic, strong)NSString *isFull;
@end

@implementation LoginNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_lblPassward becomeFirstResponder];

    self.title = @"登录";
    
    NSLog(@"phonephone=%@",self.phone);
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionFogetPwd:(id)sender
{
    ResetPasswardViewController *vc = [[ResetPasswardViewController alloc] initWithNibName:@"ResetPasswardViewController" bundle:nil];
    vc.phone = self.phone;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)actionLogin:(id)sender
{
    if (IsStrEmpty(_lblPassward.text))
    {
        [Hud showMessageWithText:@"请输入密码"];
        return;
    }
    [Hud showLoadingWithMessage:@"登录中……"];
    NSString *password = [_lblPassward.text md5];
    //	NSString *password = _lblPassward.text ;

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
        self.isFull = isfull;
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:        KEY_AUTOLOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //环信登录
        [self regiestToken];
    } failed:^(MOCHTTPResponse *response)
     {
         [Hud showMessageWithText:response.errorMessage];
         [Hud hideHud];
     }];
}

-(void)regiestToken
{
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *uid =  [[NSUserDefaults standardUserDefaults]objectForKey:KEY_UID];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    NSDictionary *param = @{@"uid":uid, @"t":token?:@"", @"channelid":channelId?:@"", @"channeluid":@"getui"};
    [[AFHTTPRequestOperationManager manager] PUT:rBaseAddressForHttpUBpush parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject){
         NSString *code = [responseObject valueForKey:@"code"];
         if ([code isEqualToString:@"000"]){
             if ([self.isFull isEqualToString:@"1"]){
                 [self chatLoagin];
                 [self loginSuccess];
             } else{
                 ImproveMatiralViewController *vc = [[ImproveMatiralViewController alloc] init];
                 [self.navigationController pushViewController:vc animated:YES];
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [Hud showLoadingWithMessage:error.domain];
        
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

-(void)loginSuccess
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_CHANGE_UPDATE_AUTO_STATUE object:nil];

    TabBarViewController *vc = [TabBarViewController tabBar];
    vc.rid = self.rid;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [AppDelegate currentAppdelegate].window.rootViewController = nav;
    //重新登录时刷新我的页面数据
}
@end
