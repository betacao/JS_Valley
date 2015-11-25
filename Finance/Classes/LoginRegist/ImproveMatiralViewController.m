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
#import "SHGProvincesViewController.h"
#import "SHGUserTagModel.h"
#import "SHGIndustryChoiceView.h"

#define kPersonCategoryLeftMargin 13.0f * XFACTOR
#define kPersonCategoryTopMargin 10.0f * XFACTOR
#define kPersonCategoryHorizontalMargin 7.0f * XFACTOR
#define kPersonCategoryVerticalMargin 9.0f * XFACTOR
#define kPersonCategoryHeight 22.0f * XFACTOR

@interface ImproveMatiralViewController ()<UIScrollViewDelegate, SHGGlobleDelegate, SHGAreaDelegate, SHGIndustryChoiceDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *industrycodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet SHGPersonCategoryView *personCategoryView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *manualButton;

@property (strong, nonatomic) UIImage *headImage;
@property (strong, nonatomic) NSString *headImageName;
@property (strong, nonatomic) UITextField *currentField;
@property (assign, nonatomic) CGRect keyboaradRect;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) NSString *userLocation;

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
    [self initTextFieldStyle:@[self.nameTextField,self.industrycodeTextField, self.companyTextField, self.titleTextField]];

    self.personCategoryView.superview.hidden = YES;

    [[SHGGloble sharedGloble] getUserAddressList:^(BOOL finished) {
        if(finished){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KEY_USER_NEEDUPLOADCONTACT];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    [self downloadUserSelectedInfo];
    [self adjustLocationFrame];
    [[CCLocationManager shareLocation] getCity:^{

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

//调整选择地理位置label button等控件的位置
- (void)adjustLocationFrame
{
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.activityView startAnimating];

    CGRect frame = self.locationLabel.frame;
    CGSize size = [self.locationLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.locationLabel.frame))];
    frame.size.width = size.width;
    self.locationLabel.frame = frame;

    self.manualButton.center = self.locationLabel.center;
    frame = self.manualButton.frame;
    frame.origin.x = CGRectGetMaxX(self.locationLabel.frame);
    self.manualButton.frame = frame;

    self.activityView.center = self.locationLabel.center;
    frame = self.activityView.frame;
    frame.origin.x = CGRectGetMaxX(self.manualButton.frame);
    self.activityView.frame = frame;

    [self.locationLabel.superview addSubview:self.activityView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SHGGloble sharedGloble].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)btnBackClick:(id)sender
{
    [self.currentField resignFirstResponder];
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
    pickerImage.allowsEditing = YES;
	pickerImage.delegate = self;
	[self.navigationController presentViewController:pickerImage animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *newHeadiamge = info[UIImagePickerControllerEditedImage];
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	self.headImage = newHeadiamge;
	[self.headImageButton setBackgroundImage:newHeadiamge forState:UIControlStateNormal];
	[self.headImageButton setBackgroundImage:newHeadiamge forState:UIControlStateHighlighted];

}


- (IBAction)submitButtonClicked:(id)sender
{
    if(self.headImage){
        [self uploadHeadImage:self.headImage];
    } else{
        [self uploadMaterial];
    }
}

- (IBAction)manualSelectCity:(id)sender
{
    SHGProvincesViewController *controller = [[SHGProvincesViewController alloc] initWithNibName:@"SHGProvincesViewController" bundle:nil];
    if(controller){
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)uploadHeadImage:(UIImage *)image
{
    if([self checkInputMessageValid]){
        [Hud showLoadingWithMessage:@"正在上传图片..."];
        __weak typeof(self) weakSelf = self;
        //头像需要压缩 跟其他的上传图片接口不一样了
        [[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [formData appendPartWithFileData:imageData name:@"hahaggggggg.jpg" fileName:@"hahaggggggg.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [Hud hideHud];
            NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
            weakSelf.headImageName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.headImageName forKey:KEY_HEAD_IMAGE];
            [weakSelf uploadMaterial];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [Hud hideHud];
            [Hud showMessageWithText:@"上传图片失败"];
            
        }];
    }
    
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
    if([self checkInputMessageValid]){
        __weak typeof(self)weakSelf = self;
        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];

        NSDictionary *param = @{@"uid":uid, @"head_img":self.headImageName ? self.headImageName : @"", @"name":self.nameTextField.text, @"industrycode":self.industrycodeTextField.text, @"company":self.companyTextField.text, @"title":self.titleTextField.text, @"position":self.userLocation ? self.userLocation : @""};
        [Hud showLoadingWithMessage:@"完善信息中"];
        [[AFHTTPRequestOperationManager manager] PUT:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"register"] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",operation);
            NSLog(@"%@",responseObject);
            NSString *code = [responseObject valueForKey:@"code"];
            if ([code isEqualToString:@"000"]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:KEY_USER_NAME];
                [[NSUserDefaults standardUserDefaults] setObject:self.headImageName forKey:KEY_HEAD_IMAGE];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [weakSelf chatLoagin];
                [weakSelf dealFriendPush];
                [weakSelf uploadUserSelectedInfo];
                NSLog(@"**********");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Hud hideHud];
        }];
    }
}

- (BOOL)checkInputMessageValid
{
    if (IsStrEmpty(self.nameTextField.text)) {
        [Hud showMessageWithText:@"请输入名字"];
        return NO;
    }
    if (self.nameTextField.text.length > 12) {
        [Hud showMessageWithText:@"名字过长，最大长度为12个字"];
        return NO;
    }
    if (IsStrEmpty(self.industrycodeTextField.text)) {
        [Hud showMessageWithText:@"请输入行业"];
        return NO;
    }
    if (IsStrEmpty(self.companyTextField.text)) {
        [Hud showMessageWithText:@"请输入公司名"];
        return NO;
    }
    if (IsStrEmpty(self.titleTextField.text)) {
        [Hud showMessageWithText:@"请输入职务"];
        return NO;
    }
    if ([self.personCategoryView userSelectedTags].count == 0) {
        [Hud showMessageWithText:@"标签至少选择一项"];
        return NO;
    }
    return YES;
}

- (void)downloadUserSelectedInfo
{
    __weak typeof(self) weakSelf = self;
    [[SHGGloble sharedGloble] downloadUserTagInfo:^{
        [weakSelf.personCategoryView updateViewWithArray:[SHGGloble sharedGloble].tagsArray finishBlock:^{
            CGPoint point = CGPointMake(0.0f, CGRectGetMaxY(weakSelf.personCategoryView.frame) + 2 * kPersonCategoryTopMargin);
            point = [weakSelf.view convertPoint:point fromView:weakSelf.personCategoryView.superview];
            CGRect frame = weakSelf.nextButton.frame;
            frame.origin.y = point.y;
            weakSelf.nextButton.frame = frame;
            weakSelf.bgScrollView.contentSize = CGSizeMake(SCREENWIDTH, CGRectGetMaxY(self.nextButton.frame) + 2 * kPersonCategoryTopMargin);
            weakSelf.personCategoryView.superview.hidden = NO;
        }];
    }];
}

- (void)uploadUserSelectedInfo
{
    __weak typeof(self) weakSelf = self;
    NSArray *array = [self.personCategoryView userSelectedTags];
    [[SHGGloble sharedGloble] uploadUserSelectedInfo:array completion:^(BOOL finished) {
        if(finished){
            [weakSelf didUploadAllUserInfo];
        } else{
            [Hud hideHud];
        }
    }];
}

//上传个人信息和标签是在两个地方分别上传的 要等两个请求全部完成才能去跳转到下一页
- (void)didUploadAllUserInfo
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [Hud hideHud];
        [weakSelf loginSuccess];
    });
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
    TabBarViewController *vc = [TabBarViewController tabBar];
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.industrycodeTextField]) {
        [self.currentField resignFirstResponder];
        [self showIndustryChoiceView];
        return NO;
    }
    return YES;
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
    if(CGRectGetMaxY(self.currentField.frame) + 64.0f > CGRectGetMinY(self.keyboaradRect)){
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
    [self.activityView removeFromSuperview];
    if(cityName.length == 0){
        self.locationLabel.text = @"未定位到您的位置  ";
    } else{
        self.userLocation = cityName;
        NSMutableString *string = [NSMutableString stringWithString:@"地点：大牛圈猜你在，没猜对？"];
        NSRange range = [string rangeOfString:@"，"];
        if(range.location != NSNotFound){
            [string insertString:cityName atIndex:range.location];
            range = [string rangeOfString:cityName];
            NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:string];
            [aString setAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"f04241"] forKey:NSForegroundColorAttributeName] range:range];
            //替换显示的字符串，随后要更改“手动选择”的button位置
            [self.locationLabel setAttributedText:aString];
        }
    }

    CGSize size = [self.locationLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.locationLabel.frame))];

    CGRect frame = self.locationLabel.frame;
    frame.size.width = size.width;
    self.locationLabel.frame = frame;

    self.manualButton.center = self.locationLabel.center;
    frame = self.manualButton.frame;
    frame.origin.x = CGRectGetMaxX(self.locationLabel.frame);
    self.manualButton.frame = frame;
}

- (void)didSelectCity:(NSString *)city
{
    self.userLocation = city;
    city = [city stringByAppendingString:@"  "];
    NSMutableString *string = [NSMutableString stringWithString:@"地点："];
    NSRange range = [string rangeOfString:@"："];
    if(range.location != NSNotFound){
        [self.activityView removeFromSuperview];
        [string insertString:city atIndex:range.location + 1];
        range = [string rangeOfString:city];
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

- (void)showIndustryChoiceView
{
    SHGIndustryChoiceView *view = [[SHGIndustryChoiceView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    view.delegate = self;
    [self.view.window addSubview:view];
}

#pragma mark ------ 选择行业代理
- (void)didSelectIndustry:(NSString *)industry
{
    self.industrycodeTextField.text = industry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@interface SHGPersonCategoryView ()

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) UILabel *noticeLabel;
@property (strong, nonatomic) NSMutableArray *buttonArrays;
@property (copy, nonatomic) SHGPersonCategoryViewLoadFinish finishBlock;


@end

@implementation SHGPersonCategoryView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.selectedArray = [NSMutableArray array];
        self.buttonArrays = [NSMutableArray array];
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    self.selectedArray = [NSMutableArray array];
    self.buttonArrays = [NSMutableArray array];
}

- (void)updateViewWithArray:(NSArray *)dataArray finishBlock:(SHGPersonCategoryViewLoadFinish)block
{
    self.dataArray = dataArray;
    self.finishBlock = block;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.buttonArrays.count > 0) {
        return;
    }
    [self.buttonArrays removeAllObjects];
    CGFloat width = (CGRectGetWidth(self.frame) - 2 * kPersonCategoryLeftMargin - 3 * kPersonCategoryHorizontalMargin) / 4.0f;
    for(SHGUserTagModel *model in self.dataArray){
        NSInteger index = [self.dataArray indexOfObject:model];
        NSInteger row = index / 4;
        NSInteger col = index % 4;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor colorWithHexString:@"D6D6D6"].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:11.0f];

        [button setTitle:model.tagName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"8c8c8c"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f95c53"]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f95c53"]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectMake(kPersonCategoryLeftMargin + (kPersonCategoryHorizontalMargin + width) * col, kPersonCategoryTopMargin + (kPersonCategoryVerticalMargin + kPersonCategoryHeight) * row, width, kPersonCategoryHeight);
        button.frame = frame;
        [self addSubview:button];
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(button.frame);
        self.frame = frame;
        [self.buttonArrays addObject:button];
    }

    [self.noticeLabel sizeToFit];
    CGRect frame = self.noticeLabel.frame;
    frame.origin.y = CGRectGetHeight(self.frame) + kPersonCategoryTopMargin;
    frame.origin.x = kPersonCategoryLeftMargin;
    self.noticeLabel.frame = frame;
    frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.noticeLabel.frame) + kPersonCategoryTopMargin;
    self.frame = frame;
    if(self.finishBlock){
        self.finishBlock();
    }
    if (self.buttonArrays.count > 0) {
        [self didSelectCategory:[self.buttonArrays firstObject]];
    }
}

- (UILabel *)noticeLabel
{
    if(!_noticeLabel){
        _noticeLabel = [[UILabel alloc] init];
        _noticeLabel.text = @"最多选3项（个人中心可更新）";
        _noticeLabel.font = [UIFont systemFontOfSize:11.0f];

        _noticeLabel.textColor = [UIColor colorWithHexString:@"D2D1D1"];
        [self addSubview:_noticeLabel];
    }
    return _noticeLabel;
}

- (void)didSelectCategory:(UIButton *)button
{
    BOOL isSelecetd = button.selected;
    NSInteger index = [self.buttonArrays indexOfObject:button];
    if(!isSelecetd){
        if(self.selectedArray.count >= 3){
            [Hud showMessageWithText:@"最多选3项"];
        } else{
            button.selected = !isSelecetd;
            [self.selectedArray addObject:@(index)];
        }
    } else{
        button.selected = !isSelecetd;
        [self.selectedArray removeObject:@(index)];
    }
}

- (NSArray *)userSelectedTags
{
    return self.selectedArray;
}


@end
