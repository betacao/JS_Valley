//
//  ResetPasswardViewController.m
//  Finance
//
//  Created by HuMin on 15/5/7.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ResetPasswardViewController.h"

@interface ResetPasswardViewController ()
- (IBAction)actionGO:(id)sender;
- (IBAction)actionCode:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UITextField *txtPwdVery;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtCode;
@property (nonatomic, assign) NSInteger remainTime;
@property (weak, nonatomic) IBOutlet UIButton *psdButton;
@property (weak, nonatomic) IBOutlet UIButton *againPsdButton;

//重新发送的定时器
@property (nonatomic, strong) NSTimer	*remainTimer;
@property (nonatomic, assign) CodeType registType;
- (IBAction)psdButtonClick:(id)sender;
- (IBAction)againPsdButtonClick:(id)sender;
@end

@implementation ResetPasswardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblCode.hidden = YES;
    NSString *phone;
    self.title = @"密码找回";
    phone = [NSString stringWithFormat:@"%@****%@",[self.phone substringToIndex:2],[self.phone substringFromIndex:7]];
    _lblCode.text = [NSString stringWithFormat:@"已向您的手机%@发送了短信验证码，验证为本人使用",phone];
    _lblCode.textColor = [UIColor colorWithHexString:@"AFAFAF"];
    _lblCode.font = [UIFont systemFontOfSize:12];
    // Do any additional setup after loading the view from its nib.
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 45)];
    self.txtCode.leftView = paddingView1;
    self.txtCode.leftViewMode = UITextFieldViewModeAlways;
    self.txtCode.placeholder = @"验证码";
    [self.txtCode setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtCode setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 45)];
    self.txtPwd.leftView = paddingView2;
    self.txtPwd.leftViewMode = UITextFieldViewModeAlways;
    self.txtPwd.placeholder = @"输入新密码";
    [self.txtPwd setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPwd setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 45)];
    self.txtPwdVery.leftView = paddingView3;
    self.txtPwdVery.leftViewMode = UITextFieldViewModeAlways;
    self.txtPwdVery.placeholder = @"再次输入新密码";
    [self.txtPwdVery setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPwdVery setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refreshButtonCount
{
    if (self.remainTime >0) {
        self.remainTime --;
        [self reloadView:CodeInTime];
    }else{
        [self.remainTimer invalidate];
        self.remainTimer = nil;
        [self reloadView:CodeOverTime];
    }
}

- (IBAction)actionGO:(id)sender {
    if (_txtCode.text.length == 0) {
        [Hud showMessageWithText:@"请输入验证码"];
        return;
    }
    if (IsStrEmpty(_txtPwd.text)) {
        [Hud showMessageWithText:@"请输入密码"];
        return;
    }
    if (IsStrEmpty(_txtPwdVery.text)) {
        [Hud showMessageWithText:@"请输入确认密码"];
        return;
    }
    if (![_txtPwdVery.text isEqualToString:_txtPwd.text]) {
        [Hud showMessageWithText:@"两次密码不一致"];
        return;
    }
    if (_txtPwdVery.text.length > 20)
    {
        [Hud showMessageWithText:@"您的密码太长了"];
        return;
    }
    if (  _txtPwdVery.text.length < 6) {
        [Hud showMessageWithText:@" 密码不得少于6位"];
        return;
    }
    [self findPwd];
}

-(void)findPwd
{
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"account",@"findpwd"];
    NSDictionary *param = @{@"phone":self.phone,@"pwd":[_txtPwd.text md5],@"validatecode":_txtCode.text};
    [[AFHTTPRequestOperationManager manager] PUT:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [Hud showMessageWithText:@"密码修改成功"];
        }
        else
        {
            [Hud showMessageWithText:[responseObject objectForKey:@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud showLoadingWithMessage:error.domain];
    }];
}
- (void)reloadView:(CodeType)CodeType
{
    self.registType = CodeType;
    if (CodeType == CodeInit) {
        self.txtPwd.text= @"";
        self.txtPwdVery.text= @"";
        [self.btnCode setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateNormal];
        [self.btnCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.btnCode setTitle:@"获取验证码" forState:UIControlStateHighlighted];
        [self.btnCode setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateHighlighted];
        _lblCode.hidden = YES;
        self.btnCode.userInteractionEnabled = YES;
        
    }else if (CodeType == CodeInTime){
        [self.btnCode setTitleColor:[UIColor colorWithHexString:@"AFAFAF"] forState:UIControlStateNormal];
        [self.btnCode setTitleColor:[UIColor colorWithHexString:@"AFAFAF"] forState:UIControlStateHighlighted];
        [self.btnCode setTitle:[NSString stringWithFormat:@"%ld秒后可重新获取",(long)self.remainTime] forState:UIControlStateNormal];
        [self.btnCode setTitle:[NSString stringWithFormat:@"%ld秒后可重新获取",(long)self.remainTime] forState:UIControlStateHighlighted];
        
        _lblCode.hidden = NO;

    }else if (CodeType == CodeOverTime){
        [self.btnCode setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateNormal];
        [self.btnCode setTitleColor:[UIColor colorWithHexString:@"4482C8"] forState:UIControlStateHighlighted];
        [self.btnCode setTitle:@"重新获取" forState:UIControlStateNormal];
        [self.btnCode setTitle:@"重新获取" forState:UIControlStateHighlighted];
        self.btnCode.userInteractionEnabled = YES;
        _lblCode.hidden = YES;
        
    }else{
        return;
    }
}
- (IBAction)actionCode:(id)sender {
    
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"sms"] parameters:@{@"type":@"backpwd",@"phone":self.phone} success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            self.btnCode.userInteractionEnabled = NO;
            self.remainTime = 60;
            self.remainTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshButtonCount) userInfo:nil repeats:YES];
        }
        NSLog(@"%@",response.dataDictionary);
        NSLog(@"%@",response);
    } failed:^(MOCHTTPResponse *response) {
        
    }];
    
}
- (IBAction)psdButtonClick:(id)sender {
    self.txtPwd.text = @"";
    [self.txtPwd becomeFirstResponder];
}

- (IBAction)againPsdButtonClick:(id)sender {
    self.txtPwdVery.text = @"";
    [self.txtPwdVery becomeFirstResponder];
}
@end
