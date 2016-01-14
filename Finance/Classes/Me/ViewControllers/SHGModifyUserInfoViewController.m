//
//  SHGModifyUserInfoViewController.m
//  Finance
//
//  Created by changxicao on 16/1/5.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGModifyUserInfoViewController.h"
#import "SHGIndustryChoiceView.h"
#define kNextButtonHeight 8.0f *  XFACTOR
@interface SHGModifyUserInfoViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SHGIndustryChoiceDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *industryField;
@property (weak, nonatomic) IBOutlet UITextField *companyField;
@property (weak, nonatomic) IBOutlet UITextField *departmentField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UIButton *industryButton;
@property (weak, nonatomic) IBOutlet UIButton *companyButton;
@property (weak, nonatomic) IBOutlet UIButton *departmentButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

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

    self.nickName = [self.userInfo objectForKey:kNickName];
    self.department = [self.userInfo objectForKey:kDepartment];
    self.company = [self.userInfo objectForKey:kCompany];
    self.industry = [self.userInfo objectForKey:kIndustry];
    self.location = [self.userInfo objectForKey:kLocation];
    self.head_img = [self.userInfo objectForKey:kHeaderImage];

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopView:)];
    [self.topView addGestureRecognizer:recognizer];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self initObject];
}

- (void)initObject
{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,self.head_img]] placeholderImage:[UIImage imageNamed:@"default_head"]];
    self.nameField.text = [self.userInfo objectForKey:kNickName];
    self.industryField.text = [self codeToIndustry: [self.userInfo objectForKey:kIndustry]];
    self.companyField.text = [self.userInfo objectForKey:kCompany];
    self.departmentField.text = [self.userInfo objectForKey:kDepartment];
    self.locationField.text = [self.userInfo objectForKey:kLocation];

    [self updateCloseButtonState:self.nameField];
    [self updateCloseButtonState:self.industryField];
    [self updateCloseButtonState:self.companyField];
    [self updateCloseButtonState:self.departmentField];
    [self updateCloseButtonState:self.locationField];

    CGRect frame = self.nextButton.frame;
    //frame.origin.y *= YFACTOR;
    frame.origin.y = self.bgScrollView.height - kNextButtonHeight - frame.size.height;
    self.nextButton.frame = frame;

}

- (IBAction)nextButtonClick:(UIButton *)button
{
    if (self.imageChanged) {
        [self uploadHeadImage:self.headerImage.image];
    } else{
        [self uploadUserInfo];
    }
}

- (void)uploadHeadImage:(UIImage *)image
{
    //头像需要压缩 跟其他的上传图片接口不一样了
    __weak typeof(self) weakSelf = self;
    [Hud showLoadingWithMessage:@"正在上传图片..."];
    [[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/basephoto"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
        [formData appendPartWithFileData:imageData name:@"hahaggg.jpg" fileName:@"hahaggg.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
        NSString *newHeadIamgeName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
        weakSelf.head_img = newHeadIamgeName;
        [[NSUserDefaults standardUserDefaults] setObject:newHeadIamgeName forKey:KEY_HEAD_IMAGE];
        [weakSelf uploadUserInfo];
        [Hud hideHud];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [Hud hideHud];
        [Hud showMessageWithText:@"上传图片失败"];
    }];

}

- (void)uploadUserInfo
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"uid":UID,@"picName":self.head_img,@"realName":self.nameField.text, @"industrycode":self.industry, @"company":self.companyField.text, @"city":self.locationField.text, @"title":self.departmentField.text};
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@/%@",rBaseAddressForHttp,@"user",@"editUser"] parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        if (weakSelf.block) {
            weakSelf.block(@{kHeaderImage:weakSelf.head_img,kNickName:weakSelf.nameField.text, kIndustry:weakSelf.industry, kCompany:weakSelf.companyField.text, kLocation:weakSelf.locationField.text, kDepartment:weakSelf.departmentField.text});
        }
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.nameField.text forKey:KEY_USER_NAME];
        [weakSelf performSelector:@selector(delayPostNotification) withObject:nil afterDelay:1.2f];
        [Hud showMessageWithText:@"修改个人信息成功"];
    }failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:@"修改个人信息失败"];
    }];
}

- (void)delayPostNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}


- (IBAction)clickNameButton:(UIButton *)sender
{
    self.nameField.text = @"";
    [self updateCloseButtonState:self.nameField];
    [self.nameField becomeFirstResponder];
}

- (IBAction)clickIndustryButton:(id)sender
{
    self.industryField.text = @"";
    [self updateCloseButtonState:self.industryField];
    [self.industryField becomeFirstResponder];

}

- (IBAction)clickCompanyButton:(id)sender
{
    self.companyField.text = @"";
    [self updateCloseButtonState:self.companyField];
    [self.companyField becomeFirstResponder];
}

- (IBAction)clickDepartmentButton:(id)sender
{
    self.departmentField.text = @"";
    [self updateCloseButtonState:self.departmentField];
    [self.departmentField becomeFirstResponder];

}
- (IBAction)clickLocationButton:(id)sender
{
    self.locationField.text = @"";
    [self updateCloseButtonState:self.locationField];
    [self.locationField becomeFirstResponder];
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


- (void)textFieldDidChange:(NSNotification *)notif
{
    UITextField *field = (UITextField *)notif.object;
    [self updateCloseButtonState:field];
}



- (void)updateCloseButtonState:(UITextField *)textField
{
    if ([textField isEqual:self.nameField]) {
        if (textField.text.length > 0) {
            self.nameButton.hidden = NO;
        } else{
            self.nameButton.hidden = YES;
        }
    } else if ([textField isEqual:self.industryField]) {
        if (textField.text.length > 0) {
            self.industryButton.hidden = NO;
        } else{
            self.industryButton.hidden = YES;
        }
    } else if ([textField isEqual:self.companyField]) {
        if (textField.text.length > 0) {
            self.companyButton.hidden = NO;
        } else{
            self.companyButton.hidden = YES;
        }
    } else if ([textField isEqual:self.departmentField]) {
        if (textField.text.length > 0) {
            self.departmentButton.hidden = NO;
        } else{
            self.departmentButton.hidden = YES;
        }
    } else if ([textField isEqual:self.locationField]) {
        if (textField.text.length > 0) {
            self.locationButton.hidden = NO;
        } else{
            self.locationButton.hidden = YES;
        }
    }
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
    SHGIndustryChoiceView *view = [[SHGIndustryChoiceView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
    view.delegate = self;
    [self.view.window addSubview:view];
}

#pragma mark ------ 选择行业代理
- (void)didSelectIndustry:(NSString *)industry
{
    self.industryField.text = industry;
    self.industry = [self industryToCode:industry];

}

- (NSString *)industryToCode:(NSString *)industry
{
    if ([industry isEqualToString:@"银行机构"]) {
        return @"bank";
    } else if ([industry isEqualToString:@"证券公司"]) {
        return @"bond";
    } else if ([industry isEqualToString:@"三方理财"]) {
        return @"manage";
    } else if ([industry isEqualToString:@"基金公司"]) {
        return @"fund";
    } else if ([industry isEqualToString:@"其他"]) {
        return @"other";
    }
    return nil;
}

- (NSString *)codeToIndustry:(NSString *)code
{
    if ([code isEqualToString:@"bank"]) {
        return @"银行机构";
    } else if ([code isEqualToString:@"bond"]) {
        return @"证券公司";
    } else if ([code isEqualToString:@"manage"]) {
        return @"三方理财";
    } else if ([code isEqualToString:@"fund"]) {
        return @"基金公司";
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


@end
