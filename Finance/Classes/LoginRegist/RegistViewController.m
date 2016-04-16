//
//  RegistViewController.m
//  Finance
//
//  Created by HuMin on 15/4/10.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "RegistViewController.h"
#import "AppDelegate.h"
#import "ApplyViewController.h"
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
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    [self addSdLayout];
    NSLog(@"phoneNumberphoneNumber%@",self.phoneNumber);
    self.protocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSString *btnStr = @"我已阅读并同意《大牛圈用户协议》";
    NSRange range =[btnStr rangeOfString:@"《"];
    range = NSMakeRange(range.location, 9);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:btnStr];
    NSDictionary *dic =@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"D43C33"]};
    [attrString setAttributes:dic range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"AFAFAF"] range:NSMakeRange(0, 7)];
    [attrString addAttribute:NSFontAttributeName value:FontFactor(12.0f) range:NSMakeRange(0, attrString.length)];
    [self.protocolButton setAttributedTitle:attrString forState:UIControlStateNormal];
    
	[self reloadView:RegistInit];
	
	self.isAgree = YES;
    
    UIView * padView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MarginFactor(19.0f), MarginFactor(55.0f))];
    self.verifyCodeTextField.leftView = padView1;
    self.verifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView * padView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MarginFactor(19.0f), MarginFactor(55.0f))];
    self.passwordTextField.leftView = padView2;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.verifyCodeTextField.placeholder = @"验证码";
    [self.verifyCodeTextField setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.verifyCodeTextField setValue:FontFactor(15.0f) forKeyPath:@"_placeholderLabel.font"];
    
    self.passwordTextField.placeholder = @"登录密码";
    [self.passwordTextField setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:FontFactor(15.0f) forKeyPath:@"_placeholderLabel.font"];
}

- (void)addSdLayout
{
    self.firstView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.verifyCodeTextField.sd_layout
    .leftSpaceToView(self.firstView, 0.0f)
    .topSpaceToView(self.firstView, 0.0f)
    .widthIs(MarginFactor(100.0f))
    .heightIs(MarginFactor(55.0f));
    
    self.getVerfyCodeButton.sd_layout
    .rightSpaceToView(self.firstView, MarginFactor(19.0f))
    .topSpaceToView(self.firstView, 0.0f)
    .widthIs(MarginFactor(150.0f))
    .heightIs(MarginFactor(55.0f));
    
    self.secondView.sd_layout
    .topSpaceToView(self.firstView, MarginFactor(10.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.passwordTextField.sd_layout
    .leftSpaceToView(self.secondView, 0.0f)
    .topSpaceToView(self.secondView, 0.0f)
    .rightSpaceToView(self.secondView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    UIImage * image = [UIImage imageNamed:@"regist_check_box"];
    CGSize checkSize = image.size;
    self.protocolCheckButton.sd_layout
    .topSpaceToView(self.secondView, MarginFactor(5.0f))
    .leftSpaceToView(self.view, MarginFactor(19.0f))
    .widthIs(checkSize.width)
    .heightIs(checkSize.height);
    
    self.protocolButton.sd_layout
    .leftSpaceToView(self.protocolCheckButton, MarginFactor(3.0f))
    .rightSpaceToView(self.view, MarginFactor(0.0f))
    .topEqualToView(self.protocolCheckButton)
    .bottomEqualToView(self.protocolCheckButton);
    
    self.messageSendedLabel.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.protocolCheckButton, MarginFactor(83.0f))
    .autoHeightRatio(0.0f);
    
    self.nextStepButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.firstView, MarginFactor(181.0f))
    .heightIs(MarginFactor(40.0f));
    
}

- (IBAction)protocolCheckButtonClicked:(id)sender
{
    self.protocolCheckButton.selected = !self.protocolCheckButton.selected;
	if (self.protocolCheckButton.selected) {
		self.isAgree = NO;
	}else{
		self.isAgree = YES;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)reloadView:(RegistType)registType
{
	self.registType = registType;
	if (registType == RegistInit) {
		self.verifyCodeTextField.text	= @"";
		self.passwordTextField.text		= @"";
        [self.getVerfyCodeButton setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateNormal];
        [self.getVerfyCodeButton setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateHighlighted];
        [self.getVerfyCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
		[self.getVerfyCodeButton setTitle:@"获取验证码" forState:UIControlStateHighlighted];
        self.getVerfyCodeButton.titleLabel.font = FontFactor(12.0f);
		self.getVerfyCodeButton.userInteractionEnabled = YES;
		self.messageSendedLabel.hidden = YES;
		//self.footerView.origin  = CGPointMake(self.footerView.origin.x, 180);
        registType = RegistInTime;
	}else if (registType == RegistInTime){
        [self.getVerfyCodeButton setTitleColor:[UIColor colorWithHexString:@"AFAFAF"] forState:UIControlStateNormal];
        [self.getVerfyCodeButton setTitleColor:[UIColor colorWithHexString:@"AFAFAF"] forState:UIControlStateHighlighted];
		[self.getVerfyCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后可重新获取",(long)self.remainTime] forState:UIControlStateNormal];
		[self.getVerfyCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后可重新获取",(long)self.remainTime] forState:UIControlStateHighlighted];
		
		self.messageSendedLabel.hidden = NO;

		//self.footerView.origin  = CGPointMake(self.footerView.origin.x, 180);

	}else if (registType == RegistOverTime){
        [self.getVerfyCodeButton setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateNormal];
        [self.getVerfyCodeButton setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateHighlighted];
		[self.getVerfyCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
		[self.getVerfyCodeButton setTitle:@"重新获取" forState:UIControlStateHighlighted];
		self.getVerfyCodeButton.userInteractionEnabled = YES;
		
		self.messageSendedLabel.hidden = YES;
		
		//self.footerView.origin  = CGPointMake(self.footerView.origin.x, 180);
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
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"1104"]) {
            [Hud showMessageWithText:[response.data objectForKey:@"msg"]];
        }
	}];
}

- (void)postRegistRequest
{
	if (!self.isAgree) {
		[Hud showMessageWithText:@"未同意大牛圈用户协议"];
		return;
	}
    
    if(self.verifyCodeTextField.text.length == 0){
        [Hud showMessageWithText:@"验证码不能为空"];
        return;
    } else if (self.verifyCodeTextField.text.length > 4){
        [Hud showMessageWithText:@"验证码格式不正确"];
        return;
    }
    
    if(self.passwordTextField.text.length == 0){
        [Hud showMessageWithText:@"登录密码不能为空"];
        return;
        
    } else if (_passwordTextField.text.length > 20 || _passwordTextField.text.length < 6) {
        [Hud showMessageWithText:@"密码长度不能少于6位"];
        return;
    }
    [Hud showWait];

	NSString *osv = [UIDevice currentDevice].systemVersion;
	NSString *channelId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_CHANNELID];
	NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_BPUSH_USERID];

	NSDictionary *parameters = @{@"phone":self.phoneNumber, @"pwd":[self.passwordTextField.text md5], @"validatecode":self.verifyCodeTextField.text, @"ctype":@"iphone", @"os":@"ios", @"osv":osv, @"appv":LOCAL_Version, @"yuncid":channelId?:@"",  @"yunuid":userId?:@""};
	
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"register"] parameters:parameters success:^(MOCHTTPResponse *response){
        [Hud hideHud];
        NSString *uid = response.dataDictionary[@"uid"];
        NSString *token = response.dataDictionary[@"token"];
        NSString *state = response.dataDictionary[@"state"];

        NSString *name = response.dataDictionary[@"name"];
        NSString *head_img = response.dataDictionary[@"head_img"];
        NSString *area = response.dataDictionary[@"area"];

        [[NSUserDefaults standardUserDefaults] setObject:uid forKey:KEY_UID];
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumber forKey:KEY_PHONE];
        [[NSUserDefaults standardUserDefaults] setObject:[self.passwordTextField.text md5] forKey:KEY_PASSWORD];
        [[NSUserDefaults standardUserDefaults] setObject:state forKey:KEY_AUTHSTATE];
        [[NSUserDefaults standardUserDefaults] setObject:name forKey:KEY_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:head_img forKey:KEY_HEAD_IMAGE];
        [[NSUserDefaults standardUserDefaults] setObject:area forKey:KEY_USER_AREA];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:KEY_TOKEN];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KEY_AUTOLOGIN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self chatLoagin];
        [self loginSuccess];

    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:response.errorMessage];
        [Hud hideHud];
    }];
}


- (void)chatLoagin
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];

    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid password:password completion:^(NSDictionary *loginInfo, EMError *error) {
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
    [[AppDelegate currentAppdelegate] moveToRootController:nil];
}

-(void)registChat
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:uid password:[_passwordTextField.text md5] withCompletion: ^(NSString *username, NSString *password, EMError *error) {
         
         if (!error) {
            // TTAlertNoTitle(NSLocalizedString(@"register.success", @"Registered successfully, please log in"));
          
         }else{
             switch (error.errorCode)
             {
                 case EMErrorServerNotReachable:
                     //TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                     [Hud showMessageWithText:NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!")];
                     break;
                 case EMErrorServerDuplicatedAccount:
                    // TTAlertNoTitle(NSLocalizedString("@register.repeat", @"You registered user already exists!"));
                     [Hud showMessageWithText:NSLocalizedString(@"register.repeat", @"You registered user already exists!")];
                     break;
                 case EMErrorServerTimeout:
                     //TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                     [Hud showMessageWithText:NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!")];
                     break;
                 default:
                    // TTAlertNoTitle(NSLocalizedString(@"register.fail", @"Registration failed"));
                      [Hud showMessageWithText:NSLocalizedString(@"register.fail", @"Registration failed")];
                     break;
             }
         }
     } onQueue:nil];
}

- (IBAction)protocolButtonClicked:(id)sender
{
    ProtocolViewController *vc = [[ProtocolViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.verifyCodeTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

@end
