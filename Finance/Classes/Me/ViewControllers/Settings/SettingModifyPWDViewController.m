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

- (IBAction)confirmButtonClicked:(id)sender;
@end

@implementation SettingModifyPWDViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick event:@"SettingModifyPWDViewController" label:@"onClick"];
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
