//
//  BindPhoneViewController.m
//  Finance
//
//  Created by zhuaijun on 15/8/13.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "SetPassWordViewController.h"
#import "ApplyViewController.h"
#import "ProtocolViewController.h"

typedef NS_ENUM(NSInteger, RegistType)
{
    RegistInit = 0,//未发送验证码
    RegistInTime = 1,//已发送验证码
    RegistOverTime = 2,//验证码过时
};

@interface BindPhoneViewController ()
{
    
    IBOutlet UITextField *phoneText;  //手机号
    IBOutlet UITextField *authCodeText; //验证码
    IBOutlet UIButton *getAuthCodeBtn;  //获取验证码
    IBOutlet UIButton *reGetAuthCodeBtn; //重新获取验证码
    
    IBOutlet UIButton *bindActionBtn; //绑定操作
    IBOutlet UIButton *readNegotiate;  //阅读相关协议
    
}
//重新发送的剩余时间
@property (nonatomic, assign) NSInteger remainTime;
//重新发送的定时器
@property (nonatomic, strong) NSTimer	*remainTimer;
//定制view的类型
@property (nonatomic, assign) RegistType registType;
@property (nonatomic, strong) NSString *isFull;
@end

@implementation BindPhoneViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"绑定手机号";
    }
    
    return  self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect rect = bindActionBtn.frame;
    rect.origin.y = bindActionBtn.origin.y-25;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUIViews];
}

-(void)configUIViews
{
    [getAuthCodeBtn.layer setCornerRadius:4.0];
    [getAuthCodeBtn.layer setMasksToBounds:YES];
    
    [reGetAuthCodeBtn.layer setCornerRadius:4.0];
    [reGetAuthCodeBtn.layer setMasksToBounds:YES];
    
    
    NSString *btnStr = @"点击绑定按钮,即表示同意《大牛圈用户协议》";
    NSRange range =[btnStr rangeOfString:@"《"];
    range =NSMakeRange(12, 9);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:btnStr];
    NSDictionary *dic =@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:57/255.0 blue:67/255.0 alpha:1.0]};
    [attrString setAttributes:dic range:range];

    [readNegotiate setAttributedTitle:attrString forState:UIControlStateNormal];
    [readNegotiate setTitleColor:RGB(96.0f, 96.0f, 96.0f) forState:UIControlStateNormal];
    [readNegotiate addTarget:self action:@selector(protocolButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)protocolButtonClicked:(id)sender
{
    ProtocolViewController *vc = [[ProtocolViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)getverifyCodeRequest
{
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"sms"] parameters:@{@"type":@"register",@"phone":phoneText.text} success:^(MOCHTTPResponse *response) {
        getAuthCodeBtn.userInteractionEnabled = NO;
        self.remainTime = 60;
        self.remainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshButtonCount) userInfo:nil repeats:YES];
        NSLog(@"%@",response.dataDictionary);
        NSLog(@"%@",response);
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}

-(void)refreshButtonCount
{
    if (self.remainTime >0) {
        self.remainTime --;
        [self reloadView:RegistInTime];
    }else{
        [self.remainTimer invalidate];
        self.remainTimer = nil;
        [self reloadView:RegistOverTime];
    }
}

- (void)reloadView:(RegistType)registType
{
    self.registType = registType;
    if (registType == RegistInit) {
        authCodeText.text	= @"";
        [getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        reGetAuthCodeBtn.hidden = YES;
        getAuthCodeBtn.userInteractionEnabled = YES;
        registType = RegistInTime;
    }else if (registType == RegistInTime){
        
        [getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        getAuthCodeBtn.userInteractionEnabled = NO;
        [reGetAuthCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.remainTime] forState:UIControlStateNormal];
        reGetAuthCodeBtn.hidden = NO;
        
    }else if (registType == RegistOverTime){
        [getAuthCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        reGetAuthCodeBtn.hidden = YES;
        getAuthCodeBtn.userInteractionEnabled = YES;
    }else{
        return;
    }
}
#pragma mark -获取验证码
- (IBAction)getAuthCode:(id)sender
{
    if (IsStrEmpty(phoneText.text)) {
        [Hud showMessageWithText:@"手机号码不能为空"];
        return;
    }
    [self getverifyCodeRequest];
    
}

#pragma mark -绑定号码
- (IBAction)bindPhone:(id)sender
{
    if (IsStrEmpty(authCodeText.text)) {
        [Hud showMessageWithText:@"请先输入验证码"];
        return;
    }
    
    NSString *thirdUid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_THIRDPARTY_UID];
    NSString *logType =[[NSUserDefaults standardUserDefaults] objectForKey:KEY_THIRDPARTY_TYPE];
    NSString *osv = [UIDevice currentDevice].systemVersion;
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];

    NSDictionary *param = @{@"loginNum":thirdUid, @"loginType":logType, @"ctype":@"iphone", @"phone":phoneText.text, @"validateCode":authCodeText.text, @"os":@"ios", @"osv":osv, @"appv":LOCAL_Version, @"yuncid":channelId?:@"", @"yunuid":userId?:@""};
    WEAK(self, weakSelf);
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"thirdLogin/bindingPhone"] class:nil parameters:param success:^(MOCHTTPResponse *response){
        [Hud hideHud];
        NSString *isthirdlogin = response.dataDictionary[@"bindresult"];
        NSString *uid = response.dataDictionary[@"uid"];
        NSString *token = response.dataDictionary[@"token"];
        NSString *state = response.dataDictionary[@"state"];
        NSString *name = response.dataDictionary[@"name"];
        NSString *head_img = response.dataDictionary[@"head_img"];
        weakSelf.isFull = response.dataDictionary[@"isfull"];
        NSString *pwd =response.dataDictionary[@"pwd"];
        NSString *area =response.dataDictionary[@"area"];
        NSString *companyName = response.dataDictionary[@"companyname"];
        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.isFull forKey:KEY_ISFULL];
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTOLOGIN];
        [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:area forKey:KEY_USER_AREA];
        [[NSUserDefaults standardUserDefaults] setObject:authCodeText.text forKey:KEY_AUTHCODE];
        [[NSUserDefaults standardUserDefaults] setObject:phoneText.text forKey:KEY_PHONE];
        [[NSUserDefaults standardUserDefaults] setObject:companyName forKey:KEY_COMPANYNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];

        if ([isthirdlogin isEqualToString:@"false"]){ //输入密码
            SetPassWordViewController *detaiVC = [[SetPassWordViewController alloc]init];
            [weakSelf.navigationController pushViewController:detaiVC animated:YES];
        } else{
            [weakSelf registerToken];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        [Hud hideHud];
    }];

}

- (void)registerToken
{
    [Hud showWait];
    NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
    NSString *uid =  [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_TOKEN];
    NSDictionary *param = @{@"uid":uid, @"t":token?:@"", @"channelid":channelId?:@"", @"channeluid":@"getui"};
    WEAK(self, weakSelf);

    [[SHGGloble sharedGloble] registerToken:param block:^(BOOL success, MOCHTTPResponse *response) {
        if (success) {
            [Hud hideHud];
            NSString *code = [response.data valueForKey:@"code"];
            if ([code isEqualToString:@"000"]){
                [weakSelf chatLoagin];
                [weakSelf loginSuccess];
            }
        } else{
            [Hud hideHud];
            [Hud showMessageWithText:response.errorMessage];
        }
    }];
}

- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid password:password completion:^(NSDictionary *loginInfo, EMError *error) {
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
             
         } else{
             switch (error.errorCode){
                 case EMErrorServerNotReachable:
                     NSLog(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerAuthenticationFailure:
                     NSLog(@"%@",[NSString stringWithFormat:@"%@", error.description]);
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
    [[AppDelegate currentAppdelegate] moveToRootController:self.rid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
