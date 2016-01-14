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
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 30)];
    self.oldPassword.leftView = paddingView1;
    self.oldPassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 30)];
    self.changedPassword.leftView = paddingView2;
    self.changedPassword.leftViewMode = UITextFieldViewModeAlways;
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0,20, 30)];
    self.confirmPassword.leftView = paddingView3;
    self.confirmPassword.leftViewMode = UITextFieldViewModeAlways;
    [self.oldPassword setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.oldPassword setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    [self.changedPassword setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.changedPassword setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    [self.confirmPassword setValue:[UIColor colorWithHexString:@"AFAFAF"] forKeyPath:@"_placeholderLabel.textColor"];
    [self.confirmPassword setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
   
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

- (IBAction)oldButtonClick:(id)sender {
    self.oldPassword.text = @"";
    [self.oldPassword becomeFirstResponder];
}

- (IBAction)changeButtonClick:(id)sender {
    self.changedPassword.text = @"";
    [self.changedPassword becomeFirstResponder];
}

- (IBAction)confirmNumButtonClick:(id)sender {
    self.confirmPassword.text = @"";
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
	
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	
	NSString *oldPassword = [self.oldPassword.text md5];
	NSString *newPassword = [self.changedPassword.text md5];
	
	[[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"account",@"modifyPwd"] parameters:@{@"uid":uid,@"oldpwd":oldPassword,@"newpwd":newPassword	} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"%@",operation);
		NSLog(@"%@",responseObject);
		NSString *code = [responseObject valueForKey:@"code"];
		if ([code isEqualToString:@"000"]) {
			[Hud showMessageWithText:@"修改成功"];
			[self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] afterDelay:1];
		}else{
			NSString *code = [responseObject valueForKey:@"msg"];
			[Hud showMessageWithText:code];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[Hud showMessageWithText:@"修改失败"];
	}];
}

@end
