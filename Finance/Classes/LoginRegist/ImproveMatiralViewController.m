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
#import "CCLocationManager.h"
#import "SHGAreaViewController.h"

#define kPersonCategoryLeftMargin 13.0f * XFACTOR
#define kPersonCategoryTopMargin 10.0f * YFACTOR
#define kPersonCategoryMargin 7.0f *XFACTOR
#define kPersonCategoryHeight 22.0f * YFACTOR

@interface ImproveMatiralViewController ()<UIScrollViewDelegate,SHGGlobleDelegate>
{
    BOOL hasUploadHead;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet SHGPersonCategoryView *personCategoryView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;
@property (strong, nonatomic) UIImage *headImage;
@property (strong, nonatomic) NSString *headImageName;
@property (strong, nonatomic) NSMutableArray *phones;
@property (strong, nonatomic) UITextField *currentField;
@property (assign, nonatomic) CGRect keyboaradRect;

- (IBAction)headImageButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;

@end

@implementation ImproveMatiralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SHGGloble sharedGloble].delegate = self;
    self.title = @"完善信息";

    self.bgScrollView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectZero];
    NSString *imageName = @"返回";
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.headImageButton.layer.masksToBounds = YES;
    self.headImageButton.layer.cornerRadius = CGRectGetHeight(self.headImageButton.frame) / 2.0f;
    [self initTextFieldStyle:@[self.nameTextField, self.companyTextField, self.titleTextField]];

    __weak typeof(self) weakSelf = self;
    [self.personCategoryView updateViewWithArray:[SHGGloble sharedGloble].tagsArray finishBlock:^{
        CGPoint point = CGPointMake(0.0f, CGRectGetMaxY(weakSelf.personCategoryView.frame) + 2 * kPersonCategoryTopMargin);
        point = [weakSelf.view convertPoint:point fromView:weakSelf.personCategoryView.superview];
        CGRect frame = weakSelf.nextButton.frame;
        frame.origin.y = point.y;
        weakSelf.nextButton.frame = frame;
        weakSelf.bgScrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(self.nextButton.frame) + 2 * kPersonCategoryTopMargin);

    }];

    [self getAddress];
    [[CCLocationManager shareLocation] getCity:^(NSString *addressString) {

    }];
}

- (void)initTextFieldStyle:(NSArray *)arrays
{
    for(UITextField *field in arrays){
        field.layer.masksToBounds = YES;
        field.layer.cornerRadius = 5.0f;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SHGGloble sharedGloble].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark -- sdc
#pragma mark -- 获得联系人
- (void)getAddress
{
    __weak typeof(self) weakSelf = self;
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            if (error){
                NSLog(@"Error: %@", (__bridge NSError *)error);
            } else if (!granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"获取权限失败" message:@"请设置权限." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [av show];
                });
            } else{
                CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
                for(int i = 0; i < CFArrayGetCount(results); i++){
                    ABRecordRef person = CFArrayGetValueAtIndex(results, i);
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    for (int k = 0; k<ABMultiValueGetCount(phone); k++){
                        //获取該Label下的电话值
                        NSString *personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                        NSString *phone = [personPhone validPhone];
                        NSString *personNameFirst = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                        NSString *personNameLast = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
                        NSString *personName = @"";

                        if (!IsStrEmpty(personNameLast)){
                            personName =[NSString stringWithFormat:@"%@",personNameLast];

                        }
                        if (!IsStrEmpty(personNameFirst)){
                            personName =[NSString stringWithFormat:@"%@%@",personNameLast,personNameFirst];
                        }
                        NSString *text = [NSString stringWithFormat:@"%@#%@",personName,phone];
                        BOOL hasExsis = NO;
                        NSInteger index = 0;
                        for (NSInteger i = 0 ; i < self.phones.count; i ++){
                            NSString *phoneStr = self.phones[i];
                            if ([phoneStr hasSuffix:phone]) {
                                hasExsis = YES;
                                index = i;
                                break;
                            }
                        }
                        if ([phone isValidateMobile]){
                            if (hasExsis){
                                [weakSelf.phones replaceObjectAtIndex:index withObject:text];
                            } else{
                                [weakSelf.phones addObject:text];
                            }
                        }
                    }
                }
                if (!IsArrEmpty(weakSelf.phones)){
                    [weakSelf uploadPhonesWithPhone:weakSelf.phones];
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
    }else{
        if (self.headImage) {
            [self uploadHeadImage:self.headImage];
        }else{
            [Hud showMessageWithText:@"选择头像"];
        }
    }
}

- (IBAction)manualSelectCity:(id)sender
{
    SHGAreaViewController *controller = [[SHGAreaViewController alloc] initWithNibName:@"SHGAreaViewController" bundle:nil];
    if(controller){
        [self.navigationController pushViewController:controller animated:YES];
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
        else{
            count = (i-1) *100 +phones.count % 100;
        }

        for (int j = (i -1)*100; j < count; j ++){
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
    NSDictionary *parm = @{@"phones":str, @"uid":[[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID]};
    [MOCHTTPRequestOperationManager postWithURL:url class:nil parameters:parm success:^(MOCHTTPResponse *response) {
        
    } failed:^(MOCHTTPResponse *response) {
        
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

-(void)loginSuccess
{
    TabBarViewController *vc = [[TabBarViewController alloc] init];
    vc.rid = self.rid;
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
    [AppDelegate currentAppdelegate].window.rootViewController = nav;
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboaradRect = rect;
    [self scrollFieldToVisible];
    
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

//异步获取地理位置信息
- (void)userlocationDidShow:(NSString *)cityName
{
    NSMutableString *string = [NSMutableString stringWithString:@"地点：大牛圈猜你在，没猜对？"];
    NSRange range = [string rangeOfString:@"，"];
    if(range.location != NSNotFound){
        [string insertString:cityName atIndex:range.location];
        range = [string rangeOfString:cityName];
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:string];
        [aString setAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"f04241"] forKey:NSForegroundColorAttributeName] range:range];
        //替换显示的字符串，随后要更改“手动选择”的button位置
        [self.locationLabel setAttributedText:aString];
        CGSize size = [self.locationLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.locationLabel.frame))];

        CGRect frame = self.locationLabel.frame;
        frame.size.width = size.width;
        self.locationLabel.frame = frame;

        self.manualButton.center = self.locationLabel.center;
        frame = self.manualButton.frame;
        frame.origin.x = CGRectGetMaxX(self.locationLabel.frame);
        self.manualButton.frame = frame;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface SHGPersonCategoryView ()

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (copy, nonatomic) SHGPersonCategoryViewLoadFinish finishBlock;


@end

@implementation SHGPersonCategoryView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.selectedArray = [NSMutableArray array];
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectedArray = [NSMutableArray array];
}

- (void)updateViewWithArray:(NSArray *)dataArray finishBlock:(SHGPersonCategoryViewLoadFinish)block
{
    self.dataArray = dataArray;
    self.finishBlock = block;
}

- (void)layoutSubviews
{
    CGFloat width = (CGRectGetWidth(self.frame) - 2 * kPersonCategoryLeftMargin - 3 * kPersonCategoryMargin) / 4.0f;
    for(NSString *string in self.dataArray){
        NSInteger index = [self.dataArray indexOfObject:string];
        NSInteger row = index / 4;
        NSInteger col = index % 4;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor colorWithHexString:@"D6D6D6"].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:11.0f];

        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"D2D1D1"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f04240"]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f04240"]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectMake(kPersonCategoryLeftMargin + (kPersonCategoryMargin + width) * col, kPersonCategoryTopMargin + (kPersonCategoryMargin + kPersonCategoryHeight) * row, width, kPersonCategoryHeight);
        button.frame = frame;
        [self addSubview:button];
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(button.frame);
        self.frame = frame;
    }

    UILabel *label = [[UILabel alloc] init];
    label.text = @"最多选3项（个人中心可更新）";
    label.font = [UIFont systemFontOfSize:11.0f];
    label.textColor = [UIColor colorWithHexString:@"D2D1D1"];
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin.y = CGRectGetHeight(self.frame) + kPersonCategoryTopMargin;
    frame.origin.x = kPersonCategoryLeftMargin;
    label.frame = frame;
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(label.frame) + kPersonCategoryTopMargin;
    self.frame = frame;
    [self addSubview:label];
    if(self.finishBlock){
        self.finishBlock();
    }
}

- (void)didSelectCategory:(UIButton *)button
{
    BOOL isSelecetd = button.selected;
    if(!isSelecetd){
        if(self.selectedArray.count >= 3){
            [Hud showMessageWithText:@"最多选3项"];
        } else{
            button.selected = !isSelecetd;
            [self.selectedArray addObject:button];
        }
    } else{
        button.selected = !isSelecetd;
        [self.selectedArray removeObject:button];
    }
}


@end
