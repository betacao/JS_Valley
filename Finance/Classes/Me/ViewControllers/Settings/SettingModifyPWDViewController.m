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

- (IBAction)confirmButtonClicked:(id)sender;
@end

@implementation SettingModifyPWDViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.oldPassword.delegate = self;
    self.changedPassword.delegate = self;
    self.confirmPassword.delegate = self;
    self.title = @"密码修改";
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

    self.oldPswView.sd_layout
    .topSpaceToView(self.view, 0.0f)
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.oldPassword.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));
    
    self.changeView.sd_layout
    .topSpaceToView(self.oldPswView, MarginFactor(11.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.changedPassword.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));
    
    self.confirmView.sd_layout
    .topSpaceToView(self.changeView, MarginFactor(11.0f))
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.confirmPassword.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));
    
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
