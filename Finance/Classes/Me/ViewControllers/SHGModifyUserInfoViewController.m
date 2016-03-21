//
//  SHGModifyUserInfoViewController.m
//  Finance
//
//  Created by changxicao on 16/1/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGModifyUserInfoViewController.h"
#import "SHGItemChooseView.h"
#import "SHGMarketManager.h"
#import "SHGProvincesViewController.h"
#define kNextButtonHeight 8.0f *  XFACTOR
@interface SHGModifyUserInfoViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SHGItemChooseDelegate,SHGAreaDelegate>

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
    [self addSdLayout];
    self.nickName = [self.userInfo objectForKey:kNickName];
    self.department = [self.userInfo objectForKey:kDepartment];
    self.company = [self.userInfo objectForKey:kCompany];
    self.industry = [self.userInfo objectForKey:kIndustry];
    self.location = [self.userInfo objectForKey:kLocation];
    self.head_img = [self.userInfo objectForKey:kHeaderImage];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopView:)];
    [self.headView addGestureRecognizer:recognizer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [self initObject];
}

- (void)initView
{
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"efeeef"];
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
    [self.cityButton setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    self.nextButton.titleLabel.font = FontFactor(17.0f);
    [self.nextButton setBackgroundColor:[UIColor colorWithHexString:@"f04241"]];
    
}

- (void)addSdLayout
{
    self.bgScrollView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f);
    
    self.bgView.sd_layout
    .leftSpaceToView(self.bgScrollView, 0.0f)
    .rightSpaceToView(self.bgScrollView, 0.0f)
    .topSpaceToView(self.bgScrollView, 0.0f)
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
    .topSpaceToView(self.headView, MarginFactor(11.0f))
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
    .leftSpaceToView(self.bgView, MarginFactor(12.0f))
    .rightSpaceToView(self.bgView, MarginFactor(12.0f))
    .bottomSpaceToView(self.bgView, MarginFactor(19.0f))
    .heightIs(MarginFactor(35.0f));
    
}
- (void)initObject
{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.head_img]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nameField.text = [self.userInfo objectForKey:kNickName];
    self.industryField.text = [self codeToIndustry: [self.userInfo objectForKey:kIndustry]];
    self.companyField.text = [self.userInfo objectForKey:kCompany];
    self.departmentField.text = [self.userInfo objectForKey:kDepartment];
    NSString *locationStr = [self.userInfo objectForKey:kLocation];
    if ([locationStr isEqualToString:@""]) {
        [self.cityButton setTitle:@"所在地" forState:UIControlStateNormal];
    } else{
        [self.cityButton setTitle:[NSString stringWithFormat:@"%@",self.location] forState:UIControlStateNormal];
        [self.cityButton setTitleColor:[UIColor colorWithHexString:@"161616"] forState:UIControlStateNormal];
    }

    [self.view layoutSubviews];
}

- (IBAction)nextButtonClick:(UIButton *)button
{
    
    if (self.imageChanged) {
        [self uploadHeadImage:self.headerImage.image];
    } else{
        [self uploadUserInfo];
    }
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
    if ([self.cityButton.titleLabel.text isEqualToString:@"所选城市"]) {
        [Hud showMessageWithText:@"请输入城市选择"];
        return NO;
    }
    return YES;
}

- (void)uploadHeadImage:(UIImage *)image
{
    //头像需要压缩 跟其他的上传图片接口不一样了
    if([self checkInputMessageValid]){
        __weak typeof(self) weakSelf = self;
        [Hud showWait];
        [[AFHTTPSessionManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
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
        __weak typeof(self) weakSelf = self;
        NSDictionary *param = @{@"uid":UID,@"picName":self.head_img,@"realName":self.nameField.text, @"industrycode":self.industry, @"company":self.companyField.text, @"city":self.cityButton.titleLabel.text, @"title":self.departmentField.text};
        [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"editUser"] parameters:param success:^(MOCHTTPResponse *response) {
            [Hud hideHud];
            if (weakSelf.block) {
                weakSelf.block(@{kHeaderImage:weakSelf.head_img,kNickName:weakSelf.nameField.text, kIndustry:weakSelf.industry, kCompany:weakSelf.companyField.text, kLocation:weakSelf.cityButton.titleLabel.text, kDepartment:weakSelf.departmentField.text});
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
    __weak typeof(self) weakSelf = self;
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
    SHGItemChooseView *view = [[SHGItemChooseView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) lineNumber:9];
    view.delegate = self;
    view.dataArray = @[@"银行机构", @"证券公司", @"PE/VC",@"公募基金",@"信托公司",@"三方理财", @"担保小贷", @"上市公司", @"其他"];
    [self.view.window addSubview:view];
}

#pragma mark ------ 选择行业代理
- (void)didSelectItem:(NSString *)item
{
    self.industryField.text = item;
    self.industry = [self industryToCode:item];

}

- (NSString *)industryToCode:(NSString *)industry
{
    if ([industry isEqualToString:@"银行机构"]) {
        return  @"bank";
    } else if ([industry isEqualToString:@"证券公司"]) {
        return @"bond";
    } else if ([industry isEqualToString:@"PE/VC"]) {
        return  @"pevc";
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
    } else if ([code isEqualToString:@"other"]) {
        return @"其他";
    }

    return nil;
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
