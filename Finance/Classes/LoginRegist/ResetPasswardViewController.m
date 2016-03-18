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
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

//重新发送的定时器
@property (nonatomic, strong) NSTimer	*remainTimer;
@property (nonatomic, assign) CodeType registType;

@end

@implementation ResetPasswardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblCode.hidden = YES;
    NSString *phone;
    self.title = @"密码找回";
    [self addSdLayout];
    phone = [NSString stringWithFormat:@"%@****%@",[self.phone substringToIndex:2],[self.phone substringFromIndex:7]];
    _lblCode.text = [NSString stringWithFormat:@"已向您的手机%@发送了短信验证码，验证为本人使用",phone];
    _lblCode.textColor = [UIColor colorWithHexString:@"AFAFAF"];
    _lblCode.font = FontFactor(12.0f);
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MarginFactor(19.0f), MarginFactor(55.0f))];
    self.txtCode.leftView = paddingView1;
    self.txtCode.leftViewMode = UITextFieldViewModeAlways;
    self.txtCode.placeholder = @"验证码";
    [self.txtCode setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtCode setValue:FontFactor(15.0f) forKeyPath:@"_placeholderLabel.font"];
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MarginFactor(19.0f), MarginFactor(55.0f))];
    self.txtPwd.leftView = paddingView2;
    self.txtPwd.leftViewMode = UITextFieldViewModeAlways;
    self.txtPwd.placeholder = @"输入新密码";
    [self.txtPwd setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPwd setValue:FontFactor(15.0f)  forKeyPath:@"_placeholderLabel.font"];
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,MarginFactor(19.0f), MarginFactor(55.0f))];
    self.txtPwdVery.leftView = paddingView3;
    self.txtPwdVery.leftViewMode = UITextFieldViewModeAlways;
    self.txtPwdVery.placeholder = @"再次输入新密码";
    [self.txtPwdVery setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPwdVery setValue:FontFactor(15.0f) forKeyPath:@"_placeholderLabel.font"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSdLayout
{
    self.firstView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.txtCode.sd_layout
    .leftSpaceToView(self.firstView, 0.0f)
    .topSpaceToView(self.firstView, 0.0f)
    .widthIs(MarginFactor(100.0f))
    .heightIs(MarginFactor(55.0f));
    
    self.btnCode.sd_layout
    .rightSpaceToView(self.firstView, 19.0f)
    .topSpaceToView(self.firstView, 0.0f)
    .widthIs(MarginFactor(150.0f))
    .heightIs(MarginFactor(55.0f));
    
    self.secondView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.firstView, MarginFactor(10.0f))
    .heightIs(MarginFactor(55.0f));
    
    self.txtPwd.sd_layout
    .leftSpaceToView(self.secondView, 0.0f)
    .rightSpaceToView(self.secondView, 0.0f)
    .topSpaceToView(self.secondView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.thirdView.sd_layout
    .topSpaceToView(self.secondView, MarginFactor(10.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.txtPwdVery.sd_layout
    .leftSpaceToView(self.thirdView, 0.0f)
    .rightSpaceToView(self.thirdView, 0.0f)
    .topSpaceToView(self.thirdView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.lblCode.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.thirdView, MarginFactor(35.0f))
    .autoHeightRatio(0.0f);
    
    self.sureButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .topSpaceToView(self.lblCode, MarginFactor(5.0f))
    .heightIs(MarginFactor(40.0f));
    
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
        [Hud showMessageWithText:@"密码不能为空！"];
        return;
    }
    if (IsStrEmpty(_txtPwdVery.text)) {
        [Hud showMessageWithText:@"确认密码不能为空！"];
        return;
    }
    if (![_txtPwdVery.text isEqualToString:_txtPwd.text]) {
        [Hud showMessageWithText:@"两次输入的密码不一致，请重新输入！"];
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

    [MOCHTTPRequestOperationManager putWithURL:url class:nil parameters:param success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
            [self.navigationController popViewControllerAnimated:YES];
            [Hud showMessageWithText:@"密码修改成功"];
        } else{
            [Hud showMessageWithText:[response.data objectForKey:@"msg"]];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showLoadingWithMessage:response.errorMessage];
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
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"1104"]) {
            [Hud showMessageWithText:[response.data objectForKey:@"msg"]];
        }
    }];
    
}

@end
