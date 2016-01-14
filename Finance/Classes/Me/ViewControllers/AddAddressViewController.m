//
//  AddAddressViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/4/28.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()
	<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UITableViewCell *nameCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *phoneNumCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *postcodeCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *cityCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *streetCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *detailAddressCell;

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) IBOutlet UITextField *phonNumTextField;
@property (nonatomic, strong) IBOutlet UITextField *postCodeTextField;
@property (nonatomic, strong) IBOutlet UITextField *cityTextField;
@property (nonatomic, strong) IBOutlet UITextField *streetTextField;
@property (nonatomic, strong) IBOutlet UITextField *detailAddressTextField;


@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor clearColor];
	[_tableView setTableFooterView:view];
	[self registerForKeyboardNotifications];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame =CGRectMake(0, 0, 50, 44);
	[button addTarget:self action:@selector(saveAddress) forControlEvents:UIControlEventTouchUpInside];
	[button setTitle:@"保存" forState:UIControlStateNormal];
	[button setTitle:@"保存" forState:UIControlStateHighlighted];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	
	button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.nameTextField.text		=self.obj.name;
	self.phonNumTextField.text	=self.obj.phoneNumber;
	self.postCodeTextField.text	=self.obj.code;
	self.cityTextField.text		=self.obj.area;
	self.streetTextField.text	=self.obj.street;
	self.detailAddressTextField.text=self.obj.addressDescription;
	self.title = @"修改地址";
}

- (void)saveAddress
{
	self.obj.name = self.nameTextField.text?:@"";
	self.obj.phoneNumber = self.phonNumTextField.text?:@"";
	self.obj.code	= self.postCodeTextField.text?:@"";
	self.obj.area	= self.cityTextField.text?:@"";
	self.obj.street	= self.streetTextField.text?:@"";
	self.obj.addressDescription = self.detailAddressTextField.text?:@"";
	
	if (![self.obj.phoneNumber isValidateMobile]) {
		[Hud showMessageWithText:@"手机号码不合法"];
		return;
	}
	
	
	
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

	[[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"address"] parameters:@{@"uid":uid,@"name":self.obj.name ,@"phone":self.obj.phoneNumber,@"code":self.obj.code,@"area":self.obj.area,@"street":self.obj.street,@"address":self.obj.addressDescription} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"%@",operation);
		NSLog(@"%@",responseObject);
		NSString *code = [responseObject valueForKey:@"code"];
		if ([code isEqualToString:@"000"]) {
			[Hud showMessageWithText:@"修改成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
	}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
	return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
        self.nameCell.contentView.userInteractionEnabled = NO;
		return self.nameCell;
        
	}else if (indexPath.row == 1) {
		return self.phoneNumCell;
	}else if (indexPath.row == 2) {
		return self.postcodeCell;
	}else if (indexPath.row == 3) {
		return self.cityCell;
	}else if (indexPath.row == 4) {
		return self.streetCell;
	}else if (indexPath.row == 5){
		return self.detailAddressCell;
	}
	
	UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"empty"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.view endEditing:YES];

}

- (void)registerForKeyboardNotifications
{
	//使用NSNotificationCenter 鍵盤出現時
	[[NSNotificationCenter defaultCenter] addObserver:self
	 
											 selector:@selector(keyboardWasShown:)
	 
												 name:UIKeyboardWillShowNotification object:nil];
	
	//使用NSNotificationCenter 鍵盤隐藏時
	[[NSNotificationCenter defaultCenter] addObserver:self
	 
											 selector:@selector(keyboardWillBeHidden:)
	 
												 name:UIKeyboardWillHideNotification object:nil];
	
	
}
-(void)keyboardWasShown:(NSNotification *)noti
{
	NSDictionary *info = [noti userInfo];
	NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
	CGSize keyboardSize = [value CGRectValue].size;
	self.tableView.height = self.view.height - keyboardSize.height;
}

-(void)keyboardWillBeHidden:(NSNotification *)noti
{
	self.tableView.height = self.view.height;
}

@end
