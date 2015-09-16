//
//  RegistViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "RegistViewController.h"
#import "AppDelegate.h"
#import "ImproveMatiralViewController.h"
#import "ProtocolViewController.h"

typedef NS_ENUM(NSInteger, RegistType)
{
	RegistInit = 0,//未发送验证码
	RegistInTime = 1,//已发送验证码
	RegistOverTime = 2,//验证码过时
};

@interface RegistViewController ()<UITextFieldDelegate>
//验证码输入框
@property (nonatomic, strong) IBOutlet UITextField	*verifyCodeTextField;
//密码输入框
@property (nonatomic, strong) IBOutlet UITextField	*passwordTextField;
//获取验证码
@property (nonatomic, strong) IBOutlet UIButton		*getVerfyCodeButton;
//已经发送短信的文本框
@property (nonatomic, strong) IBOutlet UILabel		*messageSendedLabel;
//底部整个view
@property (nonatomic, strong) IBOutlet UIView		*footerView;
//同意协议的button
@property (nonatomic, strong) IBOutlet UIButton		*protocolCheckButton;
//下一步
@property (nonatomic, strong) IBOutlet UIButton		*nextStepButton;
//用户协议按钮
@property (weak, nonatomic) IBOutlet UIButton       *protocolButton;
//定制view的类型
@property (nonatomic, assign) RegistType            registType;
//重新发送的剩余时间
@property (nonatomic, assign) NSInteger             remainTime;
//重新发送的定时器
@property (nonatomic, strong) NSTimer               *remainTimer;

- (IBAction)getverifyCodeButtonClicked:(id)sender;
- (IBAction)nextStepButtonClicked:(id)sender;
- (IBAction)protocolCheckButtonClicked:(id)sender;
- (IBAction)protocolButtonClicked:(id)sender;

@property (nonatomic, assign) BOOL isAgree;
@end


@implementation RegistViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    NSLog(@"phoneNumberphoneNumber%@",self.phoneNumber);
	self.nextStepButton.layer.masksToBounds = YES;
	self.nextStepButton.layer.cornerRadius = 3;
    
    self.protocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *btnStr = @"我已阅读并同意《大牛圈用户协议》";
    NSRange range =[btnStr rangeOfString:@"《"];
    range = NSMakeRange(range.location, 9);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:btnStr];
    NSDictionary *dic =@{NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:57/255.0 blue:67/255.0 alpha:1.0]};
    [attrString setAttributes:dic range:range];
    [self.protocolButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
	[self reloadView:RegistInit];
	
	self.isAgree = YES;
}

- (IBAction)protocolCheckButtonClicked:(id)sender
{
	if (self.protocolCheckButton.selected) {
		self.protocolCheckButton.selected = NO;
		self.isAgree = NO;
	}else{
		self.protocolCheckButton.selected = YES;
		self.isAgree = YES;
	}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)reloadView:(RegistType)registType
{
	self.registType = registType;
	if (registType == RegistInit) {
		self.verifyCodeTextField.text	= @"";
		self.passwordTextField.text		= @"";
        
		[self.getVerfyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
		[self.getVerfyCodeButton setTitle:@"获取验证码" forState:UIControlStateHighlighted];
        self.getVerfyCodeButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
		self.getVerfyCodeButton.userInteractionEnabled = YES;
		self.messageSendedLabel.hidden = YES;
		self.footerView.origin  = CGPointMake(self.footerView.origin.x, 185);
        registType = RegistInTime;
	}else if (registType == RegistInTime){
		
		[self.getVerfyCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.remainTime] forState:UIControlStateNormal];
		[self.getVerfyCodeButton setTitle:[NSString stringWithFormat:@"重新发送(%ld)",(long)self.remainTime] forState:UIControlStateHighlighted];
		
		self.messageSendedLabel.hidden = NO;

		self.footerView.origin  = CGPointMake(self.footerView.origin.x, 265);

	}else if (registType == RegistOverTime){
		[self.getVerfyCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
		[self.getVerfyCodeButton setTitle:@"重新发送" forState:UIControlStateHighlighted];
		self.getVerfyCodeButton.userInteractionEnabled = YES;
		
		self.messageSendedLabel.hidden = YES;
		
		self.footerView.origin  = CGPointMake(self.footerView.origin.x, 185);
	}else{
		return;
	}
}


- (void)refreshButtonCount
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


- (IBAction)getverifyCodeButtonClicked:(id)sender
{
	[self getverifyCodeRequest];
	
}

- (IBAction)nextStepButtonClicked:(id)sender
{
	[self postRegistRequest];
}

- (void)getverifyCodeRequest
{
	[MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"sms"] parameters:@{@"type":@"register",@"phone":self.phoneNumber} success:^(MOCHTTPResponse *response) {
        self.getVerfyCodeButton.userInteractionEnabled = NO;
        self.remainTime = 60;
        self.remainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshButtonCount) userInfo:nil repeats:YES];
		NSLog(@"%@",response.dataDictionary);
		NSLog(@"%@",response);
	} failed:^(MOCHTTPResponse *response) {
		
	}];
}

- (void)postRegistRequest
{
	if (!self.isAgree) {
		[Hud showMessageWithText:@"未同意大牛圈用户协议"];
		return;
	}
    
    if(self.verifyCodeTextField.text.length == 0){
        [Hud showMessageWithText:@"验证不能为空"];
        return;
    } else if (self.verifyCodeTextField.text.length > 4){
        [Hud showMessageWithText:@"验证码格式不正确"];
        return;
    }
    
    if(self.passwordTextField.text.length == 0){
        [Hud showMessageWithText:@"登录密码不能为空"];
        return;
        
    } else if (_passwordTextField.text.length > 20 || _passwordTextField.text.length < 6) {
        [Hud showMessageWithText:@"密码长度为6-20位"];
        return;
    }
	[Hud showLoadingWithMessage:@"注册中……"];

	NSString *osv = [UIDevice currentDevice].systemVersion;
	NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
	NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];

	NSDictionary *parameters = @{@"phone"		:self.phoneNumber,
								 @"pwd"			:[self.passwordTextField.text md5],
								 @"validatecode":self.verifyCodeTextField.text,
								 @"ctype"		:@"iphone",
								 @"os"			:@"ios",
								 @"osv"			:osv,
								 @"appv"		:LOCAL_Version,
								 @"yuncid"		:channelId?:@"",
								 @"yunuid"		:userId?:@""};
	
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"register"] parameters:parameters success:^(MOCHTTPResponse *response)
    {
		[Hud hideHud];
		NSString *uid = response.dataDictionary[@"uid"];
		NSString *token = response.dataDictionary[@"token"];
		NSString *state = response.dataDictionary[@"state"];
		
		NSString *name = response.dataDictionary[@"name"];
		NSString *head_img = response.dataDictionary[@"head_img"];
		
		[[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber forKey:KEY_PHONE];
		[[NSUserDefaults standardUserDefaults] setObject:[self.passwordTextField.text md5] forKey:KEY_PASSWORD];
		[[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
		[[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
		[[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
		[[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        ImproveMatiralViewController *vc = [[ImproveMatiralViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
		
	} failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
		[Hud hideHud];
	}];
}

-(void)registChat
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:uid
                                                         password:[_passwordTextField.text md5]
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
         
         if (!error) {
            // TTAlertNoTitle(NSLocalizedString(@"register.success", @"Registered successfully, please log in"));
          
         }else{
             switch (error.errorCode)
             {
                 case EMErrorServerNotReachable:
                     //TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     break;
                 case EMErrorServerDuplicatedAccount:
                    // TTAlertNoTitle(NSLocalizedString(@"register.repeat", @"You registered user already exists!"));
                     break;
                 case EMErrorServerTimeout:
                     //TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     break;
                 default:
                    // TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                     break;
             }
             [Hud showMessageWithText:@"注册失败"];
         }
     } onQueue:nil];
}
- (IBAction)protocolButtonClicked:(id)sender
{
	ProtocolViewController *vc = [[ProtocolViewController alloc] init];
	[self.navigationController pushViewController:vc animated:YES];
}
@end
