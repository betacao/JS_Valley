//
//  SHGModifyUserInfoViewController.m
//  Finance
//
//  Created by changxicao on 16/1/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGModifyUserInfoViewController.h"
#import "SHGIndustrySelectView.h"
#import "SHGProvincesViewController.h"
#import "SHGAuthenticationWarningView.h"

@interface SHGModifyUserInfoViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,SHGAreaDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *headName;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *industryView;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UIView *departmentView;
@property (weak, nonatomic) IBOutlet UIView *cityView;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *industryField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *cityButton;

@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UIImageView *authTitleTipView;
@property (weak, nonatomic) IBOutlet UIImageView *authTipView;
@property (weak, nonatomic) IBOutlet UIButton *authButton;

@property (strong, nonatomic) SHGAuthenticationWarningView *warningView;

@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *industry;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *head_img;

@property (assign, nonatomic) BOOL imageChanged;
@property (strong, nonatomic) UITextField *currentField;
@property (assign, nonatomic) CGRect keyboaradRect;

@end

@implementation SHGModifyUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人信息";
    self.authView.hidden = YES;
    self.bgScrollView.hidden = YES;
    self.nickName = [self.userInfo objectForKey:kNickName];
    self.department = [self.userInfo objectForKey:kDepartment];
    self.company = [self.userInfo objectForKey:kCompany];
    self.industry = [self.userInfo objectForKey:kIndustry];
    self.location = [self.userInfo objectForKey:kLocation];
    self.head_img = [self.userInfo objectForKey:kHeaderImage];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopView:)];
    [self.headView addGestureRecognizer:recognizer];

    [self initView];
    [self addSdLayout];
    //请求状态
    WEAK(self, weakSelf);
    [[SHGGloble sharedGloble] requestUserVerifyStatusCompletion:^(BOOL state,NSString *auditState) {
        if (state) {
            self.bgScrollView.hidden = NO;
            if ([auditState isEqualToString:@"1"]){
                [weakSelf.authView removeFromSuperview];
                weakSelf.nextButton.alpha = 0.0f;
            } else{
                [weakSelf.authView removeFromSuperview];
            }
            
        } else {
            weakSelf.authView.hidden = NO;
            if ([auditState isEqualToString:@"1"]) {
                [weakSelf.authButton setTitle:@"审核中" forState:UIControlStateNormal];
                weakSelf.authButton.enabled = NO;
                weakSelf.authTipView.image = [UIImage imageNamed:@"messageIsChecked"];
            }
        }
    } showAlert:NO leftBlock:nil failString:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (SHGAuthenticationWarningView *)warningView
{
    if (!_warningView) {
        _warningView = [[SHGAuthenticationWarningView alloc] init];
        _warningView.text = @"如需修改个人信息请重新认证";
        [self.bgScrollView addSubview:_warningView];
    }
    return _warningView;
}

- (void)initView
{
    WEAK(self, weakSelf);
    self.warningView.block = ^{
        [UIView animateWithDuration:0.25f animations:^{
            weakSelf.warningView.sd_layout
            .heightIs(0.0f);
            [weakSelf.warningView updateLayout];
        }];
    };
    
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"f7f8f9"];
    self.headName.font = FontFactor(15.0f);
    self.headName.textColor = [UIColor colorWithHexString:@"161616"];
    
    self.nameField.font = FontFactor(15.0f);
    self.nameField.textColor = [UIColor colorWithHexString:@"161616"];
    [self.nameField setValue:[UIColor colorWithHexString:@"afafaf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.industryField.font = FontFactor(15.0f);
    self.industryField.textColor = [UIColor colorWithHexString:@"161616"];
    [self.industryField setValue:[UIColor colorWithHexString:@"afafaf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.companyField.font = FontFactor(15.0f);
    self.companyField.textColor = [UIColor colorWithHexString:@"161616"];
    [self.companyField setValue:[UIColor colorWithHexString:@"afafaf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.departmentField.font = FontFactor(15.0f);
    self.departmentField.textColor = [UIColor colorWithHexString:@"161616"];
    [self.departmentField setValue:[UIColor colorWithHexString:@"afafaf"] forKeyPath:@"_placeholderLabel.textColor"];
    self.cityButton.titleLabel.font = FontFactor(15.0f);
    [self.nextButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = FontFactor(17.0f);
    self.nextButton.backgroundColor = Color(@"f04241");

    //认证界面
    self.authView.backgroundColor = Color(@"f6f7f8");
    [self.authButton setTitle:@"立即认证" forState:UIControlStateNormal];
    [self.authButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.authButton.titleLabel.font = FontFactor(17.0f);
    self.authButton.backgroundColor = Color(@"f04241");
    [self.authButton addTarget:self action:@selector(authButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self initObject];

}

- (void)addSdLayout
{
    self.bgScrollView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);

    self.warningView.sd_layout
    .leftSpaceToView(self.bgScrollView, 0.0f)
    .rightSpaceToView(self.bgScrollView, 0.0f)
    .topSpaceToView(self.bgScrollView, 0.0f)
    .heightIs(MarginFactor(39.0f));
    
    self.bgView.sd_layout
    .leftSpaceToView(self.bgScrollView, 0.0f)
    .rightSpaceToView(self.bgScrollView, 0.0f)
    .topSpaceToView(self.warningView, 0.0f)
    .bottomSpaceToView(self.bgScrollView, 0.0f);
    
    self.headView.sd_layout
    .topSpaceToView(self.bgView, 0.0f)
    .leftSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.bgView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.headName.sd_layout
    .topSpaceToView(self.headView, 0.0f)
    .leftSpaceToView(self.headView, MarginFactor(11.0f))
    .rightSpaceToView(self.headView, MarginFactor(60.0f))
    .bottomSpaceToView(self.headView, 0.0f);
    
    self.headerImage.sd_layout
    .rightSpaceToView(self.headView, MarginFactor(11.0f))
    .centerYEqualToView(self.headView)
    .widthIs(MarginFactor(35.0f))
    .heightIs(MarginFactor(35.0f));
    
    self.nameView.sd_layout
    .topSpaceToView(self.bgView, MarginFactor(11.0f))
    .leftSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.bgView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.nameField.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));
    
    self.industryView.sd_layout
    .topSpaceToView(self.nameView, MarginFactor(11.0f))
    .leftSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.bgView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.industryField.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));
    
    self.companyView.sd_layout
    .topSpaceToView(self.industryView, MarginFactor(11.0f))
    .leftSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.bgView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.companyField.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));

    self.departmentView.sd_layout
    .topSpaceToView(self.companyView, MarginFactor(11.0f))
    .leftSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.bgView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.departmentField.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));
    
    self.cityView.sd_layout
    .topSpaceToView(self.departmentView, MarginFactor(11.0f))
    .leftSpaceToView(self.bgView, 0.0f)
    .rightSpaceToView(self.bgView, 0.0f)
    .heightIs(MarginFactor(55.0f));
    
    self.cityButton.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0.0f, MarginFactor(11.0f), 0.0f, 0.0f));
    
    self.nextButton.sd_layout
    .leftSpaceToView(self.bgScrollView, MarginFactor(12.0f))
    .rightSpaceToView(self.bgScrollView, MarginFactor(12.0f))
    .bottomSpaceToView(self.bgScrollView, MarginFactor(19.0f))
    .heightIs(MarginFactor(40.0f));

    //认证界面

    self.authTitleTipView.sd_layout
    .topSpaceToView(self.authView, 75.0f)
    .centerXEqualToView(self.authView)
    .widthIs(self.authTitleTipView.image.size.width)
    .heightIs(self.authTitleTipView.image.size.height);

    //不用margin
    self.authTipView.sd_layout
    .topSpaceToView(self.authTitleTipView, 95.0f)
    .centerXEqualToView(self.authView)
    .widthIs(self.authTipView.image.size.width)
    .heightIs(self.authTipView.image.size.height);

    self.authButton.sd_layout
    .leftSpaceToView(self.authView, MarginFactor(12.0f))
    .rightSpaceToView(self.authView, MarginFactor(12.0f))
    .bottomSpaceToView(self.authView, MarginFactor(19.0f))
    .heightIs(MarginFactor(40.0f));

    self.authView.sd_layout
    .spaceToSuperView(UIEdgeInsetsZero);
    
}

- (void)initObject
{
    [self.headerImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.head_img]] placeholder:[UIImage imageNamed:@"default_head"]];
    self.nameField.text = [self.userInfo objectForKey:kNickName];
    self.industryField.text = [self codeToIndustry: [self.userInfo objectForKey:kIndustry]];
    NSString *company = [self.userInfo objectForKey:kCompany];
    if (![company containsString:@"优质人脉"]) {
        self.companyField.text = company;
    }
    self.departmentField.text = [self.userInfo objectForKey:kDepartment];
    NSString *locationStr = [self.userInfo objectForKey:kLocation];
    if ([locationStr isEqualToString:@""]) {
        [self.cityButton setTitle:@"所在地" forState:UIControlStateNormal];
        self.cityButton.titleLabel.textColor = Color(@"afafaf");
    } else{
        [self.cityButton setTitle:[NSString stringWithFormat:@"%@",self.location] forState:UIControlStateNormal];
        [self.cityButton setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    }
}

- (void)authButtonClicked:(UIButton *)button
{
    SHGAuthenticationViewController *controller = [[SHGAuthenticationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)nextButtonClick:(UIButton *)button
{
    [self authButtonClicked:button];
}

- (BOOL)checkInputMessageValid
{
    if (IsStrEmpty(self.nameField.text)) {
        [Hud showMessageWithText:@"用户名不能为空"];
        return NO;
    }
    if (IsStrEmpty(self.industryField.text)) {
        [Hud showMessageWithText:@"行业名不能为空"];
        return NO;
    }
    if (IsStrEmpty(self.companyField.text)) {
        [Hud showMessageWithText:@"公司名不能为空"];
        return NO;
    }
    if (IsStrEmpty(self.departmentField.text)) {
        [Hud showMessageWithText:@"职位不能为空"];
        return NO;
    }
    if ([self.cityButton.titleLabel.text isEqualToString:@"所在地"]) {
        [Hud showMessageWithText:@"所在地不能为空"];
        return NO;
    }
    return YES;
}

- (void)uploadHeadImage:(UIImage *)image
{
    //头像需要压缩 跟其他的上传图片接口不一样了
    if([self checkInputMessageValid]){
        WEAK(self, weakSelf);
        [Hud showWait];
        [MOCHTTPRequestOperationManager POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
            [formData appendPartWithFileData:imageData name:@"hahaggg.jpg" fileName:@"hahaggg.jpg" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
            NSString *newHeadIamgeName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
            weakSelf.head_img = newHeadIamgeName;
            [[NSUserDefaults standardUserDefaults] setObject:newHeadIamgeName forKey:KEY_HEAD_IMAGE];
            [Hud hideHud];
            [weakSelf uploadUserInfo];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [Hud hideHud];
            [Hud showMessageWithText:@"上传图片失败"];
        }];
    }
}

- (void)uploadUserInfo
{
    if([self checkInputMessageValid]){
        [Hud showWait];
        WEAK(self, weakSelf);
        NSString *city = @"";
        if (![self.cityButton.titleLabel.text isEqualToString:@"所在地"]) {
            city = self.cityButton.titleLabel.text;
        }
        
        NSDictionary *param = @{@"uid":UID,@"picName":self.head_img,@"realName":self.nameField.text, @"industrycode":self.industry, @"company":self.companyField.text, @"city":city, @"title":self.departmentField.text};
        [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"editUser"] parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            if (weakSelf.block) {
                weakSelf.block(@{kHeaderImage:IsStrEmpty(weakSelf.head_img) ?@"":weakSelf.head_img,kNickName:weakSelf.nameField.text, kIndustry:weakSelf.industry, kCompany:weakSelf.companyField.text, kLocation:weakSelf.cityButton.titleLabel.text, kDepartment:weakSelf.departmentField.text});
            }
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.nameField.text forKey:KEY_USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.cityButton.titleLabel.text forKey:KEY_USER_AREA];
            [weakSelf performSelector:@selector(delayPostNotification) withObject:nil afterDelay:1.2f];
            [Hud showMessageWithText:@"修改个人信息成功"];
        }failed:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            [Hud showMessageWithText:@"修改个人信息失败"];
        }];
    }
}

- (void)delayPostNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
    WEAK(self, weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}

- (void)tapTopView:(UIGestureRecognizer *)recognizer
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

- (void)cameraClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

- (void)photosClick
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *newHeadiamge = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.headerImage.image = newHeadiamge;
    self.imageChanged = YES;
}

#pragma mark ------

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.industryField]) {
        [self.bgScrollView setContentOffset:CGPointZero animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.currentField resignFirstResponder];
        });
        [self showIndustryChoiceView];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.bgScrollView setContentOffset:CGPointZero animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [textField resignFirstResponder];
    });
    return YES;
}


- (void)scrollFieldToVisible
{
    if(!self.currentField ||CGRectGetHeight(self.keyboaradRect) == 0){
        return;
    }
    CGRect frame = self.currentField.frame;
    frame = [self.currentField.superview convertRect:frame toView:self.bgScrollView];
    if(CGRectGetMaxY(frame) + 64.0f > CGRectGetMinY(self.keyboaradRect)){
        [self.bgScrollView setContentOffset:CGPointMake(0.0f, CGRectGetMaxY(frame) - CGRectGetMinY(self.keyboaradRect) + 2 * 64.0f) animated:YES];
    }
}


- (void)showIndustryChoiceView
{
    SHGIndustrySelectView *view = [[SHGIndustrySelectView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) andSelctIndustry:self.industryField.text];
    WEAK(self, weakSelf);
    view.returnTextBlock = ^(NSString *string){
        weakSelf.industryField.text = string;
    };
    [weakSelf.view.window addSubview:view];
}

- (NSString *)industryToCode:(NSString *)industry
{
    if ([industry isEqualToString:@"银行机构"]) {
        return  @"bank";
    } else if ([industry isEqualToString:@"证券公司"]) {
        return @"bond";
    } else if ([industry isEqualToString:@"PE/VC"]) {
        return  @"pevc";
    } else if ([industry isEqualToString:@"债权机构"]) {
        return @"bondAgency";
    } else if ([industry isEqualToString:@"公募基金"]) {
        return @"fund";
    } else if ([industry isEqualToString:@"信托公司"]) {
        return @"entrust";
    } else if ([industry isEqualToString:@"三方理财"]) {
        return @"manage";
    } else if ([industry isEqualToString:@"担保小贷"]) {
        return @"bonding";
    } else if ([industry isEqualToString:@"上市公司"]) {
        return @"public";
    } else if ([industry isEqualToString:@"融资企业"]) {
        return @"financingEnterprise";
    } else if ([industry isEqualToString:@"其他"]) {
        return @"other";
    }

    return nil;
}

- (NSString *)codeToIndustry:(NSString *)code
{
    if ([code isEqualToString:@"bank"]) {
        return  @"银行机构";
    } else if ([code isEqualToString:@"bond"]) {
        return @"证券公司";
    } else if ([code isEqualToString:@"pevc"]) {
        return  @"PE/VC";
    } else if ([code isEqualToString:@"bondAgency"]) {
        return @"债权机构";
    } else if ([code isEqualToString:@"fund"]) {
        return @"公募基金";
    } else if ([code isEqualToString:@"entrust"]) {
        return @"信托公司";
    } else if ([code isEqualToString:@"manage"]) {
        return @"三方理财";
    } else if ([code isEqualToString:@"bonding"]) {
        return @"担保小贷";
    } else if ([code isEqualToString:@"public"]) {
        return @"上市公司";
    } else if ([code isEqualToString:@"financingEnterprise"]) {
        return @"融资企业";
    } else if ([code isEqualToString:@"other"]) {
        return @"其他";
    }

    return nil;
}

- (IBAction)citySelect:(UIButton *)sender {
    SHGProvincesViewController *controller = [[SHGProvincesViewController alloc] initWithNibName:@"SHGProvincesViewController" bundle:nil];
    if(controller){
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }

}

- (void)didSelectCity:(NSString *)city
{
    [self.cityButton setTitle:city forState:UIControlStateNormal];
    [self.cityButton setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
