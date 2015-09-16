//
//  ImproveMatiralViewController.m
//  Finance
//
//  Created by Okay Hoo on 15/5/13.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ImproveMatiralViewController.h"
#import "AppDelegate.h"
#import "ApplyViewController.h"
#import <AddressBook/AddressBook.h>
@interface ImproveMatiralViewController ()<UIScrollViewDelegate>
{
    BOOL hasUploadHead;
}
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *companyTextField;
@property (nonatomic, weak) IBOutlet UITextField *titleTextField;
@property (nonatomic, weak) IBOutlet UIButton *headImageButton;
@property (nonatomic, weak) IBOutlet UIScrollView *bgScrollView;
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) NSString *headImageName;
@property (nonatomic, strong) NSMutableArray *phones;
@property (strong, nonatomic) UITextField *currentField;
@property (assign, nonatomic) CGRect keyboaradRect;

- (IBAction)headImageButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
@end

@implementation ImproveMatiralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 24, 24)];
    NSString *imageName ;
    
    imageName = @"返回";
    [leftButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
  
    [leftButton addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    // Do any additional setup after loading the view from its nib.
    self.title = @"完善信息";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        //更新好友
        [self getAddress];
    });
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark -- sdc
#pragma mark -- 获得联系人
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void )getAddress
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    //取得授权状态
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    ABAddressBookRequestAccessWithCompletion
    (addressBook, ^(bool granted, CFErrorRef error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (error)
                 NSLog(@"Error: %@", (__bridge NSError *)error);
             else if (!granted)
             {
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"获取权限失败" message:@"请设置权限." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [av show];
             }
             else
             {
                 CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
                 
                 for(int i = 0; i < CFArrayGetCount(results); i++)
                 {
                     ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                     ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                     for (int k = 0; k<ABMultiValueGetCount(phone); k++)
                     {
                         //获取电话Label
                         NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
                         //获取該Label下的电话值
                         NSString *personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                         NSString *phone = [personPhone validPhone];
                         NSString *personNameFirst = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                         NSString *personNameLast = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                         NSString *personNameCompany = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
                         //NSLog(@"%@=======%@=====%@",personNameFirst,personNameLast,personNameCompany);
                         NSString *personName = @"";
                         
                         if (!IsStrEmpty(personNameLast))
                         {
                             personName =[NSString stringWithFormat:@"%@",personNameLast];
                             
                         }
                         if (!IsStrEmpty(personNameFirst)){
                             personName =[NSString stringWithFormat:@"%@%@",personNameLast,personNameFirst];
                         }
                         
                         NSString *text = [NSString stringWithFormat:@"%@#%@",personName,phone];
                         NSLog(@"%@",text);
                         BOOL hasExsis = NO;
                         NSInteger index = 0;
                         for (int i = 0 ; i < self.phones.count; i ++)
                         {
                             NSString *phoneStr = self.phones[i];
                             if ([phoneStr hasSuffix:phone]) {
                                 hasExsis = YES;
                                 index = i;
                                 break;
                             }
                         }
                         if ([phone isValidateMobile])
                         {
                             if (hasExsis)
                             {
                                 [self.phones replaceObjectAtIndex:index withObject:text];
                             }
                             else
                             {
                                 [self.phones addObject:text];
                             }
                         }
                     }
                 }
                 if (!IsArrEmpty(self.phones))
                 {
                     
                     [self uploadPhonesWithPhone:self.phones];
                 }
             }
         });
     });
}
-(NSMutableArray *)phones
{
    if (!_phones) {
        _phones = [NSMutableArray array];
    }
    return _phones;
}

-(void)btnBackClick:(id)sender
{
    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"因大牛圈需要真实用户信息，完善信息后才可正常使用。" leftButtonTitle:@"完善信息" rightButtonTitle:@"退出应用"];
    alert.rightBlock = ^{
        [[AppDelegate currentAppdelegate] exitApplication];
    };
    [alert show];
}
- (IBAction)headImageButtonClicked:(id)sender
{
	UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
	[takeSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		NSLog(@"拍照");
		[self cameraClick];
	}
	else if (buttonIndex == 1)
	{
		NSLog(@"选图");
		[self photosClick];
	}
	else if (buttonIndex == 2)
	{
		NSLog(@"取消");
	}
}

-(void)cameraClick
{
	UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
		pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
	}
    pickerImage.allowsEditing = YES;
	pickerImage.delegate = self;
	[self presentViewController:pickerImage animated:YES completion:nil];
}

-(void)photosClick
{
	UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
	}
	pickerImage.delegate = self;
	[self.navigationController presentViewController:pickerImage animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *newHeadiamge = info[UIImagePickerControllerOriginalImage];
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	self.headImage = newHeadiamge;
	[self.headImageButton setBackgroundImage:newHeadiamge forState:UIControlStateNormal];
	[self.headImageButton setBackgroundImage:newHeadiamge forState:UIControlStateHighlighted];

}


- (IBAction)submitButtonClicked:(id)sender
{
    if (hasUploadHead) {
        [self uploadMaterial];
    }
    
    else
    {
        if (self.headImage) {
            [self uploadHeadImage:self.headImage];
        }else{
            [Hud showMessageWithText:@"选择头像"];
        }
    }
}

- (void)uploadHeadImage:(UIImage *)image
{
	[Hud showLoadingWithMessage:@"正在上传图片..."];
	[[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/base"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
		[formData appendPartWithFileData:imageData name:@"hahaggggggg.jpg" fileName:@"hahaggggggg.jpg" mimeType:@"image/jpeg"];
	} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"%@",responseObject);
		
		NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
		self.headImageName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:self.headImageName forKey:KEY_HEAD_IMAGE];
        hasUploadHead = YES;
		[self uploadMaterial];
		[Hud hideHud];
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"%@",error);
		[Hud hideHud];
		[Hud showMessageWithText:@"上传图片失败"];
		
	}];
    
}

//此功能------当此用户注册成功的时候调用通知给其他的好友用户
- (void)dealFriendPush
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    uid = uid ? uid : @"";
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friend/dealFriendPush"];
    NSDictionary *parm = @{@"uid":uid};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parm success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"]){
        }
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
    
}

- (void)uploadMaterial
{
	if (IsStrEmpty(self.nameTextField.text)) {
		[Hud showMessageWithText:@"请输入名字"];
		return;
	}
    if (self.nameTextField.text.length > 12) {
        [Hud showMessageWithText:@"名字过长，最大长度为12个字"];
        return;
    }
	if (IsStrEmpty(self.companyTextField.text)) {
		[Hud showMessageWithText:@"请输入公司名"];
		return;
	}
	if (IsStrEmpty(self.titleTextField.text)) {
		[Hud showMessageWithText:@"请输入职务"];
		return;
	}
    
    __weak typeof(self)weakSelf = self;
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    
    [Hud showLoadingWithMessage:@"完善信息中"];
    [[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"register"] parameters:@{@"uid":uid, @"head_img":self.headImageName, @"name":self.nameTextField.text, @"company":self.companyTextField.text, @"title":self.titleTextField.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",operation);
        NSLog(@"%@",responseObject);
        [Hud hideHud];
        NSString *code = [responseObject valueForKey:@"code"];
        if ([code isEqualToString:@"000"]) {
            [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:KEY_USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:self.headImageName forKey:KEY_HEAD_IMAGE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                [weakSelf chatLoagin];
                [weakSelf dealFriendPush];
                if (!IsArrEmpty(self.phones)) {
                    [weakSelf uploadPhones];
                }
                
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loginSuccess];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Hud hideHud];
    }];
}

-(void)uploadPhones
{
    [self uploadPhonesWithPhone:self.phones];
}
-(void)uploadPhonesWithPhone:(NSMutableArray *)phones
{
    NSInteger num = phones.count/100+1;
    for (int i = 1; i <= num; i ++ ) {
        NSMutableArray *arr = [NSMutableArray array];
        
        NSInteger count = 0;
        if (phones.count > i * 100) {
            count =  i *100;
            
        }
        else
        {
            count = (i-1) *100 +phones.count % 100;
        }
        
        for (int j = (i -1)*100; j < count; j ++)
        {
            
            [arr addObject:phones[j]];
        }
        if (!IsArrEmpty(arr)) {
           
        [self uploadPhone:arr];
            
        }
    }
}


-(void)uploadPhone:(NSMutableArray *)arr
{
    NSString *str = arr[0];
    for (int i = 1 ; i < arr.count; i ++) {
        str = [NSString stringWithFormat:@"%@,%@",str,arr[i]];
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"friend/contact"];
    NSDictionary *parm = @{@"phones":str,
                           @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parm success:^(MOCHTTPResponse *response) {
        NSString *code = [response.data valueForKey:@"code"];
        if ([code isEqualToString:@"000"])
        {
        }
        
    } failed:^(MOCHTTPResponse *response) {
        
    }];
}
- (void)chatLoagin
{
	NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
	
	[[EaseMob sharedInstance].chatManager asyncLoginWithUsername:uid
														password:password
													  completion:
	 ^(NSDictionary *loginInfo, EMError *error) {
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
             
		 }else {
			 switch (error.errorCode) {
				 case EMErrorServerNotReachable:
					 NSLog(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
					 break;
				 case EMErrorServerAuthenticationFailure:
					 NSLog(error.description);
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
-(void)loginSuccess
{
    TabBarViewController *vc = [[TabBarViewController alloc] init];
    vc.rid = self.rid;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [AppDelegate currentAppdelegate].window.rootViewController = nav;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(self.currentField && [self.currentField isFirstResponder]){
        [self.currentField resignFirstResponder];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboaradRect = rect;
    [self scrollFieldToVisible];
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
//    self.bgScrollView.contentOffset = CGPointZero;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentField = textField;
    [self scrollFieldToVisible];
}

- (void)scrollFieldToVisible
{
    if(!self.currentField ||CGRectGetHeight(self.keyboaradRect) == 0){
        return;
    }
    if(CGRectGetMaxY(self.currentField.frame)+64.0f > CGRectGetMinY(self.keyboaradRect)){
        [self.bgScrollView setContentOffset:CGPointMake(0.0f, CGRectGetMaxY(self.currentField.frame) - CGRectGetMinY(self.keyboaradRect) + 2 * 64.0f) animated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
