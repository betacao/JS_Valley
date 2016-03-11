//
//  SettingModifyPWDViewController.m
//  DingDCommunity
//
//  Created by JianjiYuan on 14-4-10.
//  Copyright (c) 2014年 JianjiYuan. All rights reserved.
//

#import "SettingModifyPWDViewController.h"

@interface SettingModifyPWDViewController () < UITextFieldDelegate >

@property (nonatomic, strong) NSString *xinPassword;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *oldPswView;

@property (weak, nonatomic) IBOutlet UIView *changeView;

@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (nonatomic, strong) IBOutlet	UITextField *oldPassword;

@property (nonatomic, strong) IBOutlet UITextField *changedPassword;

@property (nonatomic, strong) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *oldButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

- (IBAction)oldButtonClick:(id)sender;
- (IBAction)changeButtonClick:(id)sender;
- (IBAction)confirmNumButtonClick:(id)sender;

- (IBAction)confirmButtonClicked:(id)sender;
@end

@implementation SettingModifyPWDViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.oldPassword.delegate = self;
    self.changedPassword.delegate = self;
    self.confirmPassword.delegate = self;
    self.title = @"密码修改";
//    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,14.0, 30.0f)];
//    self.oldPassword.leftView = paddingView1;
//    self.oldPassword.leftViewMode = UITextFieldViewModeAlways;
//    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,14.0f, 30.0f)];
//    self.changedPassword.leftView = paddingView2;
//    self.changedPassword.leftViewMode = UITextFieldViewModeAlways;
//    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,14.0f, 30.0f)];
//    self.confirmPassword.leftView = paddingView3;
//    self.confirmPassword.leftViewMode = UITextFieldViewModeAlways;
//    [self.oldPassword setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.oldPassword setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
//    
//    [self.changedPassword setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.changedPassword setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
//    
//    [self.confirmPassword setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.confirmPassword setValue:[UIFont systemFontOfSize:14.0f] forKeyPath:@"_placeholderLabel.font"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self updateCloseButtonState:self.oldPassword];
    [self updateCloseButtonState:self.changedPassword];
    [self updateCloseButtonState:self.confirmPassword];
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
    self.oldPassword.font = FontFactor(15.0f);
    self.oldPassword.textColor = [UIColor colorWithHexString:@"161616"];
    [self.oldPassword setValue:[UIColor colorWithHexString:@"afafaf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.changedPassword.font = FontFactor(15.0f);
    self.changedPassword.textColor = [UIColor colorWithHexString:@"161616"];
    [self.changedPassword setValue:[UIColor colorWithHexString:@"afafaf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.confirmPassword.font = FontFactor(15.0f);
    self.confirmPassword.textColor = [UIColor colorWithHexString:@"161616"];
    [self.confirmPassword setValue:[UIColor colorWithHexString:@"afafaf"] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.sureButton.titleLabel.font = FontFactor(15.0f);
    [self.sureButton setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = FontFactor(17.0f);
    [self.sureButton setBackgroundColor:[UIColor colorWithHexString:@"f04241"]];
   
    
    UIImage *image = [UIImage imageNamed:@"me_deleteInput"];
    CGSize size = image.size;
    self.oldPswView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.oldPassword.sd_layout
    .topSpaceToView(self.oldPswView, 0.0f)
    .leftSpaceToView(self.oldPswView, MarginFactor(19.0f))
    .rightSpaceToView(self.oldPswView, MarginFactor(50.0f))
    .bottomSpaceToView(self.oldPswView, 0.0f);
    
    self.oldButton.sd_layout
    .rightSpaceToView(self.oldPswView, MarginFactor(19.0f))
    .centerYEqualToView(self.oldPswView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.changeView.sd_layout
    .topSpaceToView(self.oldPswView, MarginFactor(11.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.changedPassword.sd_layout
    .topSpaceToView(self.changeView, 0.0f)
    .leftSpaceToView(self.changeView, MarginFactor(19.0f))
    .rightSpaceToView(self.changeView, MarginFactor(50.0f))
    .bottomSpaceToView(self.changeView, 0.0f);
    
    self.changeButton.sd_layout
    .rightSpaceToView(self.changeView, MarginFactor(19.0f))
    .centerYEqualToView(self.changeView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.confirmView.sd_layout
    .topSpaceToView(self.changeView, MarginFactor(11.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.confirmPassword.sd_layout
    .topSpaceToView(self.confirmView, MarginFactor(11.0f))
    .leftSpaceToView(self.confirmView, MarginFactor(19.0f))
    .rightSpaceToView(self.confirmView, MarginFactor(50.0f))
    .bottomSpaceToView(self.confirmView, 0.0f);
    
    self.confirmButton.sd_layout
    .rightSpaceToView(self.confirmView, MarginFactor(19.0f))
    .centerYEqualToView(self.confirmView)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.sureButton.sd_layout
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .bottomSpaceToView(self.view, MarginFactor(19.0f))
    .heightIs(MarginFactor(35.0f));


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SettingModifyPWDViewController" label:@"onClick"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (void)textFieldDidChange:(NSNotification *)notif
{
    UITextField *field = (UITextField *)notif.object;
    [self updateCloseButtonState:field];
}

- (void)updateCloseButtonState:(UITextField *)textField
{
    if ([textField isEqual:self.oldPassword]) {
        if (textField.text.length > 0) {
            self.oldButton.hidden = NO;
        } else{
            self.oldButton.hidden = YES;
        }
    } else if ([textField isEqual:self.changedPassword]) {
        if (textField.text.length > 0) {
            self.changeButton.hidden = NO;
        } else{
            self.changeButton.hidden = YES;
        }
    } else if ([textField isEqual:self.confirmPassword]) {
        if (textField.text.length > 0) {
            self.confirmButton.hidden = NO;
        } else{
            self.confirmButton.hidden = YES;
        }
    }
}

- (IBAction)oldButtonClick:(id)sender {
    self.oldPassword.text = @"";
    [self updateCloseButtonState:self.oldPassword];
    [self.oldPassword becomeFirstResponder];
}

- (IBAction)changeButtonClick:(id)sender {
    self.changedPassword.text = @"";
    [self updateCloseButtonState:self.changedPassword];
    [self.changedPassword becomeFirstResponder];
}

- (IBAction)confirmNumButtonClick:(id)sender {
    self.confirmPassword.text = @"";
    [self updateCloseButtonState:self.confirmPassword];
    [self.confirmPassword becomeFirstResponder];
}

- (IBAction)confirmButtonClicked:(id)sender
{
	if (IsStrEmpty(self.oldPassword.text)) {
		[Hud showMessageWithText:@"请输入旧密码"];
		return;

	}
	if (IsStrEmpty(self.changedPassword.text)) {
		[Hud showMessageWithText:@"请输入新密码"];
		return;

	}
	if (IsStrEmpty(self.confirmPassword.text)) {
		[Hud showMessageWithText:@"请确认新密码"];
		return;

	}

	
	if (![self.changedPassword.text isEqualToString:self.confirmPassword.text]) {
		[Hud showMessageWithText:@"两次密码输入不一致"];
		return;
	}
	
	if (self.changedPassword.text.length >20) {
		[Hud showMessageWithText:@"您的密码太长了"];
		return;
	}
	
	if (self.changedPassword.text.length <6) {
		[Hud showMessageWithText:@"密码不得少于6位"];
		return;
	}
 
	if ([self.changedPassword.text containsString:@" "]) {
        [Hud showMessageWithText:@"请勿输入空格"];
        return;
    }

    NSString *oldPassword = [self.oldPassword.text md5];
    NSString *newPassword = [self.changedPassword.text md5];
    [MOCHTTPRequestOperationManager putWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"account",@"modifyPwd"] class:nil parameters:@{@"uid":UID,@"oldpwd":oldPassword,@"newpwd":newPassword} success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [Hud showMessageWithText:@"修改成功"];
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1];
        }else{
            NSString *code = [response.data valueForKey:@"msg"];
            [Hud showMessageWithText:code];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud showMessageWithText:@"修改失败"];
    }];
}

@end
